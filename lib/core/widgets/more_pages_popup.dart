import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:client_app/l10n/app_localizations.dart';

class MorePagesPopup extends StatefulWidget {
  final VoidCallback? onMapTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onWalletTap;
  final VoidCallback? onPricingTap;

  const MorePagesPopup({
    super.key,
    this.onMapTap,
    this.onNotificationsTap,
    this.onWalletTap,
    this.onPricingTap,
  });

  @override
  State<MorePagesPopup> createState() => _MorePagesPopupState();
}

class _MorePagesPopupState extends State<MorePagesPopup>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.black.withValues(alpha: 0.3),
          child: Center(
            child: GestureDetector(
              onTap: () {}, // Prevent closing when tapping the popup
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: _buildPopupContent(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopupContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          FadeInDown(
            duration: const Duration(milliseconds: 400),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.more_horiz_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'More Pages',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Additional features',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Menu Items
          FadeInUp(
            duration: const Duration(milliseconds: 500),
            child: Column(
              children: [
                _buildMenuItem(
                  icon: Icons.map_outlined,
                  title: 'Map',
                  subtitle: 'View locations and tracking',
                  color: const Color(0xFF06B6D4),
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onMapTap?.call();
                  },
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  icon: Icons.notifications_outlined,
                  title:
                      AppLocalizations.of(context)?.viewNotifications ??
                      'Notifications',
                  subtitle:
                      AppLocalizations.of(context)?.viewAllNotifications ??
                      'View all notifications',
                  color: const Color(0xFF8B5CF6),
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onNotificationsTap?.call();
                  },
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  icon: Icons.account_balance_wallet_outlined,
                  title: AppLocalizations.of(context)?.viewWallet ?? 'Wallet',
                  subtitle:
                      AppLocalizations.of(context)?.viewWalletSubtitle ??
                      'View wallet balance',
                  color: const Color(0xFF0EA5E9),
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onWalletTap?.call();
                  },
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  icon: Icons.price_check_outlined,
                  title: AppLocalizations.of(context)?.viewPricing ?? 'Pricing',
                  subtitle:
                      AppLocalizations.of(context)?.viewDeliveryPricing ??
                      'View delivery pricing',
                  color: const Color(0xFF10B981),
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onPricingTap?.call();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1a1a1a),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}

class MorePagesButton extends StatelessWidget {
  final VoidCallback? onMapTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onWalletTap;
  final VoidCallback? onPricingTap;

  const MorePagesButton({
    super.key,
    this.onMapTap,
    this.onNotificationsTap,
    this.onWalletTap,
    this.onPricingTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMorePagesPopup(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667eea).withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.more_horiz_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  void _showMorePagesPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => MorePagesPopup(
            onMapTap: onMapTap,
            onNotificationsTap: onNotificationsTap,
            onWalletTap: onWalletTap,
            onPricingTap: onPricingTap,
          ),
    );
  }
}
