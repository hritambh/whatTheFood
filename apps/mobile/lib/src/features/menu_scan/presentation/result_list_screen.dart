import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'menu_providers.dart';
import 'item_detail_sheet.dart';

class ResultListScreen extends ConsumerWidget {
  const ResultListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(scanResultProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Scanned Items')),
      body: scanState.when(
        data: (items) {
          if (items == null) return const Center(child: Text('No scan data.'));
          if (items.isEmpty) return const Center(child: Text('No menu items found.'));

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(item.description ?? 'No description'),
                trailing: Text(item.price ?? '', style: const TextStyle(color: Colors.green)),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => ItemDetailSheet(item: item),
                  );
                },
              );
            },
          );
        },
        error: (err, stack) => Center(child: Text('Error: $err')),
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Analyzing Menu with GPT-4o...'),
            ],
          ),
        ),
      ),
    );
  }
}

