import 'package:animate_do/animate_do.dart';
import 'package:client_app/features/dashboard/data/models/dashboard_models.dart';
import 'package:flutter/material.dart';

class RecentActivityWidget extends StatelessWidget {
  final List<ActivityData> activities;

  const RecentActivityWidget({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 900),
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
                    color: const Color(0xFFef4444).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.history,
                    color: Color(0xFFef4444),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (activities.isEmpty)
              _buildEmptyState()
            else
              ...activities
                  .take(5)
                  .map((activity) => _buildActivityItem(activity)),
            if (activities.length > 5)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: Navigate to full activity list
                    },
                    child: const Text(
                      'View All Activities',
                      style: TextStyle(
                        color: Color(0xFF667eea),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(ActivityData activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF667eea).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.local_shipping,
              color: Color(0xFF667eea),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${activity.count} orders created',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Activity on ${_formatDate(activity.date)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF10b981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              activity.count.toString(),
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF10b981),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Recent Activity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your recent activities will appear here',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }
}
