import 'package:client_app/core/utilities/app_color.dart';
import 'package:client_app/features/invoices/cubit/invoice_cubit.dart';
import 'package:client_app/features/invoices/cubit/invoice_state.dart';
import 'package:client_app/features/invoices/presentation/widgets/payment_summary_widget.dart';
import 'package:client_app/features/invoices/presentation/widgets/payment_transaction_card.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  String? _selectedTypeFilter;

  @override
  void initState() {
    super.initState();
    // Load payment data when page loads
    context.read<InvoiceCubit>().loadPaymentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.payments),
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<InvoiceCubit>().refreshPaymentData();
            },
          ),
        ],
      ),
      body: BlocBuilder<InvoiceCubit, InvoiceState>(
        builder: (context, state) {
          if (state is PaymentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PaymentError) {
            return _buildErrorWidget(state.message);
          } else if (state is PaymentEmpty) {
            return _buildEmptyWidget();
          } else if (state is PaymentCombinedLoaded) {
            return _buildLoadedWidget(state);
          } else if (state is PaymentSummaryLoaded) {
            return SingleChildScrollView(
              child: PaymentSummaryWidget(summary: state.summary),
            );
          } else if (state is PaymentTransactionsLoaded) {
            return _buildTransactionsOnly(state.transactions);
          }

          // Default case - show loading
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildLoadedWidget(PaymentCombinedLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<InvoiceCubit>().refreshPaymentData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            PaymentSummaryWidget(summary: state.summary),
            const SizedBox(height: 16),
            _buildTransactionsSection(state.transactions),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsOnly(List transactions) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<InvoiceCubit>().refreshPaymentData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: _buildTransactionsSection(transactions),
      ),
    );
  }

  Widget _buildTransactionsSection(List transactions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.recentTransactions,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (transactions.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.noTransactionsFound,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.tryAdjustingFilters,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return PaymentTransactionCard(
                  transaction: transaction,
                  onTap: () => _showTransactionDetails(transaction),
                );
              },
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.errorLoadingPayments,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<InvoiceCubit>().loadPaymentData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noPaymentData,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.noPaymentTransactionsFound,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<InvoiceCubit>().loadPaymentData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text(AppLocalizations.of(context)!.refresh),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.filterTransactions),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.paymentType),
                Wrap(
                  children:
                      ['cod', 'card', 'bank'].map((type) {
                        return FilterChip(
                          label: Text(type.toUpperCase()),
                          selected: _selectedTypeFilter == type,
                          onSelected: (selected) {
                            setState(() {
                              _selectedTypeFilter = selected ? type : null;
                            });
                          },
                        );
                      }).toList(),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _applyFilters();
                  },
                  child: Text(AppLocalizations.of(context)!.applyFilters),
                ),
              ],
            ),
          ),
    );
  }

  void _applyFilters() {
    if (_selectedTypeFilter != null) {
      context.read<InvoiceCubit>().filterTransactionsByType(
        _selectedTypeFilter,
      );
    }
  }

  void _showTransactionDetails(transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.transactionDetails,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  AppLocalizations.of(context)!.trackingNo,
                  transaction.trackingNo,
                ),
                _buildDetailRow(
                  AppLocalizations.of(context)!.amount,
                  transaction.formattedAmount,
                ),
                _buildDetailRow(
                  AppLocalizations.of(context)!.type,
                  transaction.typeLabel,
                ),
                _buildDetailRow(
                  AppLocalizations.of(context)!.status,
                  transaction.status.toUpperCase(),
                ),
                _buildDetailRow(
                  AppLocalizations.of(context)!.customer,
                  transaction.customerName,
                ),
                _buildDetailRow(
                  AppLocalizations.of(context)!.phone,
                  transaction.customerPhone,
                ),
                _buildDetailRow(
                  AppLocalizations.of(context)!.date,
                  transaction.createdAt.toString(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
