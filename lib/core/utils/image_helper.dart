import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  static final ImagePicker _picker = ImagePicker();

  /// 갤러리에서 이미지를 선택하고 [바이너리 바이트 데이터]로 반환합니다.
  static Future<Uint8List?> pickImageBytes() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        // 💡 XFile에서 바이너리(바이트) 데이터를 직접 추출합니다. (웹/모바일 공통 호환)
        final Uint8List bytes = await image.readAsBytes();
        return bytes;
      }
      return null;
    } catch (e) {
      debugPrint('이미지 바이트 선택 에러: $e');
      return null;
    }
  }

  /// 카메라로 촬영 후 [바이너리 바이트 데이터]로 반환합니다.
  static Future<Uint8List?> takePhotoBytes() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (photo != null) {
        return await photo.readAsBytes();
      }
      return null;
    } catch (e) {
      debugPrint('카메라 바이트 촬영 에러: $e');
      return null;
    }
  }

  /// [✨ 바이너리 전용 위젯 유틸] 
  /// 웹이든 모바일이든 관계없이 바이너리(Uint8List) 데이터를 화면에 띄워줍니다.
  static Widget displayBytesImage(Uint8List? bytes, {double size = 150}) {
    if (bytes == null) {
      return Container(
        width: size,
        height: size,
        color: Colors.grey[300],
        child: Icon(Icons.image, color: Colors.grey[600], size: size * 0.4),
      );
    }

    // 💡 Image.memory를 사용하면 플랫폼(웹/앱)을 가리지 않고 바이너리 데이터를 즉시 그려줍니다.
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.memory(
        bytes,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
