import 'package:client_app/features/finance/data/models/finance_models.dart';
import 'package:client_app/features/finance/presentation/widgets/transaction_item.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Transaction list widget displaying transaction history
class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final bool hasMorePages;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.hasMorePages,
    required this.isLoadingMore,
    this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.noTransactionsYet,
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
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        // Show transaction item
        if (index < transactions.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TransactionItem(transaction: transactions[index]),
          );
        }

        // Show load more button or loading indicator
        if (index == transactions.length) {
          return _buildLoadMoreSection(context);
        }

        return null;
      }, childCount: transactions.length + (hasMorePages ? 1 : 0)),
    );
  }

  Widget _buildLoadMoreSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (isLoadingMore)
            const CircularProgressIndicator()
          else if (hasMorePages && onLoadMore != null)
            ElevatedButton(
              onPressed: onLoadMore,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withOpacity(0.1),
                foregroundColor: Theme.of(context).primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(AppLocalizations.of(context)!.loadMoreTransactions),
            )
          else
            Text(
              AppLocalizations.of(context)!.noMoreTransactions,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
        ],
      ),
    );
  }
}
