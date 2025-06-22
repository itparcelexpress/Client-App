import 'package:animate_do/animate_do.dart';
import 'package:client_app/core/utilities/responsive_utils.dart';
import 'package:flutter/material.dart';

class StatCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const StatCardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
            context,
            const EdgeInsets.all(20),
          ),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(16),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: ResponsiveUtils.getResponsiveWidth(context, 48),
                    height: ResponsiveUtils.getResponsiveHeight(context, 48),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: ResponsiveUtils.getResponsiveWidth(context, 24),
                    ),
                  ),
                  if (onTap != null)
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey[400],
                      size: ResponsiveUtils.getResponsiveWidth(context, 16),
                    ),
                ],
              ),
              SizedBox(
                height: ResponsiveUtils.getResponsivePadding(context, 16),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 28),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1a1a1a),
                ),
              ),
              SizedBox(
                height: ResponsiveUtils.getResponsivePadding(context, 4),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
