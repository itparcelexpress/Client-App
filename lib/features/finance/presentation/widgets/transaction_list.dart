import 'package:client_app/core/widgets/loading_widgets.dart';
import 'package:client_app/features/finance/data/models/finance_models.dart';
import 'package:client_app/features/finance/presentation/widgets/transaction_item.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Transaction list widget displaying transaction history with automatic pagination
class TransactionList extends StatefulWidget {
  final List<Transaction> transactions;
  final bool hasMorePages;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;
  final ScrollController? scrollController;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.hasMorePages,
    required this.isLoadingMore,
    this.onLoadMore,
    this.scrollController,
  });

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  bool _hasTriggeredLoadMore = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (widget.isLoadingMore ||
        !widget.hasMorePages ||
        widget.onLoadMore == null ||
        widget.scrollController == null) {
      return;
    }

    // Trigger load more when scrolled to 80% of the content
    if (widget.scrollController!.position.pixels >=
        widget.scrollController!.position.maxScrollExtent * 0.8) {
      if (!_hasTriggeredLoadMore) {
        _hasTriggeredLoadMore = true;
        widget.onLoadMore!();

        // Reset the flag after a delay to allow for new data to load
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            _hasTriggeredLoadMore = false;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.transactions.isEmpty) {
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
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // Show transaction item
          if (index < widget.transactions.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TransactionItem(transaction: widget.transactions[index]),
            );
          }

          // Show loading indicator at the bottom when loading more
          if (index == widget.transactions.length && widget.isLoadingMore) {
            return _buildLoadingIndicator(context);
          }

          // Show end of list indicator when no more pages
          if (index == widget.transactions.length && !widget.hasMorePages) {
            return _buildEndOfListIndicator(context);
          }

          return null;
        },
        childCount:
            widget.transactions.length +
            (widget.isLoadingMore ? 1 : 0) +
            (!widget.hasMorePages && widget.transactions.isNotEmpty ? 1 : 0),
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LoadingWidgets.paginationLoading(),
    );
  }

  Widget _buildEndOfListIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.noMoreTransactions,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ),
    );
  }
}
