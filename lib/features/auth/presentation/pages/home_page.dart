import 'package:animate_do/animate_do.dart';
import 'package:client_app/core/utilities/responsive_utils.dart';
import 'package:client_app/core/widgets/stylish_bottom_navigation.dart';
import 'package:client_app/data/local/local_data.dart';
import 'package:client_app/features/auth/cubit/auth_cubit.dart';
import 'package:client_app/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:client_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:client_app/features/invoices/invoices.dart';
import 'package:client_app/features/notifications/notifications.dart';
import 'package:client_app/features/pricing/pricing.dart';
import 'package:client_app/features/profile/presentation/pages/notification_settings_page.dart';
import 'package:client_app/features/shipment/cubit/shipment_cubit.dart';
import 'package:client_app/features/shipment/presentation/pages/orders_list_page.dart';
import 'package:client_app/features/shipment/presentation/pages/create_order_page.dart';
import 'package:client_app/features/wallet/cubit/wallet_cubit.dart';
import 'package:client_app/features/wallet/data/repositories/wallet_repository.dart';
import 'package:client_app/features/wallet/presentation/pages/wallet_page.dart';
import 'package:client_app/features/map/cubit/map_cubit.dart';
import 'package:client_app/features/map/presentation/pages/map_page.dart';
import 'package:client_app/features/map/presentation/pages/locations_list_page.dart';
import 'package:client_app/injections.dart';
import 'package:client_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_app/l10n/app_localizations.dart';

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

  // Using Salomon navigation style
  NavigationStyle _navigationStyle = NavigationStyle.salomon;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _iconControllers = List.generate(
      6,
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
    // Bottom navigation destinations are now built directly in _buildNavigationBar()
    return Scaffold(
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
          _buildCreateOrderPage(),
          _buildMapPage(),
          _buildInvoicesPage(),
          _buildProfilePage(),
        ],
      ),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  Widget _buildNavigationBar() {
    // Create navigation items with localized labels
    final navigationItems = [
      NavigationItem(
        icon: Icons.dashboard_outlined,
        label: AppLocalizations.of(context)!.dashboard,
        selectedColor: const Color(0xFF6366F1),
        unselectedColor: Colors.grey,
      ),
      NavigationItem(
        icon: Icons.receipt_long_outlined,
        label: AppLocalizations.of(context)!.orders,
        selectedColor: const Color(0xFF10B981),
        unselectedColor: Colors.grey,
      ),
      NavigationItem(
        icon: Icons.add_circle_outline,
        label: AppLocalizations.of(context)!.createOrder,
        selectedColor: const Color(0xFFF59E0B),
        unselectedColor: Colors.grey,
      ),
      NavigationItem(
        icon: Icons.map_outlined,
        label: 'Map',
        selectedColor: const Color(0xFF06B6D4),
        unselectedColor: Colors.grey,
      ),
      NavigationItem(
        icon: Icons.receipt_outlined,
        label: AppLocalizations.of(context)!.invoices,
        selectedColor: const Color(0xFF8B5CF6),
        unselectedColor: Colors.grey,
      ),
      NavigationItem(
        icon: Icons.person_outline,
        label: AppLocalizations.of(context)!.profile,
        selectedColor: const Color(0xFFEF4444),
        unselectedColor: Colors.grey,
      ),
    ];

    return StylishBottomNavigation(
      selectedIndex: _selectedIndex,
      style: _navigationStyle,
      items: navigationItems,
      onTap: (int index) {
        if (index != _selectedIndex) {
          _onNavItemTapped(index);
        }
      },
    );
  }

  // Legacy bottom nav item builder removed (replaced by Material NavigationBar)

  // Legacy indicator position method removed

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

  Widget _buildCreateOrderPage() {
    return BlocProvider(
      create: (context) => getIt<ShipmentCubit>(),
      child: const CreateOrderPage(),
    );
  }

  Widget _buildMapPage() {
    return BlocProvider(
      create: (context) => getIt<MapCubit>(),
      child: const MapPage(),
    );
  }

  Widget _buildInvoicesPage() {
    return BlocProvider(
      create: (context) => getIt<InvoiceCubit>(),
      child: const InvoicesPage(showAppBar: false),
    );
  }

  Widget _buildProfilePage() {
    final user = LocalData.user;

    // Debug: Print user data when profile page loads
    print('🟢 Profile Page - User Data:');
    print('🟢 User ID: ${user?.id}');
    print('🟢 Client ID: ${user?.client?.id}');
    print('🟢 Full User: ${user?.toJson()}');

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
                  AppLocalizations.of(context)!.profile,
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
                  AppLocalizations.of(
                    context,
                  )!.manageNotificationPreferences, // Closest available
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
              user?.name ?? AppLocalizations.of(context)!.user,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 22),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1a1a1a),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 8)),
            Text(
              user?.email ?? AppLocalizations.of(context)!.notAvailable,
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
                    title: AppLocalizations.of(context)!.role,
                    value:
                        user?.role?.name ??
                        AppLocalizations.of(context)!.notAvailable,
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
                      title: AppLocalizations.of(context)!.location,
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
            Text(
              AppLocalizations.of(context)!.settings,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1a1a1a),
              ),
            ),
            const SizedBox(height: 20),
            _buildSettingItem(
              icon: Icons.settings_rounded,
              title: AppLocalizations.of(context)!.notificationSettings,
              subtitle:
                  AppLocalizations.of(context)!.manageNotificationPreferences,
              color: const Color(0xFF667eea),
              onTap: () {
                final user = LocalData.user;
                final userId = user?.id; // Main user ID for the API endpoint
                final clientId =
                    user?.client?.id; // Client ID for the form data

                print('🟢 User Data Debug:');
                print('🟢 User ID: $userId');
                print('🟢 Client ID: $clientId');
                print('🟢 User: ${user?.toJson()}');
                print('🟢 Client: ${user?.client?.toJson()}');

                if (userId != null && clientId != null) {
                  print(
                    '🟢 Navigating to NotificationSettingsPage with userId: $userId, clientId: $clientId',
                  );
                  _navigateWithSlideTransition(
                    NotificationSettingsPage(
                      userId: userId, // For API endpoint
                      clientId: clientId, // For form data
                    ),
                  );
                } else {
                  print(
                    '🔴 Missing user data - userId: $userId, clientId: $clientId',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.notAvailable),
                      backgroundColor: Colors.orange,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            // Language toggle button
            _buildLanguageToggleItem(),
            const SizedBox(height: 16),
            _buildSettingItem(
              icon: Icons.notifications_rounded,
              title: AppLocalizations.of(context)!.viewNotifications,
              subtitle: AppLocalizations.of(context)!.viewAllNotifications,
              color: const Color(0xFF8b5cf6),
              onTap:
                  () => _navigateWithSlideTransition(const NotificationsPage()),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              icon: Icons.account_balance_wallet_rounded,
              title: AppLocalizations.of(context)!.viewWallet,
              subtitle: AppLocalizations.of(context)!.viewWalletSubtitle,
              color: const Color(0xFF0ea5e9),
              onTap: () {
                _navigateWithSlideTransition(
                  BlocProvider(
                    create:
                        (_) =>
                            WalletCubit(const WalletRepository())..loadWallet(),
                    child: const WalletPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              icon: Icons.price_check_rounded,
              title: AppLocalizations.of(context)!.viewPricing,
              subtitle: AppLocalizations.of(context)!.viewDeliveryPricing,
              color: const Color(0xFF10b981),
              onTap: () => _navigateWithSlideTransition(const PricingPage()),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              icon: Icons.logout_rounded,
              title: AppLocalizations.of(context)!.logout,
              subtitle: AppLocalizations.of(context)!.signOutAccount,
              color: const Color(0xFFef4444),
              onTap: () => _showLogoutDialog(context),
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageToggleItem() {
    // Get current locale from context
    final currentLocale = Localizations.localeOf(context);
    final isEnglish = currentLocale.languageCode == 'en';

    return GestureDetector(
      onTap: () {
        // Toggle between Arabic and English
        final newLocale =
            isEnglish ? const Locale('ar', 'SA') : const Locale('en', 'US');

        // Use the existing MyApp.setLocale mechanism
        MyApp.of(context)?.setLocale(newLocale);

        // Show feedback to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEnglish
                  ? AppLocalizations.of(context)!.languageChangedToArabic
                  : AppLocalizations.of(context)!.languageChangedToEnglish,
            ),
            backgroundColor: const Color(0xFF667eea),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF667eea).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF667eea).withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF667eea).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.language,
                color: Color(0xFF667eea),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEnglish ? 'التبديل إلى العربية' : 'Switch to English',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1a1a1a),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isEnglish ? 'العربية' : 'English',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF667eea),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF667eea),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isEnglish ? 'AR' : 'EN',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
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

  void _navigateWithSlideTransition(Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            AppLocalizations.of(context)!.logout,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: Text(AppLocalizations.of(context)!.logoutConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                // Call logout using a callback approach to ensure we use the right instance
                _performLogout();
              },
              child: Text(
                AppLocalizations.of(context)!.logout,
                style: const TextStyle(color: Color(0xFFef4444)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() async {
    try {
      // Try to find the AuthCubit in the current widget tree
      final authCubit = BlocProvider.of<AuthCubit>(context, listen: false);
      await authCubit.logout();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.logoutSuccessful),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      // Fallback: Clear local data and let AuthWrapper handle navigation
      await LocalData.logout();

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.logoutSuccessful),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // The AuthWrapper will automatically show LoginPage when it detects no auth
        // Force refresh the AuthWrapper by navigating to it
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthWrapper()),
          (route) => false,
        );
      }
    }
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final Color color;

  NavItem({required this.icon, required this.label, required this.color});
}
