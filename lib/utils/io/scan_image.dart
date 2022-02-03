import 'dart:io';

import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kala/main.dart';
import 'package:permission_handler/permission_handler.dart';

Future<File?> scanImage(BuildContext context) async {

  if (await Permission.camera.request().isGranted) {
    try {
      final scannedDoc = await DocumentScannerFlutter.launch(context);
      return scannedDoc;
    } on PlatformException {
      // 'Failed to get document path or operation cancelled!';
    }
  }
}
