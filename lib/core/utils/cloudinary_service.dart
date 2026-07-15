// // lib/core/utils/cloudinary_service.dart

// import 'package:dio/dio.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class CloudinaryUploadResult {
//   final String secureUrl;
//   final String publicId;
//   final int width;
//   final int height;
//   final String format;
//   final int bytes;

//   const CloudinaryUploadResult({
//     required this.secureUrl,
//     required this.publicId,
//     required this.width,
//     required this.height,
//     required this.format,
//     required this.bytes,
//   });
// }

// class CloudinaryService {
//   final Dio _dio;

//   CloudinaryService(this._dio);

//   static String get _cloudName => dotenv.env['CLOUDINARY_CLOUD_NAME']!;
//   static String get _uploadPreset => dotenv.env['CLOUDINARY_UPLOAD_PRESET']!;

//   // ── Upload image ──────────────────────────────────────────
//   Future<CloudinaryUploadResult> uploadWallpaper({
//     required List<int> fileBytes,
//     required String fileName,
//     void Function(double progress)? onProgress,
//   }) async {
//     final formData = FormData.fromMap({
//       'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
//       'upload_preset': _uploadPreset,
//       'folder': 'wallpapers',
//     });

//     final response = await _dio.post(
//       'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
//       data: formData,
//       onSendProgress: (sent, total) => onProgress?.call(sent / total),
//     );

//     final data = response.data;
//     return CloudinaryUploadResult(
//       secureUrl: data['secure_url'],
//       publicId: data['public_id'],
//       width: data['width'],
//       height: data['height'],
//       format: data['format'],
//       bytes: data['bytes'],
//     );
//   }

//   // ── Delete image ──────────────────────────────────────────
//   Future<void> deleteWallpaper(String publicId) async {
//     await _dio.post(
//       'https://api.cloudinary.com/v1_1/$_cloudName/image/destroy',
//       data: {'public_id': publicId},
//     );
//   }

//   // ── URL transforms ────────────────────────────────────────

//   // Table thumbnail (small)
//   String thumbnailUrl(String imageUrl) =>
//       _transform(imageUrl, 'w_80,h_112,c_fill,f_auto,q_auto');

//   // Grid preview (medium)
//   String previewUrl(String imageUrl) =>
//       _transform(imageUrl, 'w_400,h_600,c_fill,f_auto,q_auto');

//   // Full quality
//   String fullUrl(String imageUrl) => _transform(imageUrl, 'f_auto,q_auto');

//   String _transform(String url, String transformation) =>
//       url.replaceFirst('/image/upload/', '/image/upload/$transformation/');
// }

// lib/core/utils/cloudinary_service.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'logger.dart';

class CloudinaryUploadResult {
  final String secureUrl;
  final String publicId;
  final int width;
  final int height;
  final String format;
  final int bytes;

  const CloudinaryUploadResult({
    required this.secureUrl,
    required this.publicId,
    required this.width,
    required this.height,
    required this.format,
    required this.bytes,
  });
}

class CloudinaryService {
  final Dio _dio;

  CloudinaryService(this._dio);

  static String get _cloudName => dotenv.env['CLOUDINARY_CLOUD_NAME']!;
  static String get _uploadPreset => dotenv.env['CLOUDINARY_UPLOAD_PRESET']!;
  static String get _apiKey => dotenv.env['CLOUDINARY_API_KEY']!;
  static String? get _apiSecret => dotenv.env['CLOUDINARY_API_SECRET'];

  // ── Upload image ──────────────────────────────────────────
  Future<CloudinaryUploadResult> uploadWallpaper({
    required List<int> fileBytes,
    required String fileName,
    void Function(double progress)? onProgress,
  }) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      'upload_preset': _uploadPreset,
      'folder': 'wallpapers',
    });

    final response = await _dio.post(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
      data: formData,
      onSendProgress: (sent, total) => onProgress?.call(sent / total),
    );

    final data = response.data;
    return CloudinaryUploadResult(
      secureUrl: data['secure_url'],
      publicId: data['public_id'],
      width: data['width'],
      height: data['height'],
      format: data['format'],
      bytes: data['bytes'],
    );
  }

  // ── Delete image ──────────────────────────────────────────
  Future<void> deleteWallpaper(String publicId) async {
    try {
      AppLogger.info('DELETE STARTED', tag: 'CloudinaryService');
      AppLogger.info('Cloud Name: $_cloudName | Public ID: $publicId', tag: 'CloudinaryService');

      if (_apiSecret == null) {
        throw Exception('CLOUDINARY_API_SECRET is required for delete operations. Add it to .env file.');
      }

      final url = 'https://api.cloudinary.com/v1_1/$_cloudName/image/destroy';
      AppLogger.info('URL: $url', tag: 'CloudinaryService');

      // Cloudinary requires Basic Auth for admin APIs
      final credentials = base64Encode(utf8.encode('$_apiKey:$_apiSecret'));
      AppLogger.info('Using Basic Auth with credentials', tag: 'CloudinaryService');

      final requestData = FormData.fromMap({
        'public_id': publicId,
      });

      final response = await _dio.post(
        url,
        data: requestData,
        options: Options(
          headers: {
            'Authorization': 'Basic $credentials',
          },
        ),
      );

      AppLogger.info('DELETE SUCCESS - Status: ${response.statusCode}', tag: 'CloudinaryService');
      AppLogger.info('Response: ${response.data}', tag: 'CloudinaryService');
    } on DioException catch (e) {
      AppLogger.error(
        'DIO ERROR during delete | Status: ${e.response?.statusCode}',
        error: e,
        tag: 'CloudinaryService',
      );
      AppLogger.error(
        'Response Data: ${e.response?.data}',
        tag: 'CloudinaryService',
      );
      rethrow;
    } catch (e, st) {
      AppLogger.error(
        'ERROR during delete: $e',
        error: e,
        stackTrace: st,
        tag: 'CloudinaryService',
      );
      rethrow;
    }
  }

  // ── URL transforms ────────────────────────────────────────

  // Table thumbnail (small) — q_auto theek hai, chhota size, eyes pe farak nahi padta
  String thumbnailUrl(String imageUrl) =>
      _transform(imageUrl, 'w_80,h_112,c_fill,f_auto,q_auto');

  // Grid preview (medium) — q_auto theek hai, list/grid mein chhota dikhta hai
  String previewUrl(String imageUrl) =>
      _transform(imageUrl, 'w_400,h_600,c_fill,f_auto,q_auto');

  // Full quality wallpaper (lock screen / set as wallpaper / download)
  // q_100 = no compression. Yahi method user panel mein full-size dikhane
  // aur download karne ke liye use hona chahiye.
  String fullUrl(String imageUrl) => _transform(imageUrl, 'f_auto,q_100');

  String _transform(String url, String transformation) =>
      url.replaceFirst('/image/upload/', '/image/upload/$transformation/');
}
