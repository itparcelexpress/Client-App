import 'package:client_app/features/finance/data/models/finance_models.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Individual transaction item widget
class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with type and amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_buildTransactionType(context), _buildAmount(context)],
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              transaction.description,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 8),

            // Footer row with reference and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_buildReference(context), _buildDate(context)],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionType(BuildContext context) {
    Color typeColor;
    IconData typeIcon;
    String typeText;

    switch (transaction.type.toLowerCase()) {
      case 'cod':
        typeColor = Colors.green;
        typeIcon = Icons.money;
        typeText = AppLocalizations.of(context)!.codTransaction;
        break;
      case 'fee':
        typeColor = Colors.orange;
        typeIcon = Icons.receipt;
        typeText = AppLocalizations.of(context)!.feeTransaction;
        break;
      case 'settlement':
        typeColor = Colors.blue;
        typeIcon = Icons.account_balance;
        typeText = AppLocalizations.of(context)!.settlementTransaction;
        break;
      default:
        typeColor = Colors.grey;
        typeIcon = Icons.receipt_long;
        typeText = transaction.type;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: typeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: typeColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(typeIcon, size: 14, color: typeColor),
          const SizedBox(width: 4),
          Text(
            typeText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: typeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmount(BuildContext context) {
    final isCredit = transaction.isCredit;
    final color = isCredit ? Colors.green : Colors.red;
    final sign = isCredit ? '+' : '-';
    final icon =
        isCredit ? Icons.add_circle_outline : Icons.remove_circle_outline;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          '$sign${transaction.amount.abs().toStringAsFixed(2)} OMR',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildReference(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.tag, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          transaction.reference,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildDate(BuildContext context) {
    String formattedDate;
    try {
      final date = DateTime.parse(transaction.date);
      formattedDate = DateFormat('MMM dd, yyyy HH:mm').format(date);
    } catch (e) {
      formattedDate = transaction.date;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          formattedDate,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
