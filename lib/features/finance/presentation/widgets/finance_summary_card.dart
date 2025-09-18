import 'package:client_app/features/finance/data/models/finance_models.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Finance summary card displaying account balance and financial overview
class FinanceSummaryCard extends StatelessWidget {
  final AccountSummary summary;

  const FinanceSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.financeSummary,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Current Balance (Highlighted)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    Theme.of(context).primaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.currentBalance,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${summary.currentBalance.toStringAsFixed(2)} OMR',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Financial Metrics Grid
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    context,
                    AppLocalizations.of(context)!.totalCod,
                    '${summary.totalCod.toStringAsFixed(2)} OMR',
                    Icons.money,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    context,
                    AppLocalizations.of(context)!.totalFees,
                    '${summary.totalFees.toStringAsFixed(2)} OMR',
                    Icons.receipt,
                    Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    context,
                    AppLocalizations.of(context)!.totalSettlements,
                    '${summary.totalSettlements.toStringAsFixed(2)} OMR',
                    Icons.account_balance,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(), // Empty space for symmetry
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
