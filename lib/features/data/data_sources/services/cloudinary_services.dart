import 'dart:convert';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ImageUploadService {
  static final ImageUploadService _instance = ImageUploadService._internal();
  factory ImageUploadService() => _instance;
  ImageUploadService._internal();

  /// Maximum image dimension (width or height) before compression.
  static const int _maxDimension = 1024;

  Future<String?> pickAndUpload() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;

    final bytes = result.files.single.bytes;
    final fileName = result.files.single.name;
    if (bytes == null) {
      debugPrint('ImageUploadService: Picked file has no bytes (web data missing).');
      return null;
    }

    return _upload(bytes, fileName);
  }

  Future<String> uploadBytes(Uint8List bytes, String fileName) async {
    final url = await _upload(bytes, fileName);
    if (url == null) {
      throw Exception('Failed to upload image to Cloudinary.');
    }
    return url;
  }

  /// Compresses an image if it's larger than 500KB.
  /// Skips compression for smaller files to avoid blocking the UI thread on web.
  Future<Uint8List> _compressImage(Uint8List bytes) async {
    // On web, skip dart:ui compression entirely — instantiateImageCodec and
    // toByteData can crash or hang in release builds (CanvasKit renderer).
    // The browser handles image decoding natively, and Cloudinary accepts as-is.
    if (kIsWeb) {
      debugPrint('ImageUploadService: Web platform — skipping dart:ui compression.');
      return bytes;
    }

    // Skip compression for files under 500KB — not worth the UI thread cost on web
    if (bytes.length < 500 * 1024) {
      debugPrint('ImageUploadService: Image is ${bytes.length} bytes, skipping compression.');
      return bytes;
    }

    try {
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: _maxDimension,
      );
      final frame = await codec.getNextFrame();
      final image = frame.image;

      // If the image is already smaller than max dimension, skip
      if (image.width <= _maxDimension && image.height <= _maxDimension) {
        image.dispose();
        return bytes;
      }

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();

      if (byteData != null) {
        final compressed = byteData.buffer.asUint8List();
        debugPrint(
          'ImageUploadService: Compressed ${bytes.length} → ${compressed.length} bytes '
          '(${((1 - compressed.length / bytes.length) * 100).toStringAsFixed(0)}% reduction)',
        );
        return compressed;
      }
    } catch (e) {
      debugPrint('ImageUploadService: Compression failed, using original. Error: $e');
    }
    return bytes;
  }

  Future<String?> _upload(Uint8List bytes, String fileName) async {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
    final preset = dotenv.env['PRESET_NAME'] ?? '';

    if (cloudName.isEmpty || preset.isEmpty) {
      debugPrint(
        'ImageUploadService Error: Cloudinary not configured.\n'
        '  CLOUDINARY_CLOUD_NAME: ${cloudName.isEmpty ? "MISSING" : "OK"}\n'
        '  PRESET_NAME: ${preset.isEmpty ? "MISSING" : "OK"}\n'
        '  Loaded env keys: ${dotenv.env.keys.toList()}',
      );
      throw Exception(
        'Image upload service is not configured. Please check your environment settings.',
      );
    }

    // Compress image before uploading for faster transfer
    final compressedBytes = await _compressImage(bytes);

    final uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    try {
      debugPrint('ImageUploadService: Uploading ${compressedBytes.length} bytes to Cloudinary...');

      final request = http.MultipartRequest("POST", uri);
      request.fields['upload_preset'] = preset;
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          compressedBytes,
          filename: fileName,
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        debugPrint('ImageUploadService: Upload successful! URL: ${data['secure_url']}');
        return data['secure_url'];
      } else {
        debugPrint('ImageUploadService: Upload failed with status ${response.statusCode}');
        debugPrint('Response Body: $responseBody');
        throw Exception(
          'Image upload failed (HTTP ${response.statusCode}). Please try again.',
        );
      }
    } catch (e) {
      if (e is Exception && e.toString().contains('Image upload failed')) {
        rethrow;
      }
      debugPrint('ImageUploadService: Upload exception: $e');
      throw Exception('Image upload failed: $e');
    }
  }
}