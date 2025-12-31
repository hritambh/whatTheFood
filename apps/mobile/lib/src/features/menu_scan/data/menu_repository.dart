import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // Needed for kIsWeb
import 'models/menu_item.dart';
import 'models/enriched_item.dart';

final menuRepositoryProvider = Provider((ref) => MenuRepository(Dio()));

class MenuRepository {
  final Dio _dio;

  // --- 1. ADD CACHES ---
  // Simple in-memory cache to store results during the session
  final Map<String, List<MenuItem>> _scanCache = {};
  final Map<String, EnrichedItem> _enrichCache = {};

  MenuRepository(this._dio);

  String get _baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api/menu';
    }
    if (Platform.isAndroid) {
      return 'http://192.168.0.120:3000/api/menu';
    }
    return 'http://192.168.0.120:3000/api/menu';
  }

  // --- 2. UPDATE SCAN METHOD ---
  Future<List<MenuItem>> scanMenu(XFile imageFile, String model) async {
    
    // 1. FIX: Use Dart's built-in environment lookup.
    // This allows you to disable cache by running: flutter run --dart-define=USE_CACHE=false
    const bool useCache = bool.fromEnvironment('USE_CACHE', defaultValue: false);

    // 2. Check Cache
    // We include the model in the key so changing models doesn't return stale data.
    final cacheKey = '${imageFile.name}_$model';

    if (useCache && _scanCache.containsKey(cacheKey)) {
      print('CACHE HIT: Returning saved scan results for $cacheKey');
      return _scanCache[cacheKey]!;
    }

    try {
      final String fileName = imageFile.name;
      final bytes = await imageFile.readAsBytes();
      final String ext = fileName.split('.').last.toLowerCase();
      final MediaType contentType = MediaType('image', ext == 'png' ? 'png' : 'jpeg');

      FormData formData = FormData.fromMap({
        "image": MultipartFile.fromBytes(
          bytes,
          filename: fileName,
          contentType: contentType,
        ),
      });

      final response = await _dio.post(
        '$_baseUrl/scan',
        data: formData,
      );

      final List<dynamic> itemsJson = response.data['items'];
      final results = itemsJson.map((json) => MenuItem.fromJson(json)).toList();

      // Save to Cache
      if (useCache) {
        _scanCache[imageFile.name] = results;
      }

      return results;
    } catch (e) {
      print('SCAN ERROR: $e'); 
      throw Exception('Failed to scan menu: $e');
    }
  }

  // --- 3. UPDATE ENRICH METHOD ---
  Future<EnrichedItem> enrichItem(MenuItem item, {bool useCache = true}) async {
    // Check Cache
    if (useCache && _enrichCache.containsKey(item.name)) {
      print('CACHE HIT: Returning saved enrichment for ${item.name}');
      return _enrichCache[item.name]!;
    }

    try {
      final response = await _dio.post(
        '$_baseUrl/enrich',
        data: item.toJson(),
      );
      final result = EnrichedItem.fromJson(response.data);

      // Save to Cache
      if (useCache) {
        _enrichCache[item.name] = result;
      }

      return result;
    } catch (e) {
      throw Exception('Failed to enrich item: $e');
    }
  }
}