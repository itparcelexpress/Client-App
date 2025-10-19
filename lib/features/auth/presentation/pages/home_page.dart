import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:client_app/core/services/messaging_service.dart';
import 'package:client_app/core/utilities/responsive_utils.dart';
import 'package:client_app/core/widgets/stylish_bottom_navigation.dart';
import 'package:client_app/core/widgets/more_pages_popup.dart';
import 'package:client_app/core/services/global_auth_manager.dart';
import 'package:client_app/data/local/local_data.dart';
import 'package:client_app/features/auth/cubit/auth_cubit.dart';
import 'package:client_app/features/auth/data/repositories/auth_repository.dart';
import 'package:client_app/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:client_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:client_app/features/auth/presentation/pages/login_page.dart';
import 'package:client_app/features/finance/cubit/finance_cubit.dart';
import 'package:client_app/features/finance/presentation/pages/finance_page.dart';
import 'package:client_app/features/notifications/notifications.dart';
import 'package:client_app/features/pricing/pricing.dart';
import 'package:client_app/features/profile/presentation/pages/notification_settings_page.dart';
import 'package:client_app/features/shipment/cubit/shipment_cubit.dart';
import 'package:client_app/features/shipment/presentation/pages/orders_list_page.dart';
import 'package:client_app/features/shipment/presentation/pages/create_order_page.dart';
import 'package:client_app/features/map/cubit/map_cubit.dart';
import 'package:client_app/features/map/presentation/pages/enhanced_map_page.dart';
import 'package:client_app/injections.dart';
import 'package:client_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      5,
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
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          await _onWillPop(context);
        }
      },
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
            _buildCreateOrderPage(),
            _buildFinancePage(),
            _buildProfilePage(),
          ],
        ),
        bottomNavigationBar: _buildNavigationBar(),
        floatingActionButton: _buildMoreButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
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
        icon: Icons.account_balance_wallet_outlined,
        label: AppLocalizations.of(context)!.finance,
        selectedColor: const Color(0xFF06B6D4),
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

  // Show exit confirmation dialog
  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.exitApp),
                content: Text(
                  AppLocalizations.of(context)!.exitAppConfirmation,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(AppLocalizations.of(context)!.stay),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      AppLocalizations.of(context)!.exit,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }

  // Handle back button press
  Future<bool> _onWillPop(BuildContext context) async {
    final shouldExit = await _showExitConfirmationDialog(context);
    if (shouldExit) {
      // Exit the app
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    }
    return false; // Always return false to prevent default pop behavior
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

  Widget _buildFinancePage() {
    return BlocProvider(
      create: (context) => getIt<FinanceCubit>(),
      child: const FinancePage(),
    );
  }

  Widget _buildProfilePage() {
    final user = LocalData.user;

    return SafeArea(
      child: SingleChildScrollView(
        padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
          context,
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 10)),
            _buildCompactProfileHeader(),
            SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 12)),
            _buildCompactProfileCard(user),
            SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 16)),
            _buildCompactSettingsSection(),
            SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 16)),
            _buildCompactDangerZoneSection(),
            SizedBox(
              height: ResponsiveUtils.getResponsivePadding(context, 20),
            ), // Reduced bottom spacing
          ],
        ),
      ),
    );
  }

  Widget _buildCompactProfileHeader() {
    return FadeInDown(
      duration: const Duration(milliseconds: 400),
      child: Row(
        children: [
          Container(
            width: ResponsiveUtils.getResponsiveWidth(context, 36),
            height: ResponsiveUtils.getResponsiveHeight(context, 36),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8b5cf6), Color(0xFF7c3aed)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8b5cf6).withValues(alpha: 0.18),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: ResponsiveUtils.getResponsiveWidth(context, 18),
            ),
          ),
          SizedBox(width: ResponsiveUtils.getResponsivePadding(context, 10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.profile,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      18,
                    ),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1a1a1a),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.manageNotificationPreferences,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      11,
                    ),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(7),
            child: const NotificationIconWidget(
              size: 18,
              color: Color(0xFF8b5cf6),
              showBadge: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactProfileCard(dynamic user) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
          context,
          const EdgeInsets.all(14),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: ResponsiveUtils.getResponsiveWidth(context, 60),
              height: ResponsiveUtils.getResponsiveHeight(context, 60),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8b5cf6), Color(0xFF7c3aed)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8b5cf6).withValues(alpha: 0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: ResponsiveUtils.getResponsiveWidth(context, 30),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 12)),
            Text(
              user?.name ?? AppLocalizations.of(context)!.user,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 17),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1a1a1a),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 5)),
            Text(
              user?.email ?? AppLocalizations.of(context)!.notAvailable,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
            if (user?.client?.contactNo != null) ...[
              SizedBox(
                height: ResponsiveUtils.getResponsivePadding(context, 2),
              ),
              Text(
                user!.client!.contactNo!,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 11),
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
            SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 12)),
            if (user?.client?.governorate != null ||
                user?.client?.state != null ||
                user?.client?.place != null)
              Row(
                children: [
                  Expanded(
                    child: _buildCompactInfoItem(
                      icon: Icons.location_on_rounded,
                      title: AppLocalizations.of(context)!.location,
                      value: _getLocationString(user?.client),
                      color: const Color(0xFFf59e0b),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _getLocationString(dynamic client) {
    if (client == null) return AppLocalizations.of(context)!.notAvailable;

    List<String> locationParts = [];

    // Add place if available
    if (client.place?.enName != null) {
      final isRTL = Localizations.localeOf(context).languageCode == 'ar';
      locationParts.add(isRTL ? client.place.arName : client.place.enName);
    }

    // Add state if available
    if (client.state?.name != null) {
      locationParts.add(client.state.name);
    }

    // Add governorate if available
    if (client.governorate?.enName != null) {
      final isRTL = Localizations.localeOf(context).languageCode == 'ar';
      locationParts.add(
        isRTL ? client.governorate.arName : client.governorate.enName,
      );
    }

    // If no location data, return "Oman" as fallback
    if (locationParts.isEmpty) {
      return AppLocalizations.of(context)!.oman;
    }

    return locationParts.join(', ');
  }

  Widget _buildCompactSettingsSection() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.settings,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1a1a1a),
              ),
            ),
            const SizedBox(height: 14),
            _buildCompactSettingItem(
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

                if (userId != null && clientId != null) {
                  _navigateWithSlideTransition(
                    NotificationSettingsPage(
                      userId: userId, // For API endpoint
                      clientId: clientId, // For form data
                    ),
                  );
                } else {
                  MessagingService.showWarning(
                    context,
                    AppLocalizations.of(context)!.notAvailable,
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            // Language toggle button
            _buildCompactLanguageToggleItem(),
            const SizedBox(height: 12),
            _buildCompactSettingItem(
              icon: Icons.notifications_rounded,
              title: AppLocalizations.of(context)!.viewNotifications,
              subtitle: AppLocalizations.of(context)!.viewAllNotifications,
              color: const Color(0xFF8b5cf6),
              onTap:
                  () => _navigateWithSlideTransition(const NotificationsPage()),
            ),
            const SizedBox(height: 12),
            _buildCompactSettingItem(
              icon: Icons.price_check_rounded,
              title: AppLocalizations.of(context)!.viewPricing,
              subtitle: AppLocalizations.of(context)!.viewDeliveryPricing,
              color: const Color(0xFF10b981),
              onTap: () => _navigateWithSlideTransition(const PricingPage()),
            ),
            const SizedBox(height: 12),
            _buildCompactSettingItem(
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

  Widget _buildCompactDangerZoneSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFef4444).withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFef4444).withValues(alpha: 0.08),
            blurRadius: 12,
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFef4444).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Color(0xFFef4444),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                AppLocalizations.of(context)!.dangerZone,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFef4444),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.dangerZoneWarning,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          _buildCompactDangerZoneItem(
            icon: Icons.delete_forever_rounded,
            title: AppLocalizations.of(context)!.deleteAccountTitle,
            subtitle: AppLocalizations.of(context)!.deleteAccountSubtitle,
            onTap: _showDeleteAccountDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZoneItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFef4444).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFef4444).withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFef4444).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: const Color(0xFFef4444), size: 24),
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
                      color: Color(0xFFef4444),
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
              color: const Color(0xFFef4444).withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactDangerZoneItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFef4444).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFef4444).withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFef4444).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFFef4444), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFef4444),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: const Color(0xFFef4444).withValues(alpha: 0.5),
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
        MessagingService.showInfo(
          context,
          isEnglish
              ? AppLocalizations.of(context)!.languageChangedToArabic
              : AppLocalizations.of(context)!.languageChangedToEnglish,
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
                    isEnglish
                        ? AppLocalizations.of(context)!.switchToArabic
                        : AppLocalizations.of(context)!.switchToEnglish,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1a1a1a),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isEnglish
                        ? AppLocalizations.of(context)!.arabic
                        : AppLocalizations.of(context)!.english,
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
                isEnglish
                    ? AppLocalizations.of(context)!.arabicCode
                    : AppLocalizations.of(context)!.englishCode,
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

  Widget _buildCompactLanguageToggleItem() {
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
        MessagingService.showInfo(
          context,
          isEnglish
              ? AppLocalizations.of(context)!.languageChangedToArabic
              : AppLocalizations.of(context)!.languageChangedToEnglish,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF667eea).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF667eea).withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF667eea).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.language,
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
                    isEnglish
                        ? AppLocalizations.of(context)!.switchToArabic
                        : AppLocalizations.of(context)!.switchToEnglish,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1a1a1a),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    isEnglish
                        ? AppLocalizations.of(context)!.arabic
                        : AppLocalizations.of(context)!.english,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF667eea),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF667eea),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                isEnglish
                    ? AppLocalizations.of(context)!.arabicCode
                    : AppLocalizations.of(context)!.englishCode,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
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

  Widget _buildCompactInfoItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1a1a1a),
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
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

  Widget _buildCompactSettingItem({
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? color : const Color(0xFF1a1a1a),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
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
    if (kDebugMode) {
      print('🚪 HomePage: Starting logout process...');
    }

    // Show loading indicator
    if (mounted) {
      final localizations = AppLocalizations.of(context)!;
      MessagingService.showInfo(context, localizations.logout);
    }

    try {
      // Try to get AuthCubit using BlocProvider
      final authCubit = BlocProvider.of<AuthCubit>(context, listen: false);

      // Call logout - this will call the API and clear local data
      await authCubit.logout();

      // Enforce immediate navigation to login screen
      await GlobalAuthManager.instance.performLogout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }

      if (kDebugMode) {
        print('🚪 HomePage: Logout completed successfully via AuthCubit');
      }

      // The AuthWrapper will automatically handle navigation to login page
      // based on the AuthLogoutSuccess and AuthInitial states
    } catch (e) {
      if (kDebugMode) {
        print('🚪 HomePage: Logout error: $e');
        print('🚪 HomePage: Using fallback logout via GlobalAuthManager');
      }

      // Fallback: Clear local data and use GlobalAuthManager
      await LocalData.logout();

      // Trigger the global auth manager to force state change and navigation
      await GlobalAuthManager.instance.performLogout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }

      if (kDebugMode) {
        print('🚪 HomePage: Fallback logout completed');
      }

      if (mounted) {
        MessagingService.showSuccess(
          context,
          AppLocalizations.of(context)!.logoutSuccessful,
        );
      }
    }
  }

  Future<void> _showDeleteAccountDialog() async {
    final localizations = AppLocalizations.of(context)!;

    // First confirmation dialog with warning
    final firstConfirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFef4444).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.warning_rounded,
                    color: Color(0xFFef4444),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    localizations.deleteAccountTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFef4444),
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFef4444).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFef4444).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.warningLabel,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFef4444),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        localizations.deleteAccountConfirm,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.thisWill,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                _buildWarningItem(
                  AppLocalizations.of(context)!.permanentlyDeleteData,
                ),
                _buildWarningItem(
                  AppLocalizations.of(context)!.removeOrdersHistory,
                ),
                _buildWarningItem(
                  AppLocalizations.of(context)!.cancelPendingTransactions,
                ),
                _buildWarningItem(
                  AppLocalizations.of(context)!.cannotBeReversed,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.amber.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_rounded,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.understandConsequences,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  localizations.cancel,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFef4444),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.continueAction,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
    );

    if (firstConfirmed != true) return;

    // Second confirmation dialog - final check
    if (!mounted) return;
    final finalConfirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              AppLocalizations.of(context)!.areYouAbsolutelySure,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFFef4444),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFef4444).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_rounded,
                        color: Color(0xFFef4444),
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.lastChanceWarning,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.keepMyAccount,
                  style: TextStyle(
                    color: const Color(0xFF667eea),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFef4444),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.delete_forever, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      localizations.delete,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );

    if (finalConfirmed != true) return;

    try {
      final authRepo = getIt<AuthRepository>();
      final response = await authRepo.deleteAccount();
      if (response.success) {
        if (mounted) {
          MessagingService.showSuccess(
            context,
            response.message ?? localizations.accountDeletedSuccess,
          );
        }
        // Immediately trigger app logout flow and navigation to login
        _performLogout();
      } else {
        if (mounted) {
          MessagingService.showError(
            context,
            response.message ?? localizations.somethingWentWrong,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        MessagingService.showError(
          context,
          AppLocalizations.of(context)!.somethingWentWrong,
        );
      }
    }
  }

  Widget _buildWarningItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.close_rounded, color: Color(0xFFef4444), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80, right: 16),
      child: FloatingActionButton(
        onPressed: _showMorePagesPopup,
        backgroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(
          Icons.more_horiz_rounded,
          color: Color(0xFF6366F1),
          size: 28,
        ),
      ),
    );
  }

  void _showMorePagesPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => MorePagesPopup(
            items: [
              MorePageItem(
                icon: Icons.map_outlined,
                title: AppLocalizations.of(context)!.map,
                subtitle: AppLocalizations.of(context)!.viewLocationsAndRoutes,
                color: const Color(0xFF06B6D4),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToMap();
                },
              ),
              // Add more items here as needed
            ],
          ),
    );
  }

  void _navigateToMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BlocProvider(
              create: (context) => getIt<MapCubit>(),
              child: const EnhancedMapPage(),
            ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final Color color;

  NavItem({required this.icon, required this.label, required this.color});
}
