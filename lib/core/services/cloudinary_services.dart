import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ImageUploadService {
  static final ImageUploadService _instance = ImageUploadService._internal();
  factory ImageUploadService() => _instance;
  ImageUploadService._internal();

  Future<String?> pickAndUpload() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;

    final bytes = result.files.single.bytes;
    final fileName = result.files.single.name;
    if (bytes == null) return null;

    return _upload(bytes, fileName);
  }

  Future<String> uploadBytes(Uint8List bytes, String fileName) async {
    final url = await _upload(bytes, fileName);
    if (url == null) {
      throw Exception('Failed to upload image');
    }
    return url;
  }

  Future<String?> _upload(Uint8List bytes, String fileName) async {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
    final preset = dotenv.env['PRESET_NAME'] ?? '';

    final uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );
    final request = http.MultipartRequest("POST", uri);
    request.fields['upload_preset'] = preset;
    request.files.add(
      http.MultipartFile.fromBytes('file', bytes, filename: fileName),
    );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      return data['secure_url'];
    }
    return null;
  }
}