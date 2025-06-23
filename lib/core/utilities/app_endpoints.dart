class AppEndPoints {
  AppEndPoints._();

  static const String site =
      'https://testapi.parcelexpress.om'; // Change this to your actual site URL
  // 'https://api.parcelexpress.om';
  static const String baseUrl = '$site/api/';
  static const String filePath = '$site/files';

  // User Authentication
  static const String login = 'driver/login';
  static const String clientLogin = 'client/login';
  static const String user = 'mobile_user';
  static const String logout = 'logout';

  // Orders
  static const String orders = 'orders';
  static const String createOrder = 'orders/store';
  static const String clientOrders = 'client/orders';

  // Notifications
  static const String notifications = 'client/notifications';

  // Home
  static const String homeStatus = 'mobile_app_homepage_stats';
  static const String driverRunsheet = 'driver/driver_runsheets';
  // App Settings
  static const String appSettings = 'driver_app_settings/get/main_screen_image';
  // Tasks for Delivery
  static const String returnOrder = 'driver/orders/return';
  // New endpoint for updating contact count
  static const String updateContactCount = 'driver/orders/contact_count';
  // New endpoint for checking contact count
  static const String checkContacts = 'driver/orders/check_contacts';
  // OTP related endpoints
  static const String regenerateOtp = '/driver/orders/regenerate_otp';
  static const String confirmOrderOtp = '/driver/orders/confirm_order_otp';
  // Tasks for pickup
  // Task Actions
  static const String confirmAssignOrder = 'orders/confirm-assign-order';
  static const String addContactCount = 'driver/orders/contact_count';
  static const String deliverOrder = 'driver/orders/deliver';
  static const String reverseCancellation = 'driver/orders/reverse_exception';
  static const String markOrderException = 'driver/orders/mark_exception';

  // Finance endpoints
  static const String driverInvoices = 'driver/driver_invoices';

  // Route Optimization
  static const String getAddressToken = 'driver_app/get_address_token';

  // Manual Address Update
  static const String manualUpdateAddress = 'driver_app/manual_update_address';
}
