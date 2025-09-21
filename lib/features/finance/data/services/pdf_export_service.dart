import 'dart:io';
import 'package:client_app/features/finance/data/models/finance_models.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/// Service for exporting finance data to PDF format
class PdfExportService {
  static const double _headerFontSize = 16.0;
  static const double _titleFontSize = 14.0;
  static const double _bodyFontSize = 10.0;
  static const double _smallFontSize = 8.0;
  static const double _pageMargin = 40.0;
  static const double _sectionSpacing = 20.0;

  /// Request storage permissions if needed
  static Future<bool> _requestStoragePermissions() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+), we need different permissions
      if (await _isAndroid13OrHigher()) {
        return await _requestAndroid13Permissions();
      } else {
        // For older Android versions, use traditional storage permission
        return await _requestLegacyStoragePermission();
      }
    }
    return true; // iOS doesn't need explicit storage permission
  }

  /// Check if device is running Android 13+ (API 33+)
  static Future<bool> _isAndroid13OrHigher() async {
    try {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      return deviceInfo.version.sdkInt >= 33;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking Android version: $e');
      }
      return false;
    }
  }

  /// Request permissions for Android 13+ (API 33+)
  static Future<bool> _requestAndroid13Permissions() async {
    try {
      // For Android 13+, we can use the Downloads directory without special permissions
      // But we still need to check if we can access external storage
      final status = await Permission.manageExternalStorage.status;

      if (status.isGranted) {
        return true;
      }

      if (status.isDenied) {
        final result = await Permission.manageExternalStorage.request();
        return result.isGranted;
      }

      if (status.isPermanentlyDenied) {
        if (kDebugMode) {
          print('🔴 Manage external storage permission permanently denied.');
        }
        return false;
      }

      return status.isGranted;
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting Android 13+ permissions: $e');
      }
      // Fallback to legacy permission
      return await _requestLegacyStoragePermission();
    }
  }

  /// Request legacy storage permission for older Android versions
  static Future<bool> _requestLegacyStoragePermission() async {
    try {
      var status = await Permission.storage.status;

      if (status.isGranted) {
        return true;
      }

      if (status.isDenied) {
        status = await Permission.storage.request();
        return status.isGranted;
      }

      if (status.isPermanentlyDenied) {
        if (kDebugMode) {
          print('🔴 Storage permission permanently denied.');
        }
        return false;
      }

      return status.isGranted;
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting legacy storage permission: $e');
      }
      return false;
    }
  }

  /// Export finance data to PDF file
  static Future<String> exportFinanceDataToPdf({
    required FinanceData financeData,
    required AppLocalizations localizations,
  }) async {
    try {
      // Check storage permissions using the comprehensive permission logic
      final hasPermission = await _requestStoragePermissions();
      if (!hasPermission) {
        throw Exception('Storage permission denied');
      }

      // Create PDF document
      final pdf = pw.Document();

      // Add finance summary page
      _addSummaryPage(pdf, financeData, localizations);

      // Add transactions page(s)
      _addTransactionsPages(pdf, financeData, localizations);

      // Save PDF to device
      final directory = await _getDownloadDirectory();
      final fileName = _generateFileName();
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      return filePath;
    } catch (e) {
      throw Exception('Failed to export PDF: ${e.toString()}');
    }
  }

  /// Add summary page to PDF
  static void _addSummaryPage(
    pw.Document pdf,
    FinanceData financeData,
    AppLocalizations localizations,
  ) {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(_pageMargin),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(localizations),

              pw.SizedBox(height: _sectionSpacing),

              // Account Summary Section
              _buildAccountSummary(financeData.summary, localizations),

              pw.SizedBox(height: _sectionSpacing),

              // Statistics Section
              _buildStatistics(financeData, localizations),

              pw.Spacer(),

              // Footer
              _buildFooter(localizations),
            ],
          );
        },
      ),
    );
  }

  /// Add transactions pages to PDF
  static void _addTransactionsPages(
    pw.Document pdf,
    FinanceData financeData,
    AppLocalizations localizations,
  ) {
    const int transactionsPerPage = 25;
    final transactions = financeData.transactions;

    for (int i = 0; i < transactions.length; i += transactionsPerPage) {
      final endIndex =
          (i + transactionsPerPage < transactions.length)
              ? i + transactionsPerPage
              : transactions.length;
      final pageTransactions = transactions.sublist(i, endIndex);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(_pageMargin),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Page Header
                _buildPageHeader(localizations, i + 1),

                pw.SizedBox(height: _sectionSpacing),

                // Transactions Table
                _buildTransactionsTable(pageTransactions, localizations),

                pw.Spacer(),

                // Page Footer
                _buildPageFooter(localizations, i + 1, transactions.length),
              ],
            );
          },
        ),
      );
    }
  }

  /// Build PDF header
  static pw.Widget _buildHeader(AppLocalizations localizations) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            localizations.finance,
            style: pw.TextStyle(
              fontSize: _headerFontSize,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Report Generated: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
            style: pw.TextStyle(
              fontSize: _smallFontSize,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  /// Build account summary section
  static pw.Widget _buildAccountSummary(
    AccountSummary summary,
    AppLocalizations localizations,
  ) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Account Summary',
            style: pw.TextStyle(
              fontSize: _titleFontSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 12),
          _buildSummaryRow('Total COD', summary.totalCod, localizations),
          _buildSummaryRow('Total Fees', summary.totalFees, localizations),
          _buildSummaryRow(
            'Total Settlements',
            summary.totalSettlements,
            localizations,
          ),
          pw.Divider(),
          _buildSummaryRow(
            'Current Balance',
            summary.currentBalance,
            localizations,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  /// Build summary row
  static pw.Widget _buildSummaryRow(
    String label,
    double amount,
    AppLocalizations localizations, {
    bool isTotal = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: _bodyFontSize,
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            '${amount.toStringAsFixed(2)} EGP',
            style: pw.TextStyle(
              fontSize: _bodyFontSize,
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: isTotal ? PdfColors.blue800 : PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  /// Build statistics section
  static pw.Widget _buildStatistics(
    FinanceData financeData,
    AppLocalizations localizations,
  ) {
    final creditTransactions =
        financeData.transactions.where((t) => t.isCredit).length;
    final debitTransactions =
        financeData.transactions.where((t) => t.isDebit).length;
    final totalCreditAmount = financeData.transactions
        .where((t) => t.isCredit)
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalDebitAmount = financeData.transactions
        .where((t) => t.isDebit)
        .fold(0.0, (sum, t) => sum + t.amount.abs());

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Transaction Statistics',
            style: pw.TextStyle(
              fontSize: _titleFontSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildStatItem(
                      'Total Transactions',
                      financeData.total.toString(),
                    ),
                    _buildStatItem(
                      'Credit Transactions',
                      creditTransactions.toString(),
                    ),
                    _buildStatItem(
                      'Total Credits',
                      '${totalCreditAmount.toStringAsFixed(2)} EGP',
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildStatItem(
                      'Current Page',
                      financeData.currentPage.toString(),
                    ),
                    _buildStatItem(
                      'Debit Transactions',
                      debitTransactions.toString(),
                    ),
                    _buildStatItem(
                      'Total Debits',
                      '${totalDebitAmount.toStringAsFixed(2)} EGP',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build stat item
  static pw.Widget _buildStatItem(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: _smallFontSize)),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: _smallFontSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Build page header
  static pw.Widget _buildPageHeader(
    AppLocalizations localizations,
    int pageNumber,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          '${localizations.transactionHistory} - Page $pageNumber',
          style: pw.TextStyle(
            fontSize: _titleFontSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
          style: const pw.TextStyle(fontSize: _smallFontSize),
        ),
      ],
    );
  }

  /// Build transactions table
  static pw.Widget _buildTransactionsTable(
    List<Transaction> transactions,
    AppLocalizations localizations,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FixedColumnWidth(80), // Date
        1: const pw.FixedColumnWidth(120), // Reference
        2: const pw.FixedColumnWidth(80), // Type
        3: const pw.FlexColumnWidth(2), // Description
        4: const pw.FixedColumnWidth(80), // Amount
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey100),
          children: [
            _buildTableHeader('Date'),
            _buildTableHeader('Reference'),
            _buildTableHeader('Type'),
            _buildTableHeader('Description'),
            _buildTableHeader('Amount'),
          ],
        ),
        // Transaction rows
        ...transactions.map(
          (transaction) => pw.TableRow(
            children: [
              _buildTableCell(transaction.date, fontSize: _smallFontSize),
              _buildTableCell(transaction.reference, fontSize: _smallFontSize),
              _buildTableCell(
                transaction.type,
                fontSize: _smallFontSize,
                color:
                    transaction.isCredit
                        ? PdfColors.green700
                        : PdfColors.red700,
              ),
              _buildTableCell(
                transaction.description,
                fontSize: _smallFontSize,
              ),
              _buildTableCell(
                transaction.formattedAmount,
                fontSize: _smallFontSize,
                color:
                    transaction.isCredit
                        ? PdfColors.green700
                        : PdfColors.red700,
                alignment: pw.Alignment.centerRight,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build table header cell
  static pw.Widget _buildTableHeader(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: _smallFontSize,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  /// Build table cell
  static pw.Widget _buildTableCell(
    String text, {
    double fontSize = _bodyFontSize,
    PdfColor? color,
    pw.Alignment alignment = pw.Alignment.centerLeft,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: fontSize,
          color: color ?? PdfColors.black,
        ),
        textAlign:
            alignment == pw.Alignment.centerRight
                ? pw.TextAlign.right
                : pw.TextAlign.left,
      ),
    );
  }

  /// Build page footer
  static pw.Widget _buildPageFooter(
    AppLocalizations localizations,
    int currentPage,
    int totalTransactions,
  ) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Page $currentPage',
            style: pw.TextStyle(fontSize: _smallFontSize),
          ),
          pw.Text(
            'Total Transactions: $totalTransactions',
            style: pw.TextStyle(fontSize: _smallFontSize),
          ),
          pw.Text(
            'Generated: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
            style: pw.TextStyle(fontSize: _smallFontSize),
          ),
        ],
      ),
    );
  }

  /// Build footer
  static pw.Widget _buildFooter(AppLocalizations localizations) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Text(
        'This report was generated by ParcelExpress Client App on ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
        style: const pw.TextStyle(
          fontSize: _smallFontSize,
          color: PdfColors.grey600,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  /// Get download directory
  static Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      // Try to get the Downloads directory
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        // Navigate to the Downloads folder
        final downloadsPath = Directory(
          '${directory.parent.parent.parent.parent.path}/Download',
        );
        if (await downloadsPath.exists()) {
          return downloadsPath;
        }

        // Fallback to app-specific external directory
        final downloadDir = Directory('${directory.path}/Download');
        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }
        return downloadDir;
      }
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    }

    // Final fallback to downloads directory
    final downloadsDir = await getDownloadsDirectory();
    if (downloadsDir != null) {
      return downloadsDir;
    }

    // Ultimate fallback to documents directory
    return await getApplicationDocumentsDirectory();
  }

  /// Generate file name with timestamp
  static String _generateFileName() {
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return 'finance_report_$timestamp.pdf';
  }
}
