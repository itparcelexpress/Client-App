import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/models/station_model.dart';

class EnhancedLocationCard extends StatefulWidget {
  final dynamic item;
  final VoidCallback onTap;
  final bool isSelected;

  const EnhancedLocationCard({
    super.key,
    required this.item,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  State<EnhancedLocationCard> createState() => _EnhancedLocationCardState();
}

class _EnhancedLocationCardState extends State<EnhancedLocationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(begin: 4.0, end: 8.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isStation = widget.item is Station;
    final primaryColor = isStation ? Colors.blue : Colors.red;
    final backgroundColor = isStation ? Colors.blue[50]! : Colors.red[50]!;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) {
              _animationController.reverse();
              widget.onTap();
            },
            onTapCancel: () => _animationController.reverse(),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                border: Border.all(
                  color:
                      widget.isSelected
                          ? primaryColor
                          : primaryColor.withOpacity(0.2),
                  width: widget.isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: _elevationAnimation.value,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(isStation, primaryColor, backgroundColor),
                    _buildContent(isStation),
                    _buildFooter(isStation, primaryColor),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    bool isStation,
    Color primaryColor,
    Color backgroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              isStation
                  ? FontAwesomeIcons.locationDot
                  : FontAwesomeIcons.warehouse,
              color: Colors.white,
              size: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isStation ? 'Station' : 'Hub',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.isSelected)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isStation) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            FontAwesomeIcons.locationPin,
            widget.item.location,
            Colors.grey[600] ?? Colors.grey,
          ),
          const SizedBox(height: 6),
          _buildInfoRow(
            FontAwesomeIcons.phone,
            widget.item.contactNumber,
            Colors.grey[600] ?? Colors.grey,
          ),
          if (isStation) ...[
            const SizedBox(height: 6),
            _buildInfoRow(
              FontAwesomeIcons.building,
              'Hub: ${widget.item.hub.name}',
              Colors.grey[600] ?? Colors.grey,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[700],
              fontSize: 11,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(bool isStation, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
      ),
      child: Row(
        children: [
          Icon(FontAwesomeIcons.mapPin, size: 10, color: Colors.grey[500]),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '${widget.item.lat}, ${widget.item.lng}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontFamily: 'monospace',
                fontSize: 9,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.touch_app, size: 10, color: primaryColor),
                const SizedBox(width: 1),
                Text(
                  'Tap to view',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
