import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:client_app/l10n/app_localizations.dart';

class FinancialSummaryWidget extends StatelessWidget {
  final String totalOrderValue;
  final String thisMonthValue;
  final String accountBalance;
  final String parcelValue;
  final String avgOrderValue;

  const FinancialSummaryWidget({
    super.key,
    required this.totalOrderValue,
    required this.thisMonthValue,
    required this.accountBalance,
    required this.parcelValue,
    required this.avgOrderValue,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 700),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667eea).withValues(alpha: 0.25),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  AppLocalizations.of(context)!.financialOverview,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _buildFinancialItem(
                    AppLocalizations.of(context)!.totalValue,
                    '$totalOrderValue OMR',
                    Icons.monetization_on,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildFinancialItem(
                    AppLocalizations.of(context)!.thisMonth,
                    '$thisMonthValue OMR',
                    Icons.calendar_today,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildFinancialItem(
                    AppLocalizations.of(context)!.balance,
                    '$accountBalance OMR',
                    Icons.account_balance,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildFinancialItem(
                    AppLocalizations.of(context)!.avgOrder,
                    '$avgOrderValue OMR',
                    Icons.trending_up,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialItem(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 16),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
