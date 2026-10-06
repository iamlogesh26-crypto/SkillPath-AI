import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfHelper {
  static Future<String> extractTextFromBytes(Uint8List bytes) async {
    return compute(_extractPdfText, bytes);
  }

  static String _extractPdfText(Uint8List bytes) {
    final document = PdfDocument(inputBytes: bytes);
    final extracted = PdfTextExtractor(document).extractText();
    document.dispose();
    return extracted;
  }
}
