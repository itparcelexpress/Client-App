import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10b981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: Color(0xFF10b981),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Performance Metrics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Delivery Rate with Progress Bar
            _buildPerformanceMetric(
              'Delivery Rate',
              '$deliveryRate%',
              deliveryRate / 100,
              const Color(0xFF10b981),
              Icons.local_shipping,
            ),
            const SizedBox(height: 20),
            // Task Completion Rate
            _buildPerformanceMetric(
              'Task Completion',
              '${_calculateTaskCompletionRate()}%',
              _calculateTaskCompletionRate() / 100,
              const Color(0xFF8b5cf6),
              Icons.task_alt,
            ),
            const SizedBox(height: 20),
            // Performance Summary
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Delivered',
                    deliveredOrders.toString(),
                    const Color(0xFF10b981),
                    Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Active Tasks',
                    activeTasks.toString(),
                    const Color(0xFFf59e0b),
                    Icons.pending_actions,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Completed',
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
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
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
