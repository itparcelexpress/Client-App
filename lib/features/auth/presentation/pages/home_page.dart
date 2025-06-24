import 'package:animate_do/animate_do.dart';
import 'package:client_app/core/utilities/responsive_utils.dart';
import 'package:client_app/data/local/local_data.dart';
import 'package:client_app/features/auth/cubit/auth_cubit.dart';
import 'package:client_app/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:client_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:client_app/features/notifications/notifications.dart';
import 'package:client_app/features/profile/presentation/pages/notification_settings_page.dart';
import 'package:client_app/features/shipment/cubit/shipment_cubit.dart';
import 'package:client_app/features/shipment/presentation/pages/orders_list_page.dart';
import 'package:client_app/features/shipment/presentation/pages/shipment_page.dart';
import 'package:client_app/injections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  late AnimationController _fabAnimationController;
  late List<AnimationController> _iconControllers;

  final List<NavItem> _navItems = [
    NavItem(
      icon: Icons.dashboard_rounded,
      label: 'Dashboard',
      color: const Color(0xFF667eea),
    ),
    NavItem(
      icon: Icons.receipt_long_rounded,
      label: 'Orders',
      color: const Color(0xFF10b981),
    ),
    NavItem(
      icon: Icons.person_rounded,
      label: 'Profile',
      color: const Color(0xFF8b5cf6),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _iconControllers = List.generate(
      _navItems.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    _fabAnimationController.forward();
    _iconControllers[0].forward(); // Animate first item
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabAnimationController.dispose();
    for (var controller in _iconControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: [
            BlocProvider(
              create: (context) => getIt<DashboardCubit>(),
              child: const DashboardPage(),
            ),
            _buildOrdersPage(),
            _buildProfilePage(),
          ],
        ),
        floatingActionButton: ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _fabAnimationController,
              curve: Curves.elasticOut,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667eea).withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: FloatingActionButton.extended(
              onPressed: _navigateToCreateOrder,
              backgroundColor: const Color(0xFF667eea),
              elevation: 0,
              icon: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 24,
              ),
              label: const Text(
                'Create Order',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _buildModernBottomNav(),
      ),
    );
  }

  Widget _buildModernBottomNav() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated background indicator
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _getIndicatorPosition(),
            top: 8,
            child: Container(
              width: 60,
              height: 64,
              decoration: BoxDecoration(
                color: _navItems[_selectedIndex].color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          // Navigation items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_navItems.length, (index) {
              return _buildNavItem(index);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = _navItems[index];
    final isSelected = index == _selectedIndex;

    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon
            AnimatedBuilder(
              animation: _iconControllers[index],
              builder: (context, child) {
                return Transform.scale(
                  scale:
                      isSelected
                          ? 1.0 + (_iconControllers[index].value * 0.2)
                          : 1.0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected ? item.color : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item.icon,
                      color: isSelected ? Colors.white : Colors.grey[400],
                      size: 24,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            // Animated label
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: isSelected ? 12 : 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? item.color : Colors.grey[500],
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }

  double _getIndicatorPosition() {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / _navItems.length;
    return (itemWidth * _selectedIndex) + (itemWidth - 60) / 2;
  }

  void _onNavItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    // Animate to page
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );

    // Animate icon
    _iconControllers[index].forward();
    for (int i = 0; i < _iconControllers.length; i++) {
      if (i != index) {
        _iconControllers[i].reverse();
      }
    }
  }

  void _onPageChanged(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    // Animate icon
    _iconControllers[index].forward();
    for (int i = 0; i < _iconControllers.length; i++) {
      if (i != index) {
        _iconControllers[i].reverse();
      }
    }
  }

  Widget _buildOrdersPage() {
    return BlocProvider(
      create: (context) => getIt<ShipmentCubit>(),
      child: const OrdersListPage(showAppBar: false),
    );
  }

  Widget _buildProfilePage() {
    final user = LocalData.user;

    return SafeArea(
      child: SingleChildScrollView(
        padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
          context,
          const EdgeInsets.all(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 40)),
            _buildProfileHeader(),
            SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 24)),
            _buildProfileCard(user),
            SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 24)),
            _buildSettingsSection(),
            SizedBox(
              height: ResponsiveUtils.getResponsivePadding(context, 80),
            ), // Space for FAB - reduced from 100
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return FadeInDown(
      duration: const Duration(milliseconds: 400),
      child: Row(
        children: [
          Container(
            width: ResponsiveUtils.getResponsiveWidth(context, 50),
            height: ResponsiveUtils.getResponsiveHeight(context, 50),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8b5cf6), Color(0xFF7c3aed)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8b5cf6).withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: ResponsiveUtils.getResponsiveWidth(context, 24),
            ),
          ),
          SizedBox(width: ResponsiveUtils.getResponsivePadding(context, 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      24,
                    ),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1a1a1a),
                  ),
                ),
                Text(
                  'Manage your account settings',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      14,
                    ),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: const NotificationIconWidget(
              size: 24,
              color: Color(0xFF8b5cf6),
              showBadge: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(dynamic user) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
          context,
          const EdgeInsets.all(24),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: ResponsiveUtils.getResponsiveWidth(context, 90),
              height: ResponsiveUtils.getResponsiveHeight(context, 90),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8b5cf6), Color(0xFF7c3aed)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8b5cf6).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: ResponsiveUtils.getResponsiveWidth(context, 45),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 20)),
            Text(
              user?.name ?? 'User',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 22),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1a1a1a),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 8)),
            Text(
              user?.email ?? 'N/A',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 24)),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.badge_rounded,
                    title: 'Role',
                    value: user?.role?.name ?? 'N/A',
                    color: const Color(0xFF10b981),
                  ),
                ),
                if (user?.client?.address != null) ...[
                  SizedBox(
                    width: ResponsiveUtils.getResponsivePadding(context, 16),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.location_on_rounded,
                      title: 'Location',
                      value: 'Oman',
                      color: const Color(0xFFf59e0b),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1a1a1a),
              ),
            ),
            const SizedBox(height: 20),
            _buildSettingItem(
              icon: Icons.settings_rounded,
              title: 'Notification Settings',
              subtitle: 'Manage notification preferences',
              color: const Color(0xFF667eea),
              onTap: () {
                final user = LocalData.user;
                final clientId =
                    user?.id; // Use the main user ID, not client.id

                if (clientId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              NotificationSettingsPage(clientId: clientId),
                    ),
                  );
                } else {
                  _showComingSoon(context, 'Notification Settings');
                }
              },
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              icon: Icons.notifications_rounded,
              title: 'View Notifications',
              subtitle: 'View all notifications',
              color: const Color(0xFF8b5cf6),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsPage(),
                    ),
                  ),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              icon: Icons.security_rounded,
              title: 'Privacy & Security',
              subtitle: 'Manage your privacy settings',
              color: const Color(0xFF10b981),
              onTap: () => _showComingSoon(context, 'Privacy Settings'),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              icon: Icons.help_rounded,
              title: 'Help & Support',
              subtitle: 'Get help and support',
              color: const Color(0xFFf59e0b),
              onTap: () => _showComingSoon(context, 'Help & Support'),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              icon: Icons.logout_rounded,
              title: 'Logout',
              subtitle: 'Sign out of your account',
              color: const Color(0xFFef4444),
              onTap: () => _showLogoutDialog(context),
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
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
        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1a1a1a),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isDestructive = false,
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? color : const Color(0xFF1a1a1a),
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

  void _navigateToCreateOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BlocProvider(
              create: (context) => getIt<ShipmentCubit>(),
              child: const ShipmentPage(),
            ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    Fluttertoast.showToast(
      msg: '$feature coming soon! 🚀',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: const Color(0xFF667eea),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<AuthCubit>().logout();
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Color(0xFFef4444)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final Color color;

  NavItem({required this.icon, required this.label, required this.color});
}
