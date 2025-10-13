import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:client_app/l10n/app_localizations.dart';

class PerformanceWidget extends StatelessWidget {
  final int deliveryRate;
  final int deliveredOrders;
  final int totalOrders;
  final int activeTasks;
  final int completedTasks;

  const PerformanceWidget({
    super.key,
    required this.deliveryRate,
    required this.deliveredOrders,
    required this.totalOrders,
    required this.activeTasks,
    required this.completedTasks,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 4),
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
                    color: const Color(0xFF10b981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: Color(0xFF10b981),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  AppLocalizations.of(context)!.performanceMetrics,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Delivery Rate with Progress Bar
            _buildPerformanceMetric(
              AppLocalizations.of(context)!.deliveryRate,
              '$deliveryRate%',
              deliveryRate / 100,
              const Color(0xFF10b981),
              Icons.local_shipping,
            ),
            const SizedBox(height: 12),
            // Task Completion Rate
            _buildPerformanceMetric(
              AppLocalizations.of(context)!.taskCompletion,
              '${_calculateTaskCompletionRate()}%',
              _calculateTaskCompletionRate() / 100,
              const Color(0xFF8b5cf6),
              Icons.task_alt,
            ),
            const SizedBox(height: 12),
            // Performance Summary
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    AppLocalizations.of(context)!.delivered,
                    deliveredOrders.toString(),
                    const Color(0xFF10b981),
                    Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricCard(
                    AppLocalizations.of(context)!.activeTasks,
                    activeTasks.toString(),
                    const Color(0xFFf59e0b),
                    Icons.pending_actions,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricCard(
                    AppLocalizations.of(context)!.completedTasks,
                    completedTasks.toString(),
                    const Color(0xFF667eea),
                    Icons.task,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetric(
    String title,
    String value,
    double progress,
    Color color,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  double _calculateTaskCompletionRate() {
    final totalTasks = activeTasks + completedTasks;
    if (totalTasks == 0) return 0.0;
    return (completedTasks / totalTasks * 100);
  }
}
