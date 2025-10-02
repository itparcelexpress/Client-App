import 'package:client_app/core/services/messaging_service.dart';
import 'package:client_app/core/widgets/app_version_wrapper.dart';
import 'package:client_app/core/widgets/loading_widgets.dart';
import 'package:client_app/features/finance/cubit/finance_cubit.dart';
import 'package:client_app/features/finance/data/models/finance_models.dart';
import 'package:client_app/features/finance/data/services/excel_export_service.dart';
import 'package:client_app/features/finance/presentation/widgets/finance_filter_widget.dart';
import 'package:client_app/features/finance/presentation/widgets/finance_summary_card.dart';
import 'package:client_app/features/finance/presentation/widgets/settlement_request_dialog.dart';
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
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

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

  Future<void> _exportToPdf(FinanceData data) async {
    final localizations = AppLocalizations.of(context)!;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(localizations.exportToPdf),
            content: Text(localizations.confirmExportPdf),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(localizations.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(localizations.exportToPdf),
              ),
            ],
          ),
    );

    if (confirmed != true) return;

    try {
      final filePath = await context.read<FinanceCubit>().exportToPdf(
        localizations,
      );

      if (mounted) {
        // Open the PDF file
        try {
          final result = await OpenFile.open(filePath);

          if (result.type == ResultType.done && mounted) {
            MessagingService.showSuccess(
              context,
              'PDF exported successfully. Check app documents folder.',
            );
          } else {
            throw Exception('Could not open file: ${result.message}');
          }
        } catch (openError) {
          if (mounted) {
            MessagingService.showSuccess(
              context,
              'PDF exported successfully. Check app documents folder.',
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = localizations.pdfExportFailed;

        if (e.toString().contains('Storage permission denied')) {
          errorMessage = localizations.storagePermissionRequired;
        } else if (e.toString().contains(
          'Could not access storage directory',
        )) {
          errorMessage = localizations.unableToAccessStorage;
        }

        MessagingService.showError(
          context,
          errorMessage,
          actionLabel:
              e.toString().contains('Storage permission denied')
                  ? AppLocalizations.of(context)!.settings
                  : null,
          onActionTap:
              e.toString().contains('Storage permission denied')
                  ? () async {
                    try {
                      await openAppSettings();
                    } catch (settingsError) {
                      if (mounted) {
                        MessagingService.showWarning(
                          context,
                          AppLocalizations.of(
                            context,
                          )!.manuallyEnablePermission,
                        );
                      }
                    }
                  }
                  : null,
        );
      }
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
                  '$fileExtension exported successfully. Check app documents folder.',
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 4),
              ),
            );
          } else {
            // File couldn't be opened, show manual option
            throw Exception('Could not open file: ${result.message}');
          }
        } catch (openError) {
          // If opening fails, show a message with option to open manually
          MessagingService.showSuccess(
            context,
            '${localizations.excelExportSuccess}\nFile saved to: ${filePath.split('/').last}',
            actionLabel: localizations.openExcelFile,
            onActionTap: () async {
              try {
                final result = await OpenFile.open(filePath);
                if (result.type != ResultType.done) {
                  if (mounted) {
                    MessagingService.showInfo(
                      context,
                      '${localizations.fileSavedToDownloads}. ${localizations.checkFileManager}.',
                    );
                  }
                }
              } catch (e) {
                // Show error if manual open also fails
                if (mounted) {
                  MessagingService.showInfo(
                    context,
                    '${localizations.fileSavedToDownloads}. ${localizations.checkFileManager}.',
                  );
                }
              }
            },
          );
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = AppLocalizations.of(context)!.excelExportFailed;

        // Provide specific error messages for common issues
        if (e.toString().contains('Storage permission denied')) {
          errorMessage =
              AppLocalizations.of(context)!.storagePermissionRequired;
        } else if (e.toString().contains(
          'Could not access storage directory',
        )) {
          errorMessage = AppLocalizations.of(context)!.unableToAccessStorage;
        }

        MessagingService.showError(
          context,
          errorMessage,
          actionLabel:
              e.toString().contains('Storage permission denied')
                  ? AppLocalizations.of(context)!.settings
                  : null,
          onActionTap:
              e.toString().contains('Storage permission denied')
                  ? () async {
                    // Open app settings to grant permissions
                    try {
                      await openAppSettings();
                    } catch (settingsError) {
                      if (mounted) {
                        MessagingService.showWarning(
                          context,
                          AppLocalizations.of(
                            context,
                          )!.manuallyEnablePermission,
                        );
                      }
                    }
                  }
                  : null,
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

  Future<void> _showSettlementRequestDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const SettlementRequestDialog(),
    );

    if (result != null && mounted) {
      final amount = result['amount'] as double;
      final notes = result['notes'] as String;

      await context.read<FinanceCubit>().submitSettlementRequest(
        amount: amount,
        notes: notes,
        context: context,
      );
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
            // Settlement Request Button
            BlocBuilder<FinanceCubit, FinanceState>(
              builder: (context, state) {
                if (state is FinanceLoaded) {
                  final isSubmitting =
                      context
                          .read<FinanceCubit>()
                          .isSubmittingSettlementRequest;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed:
                          isSubmitting ? null : _showSettlementRequestDialog,
                      icon:
                          isSubmitting
                              ? LoadingWidgets.compactLoading()
                              : const Icon(
                                Icons.account_balance_wallet_rounded,
                                color: Colors.white,
                              ),
                      tooltip: AppLocalizations.of(context)!.requestSettlement,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            // Export Menu
            BlocBuilder<FinanceCubit, FinanceState>(
              builder: (context, state) {
                if (state is FinanceLoaded) {
                  return PopupMenuButton<String>(
                    icon:
                        _isExporting ||
                                context.read<FinanceCubit>().isExportingPdf
                            ? LoadingWidgets.compactLoading()
                            : const Icon(Icons.file_download_outlined),
                    onSelected: (value) async {
                      switch (value) {
                        case 'excel':
                          await _exportToExcel(state.data);
                          break;
                        case 'pdf':
                          await _exportToPdf(state.data);
                          break;
                      }
                    },
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(
                            value: 'excel',
                            enabled:
                                !_isExporting &&
                                !context.read<FinanceCubit>().isExportingPdf,
                            child: Row(
                              children: [
                                const Icon(Icons.table_chart_outlined),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context)!.exportToExcel,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'pdf',
                            enabled:
                                !_isExporting &&
                                !context.read<FinanceCubit>().isExportingPdf,
                            child: Row(
                              children: [
                                const Icon(Icons.picture_as_pdf_outlined),
                                const SizedBox(width: 8),
                                Text(AppLocalizations.of(context)!.exportToPdf),
                              ],
                            ),
                          ),
                        ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocConsumer<FinanceCubit, FinanceState>(
          listener: (context, state) {
            if (state is FinanceError) {
              MessagingService.showError(context, state.message);
            } else if (state is FinancePdfExportError) {
              MessagingService.showError(context, state.message);
            } else if (state is FinanceSettlementRequestSuccess) {
              MessagingService.showSuccess(context, state.message);
            } else if (state is FinanceSettlementRequestError) {
              MessagingService.showError(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is FinanceLoading) {
              return LoadingWidgets.fullScreenLoading(
                message: AppLocalizations.of(context)!.loadingFinanceData,
              );
            } else if (state is FinanceError) {
              return _buildErrorState(context, state.message);
            } else if (state is FinanceLoaded) {
              return _buildLoadedState(context, state);
            } else if (state is FinanceSettlementRequestSubmitting) {
              // Show loading with settlement request message
              return LoadingWidgets.fullScreenLoading(
                message:
                    AppLocalizations.of(context)!.submittingSettlementRequest,
              );
            } else if (state is FinanceSettlementRequestSuccess) {
              // Show success message and return to previous state
              // The cubit will handle returning to FinanceLoaded state
              return LoadingWidgets.fullScreenLoading(message: state.message);
            } else if (state is FinanceSettlementRequestError) {
              // Show error message and return to previous state
              // The cubit will handle returning to FinanceLoaded state
              return LoadingWidgets.fullScreenLoading(message: state.message);
            } else {
              return LoadingWidgets.fullScreenLoading(
                message: AppLocalizations.of(context)!.loadingFinanceData,
              );
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
        if (_isRefreshing) return;
        _isRefreshing = true;
        try {
          await context.read<FinanceCubit>().refreshFinanceData();
        } finally {
          _isRefreshing = false;
        }
      },
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Filter Widget
          SliverToBoxAdapter(
            child: FinanceFilterWidget(
              currentFilter: context.read<FinanceCubit>().currentFilter,
              onFilterChanged: (filter) {
                if (filter != null) {
                  context.read<FinanceCubit>().applyFilter(filter);
                } else {
                  context.read<FinanceCubit>().clearFilters();
                }
              },
            ),
          ),

          // Finance Summary Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            isLoadingMore: state.isLoadingMore,
            scrollController: _scrollController,
            onLoadMore: () {
              context.read<FinanceCubit>().loadMoreFinanceData();
            },
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
