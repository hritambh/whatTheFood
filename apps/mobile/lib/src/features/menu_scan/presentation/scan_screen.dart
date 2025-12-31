import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'menu_providers.dart';
import 'result_list_screen.dart';

class ScanScreen extends ConsumerWidget {
  const ScanScreen({super.key});

  Future<void> _pickAndScan(WidgetRef ref, ImageSource source, BuildContext context) async {
    final picker = ImagePicker();
    // pickedFile is already an XFile
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null && context.mounted) {
      // CHANGED: Pass XFile directly. Do NOT use File(pickedFile.path)
      ref.read(scanNotifierProvider.notifier).scanImage(pickedFile);

      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ResultListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('MenuLens')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant_menu, size: 80, color: Colors.blueGrey),
            const SizedBox(height: 20),
            const Text('Scan a menu to detect allergens', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo'),
              onPressed: () => _pickAndScan(ref, ImageSource.camera, context),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              icon: const Icon(Icons.image),
              label: const Text('Pick from Gallery'),
              onPressed: () => _pickAndScan(ref, ImageSource.gallery, context),
            ),
          ],
        ),
      ),
    );
  }
}