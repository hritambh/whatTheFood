import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
// Fix imports to point to the correct data layer files
import '../data/models/menu_item.dart';
import '../data/models/enriched_item.dart';
import '../data/menu_repository.dart';

export '../data/menu_repository.dart';

// 1. CHANGE: Extend 'AsyncNotifier' instead of 'StateNotifier'
class ScanNotifier extends AsyncNotifier<List<MenuItem>?> {
  
  @override
  List<MenuItem>? build() {
    return null;
  }

  Future<void> scanImage(XFile image) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(menuRepositoryProvider);
      final items = await repository.scanMenu(image, 'gpt-4o');
      
      state = AsyncValue.data(items);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// 4. CHANGE: Use 'AsyncNotifierProvider'
final scanNotifierProvider = AsyncNotifierProvider<ScanNotifier, List<MenuItem>?>(() {
  return ScanNotifier();
});

// 5. HELPER: This remains a simple Provider that forwards the state
// (The UI watches this to get the AsyncValue)
final scanResultProvider = Provider<AsyncValue<List<MenuItem>?>>((ref) {
  return ref.watch(scanNotifierProvider);
});

// 6. ENRICHMENT: Keeps using FutureProvider.family as it works great for single-item logic
final enrichmentProvider = FutureProvider.family<EnrichedItem, MenuItem>((ref, MenuItem item) async {
  final repository = ref.watch(menuRepositoryProvider);
  return repository.enrichItem(item);
});