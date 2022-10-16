import 'dart:io';

import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

Future<File?> scanImage(BuildContext context) async {
  if (await Permission.camera.request().isGranted) {
    try {
      final scannedDoc = await DocumentScannerFlutter.launch(context);
      if (scannedDoc != null) {
        return await compressFile(scannedDoc);
      }
    } on PlatformException {
      // 'Failed to get document path or operation cancelled!';

      return null;
    }
  } else {
    return null;
  }
  return null;
}

Future<File?> compressFile(File file) async {
  final split = file.absolute.path.split('.');
  final result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    '${split.first}_c.jpg',
    quality: 50,
    minWidth: (1.sw - 36.w).toInt(),
    minHeight: 182.h.toInt(),
  );

  return result;
}
