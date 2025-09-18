import 'package:client_app/core/widgets/app_version_wrapper.dart';
import 'package:client_app/features/finance/cubit/finance_cubit.dart';
import 'package:client_app/features/finance/data/models/finance_models.dart';
import 'package:client_app/features/finance/data/services/excel_export_service.dart';
import 'package:client_app/features/finance/presentation/widgets/finance_summary_card.dart';
import 'package:client_app/features/finance/presentation/widgets/transaction_list.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

/// Finance page displaying account balance and transaction history
class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  late ScrollController _scrollController;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Load initial finance data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FinanceCubit>().loadFinanceData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // Load more when scrolled to 80% of the content
      context.read<FinanceCubit>().loadMoreFinanceData();
    }
  }

  Future<void> _exportToExcel(FinanceData data) async {
    if (_isExporting) return;

    setState(() {
      _isExporting = true;
    });

    try {
      final localizations = AppLocalizations.of(context)!;
      String filePath;

      // Try Excel first, fallback to CSV if Excel fails
      try {
        filePath = await ExcelExportService.exportFinanceDataToExcel(
          financeData: data,
          localizations: localizations,
        );
      } catch (excelError) {
        if (kDebugMode) {
          print('Excel export failed, trying CSV: $excelError');
        }
        // Fallback to CSV
        filePath = await ExcelExportService.exportFinanceDataToCSV(
          financeData: data,
          localizations: localizations,
        );
      }

      if (mounted) {
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        // Automatically open the Excel file
        try {
          final result = await OpenFile.open(filePath);

          if (result.type == ResultType.done) {
            // Show success message
            final fileExtension = filePath.endsWith('.csv') ? 'CSV' : 'Excel';
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(
                  '$fileExtension ${localizations.excelExportSuccess}',
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          } else {
            // File couldn't be opened, show manual option
            throw Exception('Could not open file: ${result.message}');
          }
        } catch (openError) {
          // If opening fails, show a message with option to open manually
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(
                '${localizations.excelExportSuccess}\nFile saved to: ${filePath.split('/').last}',
              ),
              backgroundColor: Colors.green,
              action: SnackBarAction(
                label: localizations.openExcelFile,
                textColor: Colors.white,
                onPressed: () async {
                  try {
                    final result = await OpenFile.open(filePath);
                    if (result.type != ResultType.done) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'File saved to Downloads folder. Check your file manager.',
                            ),
                            backgroundColor: Colors.blue,
                            duration: const Duration(seconds: 4),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    // Show error if manual open also fails
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'File saved to Downloads folder. Check your file manager.',
                          ),
                          backgroundColor: Colors.blue,
                          duration: const Duration(seconds: 4),
                        ),
                      );
                    }
                  }
                },
              ),
              duration: const Duration(seconds: 6),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = AppLocalizations.of(context)!.excelExportFailed;

        // Provide specific error messages for common issues
        if (e.toString().contains('Storage permission denied')) {
          errorMessage =
              'Storage permission is required to save Excel files. Please grant permission in app settings.';
        } else if (e.toString().contains(
          'Could not access storage directory',
        )) {
          errorMessage =
              'Unable to access storage. Please check your device storage and try again.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action:
                e.toString().contains('Storage permission denied')
                    ? SnackBarAction(
                      label: 'Settings',
                      textColor: Colors.white,
                      onPressed: () async {
                        // Open app settings to grant permissions
                        try {
                          await openAppSettings();
                        } catch (settingsError) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please manually enable storage permission in app settings',
                                ),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        }
                      },
                    )
                    : null,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppVersionWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.finance),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            BlocBuilder<FinanceCubit, FinanceState>(
              builder: (context, state) {
                if (state is FinanceLoaded) {
                  return IconButton(
                    icon:
                        _isExporting
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(Icons.file_download_outlined),
                    onPressed:
                        _isExporting ? null : () => _exportToExcel(state.data),
                    tooltip: AppLocalizations.of(context)!.exportToExcel,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<FinanceCubit>().refreshFinanceData();
              },
              tooltip: AppLocalizations.of(context)!.refreshFinanceData,
            ),
          ],
        ),
        body: BlocConsumer<FinanceCubit, FinanceState>(
          listener: (context, state) {
            if (state is FinanceError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is FinanceLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FinanceError) {
              return _buildErrorState(context, state.message);
            } else if (state is FinanceLoaded) {
              return _buildLoadedState(context, state);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.errorLoadingFinance,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<FinanceCubit>().loadFinanceData();
            },
            child: Text(AppLocalizations.of(context)!.tryAgain),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, FinanceLoaded state) {
    final data = state.data;

    if (data.transactions.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<FinanceCubit>().refreshFinanceData();
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Finance Summary Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FinanceSummaryCard(summary: data.summary),
            ),
          ),

          // Transaction Count Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.transactionHistory,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.showingTransactionsCount(
                      data.transactions.length,
                      data.total,
                    ),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Transaction List
          TransactionList(
            transactions: data.transactions,
            hasMorePages: data.hasMorePages,
            isLoadingMore: state is FinanceLoadingMore,
            onLoadMore: () {
              context.read<FinanceCubit>().loadMoreFinanceData();
            },
          ),

          // Loading more indicator
          if (state is FinanceLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noFinanceData,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.transactionsWillAppearHere,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<FinanceCubit>().loadFinanceData();
            },
            child: Text(AppLocalizations.of(context)!.refresh),
          ),
        ],
      ),
    );
  }
}
