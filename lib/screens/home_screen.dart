import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../database/medication_repository.dart';
import '../models/medication.dart';
import '../services/sync_service.dart';
import '../utils/app_colors.dart';
import '../widgets/medication_card.dart';
import '../widgets/category_chip.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MedicationRepository _repository = MedicationRepository();
  final TextEditingController _searchController = TextEditingController();
  final SyncService _syncService = SyncService();

  List<Medication> _medications = [];
  List<Medication> _filteredMedications = [];
  List<String> _categories = [];
  List<String> _categoriesFr = [];
  String? _selectedCategory;
  bool _isLoading = true;
  bool _isArabic = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _syncService.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      await _repository.initialize();
      final medications = await _repository.getAllMedications();
      final categories = await _repository.getCategories();
      final categoriesFr = await _repository.getCategoriesFr();

      setState(() {
        _medications = medications;
        _filteredMedications = medications;
        _categories = categories;
        _categoriesFr = categoriesFr;
        _isLoading = false;
        _hasError = false;
      });

      // Start background sync on mobile
      if (!kIsWeb) {
        _syncService.stateNotifier.addListener(_onSyncStateChanged);
        _syncService.checkAndSync();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  void _onSyncStateChanged() {
    final state = _syncService.stateNotifier.value;
    if (state.status == SyncStatus.completed) {
      _reloadMedications();
    }
    if (mounted) setState(() {});
  }

  Future<void> _reloadMedications() async {
    final medications = await _repository.getAllMedications();
    final categories = await _repository.getCategories();
    final categoriesFr = await _repository.getCategoriesFr();
    if (mounted) {
      setState(() {
        _medications = medications;
        _categories = categories;
        _categoriesFr = categoriesFr;
        _filterMedications(_searchController.text);
      });
    }
  }

  void _filterMedications(String query) {
    setState(() {
      _filteredMedications = _medications.where((med) {
        final matchesSearch = query.isEmpty ||
            med.name.toLowerCase().contains(query.toLowerCase()) ||
            med.nameFr.toLowerCase().contains(query.toLowerCase()) ||
            med.category.contains(query) ||
            med.categoryFr.toLowerCase().contains(query.toLowerCase()) ||
            (med.manufacturer?.toLowerCase().contains(query.toLowerCase()) ??
                false);

        final matchesCategory = _selectedCategory == null ||
            med.category == _selectedCategory ||
            med.categoryFr == _selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _selectCategory(String category) {
    setState(() {
      if (_selectedCategory == category) {
        _selectedCategory = null;
      } else {
        _selectedCategory = category;
      }
      _filterMedications(_searchController.text);
    });
  }

  void _toggleLanguage() {
    setState(() {
      _isArabic = !_isArabic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_pharmacy, size: 24),
              const SizedBox(width: 8),
              Text(
                _isArabic ? 'فارماما' : 'PharmaMa',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          actions: [
            if (!kIsWeb) _buildSyncButton(),
            Container(
              margin: const EdgeInsets.only(right: 8, left: 8),
              child: TextButton.icon(
                onPressed: _toggleLanguage,
                icon:
                    const Icon(Icons.language, color: AppColors.white, size: 20),
                label: Text(
                  _isArabic ? 'FR' : 'عربي',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.emeraldGreen,
                ),
              )
            : _hasError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: AppColors.prescriptionBadge),
                        const SizedBox(height: 16),
                        Text(
                          _isArabic
                              ? 'وقع مشكل فتحميل الأدوية'
                              : 'Erreur de chargement des médicaments',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                              _hasError = false;
                            });
                            _loadData();
                          },
                          icon: const Icon(Icons.refresh),
                          label: Text(
                              _isArabic ? 'عاود المحاولة' : 'Réessayer'),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      _buildSearchBar(),
                      if (!kIsWeb) _buildSyncBanner(),
                      _buildCategoryFilter(),
                      _buildResultCount(),
                      Expanded(child: _buildMedicationList()),
                    ],
                  ),
      ),
    );
  }

  Widget _buildSyncButton() {
    final state = _syncService.stateNotifier.value;

    if (state.status == SyncStatus.syncing) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.white.withAlpha(200),
          ),
        ),
      );
    }

    return IconButton(
      icon: const Icon(Icons.sync, color: AppColors.white),
      tooltip: _isArabic ? 'مزامنة medicament.ma' : 'Sync medicament.ma',
      onPressed: () {
        _syncService.startSync();
      },
    );
  }

  Widget _buildSyncBanner() {
    final state = _syncService.stateNotifier.value;

    if (state.status == SyncStatus.syncing) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: AppColors.lightBlue.withAlpha(30),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.lightBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _isArabic
                    ? 'كنزامن من medicament.ma... ${state.currentLetter} (${state.totalFetched} دوا)'
                    : 'Sync medicament.ma... ${state.currentLetter} (${state.totalFetched} médicaments)',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.lightBlue,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state.status == SyncStatus.error) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        color: AppColors.prescriptionBadge.withAlpha(20),
        child: Row(
          children: [
            const Icon(Icons.error_outline,
                size: 16, color: AppColors.prescriptionBadge),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _isArabic
                    ? 'خطأ في المزامنة. اضغط على زر المزامنة للمحاولة مرة أخرى'
                    : 'Erreur de synchronisation. Appuyez sur sync pour réessayer',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.prescriptionBadge,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state.status == SyncStatus.completed && state.lastSyncTime != null) {
      final ago = _formatTimeAgo(state.lastSyncTime!);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        color: AppColors.emeraldGreen.withAlpha(12),
        child: Row(
          children: [
            const Icon(Icons.cloud_done,
                size: 14, color: AppColors.emeraldGreen),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _isArabic
                    ? 'medicament.ma: ${state.totalFetched} دوا ($ago)'
                    : 'medicament.ma: ${state.totalFetched} médicaments ($ago)',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return _isArabic ? 'دابا' : 'maintenant';
    if (diff.inMinutes < 60) {
      return _isArabic
          ? 'قبل ${diff.inMinutes} دقيقة'
          : 'il y a ${diff.inMinutes} min';
    }
    if (diff.inHours < 24) {
      return _isArabic
          ? 'قبل ${diff.inHours} ساعة'
          : 'il y a ${diff.inHours}h';
    }
    return _isArabic
        ? 'قبل ${diff.inDays} يوم'
        : 'il y a ${diff.inDays}j';
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      color: AppColors.emeraldGreen,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _filterMedications,
          textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
          decoration: InputDecoration(
            hintText: _isArabic
                ? 'قلّب على دوا... (مثلا: Doliprane)'
                : 'Rechercher un médicament...',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            prefixIcon:
                const Icon(Icons.search, color: AppColors.emeraldGreen),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear,
                        color: AppColors.textSecondary),
                    onPressed: () {
                      _searchController.clear();
                      _filterMedications('');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = _isArabic ? _categories : _categoriesFr;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: AppColors.emeraldGreen.withAlpha(12),
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: CategoryChipWidget(
              label: category,
              isSelected: isSelected,
              onTap: () => _selectCategory(category),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultCount() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Icon(Icons.medication_outlined,
              size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            _isArabic
                ? '${_filteredMedications.length} دوا'
                : '${_filteredMedications.length} médicaments',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationList() {
    if (_filteredMedications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off,
                size: 64,
                color: AppColors.textSecondary.withAlpha(128)),
            const SizedBox(height: 16),
            Text(
              _isArabic
                  ? 'ما لقينا حتى دوا. جرب كلمة أخرى.'
                  : 'Aucun médicament trouvé. Essayez un autre terme.',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 48),
      itemCount: _filteredMedications.length + 1,
      itemBuilder: (context, index) {
        if (index == _filteredMedications.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                '© Jellouli Said 2026',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          );
        }
        return MedicationCard(
          medication: _filteredMedications[index],
          isArabic: _isArabic,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(
                  medication: _filteredMedications[index],
                  isArabic: _isArabic,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
