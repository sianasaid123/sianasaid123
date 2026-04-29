import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';
import 'medicament_ma_service.dart';

enum SyncStatus { idle, syncing, completed, error }

class SyncState {
  final SyncStatus status;
  final String currentLetter;
  final int currentPage;
  final int totalPages;
  final int totalFetched;
  final String? errorMessage;
  final DateTime? lastSyncTime;

  const SyncState({
    this.status = SyncStatus.idle,
    this.currentLetter = '',
    this.currentPage = 0,
    this.totalPages = 0,
    this.totalFetched = 0,
    this.errorMessage,
    this.lastSyncTime,
  });

  SyncState copyWith({
    SyncStatus? status,
    String? currentLetter,
    int? currentPage,
    int? totalPages,
    int? totalFetched,
    String? errorMessage,
    DateTime? lastSyncTime,
  }) {
    return SyncState(
      status: status ?? this.status,
      currentLetter: currentLetter ?? this.currentLetter,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalFetched: totalFetched ?? this.totalFetched,
      errorMessage: errorMessage ?? this.errorMessage,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }

  String get progressText {
    if (status == SyncStatus.syncing) {
      return '$currentLetter ($currentPage/$totalPages) - $totalFetched';
    }
    if (status == SyncStatus.completed) {
      return '$totalFetched';
    }
    return '';
  }
}

class SyncService {
  static const String _lastSyncKey = 'last_sync_time';
  static const String _syncCountKey = 'sync_medication_count';
  static const Duration syncInterval = Duration(hours: 24);

  final MedicamentMaParser _parser = MedicamentMaParser();
  final ValueNotifier<SyncState> stateNotifier = ValueNotifier(const SyncState());

  bool _isSyncing = false;

  Future<DateTime?> getLastSyncTime() async {
    if (kIsWeb) return null;
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_lastSyncKey);
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
    } catch (_) {}
    return null;
  }

  Future<int> getSyncedCount() async {
    if (kIsWeb) return 0;
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_syncCountKey) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<bool> needsSync() async {
    final lastSync = await getLastSyncTime();
    if (lastSync == null) return true;
    return DateTime.now().difference(lastSync) > syncInterval;
  }

  Future<void> startSync() async {
    if (_isSyncing || kIsWeb) return;
    _isSyncing = true;

    var totalFetched = 0;

    stateNotifier.value = const SyncState(status: SyncStatus.syncing);

    try {
      final result = await _parser.fetchAllMedications(
        onProgress: (letter, page, totalPages) {
          stateNotifier.value = stateNotifier.value.copyWith(
            currentLetter: letter,
            currentPage: page,
            totalPages: totalPages,
            totalFetched: totalFetched,
          );
        },
        onLetterComplete: (letter, count) {
          totalFetched += count;
          stateNotifier.value = stateNotifier.value.copyWith(
            totalFetched: totalFetched,
          );
        },
      );

      // Store in database
      final db = DatabaseHelper();
      await db.clearOnlineMedications();
      await db.insertOnlineMedications(result.medications);

      // Save sync metadata
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        _lastSyncKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      await prefs.setInt(_syncCountKey, result.totalFetched);

      stateNotifier.value = SyncState(
        status: SyncStatus.completed,
        totalFetched: result.totalFetched,
        lastSyncTime: DateTime.now(),
      );
    } catch (e) {
      stateNotifier.value = SyncState(
        status: SyncStatus.error,
        errorMessage: e.toString(),
        totalFetched: totalFetched,
      );
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> checkAndSync() async {
    if (await needsSync()) {
      final lastSync = await getLastSyncTime();
      stateNotifier.value = SyncState(
        status: SyncStatus.idle,
        lastSyncTime: lastSync,
      );
      await startSync();
    } else {
      final lastSync = await getLastSyncTime();
      final count = await getSyncedCount();
      stateNotifier.value = SyncState(
        status: SyncStatus.completed,
        lastSyncTime: lastSync,
        totalFetched: count,
      );
    }
  }

  void dispose() {
    _parser.dispose();
    stateNotifier.dispose();
  }
}
