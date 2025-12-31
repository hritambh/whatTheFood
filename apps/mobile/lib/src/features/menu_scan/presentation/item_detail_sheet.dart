import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/menu_item.dart';
import '../data/models/enriched_item.dart';
import 'menu_providers.dart';
import 'dart:convert'; // Required for base64Decode

class ItemDetailSheet extends ConsumerWidget {
  final MenuItem item;

  const ItemDetailSheet({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the specific provider for this item
    final asyncEnrichment = ref.watch(enrichmentProvider(item));

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(item.name, style: Theme.of(context).textTheme.headlineSmall),
          if (item.price != null)
            Text(
              item.price!,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.green),
            ),
          const SizedBox(height: 20),

          // Enrichment Content
          Expanded(
            child: asyncEnrichment.when(
              loading: () => _buildSkeleton(),
              error: (err, _) =>
                  Center(child: Text('Failed to load details: $err')),
              data: (enriched) => _buildDetails(context, enriched),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context, EnrichedItem enriched) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. DISPLAY GENERATED IMAGE
          if (enriched.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(enriched.imageUrl!), // Call the helper
            ),
          const SizedBox(height: 16),

          // 2. DIETARY BADGE
          _buildBadge(enriched.dietaryType),
          const SizedBox(height: 16),

          // 3. AI DESCRIPTION
          if (enriched.aiDescription != null) ...[
            Text(
              "WHAT TO EXPECT",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.1,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              enriched.aiDescription!,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
                color: Colors.black87,
                fontStyle: FontStyle.italic,
              ),
            ),
            const Divider(height: 32),
          ],

          const Text(
            "ALLERGENS",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          if (enriched.allergens.isEmpty)
            const Text("None detected", style: TextStyle(color: Colors.grey))
          else
            Wrap(
              spacing: 8,
              children: enriched.allergens
                  .map(
                    (a) => Chip(
                      label: Text(a.toUpperCase()),
                      backgroundColor: Colors.red.shade100,
                      labelStyle: TextStyle(color: Colors.red.shade900),
                    ),
                  )
                  .toList(),
            ),

          const SizedBox(height: 20),

          const Text(
            "INGREDIENTS",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          if (enriched.ingredients.isEmpty)
            const Text(
              "No ingredients inferred",
              style: TextStyle(color: Colors.grey),
            )
          else
            Wrap(
              spacing: 6,
              children: enriched.ingredients
                  .map((i) => Chip(label: Text(i)))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildImage(String url) {
    // Check if it is a Base64 Data URI
    if (url.startsWith('data:image')) {
      try {
        // Extract the actual base64 string (remove the "data:image/png;base64," prefix)
        final base64String = url.split(',').last;
        return Image.memory(
          base64Decode(base64String),
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          gaplessPlayback: true,
        );
      } catch (e) {
        return Container(
          height: 200,
          color: Colors.grey[300],
          child: const Center(child: Icon(Icons.error, color: Colors.red)),
        );
      }
    }

    // Fallback for standard URLs (if you switch back later)
    return Image.network(
      url,
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          Container(height: 200, color: Colors.grey[300]),
    );
  }

  Widget _buildBadge(DietaryType type) {
    Color color;
    String label;
    switch (type) {
      case DietaryType.VEGAN:
        color = Colors.green;
        label = "VEGAN";
        break;
      case DietaryType.VEG:
        color = Colors.lightGreen;
        label = "VEGETARIAN";
        break;
      case DietaryType.NON_VEG:
        color = Colors.brown;
        label = "NON-VEG";
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("Consulting AI Chef..."),
        ],
      ),
    );
  }
}
