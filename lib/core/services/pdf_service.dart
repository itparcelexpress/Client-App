import 'dart:io';
import 'dart:typed_data';

import 'package:client_app/core/utilities/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class PdfService {
  PdfService._();

  /// Save PDF bytes to device storage and optionally open it
  static Future<bool> savePdfAndOpen({
    required List<int> pdfBytes,
    required String fileName,
    bool openAfterSave = true,
  }) async {
    try {
      // Use app-specific documents directory
      final directory = await getApplicationDocumentsDirectory();

      // Create a subdirectory for exported files
      final exportDir = Directory('${directory.path}/ExportedFiles');
      if (!await exportDir.exists()) {
        await exportDir.create(recursive: true);
      }

      // Ensure filename has .pdf extension
      if (!fileName.toLowerCase().endsWith('.pdf')) {
        fileName = '$fileName.pdf';
      }

      // Create the file
      final file = File('${exportDir.path}/$fileName');

      // Write the PDF bytes to the file
      await file.writeAsBytes(Uint8List.fromList(pdfBytes));

      Logger.info('PDF saved successfully: ${file.path}');

      // Open the file if requested
      if (openAfterSave) {
        final result = await OpenFile.open(file.path);
        if (result.type != ResultType.done) {
          Logger.error('Failed to open PDF: ${result.message}');
          return false;
        }
      }

      return true;
    } catch (e) {
      Logger.error('Error saving PDF: $e');
      return false;
    }
  }

  /// Get a safe filename from invoice number
  static String getSafeFileName(String invoiceNo) {
    // Remove or replace invalid filename characters
    String safeFileName = invoiceNo.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
    return 'Invoice_$safeFileName';
  }
}
