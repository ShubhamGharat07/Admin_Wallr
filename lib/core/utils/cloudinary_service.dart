// lib/core/utils/cloudinary_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    await _dio.post(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/destroy',
      data: {'public_id': publicId},
    );
  }

  // ── URL transforms ────────────────────────────────────────

  // Table thumbnail (small)
  String thumbnailUrl(String imageUrl) =>
      _transform(imageUrl, 'w_80,h_112,c_fill,f_auto,q_auto');

  // Grid preview (medium)
  String previewUrl(String imageUrl) =>
      _transform(imageUrl, 'w_400,h_600,c_fill,f_auto,q_auto');

  // Full quality
  String fullUrl(String imageUrl) => _transform(imageUrl, 'f_auto,q_auto');

  String _transform(String url, String transformation) =>
      url.replaceFirst('/image/upload/', '/image/upload/$transformation/');
}
