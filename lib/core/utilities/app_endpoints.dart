class AppEndPoints {
  AppEndPoints._();

  // Environment detection
  static const bool _isTestEnvironment = bool.fromEnvironment(
    'TEST_ENV',
    defaultValue: false,
  );

  // Environment-specific URLs
  static const String _productionSite = 'https://admin.parcelexpress.om';
  static const String _testSite = 'https://test.parcelexpress.om';

  // Dynamic site URL based on environment
  static String get site => _isTestEnvironment ? _testSite : _productionSite;

  // API endpoints
  static String get baseUrl => '$site/api/';
  static String get filePath => '$site/files';

  // Environment info for debugging
  static String get environmentName =>
      _isTestEnvironment ? 'TEST' : 'PRODUCTION';
  static bool get isTestEnvironment => _isTestEnvironment;

  // Client Authentication
  static const String clientLogin = 'client/login';
  static const String logout = 'logout';

  // Client Dashboard
  static const String clientDashboard = 'client/dashboard';

  // Client Orders
  static const String clientOrders = 'client/orders';
  static const String createOrder = 'client/orders/store';
  static const String orders = 'orders';
  static String orderDetails(int orderId) => 'orders/$orderId';

  // Client Notifications
  static const String notifications = 'client/notifications';

  // Client Settings
  static const String clientSettings = 'client_settings';

  // Client Pricing
  static String clientPricing(int userId) => 'client/$userId/pricing';

  // Address Book
  static const String addressBook = 'client/address_book';
  static const String createAddressBook = 'client/address_book/store';
  static String updateAddressBook(int addressId) =>
      'client/address_book/$addressId/update';
  static String deleteAddressBook(int addressId) =>
      'client/address_book/$addressId/delete';

  // Client Invoices
  static String clientInvoices(int userId) => 'client/invoices/$userId';
  static String clientInvoiceDetails(int userId, int invoiceId) =>
      'client/invoices/$userId/$invoiceId';
  static String clientInvoiceDownload(int userId, int invoiceId) =>
      'client/invoices/$userId/$invoiceId/download';
  static String clientInvoicesSearch(int userId) =>
      'client/invoices/$userId/search';

  // Client Payments
  static const String clientPaymentTransactions =
      'client/payments/transactions';
  static const String clientPaymentSummary = 'client/payments/summary';

  // Customer Orders
  static const String customerOrders = '/customer-orders/store';
}
