import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/medication.dart';
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
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _searchController = TextEditingController();

  List<Medication> _medications = [];
  List<Medication> _filteredMedications = [];
  List<String> _categories = [];
  List<String> _categoriesFr = [];
  String? _selectedCategory;
  bool _isLoading = true;
  bool _isArabic = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final medications = await _dbHelper.getAllMedications();
    final categories = await _dbHelper.getCategories();
    final categoriesFr = await _dbHelper.getCategoriesFr();

    setState(() {
      _medications = medications;
      _filteredMedications = medications;
      _categories = categories;
      _categoriesFr = categoriesFr;
      _isLoading = false;
    });
  }

  void _filterMedications(String query) {
    setState(() {
      _filteredMedications = _medications.where((med) {
        final matchesSearch = query.isEmpty ||
            med.name.toLowerCase().contains(query.toLowerCase()) ||
            med.nameFr.toLowerCase().contains(query.toLowerCase()) ||
            med.category.contains(query) ||
            med.categoryFr.toLowerCase().contains(query.toLowerCase());

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
            Container(
              margin: const EdgeInsets.only(right: 8, left: 8),
              child: TextButton.icon(
                onPressed: _toggleLanguage,
                icon: const Icon(Icons.language, color: AppColors.white, size: 20),
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
            : Column(
                children: [
                  _buildSearchBar(),
                  _buildCategoryFilter(),
                  _buildResultCount(),
                  Expanded(child: _buildMedicationList()),
                ],
              ),
      ),
    );
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
            prefixIcon: const Icon(Icons.search, color: AppColors.emeraldGreen),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.textSecondary),
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
          final arCategory = _categories[index];
          final frCategory = _categoriesFr[index];
          final isSelected =
              _selectedCategory == arCategory || _selectedCategory == frCategory;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: CategoryChipWidget(
              label: category,
              isSelected: isSelected,
              onTap: () => _selectCategory(arCategory),
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
            Icon(Icons.search_off, size: 64, color: AppColors.textSecondary.withAlpha(128)),
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
