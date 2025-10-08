import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Parcel Express'**
  String get appTitle;

  /// Welcome message on login page
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Please sign in to continue.'**
  String get welcomeMessage;

  /// App tagline
  ///
  /// In en, this message translates to:
  /// **'Fast & Reliable Delivery Service'**
  String get tagline;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// Email address field label
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Alternate phone label
  ///
  /// In en, this message translates to:
  /// **'Alternate Phone'**
  String get alternatePhone;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Customer name field label
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// Customer phone field label
  ///
  /// In en, this message translates to:
  /// **'Customer Phone'**
  String get customerPhone;

  /// Personal information section title
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// Customer information section title
  ///
  /// In en, this message translates to:
  /// **'Customer Information'**
  String get customerInformation;

  /// Location details section title
  ///
  /// In en, this message translates to:
  /// **'Location Details'**
  String get locationDetails;

  /// Additional information section title
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInformation;

  /// Order details section title
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// New order page title
  ///
  /// In en, this message translates to:
  /// **'New Order'**
  String get newOrder;

  /// Create order button text
  ///
  /// In en, this message translates to:
  /// **'Create Order'**
  String get createOrder;

  /// Create order page subtitle
  ///
  /// In en, this message translates to:
  /// **'Fill in the details to create your order'**
  String get fillDetailsToCreateOrder;

  /// Address book page title
  ///
  /// In en, this message translates to:
  /// **'Address Book'**
  String get addressBook;

  /// Shipment page title
  ///
  /// In en, this message translates to:
  /// **'Scan or Enter'**
  String get scanOrEnter;

  /// Shipment page subtitle
  ///
  /// In en, this message translates to:
  /// **'Add your sticker number to get started'**
  String get addStickerNumber;

  /// Sticker number field label
  ///
  /// In en, this message translates to:
  /// **'Sticker Number'**
  String get stickerNumber;

  /// Amount label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Notes label
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// Delivery fee label
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get deliveryFee;

  /// Payment type field label
  ///
  /// In en, this message translates to:
  /// **'Payment Type'**
  String get paymentType;

  /// Street address field label
  ///
  /// In en, this message translates to:
  /// **'Street Address'**
  String get streetAddress;

  /// Zipcode field label
  ///
  /// In en, this message translates to:
  /// **'Zipcode'**
  String get zipcode;

  /// Governorate field label
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get governorate;

  /// State field label
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// Place field label
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get place;

  /// Required field indicator
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// Name required validation message
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// Email required validation message
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// Phone required validation message
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// Valid email validation message
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get validEmailRequired;

  /// Greeting message with username
  ///
  /// In en, this message translates to:
  /// **'Hello, {userName}! 👋'**
  String helloUser(String userName);

  /// Dashboard subtitle
  ///
  /// In en, this message translates to:
  /// **'Here\'s your business overview'**
  String get businessOverview;

  /// Dashboard page title
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Notifications page title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// View notifications menu item
  ///
  /// In en, this message translates to:
  /// **'View Notifications'**
  String get viewNotifications;

  /// View all notifications subtitle
  ///
  /// In en, this message translates to:
  /// **'View all notifications'**
  String get viewAllNotifications;

  /// Pricing page title
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get pricing;

  /// View pricing menu item
  ///
  /// In en, this message translates to:
  /// **'View Pricing'**
  String get viewPricing;

  /// View pricing subtitle
  ///
  /// In en, this message translates to:
  /// **'View delivery pricing per state'**
  String get viewDeliveryPricing;

  /// Delete account setting title
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountTitle;

  /// Delete account setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Permanently deactivate your account'**
  String get deleteAccountSubtitle;

  /// Delete account confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This will deactivate your account and you will no longer be able to access it.'**
  String get deleteAccountConfirm;

  /// Delete account success
  ///
  /// In en, this message translates to:
  /// **'Your account has been deactivated successfully.'**
  String get accountDeletedSuccess;

  /// Logout subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account'**
  String get signOutAccount;

  /// Notification settings page title
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// Notification settings page subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage your notification preferences'**
  String get manageNotificationPreferences;

  /// Notification settings detailed description
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to receive notifications about your orders and account updates.'**
  String get chooseNotificationMethod;

  /// About notifications section title
  ///
  /// In en, this message translates to:
  /// **'About Notifications'**
  String get aboutNotifications;

  /// Notifications description
  ///
  /// In en, this message translates to:
  /// **'You will receive notifications for:'**
  String get receiveNotificationsFor;

  /// Order confirmations notification type
  ///
  /// In en, this message translates to:
  /// **'Order confirmations and updates'**
  String get orderConfirmations;

  /// Pickup and delivery notification type
  ///
  /// In en, this message translates to:
  /// **'Pickup and delivery notifications'**
  String get pickupDeliveryNotifications;

  /// Payment confirmations notification type
  ///
  /// In en, this message translates to:
  /// **'Payment confirmations'**
  String get paymentConfirmations;

  /// Account updates notification type
  ///
  /// In en, this message translates to:
  /// **'Important account updates'**
  String get accountUpdates;

  /// WhatsApp notification method
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// Email notification method
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailNotifications;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Done button text
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Submit button text
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Back button text
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Next page button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Search button text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Filter button text
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// From date label for date range filter
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get fromDate;

  /// To date label for date range filter
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get toDate;

  /// Apply button text
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Refresh button text
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Error message title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success message title
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Warning message title
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// Information message title
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No data message
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// Please wait message
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// Try again button text
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Connection error
  ///
  /// In en, this message translates to:
  /// **'Connection error. Please check your internet connection.'**
  String get connectionError;

  /// Invalid data message
  ///
  /// In en, this message translates to:
  /// **'Invalid data'**
  String get invalidData;

  /// Orders navigation label
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// Profile navigation label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Create guest order page title
  ///
  /// In en, this message translates to:
  /// **'Create Guest Order'**
  String get createGuestOrder;

  /// Continue as guest button text
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// Total orders statistics label
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get totalOrders;

  /// Today's orders statistics label
  ///
  /// In en, this message translates to:
  /// **'Today\'s Orders'**
  String get todayOrders;

  /// Pending pickup statistics label
  ///
  /// In en, this message translates to:
  /// **'Pending Pickup'**
  String get pendingPickup;

  /// Picked orders statistics label
  ///
  /// In en, this message translates to:
  /// **'Picked Orders'**
  String get pickedOrders;

  /// Dashboard loading message
  ///
  /// In en, this message translates to:
  /// **'Loading dashboard...'**
  String get loadingDashboard;

  /// Dashboard welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome to your dashboard'**
  String get welcomeDashboard;

  /// Tap to load stats message
  ///
  /// In en, this message translates to:
  /// **'Tap to load your statistics'**
  String get tapToLoadStats;

  /// Load dashboard button text
  ///
  /// In en, this message translates to:
  /// **'Load Dashboard'**
  String get loadDashboard;

  /// Address details page title
  ///
  /// In en, this message translates to:
  /// **'Address Details'**
  String get addressDetails;

  /// District field label
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// Identification field label
  ///
  /// In en, this message translates to:
  /// **'Identification'**
  String get identification;

  /// Tax number field label
  ///
  /// In en, this message translates to:
  /// **'Tax Number'**
  String get taxNumber;

  /// Location URL label
  ///
  /// In en, this message translates to:
  /// **'Location URL'**
  String get locationUrl;

  /// Governorate selection validation message
  ///
  /// In en, this message translates to:
  /// **'Please select a governorate'**
  String get pleaseSelectGovernorate;

  /// State selection validation message
  ///
  /// In en, this message translates to:
  /// **'Please select a state'**
  String get pleaseSelectState;

  /// Place selection validation message
  ///
  /// In en, this message translates to:
  /// **'Please select a place'**
  String get pleaseSelectPlace;

  /// Order creation success message
  ///
  /// In en, this message translates to:
  /// **'Order created successfully!'**
  String get orderCreatedSuccessfully;

  /// Tracking number label
  ///
  /// In en, this message translates to:
  /// **'Your tracking number is:'**
  String get trackingNumberIs;

  /// Optional field indicator
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// Required field validation message
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// District required validation message
  ///
  /// In en, this message translates to:
  /// **'District is required'**
  String get districtRequired;

  /// Zipcode required validation message
  ///
  /// In en, this message translates to:
  /// **'Zipcode is required'**
  String get zipcodeRequired;

  /// Street address required validation message
  ///
  /// In en, this message translates to:
  /// **'Street address is required'**
  String get streetAddressRequired;

  /// Customer name required validation message
  ///
  /// In en, this message translates to:
  /// **'Customer name is required'**
  String get customerNameRequired;

  /// Customer phone required validation message
  ///
  /// In en, this message translates to:
  /// **'Customer phone is required'**
  String get customerPhoneRequired;

  /// Valid location URL validation message
  ///
  /// In en, this message translates to:
  /// **'Enter a valid location URL'**
  String get validLocationUrlRequired;

  /// Valid amount validation message
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get validAmountRequired;

  /// User default name
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// Not available label
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get notAvailable;

  /// Role label
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// Location label
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Settings button text
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Logout confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// No search results message
  ///
  /// In en, this message translates to:
  /// **'No Results'**
  String get noResults;

  /// Clear search button text
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get clearSearch;

  /// Recent transactions section title
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No transactions found message
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get noTransactionsFound;

  /// Adjust filters message
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or check back later.'**
  String get adjustFilters;

  /// Filter payments title
  ///
  /// In en, this message translates to:
  /// **'Filter Payments'**
  String get filterPayments;

  /// Filter by type label
  ///
  /// In en, this message translates to:
  /// **'Filter by Type'**
  String get filterByType;

  /// Filter by status label
  ///
  /// In en, this message translates to:
  /// **'Filter by Status'**
  String get filterByStatus;

  /// Transaction details dialog title
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get transactionDetails;

  /// Tracking number label
  ///
  /// In en, this message translates to:
  /// **'Tracking No:'**
  String get trackingNo;

  /// Notification marked as read message
  ///
  /// In en, this message translates to:
  /// **'Notification marked as read'**
  String get notificationMarkedAsRead;

  /// Notification deleted message
  ///
  /// In en, this message translates to:
  /// **'Notification deleted'**
  String get notificationDeleted;

  /// Mark all as read button text
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// Mark all notifications as read description
  ///
  /// In en, this message translates to:
  /// **'Mark all notifications as read'**
  String get markAllNotificationsAsRead;

  /// Reload button text
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get reload;

  /// Reload notifications description
  ///
  /// In en, this message translates to:
  /// **'Reload notifications'**
  String get reloadNotifications;

  /// Mark as read button text
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get markAsRead;

  /// Mark this notification as read description
  ///
  /// In en, this message translates to:
  /// **'Mark this notification as read'**
  String get markThisNotificationAsRead;

  /// Remove this notification description
  ///
  /// In en, this message translates to:
  /// **'Remove this notification'**
  String get removeThisNotification;

  /// Delete notification title
  ///
  /// In en, this message translates to:
  /// **'Delete Notification'**
  String get deleteNotification;

  /// Delete notification confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this notification? This action cannot be undone.'**
  String get deleteNotificationConfirmation;

  /// Just now time label
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// Minutes ago time label
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String minutesAgo(int minutes);

  /// Hours ago time label
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String hoursAgo(int hours);

  /// Days ago with count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String daysAgo(num count);

  /// No notifications yet message
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// Notifications will appear here message
  ///
  /// In en, this message translates to:
  /// **'When you have new notifications,\\nthey\'ll appear here'**
  String get notificationsWillAppearHere;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// Pricing list page title
  ///
  /// In en, this message translates to:
  /// **'Pricing List'**
  String get pricingList;

  /// Loading pricing data message
  ///
  /// In en, this message translates to:
  /// **'Loading pricing data...'**
  String get loadingPricingData;

  /// Error loading pricing message
  ///
  /// In en, this message translates to:
  /// **'Error Loading Pricing'**
  String get errorLoadingPricing;

  /// No pricing data message
  ///
  /// In en, this message translates to:
  /// **'No Pricing Data'**
  String get noPricingData;

  /// Search by state name placeholder
  ///
  /// In en, this message translates to:
  /// **'Search by state name...'**
  String get searchByStateName;

  /// Total states label
  ///
  /// In en, this message translates to:
  /// **'Total States'**
  String get totalStates;

  /// Average delivery label
  ///
  /// In en, this message translates to:
  /// **'Avg. Delivery'**
  String get avgDelivery;

  /// Average return label
  ///
  /// In en, this message translates to:
  /// **'Avg. Return'**
  String get avgReturn;

  /// WhatsApp notifications toggle label
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Notifications'**
  String get whatsappNotifications;

  /// WhatsApp notifications description
  ///
  /// In en, this message translates to:
  /// **'Receive order updates via WhatsApp'**
  String get receiveOrderUpdatesViaWhatsapp;

  /// Email notifications toggle label
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotificationsTitle;

  /// Email notifications description
  ///
  /// In en, this message translates to:
  /// **'Receive order updates via email'**
  String get receiveOrderUpdatesViaEmail;

  /// Loading settings message
  ///
  /// In en, this message translates to:
  /// **'Loading settings...'**
  String get loadingSettings;

  /// Create shipment page title
  ///
  /// In en, this message translates to:
  /// **'Create Shipment'**
  String get createShipment;

  /// Scan or enter page title
  ///
  /// In en, this message translates to:
  /// **'Scan or Enter'**
  String get scanOrEnterTitle;

  /// Scan or enter page subtitle
  ///
  /// In en, this message translates to:
  /// **'Add your sticker number to get started'**
  String get addStickerNumberToStart;

  /// Enter manually label
  ///
  /// In en, this message translates to:
  /// **'Enter manually'**
  String get enterManually;

  /// Sticker number input placeholder
  ///
  /// In en, this message translates to:
  /// **'Type sticker number...'**
  String get typeStickerNumber;

  /// Scan barcode button text
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get scanBarcode;

  /// Start scanning button text
  ///
  /// In en, this message translates to:
  /// **'Start Scanning'**
  String get startScanning;

  /// Scan failed message
  ///
  /// In en, this message translates to:
  /// **'Scan Failed'**
  String get scanFailed;

  /// Successfully scanned message
  ///
  /// In en, this message translates to:
  /// **'Successfully Scanned'**
  String get successfullyScanned;

  /// Number entered message
  ///
  /// In en, this message translates to:
  /// **'Number Entered'**
  String get numberEntered;

  /// Creating order loading message
  ///
  /// In en, this message translates to:
  /// **'Creating Order...'**
  String get creatingOrder;

  /// Saved addresses section title
  ///
  /// In en, this message translates to:
  /// **'Saved Addresses'**
  String get savedAddresses;

  /// Select from saved addresses description
  ///
  /// In en, this message translates to:
  /// **'Select from saved addresses to auto-fill'**
  String get selectFromSavedAddresses;

  /// Form auto-filled message
  ///
  /// In en, this message translates to:
  /// **'Form auto-filled with selected address'**
  String get formAutoFilled;

  /// Clear button text
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Save for later title
  ///
  /// In en, this message translates to:
  /// **'Save for Later'**
  String get saveForLater;

  /// Add to address book description
  ///
  /// In en, this message translates to:
  /// **'Add this address to your address book'**
  String get addToAddressBook;

  /// Save address hint message
  ///
  /// In en, this message translates to:
  /// **'Save this address to make future orders faster and easier!'**
  String get saveAddressHint;

  /// Save address button text
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get saveAddress;

  /// Not now button text
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get notNow;

  /// Address saved success message
  ///
  /// In en, this message translates to:
  /// **'Address saved to address book successfully!'**
  String get addressSaved;

  /// Address save failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to save address. Please try again.'**
  String get addressSaveFailed;

  /// Order created success message
  ///
  /// In en, this message translates to:
  /// **'Order Created Successfully!'**
  String get orderCreated;

  /// Tracking label with number
  ///
  /// In en, this message translates to:
  /// **'Tracking: {trackingNo}'**
  String trackingLabel(String trackingNo);

  /// Order ID label with number
  ///
  /// In en, this message translates to:
  /// **'Order ID: {orderId}'**
  String orderIdLabel(String orderId);

  /// For recipient label
  ///
  /// In en, this message translates to:
  /// **'For: {recipientName}'**
  String forRecipient(String recipientName);

  /// Barcode scanning instruction
  ///
  /// In en, this message translates to:
  /// **'Position the barcode within the frame to scan'**
  String get positionBarcodeInFrame;

  /// Generic required field validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter {field}'**
  String pleaseEnterField(String field);

  /// Minimum length validation message
  ///
  /// In en, this message translates to:
  /// **'{field} must be at least {length} characters'**
  String fieldMinLength(String field, int length);

  /// Email required validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// Invalid email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterValidEmail;

  /// Invalid phone validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid {field} number (8-15 digits)'**
  String pleaseEnterValidPhone(String field);

  /// Location URL required validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a location URL'**
  String get pleaseEnterLocationUrl;

  /// Invalid location URL validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Google Maps URL'**
  String get pleaseEnterValidLocationUrl;

  /// Amount required validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get pleaseEnterAmount;

  /// Invalid amount validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get pleaseEnterValidAmount;

  /// Minimum amount validation message
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than {amount}'**
  String amountMustBeGreaterThan(String amount);

  /// Zipcode required validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a zipcode'**
  String get pleaseEnterZipcode;

  /// Invalid zipcode validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid zipcode (4-10 digits)'**
  String get pleaseEnterValidZipcode;

  /// Tax number validation message
  ///
  /// In en, this message translates to:
  /// **'Tax number should be 5-20 digits'**
  String get taxNumberValidation;

  /// Identification validation message
  ///
  /// In en, this message translates to:
  /// **'ID should be 5-20 alphanumeric characters'**
  String get identificationValidation;

  /// Logout successful message
  ///
  /// In en, this message translates to:
  /// **'Logout Successful'**
  String get logoutSuccessful;

  /// Financial overview section title
  ///
  /// In en, this message translates to:
  /// **'Financial Overview'**
  String get financialOverview;

  /// Total value label
  ///
  /// In en, this message translates to:
  /// **'Total Value'**
  String get totalValue;

  /// This month label
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// Balance label
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// Average order label
  ///
  /// In en, this message translates to:
  /// **'Avg Order'**
  String get avgOrder;

  /// Performance metrics section title
  ///
  /// In en, this message translates to:
  /// **'Performance Metrics'**
  String get performanceMetrics;

  /// Delivery rate label
  ///
  /// In en, this message translates to:
  /// **'Delivery Rate'**
  String get deliveryRate;

  /// Task completion label
  ///
  /// In en, this message translates to:
  /// **'Task Completion'**
  String get taskCompletion;

  /// Delivered status
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// Active tasks label
  ///
  /// In en, this message translates to:
  /// **'Active Tasks'**
  String get activeTasks;

  /// Completed tasks label
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedTasks;

  /// Recent activity section title
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// View all activities button text
  ///
  /// In en, this message translates to:
  /// **'View All Activities'**
  String get viewAllActivities;

  /// Orders created text for activity
  ///
  /// In en, this message translates to:
  /// **'orders created'**
  String get ordersCreated;

  /// Activity on date prefix
  ///
  /// In en, this message translates to:
  /// **'Activity on'**
  String get activityOn;

  /// No recent activity message
  ///
  /// In en, this message translates to:
  /// **'No Recent Activity'**
  String get noRecentActivity;

  /// Recent activities placeholder message
  ///
  /// In en, this message translates to:
  /// **'Your recent activities will appear here'**
  String get recentActivitiesWillAppearHere;

  /// Today label
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Yesterday label
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Orders list page title
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// Search placeholder for orders
  ///
  /// In en, this message translates to:
  /// **'Search by tracking number...'**
  String get searchByTrackingNumber;

  /// Status filter label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// All status filter option
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get allStatus;

  /// Date range filter label
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// Loading orders message
  ///
  /// In en, this message translates to:
  /// **'Loading orders...'**
  String get loadingOrders;

  /// Orders count message
  ///
  /// In en, this message translates to:
  /// **'Showing {shown} of {total} orders'**
  String showingOrdersCount(int shown, int total);

  /// Page count message
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String pageCount(int current, int total);

  /// Tracking number label
  ///
  /// In en, this message translates to:
  /// **'Tracking Number'**
  String get trackingNumber;

  /// Tracking number copied message
  ///
  /// In en, this message translates to:
  /// **'Tracking number copied! 📋'**
  String get trackingNumberCopied;

  /// Scan button text
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// Shown when tracking_no is duplicated (422)
  ///
  /// In en, this message translates to:
  /// **'This tracking number is already used. Please scan a different sticker.'**
  String get trackingAlreadyTaken;

  /// Generic dimensions validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter valid package dimensions.'**
  String get invalidDimensions;

  /// Recipient label
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipient;

  /// Delivery address label
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryAddress;

  /// Payment label
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// Created status
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// Previous page button
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No orders message
  ///
  /// In en, this message translates to:
  /// **'No Orders Yet'**
  String get noOrdersYet;

  /// Orders placeholder message
  ///
  /// In en, this message translates to:
  /// **'Your orders will appear here once you start creating them.'**
  String get ordersWillAppearHere;

  /// Create first order button
  ///
  /// In en, this message translates to:
  /// **'Create Your First Order'**
  String get createFirstOrder;

  /// Payments page title
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// Filter transactions dialog title
  ///
  /// In en, this message translates to:
  /// **'Filter Transactions'**
  String get filterTransactions;

  /// Apply filters button text
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// Try adjusting filters message
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or check back later.'**
  String get tryAdjustingFilters;

  /// Error loading payments title
  ///
  /// In en, this message translates to:
  /// **'Error Loading Payments'**
  String get errorLoadingPayments;

  /// No payment data title
  ///
  /// In en, this message translates to:
  /// **'No Payment Data'**
  String get noPaymentData;

  /// No payment transactions found message
  ///
  /// In en, this message translates to:
  /// **'No payment transactions found.\nCheck back later for updates.'**
  String get noPaymentTransactionsFound;

  /// Type label
  ///
  /// In en, this message translates to:
  /// **'Type:'**
  String get type;

  /// Customer fee payer option
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// Phone label
  ///
  /// In en, this message translates to:
  /// **'Phone:'**
  String get phone;

  /// Date label
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get date;

  /// Payment summary section title
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get paymentSummary;

  /// COD collected label
  ///
  /// In en, this message translates to:
  /// **'COD Collected'**
  String get codCollected;

  /// Settled label
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get settled;

  /// Pending label
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Total balance label
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// Total amount label
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// Paid status label
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// Overdue status label
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// ID with number
  ///
  /// In en, this message translates to:
  /// **'ID: {id}'**
  String id(int id);

  /// All filter option
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Cash on delivery payment type
  ///
  /// In en, this message translates to:
  /// **'COD'**
  String get cod;

  /// Card payment type
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// Bank payment type
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bank;

  /// Completed status
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Failed status
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// Not available text
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get na;

  /// Dialog title for selecting app language
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Language changed to Arabic message
  ///
  /// In en, this message translates to:
  /// **'تم تغيير اللغة إلى العربية'**
  String get languageChangedToArabic;

  /// Language changed to English message
  ///
  /// In en, this message translates to:
  /// **'Language changed to English'**
  String get languageChangedToEnglish;

  /// Order creation failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to create order. Please try again.'**
  String get orderCreationFailed;

  /// Address save success message
  ///
  /// In en, this message translates to:
  /// **'Address saved successfully!'**
  String get addressSavedSuccessfully;

  /// Address deletion success message
  ///
  /// In en, this message translates to:
  /// **'Address deleted successfully!'**
  String get addressDeletedSuccessfully;

  /// Address deletion failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete address. Please try again.'**
  String get addressDeleteFailed;

  /// Address update success message
  ///
  /// In en, this message translates to:
  /// **'Address updated successfully!'**
  String get addressUpdatedSuccessfully;

  /// Address update failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to update address. Please try again.'**
  String get addressUpdateFailed;

  /// Settings save success message
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully!'**
  String get settingsSavedSuccessfully;

  /// Settings save failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to save settings. Please try again.'**
  String get settingsSaveFailed;

  /// Logout success message
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully!'**
  String get logoutSuccessfully;

  /// Logout failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to logout. Please try again.'**
  String get logoutFailed;

  /// Login success message
  ///
  /// In en, this message translates to:
  /// **'Logged in successfully!'**
  String get loginSuccessfully;

  /// Login failure message
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials.'**
  String get loginFailed;

  /// Login error: incorrect password
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get loginErrorIncorrectPassword;

  /// Login error: no account
  ///
  /// In en, this message translates to:
  /// **'No account found with this email.'**
  String get loginErrorNoAccount;

  /// Login error: account disabled
  ///
  /// In en, this message translates to:
  /// **'Your account is disabled. Please contact support.'**
  String get loginErrorAccountDisabled;

  /// Login error: too many attempts
  ///
  /// In en, this message translates to:
  /// **'Too many login attempts. Please try again later.'**
  String get loginErrorTooManyAttempts;

  /// Login error: validation
  ///
  /// In en, this message translates to:
  /// **'Please check your input and try again.'**
  String get loginErrorValidation;

  /// Login error: unknown
  ///
  /// In en, this message translates to:
  /// **'Unable to login. Please try again.'**
  String get loginErrorUnknown;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection.'**
  String get networkError;

  /// Server error message
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get serverError;

  /// Validation error message
  ///
  /// In en, this message translates to:
  /// **'Please check your input and try again.'**
  String get validationError;

  /// Generic success message
  ///
  /// In en, this message translates to:
  /// **'Operation completed successfully!'**
  String get operationSuccess;

  /// Generic failure message
  ///
  /// In en, this message translates to:
  /// **'Operation failed. Please try again.'**
  String get operationFailed;

  /// Data load success message
  ///
  /// In en, this message translates to:
  /// **'Data loaded successfully!'**
  String get dataLoadedSuccessfully;

  /// Data load failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to load data. Please try again.'**
  String get dataLoadFailed;

  /// File download success message
  ///
  /// In en, this message translates to:
  /// **'File downloaded successfully!'**
  String get fileDownloadedSuccessfully;

  /// File download failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to download file. Please try again.'**
  String get fileDownloadFailed;

  /// Copy to clipboard success message
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard!'**
  String get copyToClipboardSuccess;

  /// Copy to clipboard failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to copy to clipboard.'**
  String get copyToClipboardFailed;

  /// Logout confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get confirmLogout;

  /// Delete confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get confirmDelete;

  /// Yes button text
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button text
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Processing status
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// Uploading message
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading;

  /// Downloading message
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// Saving message
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// Deleting message
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get deleting;

  /// Updating message
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get updating;

  /// Refreshing message
  ///
  /// In en, this message translates to:
  /// **'Refreshing...'**
  String get refreshing;

  /// Searching message
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get searching;

  /// Filtering message
  ///
  /// In en, this message translates to:
  /// **'Filtering...'**
  String get filtering;

  /// Sorting message
  ///
  /// In en, this message translates to:
  /// **'Sorting...'**
  String get sorting;

  /// Connecting message
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// Disconnecting message
  ///
  /// In en, this message translates to:
  /// **'Disconnecting...'**
  String get disconnecting;

  /// Syncing message
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncing;

  /// Backing up message
  ///
  /// In en, this message translates to:
  /// **'Backing up...'**
  String get backingUp;

  /// Restoring message
  ///
  /// In en, this message translates to:
  /// **'Restoring...'**
  String get restoring;

  /// Installing message
  ///
  /// In en, this message translates to:
  /// **'Installing...'**
  String get installing;

  /// Uninstalling message
  ///
  /// In en, this message translates to:
  /// **'Uninstalling...'**
  String get uninstalling;

  /// Updating app message
  ///
  /// In en, this message translates to:
  /// **'Updating app...'**
  String get updatingApp;

  /// Checking for updates message
  ///
  /// In en, this message translates to:
  /// **'Checking for updates...'**
  String get checkingForUpdates;

  /// No updates available message
  ///
  /// In en, this message translates to:
  /// **'No updates available'**
  String get noUpdatesAvailable;

  /// Update available message
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get updateAvailable;

  /// Update downloaded message
  ///
  /// In en, this message translates to:
  /// **'Update downloaded'**
  String get updateDownloaded;

  /// Update installed message
  ///
  /// In en, this message translates to:
  /// **'Update installed'**
  String get updateInstalled;

  /// Update failed message
  ///
  /// In en, this message translates to:
  /// **'Update failed'**
  String get updateFailed;

  /// Restart required message
  ///
  /// In en, this message translates to:
  /// **'Restart required'**
  String get restartRequired;

  /// Restart now button text
  ///
  /// In en, this message translates to:
  /// **'Restart Now'**
  String get restartNow;

  /// Restart later button text
  ///
  /// In en, this message translates to:
  /// **'Restart Later'**
  String get restartLater;

  /// Default note for orders created via mobile app
  ///
  /// In en, this message translates to:
  /// **'Order created via mobile app'**
  String get orderCreatedViaMobileApp;

  /// Add address button text
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get addAddress;

  /// Update address button text
  ///
  /// In en, this message translates to:
  /// **'Update Address'**
  String get updateAddress;

  /// Add first address message
  ///
  /// In en, this message translates to:
  /// **'Add your first address to get started'**
  String get addYourFirstAddress;

  /// Error loading addresses title
  ///
  /// In en, this message translates to:
  /// **'Error Loading Addresses'**
  String get errorLoadingAddresses;

  /// Location fields validation message
  ///
  /// In en, this message translates to:
  /// **'Please select all location fields'**
  String get pleaseSelectAllLocationFields;

  /// Prepaid payment type
  ///
  /// In en, this message translates to:
  /// **'PREPAID'**
  String get prepaid;

  /// Tap to select address hint text
  ///
  /// In en, this message translates to:
  /// **'Tap to select address'**
  String get tapToSelectAddress;

  /// Clear selection button text
  ///
  /// In en, this message translates to:
  /// **'Clear Selection'**
  String get clearSelection;

  /// Phone number input hint text
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get phoneNumberHint;

  /// Alternate phone number input hint text
  ///
  /// In en, this message translates to:
  /// **'Enter alternate phone number'**
  String get alternatePhoneHint;

  /// Full phone number preview text
  ///
  /// In en, this message translates to:
  /// **'Full Phone Number: {fullNumber}'**
  String fullPhoneNumberPreview(String fullNumber);

  /// Phone number input information text
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number without country code'**
  String get phoneNumberInfo;

  /// Alternate phone number input information text
  ///
  /// In en, this message translates to:
  /// **'Enter an alternate phone number (optional)'**
  String get alternatePhoneInfo;

  /// Email input placeholder
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailPlaceholder;

  /// Street address input hint
  ///
  /// In en, this message translates to:
  /// **'Building, street, area'**
  String get streetAddressHint;

  /// Location URL placeholder
  ///
  /// In en, this message translates to:
  /// **'https://maps.app.goo.gl/...'**
  String get locationUrlPlaceholder;

  /// Address book empty state title
  ///
  /// In en, this message translates to:
  /// **'No Addresses Yet'**
  String get noAddressesYet;

  /// Address book empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'Add your first address to make\norder creation easier'**
  String get addYourFirstAddressHint;

  /// Delete address dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get deleteAddress;

  /// Delete address confirmation with name
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\" address?'**
  String deleteAddressConfirmation(String name);

  /// Fee payer field label
  ///
  /// In en, this message translates to:
  /// **'Fee Payer'**
  String get feePayer;

  /// Dimensions and weight section title
  ///
  /// In en, this message translates to:
  /// **'Dimensions & Weight'**
  String get dimensionsAndWeight;

  /// Measurement unit field label
  ///
  /// In en, this message translates to:
  /// **'Measurement Unit'**
  String get measurementUnit;

  /// Package dimensions section title
  ///
  /// In en, this message translates to:
  /// **'Package Dimensions'**
  String get packageDimensions;

  /// Width field label
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get width;

  /// Height field label
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// Length field label
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get length;

  /// Weight field label
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// Items section title
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// Item name field label
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemName;

  /// Item name input hint
  ///
  /// In en, this message translates to:
  /// **'Enter item name...'**
  String get itemNameHint;

  /// Category field label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Category input hint
  ///
  /// In en, this message translates to:
  /// **'Category...'**
  String get categoryHint;

  /// Quantity field label
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// Quantity input hint
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get quantityHint;

  /// Add another item button text
  ///
  /// In en, this message translates to:
  /// **'Add Another Item'**
  String get addAnotherItem;

  /// Client fee payer option
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get client;

  /// Kilogram unit
  ///
  /// In en, this message translates to:
  /// **'Kg'**
  String get kg;

  /// Length unit
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get lengthUnit;

  /// Delivery fee input hint
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get deliveryFeeHint;

  /// Amount input hint
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get amountHint;

  /// Dimension input hint
  ///
  /// In en, this message translates to:
  /// **'0.0'**
  String get dimensionHint;

  /// Delivery fee required validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter delivery fee'**
  String get pleaseEnterDeliveryFee;

  /// Amount required validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter amount'**
  String get pleaseEnterAmountField;

  /// Email and password required validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter both email and password'**
  String get pleaseEnterBothEmailAndPassword;

  /// Email and password required error
  ///
  /// In en, this message translates to:
  /// **'Email and password are required'**
  String get emailAndPasswordRequired;

  /// Generic login failure message
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailedGeneric;

  /// Network connection error message
  ///
  /// In en, this message translates to:
  /// **'Network connection error'**
  String get networkConnectionError;

  /// Internet connection check message
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again'**
  String get pleaseCheckInternetConnection;

  /// Request timeout error
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get requestTimeout;

  /// Request timeout detailed message
  ///
  /// In en, this message translates to:
  /// **'The request took too long. Please try again'**
  String get requestTookTooLong;

  /// Unexpected error message
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedErrorOccurred;

  /// Try again later message
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get pleaseTryAgainLater;

  /// Login success message
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// OR separator text
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// Camera permission denied message
  ///
  /// In en, this message translates to:
  /// **'Camera permission denied'**
  String get cameraPermissionDenied;

  /// Client app title
  ///
  /// In en, this message translates to:
  /// **'Client App'**
  String get clientApp;

  /// Egypt country name
  ///
  /// In en, this message translates to:
  /// **'Egypt'**
  String get egypt;

  /// Saudi Arabia country name
  ///
  /// In en, this message translates to:
  /// **'Saudi Arabia'**
  String get saudiArabia;

  /// United Arab Emirates country name
  ///
  /// In en, this message translates to:
  /// **'United Arab Emirates'**
  String get unitedArabEmirates;

  /// Kuwait country name
  ///
  /// In en, this message translates to:
  /// **'Kuwait'**
  String get kuwait;

  /// Qatar country name
  ///
  /// In en, this message translates to:
  /// **'Qatar'**
  String get qatar;

  /// Bahrain country name
  ///
  /// In en, this message translates to:
  /// **'Bahrain'**
  String get bahrain;

  /// Oman country name as fallback
  ///
  /// In en, this message translates to:
  /// **'Oman'**
  String get oman;

  /// Jordan country name
  ///
  /// In en, this message translates to:
  /// **'Jordan'**
  String get jordan;

  /// Lebanon country name
  ///
  /// In en, this message translates to:
  /// **'Lebanon'**
  String get lebanon;

  /// United States country name
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get unitedStates;

  /// United Kingdom country name
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get unitedKingdom;

  /// Select country label
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// Popular countries section title
  ///
  /// In en, this message translates to:
  /// **'Popular Countries'**
  String get popularCountries;

  /// All countries section title
  ///
  /// In en, this message translates to:
  /// **'All Countries'**
  String get allCountries;

  /// No countries found message
  ///
  /// In en, this message translates to:
  /// **'No countries found'**
  String get noCountriesFound;

  /// Try different search term message
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearchTerm;

  /// Select governorate label
  ///
  /// In en, this message translates to:
  /// **'Select Governorate'**
  String get selectGovernorate;

  /// No governorates found message
  ///
  /// In en, this message translates to:
  /// **'No governorates found'**
  String get noGovernoratesFound;

  /// Select state label
  ///
  /// In en, this message translates to:
  /// **'Select State'**
  String get selectState;

  /// No states found message
  ///
  /// In en, this message translates to:
  /// **'No states found'**
  String get noStatesFound;

  /// Select place label
  ///
  /// In en, this message translates to:
  /// **'Select Place'**
  String get selectPlace;

  /// No places found message
  ///
  /// In en, this message translates to:
  /// **'No places found'**
  String get noPlacesFound;

  /// Canada country name
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get canada;

  /// Search country label
  ///
  /// In en, this message translates to:
  /// **'Search Country'**
  String get searchCountry;

  /// Search hint text
  ///
  /// In en, this message translates to:
  /// **'Start typing to search'**
  String get startTypingToSearch;

  /// Notification load failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications'**
  String get failedToLoadNotifications;

  /// Notification load error message
  ///
  /// In en, this message translates to:
  /// **'Error loading notifications'**
  String get errorLoadingNotifications;

  /// Load more notifications failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to load more notifications'**
  String get failedToLoadMoreNotifications;

  /// Load more notifications error message
  ///
  /// In en, this message translates to:
  /// **'Error loading more notifications'**
  String get errorLoadingMoreNotifications;

  /// Example phone number hint
  ///
  /// In en, this message translates to:
  /// **'123xxxx'**
  String get examplePhoneNumber;

  /// Item number with index
  ///
  /// In en, this message translates to:
  /// **'Item {number}'**
  String itemNumber(Object number);

  /// Tracking number already taken error
  ///
  /// In en, this message translates to:
  /// **'This tracking number is already used. Please scan a different sticker.'**
  String get thisTrackingNumberIsAlreadyUsed;

  /// Generic validation error message
  ///
  /// In en, this message translates to:
  /// **'Please check your input and try again.'**
  String get pleaseCheckYourInputAndTryAgain;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// Select address label
  ///
  /// In en, this message translates to:
  /// **'Select Address'**
  String get selectAddress;

  /// Add new button text
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get addNew;

  /// No addresses found message
  ///
  /// In en, this message translates to:
  /// **'No Addresses Found'**
  String get noAddressesFound;

  /// Edit address button text
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddress;

  /// Add new address button text
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addNewAddress;

  /// Full name validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterYourFullName;

  /// Email address validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get pleaseEnterYourEmailAddress;

  /// Valid email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterAValidEmailAddress;

  /// Alternate phone number field label
  ///
  /// In en, this message translates to:
  /// **'Alternate Phone Number'**
  String get alternatePhoneNumber;

  /// Street address validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your street address'**
  String get pleaseEnterYourStreetAddress;

  /// Zip code optional field label
  ///
  /// In en, this message translates to:
  /// **'Zip Code (Optional)'**
  String get zipCodeOptional;

  /// Location URL optional field label
  ///
  /// In en, this message translates to:
  /// **'Location URL (Optional)'**
  String get locationUrlOptional;

  /// Please select validation message
  ///
  /// In en, this message translates to:
  /// **'Please select {label}'**
  String pleaseSelect(Object label);

  /// Contact information section title
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// Primary phone label
  ///
  /// In en, this message translates to:
  /// **'Primary Phone'**
  String get primaryPhone;

  /// Country label
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// Zip code label
  ///
  /// In en, this message translates to:
  /// **'Zip Code'**
  String get zipCode;

  /// Client settings load failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to load client settings'**
  String get failedToLoadClientSettings;

  /// Client settings load error message
  ///
  /// In en, this message translates to:
  /// **'Error loading client settings'**
  String get errorLoadingClientSettings;

  /// No current settings message
  ///
  /// In en, this message translates to:
  /// **'No current settings available'**
  String get noCurrentSettingsAvailable;

  /// Notification settings update failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to update notification settings'**
  String get failedToUpdateNotificationSettings;

  /// Notification settings update error message
  ///
  /// In en, this message translates to:
  /// **'Error updating notification settings'**
  String get errorUpdatingNotificationSettings;

  /// No notification settings message
  ///
  /// In en, this message translates to:
  /// **'No notification settings available'**
  String get noNotificationSettingsAvailable;

  /// WhatsApp notifications enabled message
  ///
  /// In en, this message translates to:
  /// **'WhatsApp notifications enabled'**
  String get whatsappNotificationsEnabled;

  /// WhatsApp notifications disabled message
  ///
  /// In en, this message translates to:
  /// **'WhatsApp notifications disabled'**
  String get whatsappNotificationsDisabled;

  /// WhatsApp toggle failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to toggle WhatsApp notifications'**
  String get failedToToggleWhatsappNotifications;

  /// WhatsApp toggle error message
  ///
  /// In en, this message translates to:
  /// **'Error toggling WhatsApp notifications'**
  String get errorTogglingWhatsappNotifications;

  /// Email notifications enabled message
  ///
  /// In en, this message translates to:
  /// **'Email notifications enabled'**
  String get emailNotificationsEnabled;

  /// Email notifications disabled message
  ///
  /// In en, this message translates to:
  /// **'Email notifications disabled'**
  String get emailNotificationsDisabled;

  /// Email toggle failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to toggle email notifications'**
  String get failedToToggleEmailNotifications;

  /// Email toggle error message
  ///
  /// In en, this message translates to:
  /// **'Error toggling email notifications'**
  String get errorTogglingEmailNotifications;

  /// Barcode read error message
  ///
  /// In en, this message translates to:
  /// **'Unable to read barcode'**
  String get unableToReadBarcode;

  /// Shipped status
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get shipped;

  /// Cancelled status
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// Device storage access error
  ///
  /// In en, this message translates to:
  /// **'Could not access device storage'**
  String get couldNotAccessDeviceStorage;

  /// PDF save success message
  ///
  /// In en, this message translates to:
  /// **'PDF saved successfully'**
  String get pdfSavedSuccessfully;

  /// PDF open failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to open PDF'**
  String get failedToOpenPdf;

  /// PDF save error message
  ///
  /// In en, this message translates to:
  /// **'Error saving PDF'**
  String get errorSavingPdf;

  /// Update required title
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get update_required;

  /// Update available title
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get update_available;

  /// Current version label
  ///
  /// In en, this message translates to:
  /// **'Current Version:'**
  String get current_version;

  /// Latest version label
  ///
  /// In en, this message translates to:
  /// **'Latest Version:'**
  String get latest_version;

  /// Update now button text
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get update_now;

  /// Later button text
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// Critical update required message
  ///
  /// In en, this message translates to:
  /// **'Critical update required. Please update immediately.'**
  String get critical_update_required;

  /// Update required message
  ///
  /// In en, this message translates to:
  /// **'Update required for continued use.'**
  String get update_required_message;

  /// Update available message
  ///
  /// In en, this message translates to:
  /// **'New version available with improvements.'**
  String get update_available_message;

  /// Forced update warning message
  ///
  /// In en, this message translates to:
  /// **'You must update the app to continue using it. The app will not function until you install the latest version.'**
  String get forced_update_warning_message;

  /// Version 7 required message
  ///
  /// In en, this message translates to:
  /// **'This version is no longer supported. Please update to version 7.0.0 or higher to continue using the app.'**
  String get version_7_required_message;

  /// Copyright text for app footer
  ///
  /// In en, this message translates to:
  /// **'© 2024 Parcel Express. All rights reserved.'**
  String get copyright_text;

  /// Version text for app footer
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version_text(String version);

  /// Stations label
  ///
  /// In en, this message translates to:
  /// **'Stations'**
  String get stations;

  /// Hubs label
  ///
  /// In en, this message translates to:
  /// **'Hubs'**
  String get hubs;

  /// Selected item label
  ///
  /// In en, this message translates to:
  /// **'Selected: {name}'**
  String selected(String name);

  /// Map page title
  ///
  /// In en, this message translates to:
  /// **'Our Stations'**
  String get map;

  /// Map page subtitle
  ///
  /// In en, this message translates to:
  /// **'See us on the map'**
  String get viewLocationsAndRoutes;

  /// Map view title
  ///
  /// In en, this message translates to:
  /// **'Map View'**
  String get mapView;

  /// List view title
  ///
  /// In en, this message translates to:
  /// **'List View'**
  String get listView;

  /// Switch to list view tooltip
  ///
  /// In en, this message translates to:
  /// **'Switch to List View'**
  String get switchToListView;

  /// Switch to map view tooltip
  ///
  /// In en, this message translates to:
  /// **'Switch to Map View'**
  String get switchToMapView;

  /// Refresh data tooltip
  ///
  /// In en, this message translates to:
  /// **'Refresh Data'**
  String get refreshData;

  /// No locations available title
  ///
  /// In en, this message translates to:
  /// **'No Locations Available'**
  String get noLocationsAvailable;

  /// No locations available description
  ///
  /// In en, this message translates to:
  /// **'Stations and hubs will appear here once the API is available.'**
  String get stationsAndHubsWillAppearHere;

  /// Locations count with number
  ///
  /// In en, this message translates to:
  /// **'Locations ({count})'**
  String locationsCount(int count);

  /// Finance page title
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get finance;

  /// Finance menu item title
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get viewFinance;

  /// Finance menu item subtitle
  ///
  /// In en, this message translates to:
  /// **'View account balance and transactions'**
  String get viewFinanceSubtitle;

  /// Account balance label
  ///
  /// In en, this message translates to:
  /// **'Account Balance'**
  String get accountBalance;

  /// Total COD label
  ///
  /// In en, this message translates to:
  /// **'Total COD'**
  String get totalCod;

  /// Total fees label
  ///
  /// In en, this message translates to:
  /// **'Total Fees'**
  String get totalFees;

  /// Total settlements label
  ///
  /// In en, this message translates to:
  /// **'Total Settlements'**
  String get totalSettlements;

  /// Current balance label
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// Transaction history section title
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// Loading finance data message
  ///
  /// In en, this message translates to:
  /// **'Loading finance data...'**
  String get loadingFinanceData;

  /// Error loading finance title
  ///
  /// In en, this message translates to:
  /// **'Error Loading Finance'**
  String get errorLoadingFinance;

  /// No finance data title
  ///
  /// In en, this message translates to:
  /// **'No Finance Data'**
  String get noFinanceData;

  /// No transactions yet message
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactionsYet;

  /// Transactions placeholder message
  ///
  /// In en, this message translates to:
  /// **'Your transaction history will appear here once you start making transactions.'**
  String get transactionsWillAppearHere;

  /// Transaction type label
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get transactionType;

  /// Transaction reference label
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get transactionReference;

  /// Transaction description label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get transactionDescription;

  /// Transaction amount label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get transactionAmount;

  /// Transaction date label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get transactionDate;

  /// COD transaction type
  ///
  /// In en, this message translates to:
  /// **'COD'**
  String get codTransaction;

  /// Fee transaction type
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get feeTransaction;

  /// Settlement transaction type
  ///
  /// In en, this message translates to:
  /// **'Settlement'**
  String get settlementTransaction;

  /// Credit transaction
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get credit;

  /// Debit transaction
  ///
  /// In en, this message translates to:
  /// **'Debit'**
  String get debit;

  /// Load more transactions button text
  ///
  /// In en, this message translates to:
  /// **'Load More Transactions'**
  String get loadMoreTransactions;

  /// No more transactions message
  ///
  /// In en, this message translates to:
  /// **'No more transactions to load'**
  String get noMoreTransactions;

  /// Finance summary section title
  ///
  /// In en, this message translates to:
  /// **'Finance Summary'**
  String get financeSummary;

  /// Total transactions label
  ///
  /// In en, this message translates to:
  /// **'Total Transactions'**
  String get totalTransactions;

  /// Transactions count message
  ///
  /// In en, this message translates to:
  /// **'Showing {shown} of {total} transactions'**
  String showingTransactionsCount(int shown, int total);

  /// Refresh finance data tooltip
  ///
  /// In en, this message translates to:
  /// **'Refresh Finance Data'**
  String get refreshFinanceData;

  /// Export to Excel button text
  ///
  /// In en, this message translates to:
  /// **'Export to Excel'**
  String get exportToExcel;

  /// Exporting to Excel loading message
  ///
  /// In en, this message translates to:
  /// **'Exporting to Excel...'**
  String get exportingToExcel;

  /// Excel export success message
  ///
  /// In en, this message translates to:
  /// **'Excel file exported successfully!'**
  String get excelExportSuccess;

  /// Excel export failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to export Excel file'**
  String get excelExportFailed;

  /// Export to PDF button text
  ///
  /// In en, this message translates to:
  /// **'Export to PDF'**
  String get exportToPdf;

  /// Exporting to PDF loading message
  ///
  /// In en, this message translates to:
  /// **'Exporting to PDF...'**
  String get exportingToPdf;

  /// PDF export success message
  ///
  /// In en, this message translates to:
  /// **'PDF file exported successfully!'**
  String get pdfExportSuccess;

  /// PDF export failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to export PDF file'**
  String get pdfExportFailed;

  /// Welcome message for permission screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to ParcelExpress'**
  String get welcomeToParcelExpress;

  /// Subtitle for permission request screen
  ///
  /// In en, this message translates to:
  /// **'To provide you with the best experience, we need a few permissions'**
  String get permissionRequestSubtitle;

  /// Title for permission list section
  ///
  /// In en, this message translates to:
  /// **'We need these permissions:'**
  String get weNeedThesePermissions;

  /// Button text to grant permissions
  ///
  /// In en, this message translates to:
  /// **'Grant Permissions'**
  String get grantPermissions;

  /// Button text to skip permissions
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Open settings button text
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// Continue anyway button text
  ///
  /// In en, this message translates to:
  /// **'Continue Anyway'**
  String get continueAnyway;

  /// Message when all permissions are granted
  ///
  /// In en, this message translates to:
  /// **'All permissions granted!'**
  String get allPermissionsGranted;

  /// Message when some permissions are granted
  ///
  /// In en, this message translates to:
  /// **'{granted} of {total} permissions granted'**
  String permissionsPartiallyGranted(int granted, int total);

  /// Message when permissions are denied
  ///
  /// In en, this message translates to:
  /// **'Some permissions were denied. You can enable them later in Settings.'**
  String get permissionsDeniedMessage;

  /// Title for benefits section
  ///
  /// In en, this message translates to:
  /// **'Why do we need these permissions?'**
  String get whyDoWeNeedPermissions;

  /// List of permission benefits
  ///
  /// In en, this message translates to:
  /// **'• Export your finance data to PDF and Excel\n• Scan QR codes for package tracking\n• Send you important delivery notifications'**
  String get permissionBenefits;

  /// Message when permissions are required
  ///
  /// In en, this message translates to:
  /// **'Some permissions are required for full functionality'**
  String get permissionsRequiredMessage;

  /// Message when requesting a permission
  ///
  /// In en, this message translates to:
  /// **'Requesting {permission}...'**
  String requestingPermission(String permission);

  /// Excel file saved message with path
  ///
  /// In en, this message translates to:
  /// **'Excel file saved to: {filePath}'**
  String excelFileSaved(String filePath);

  /// Open Excel file button text
  ///
  /// In en, this message translates to:
  /// **'Open Excel File'**
  String get openExcelFile;

  /// Excel export error title
  ///
  /// In en, this message translates to:
  /// **'Excel Export Error'**
  String get excelExportError;

  /// Exported on label
  ///
  /// In en, this message translates to:
  /// **'Exported on'**
  String get exportedOn;

  /// Request settlement button text
  ///
  /// In en, this message translates to:
  /// **'Request Settlement'**
  String get requestSettlement;

  /// Settlement request dialog title
  ///
  /// In en, this message translates to:
  /// **'Settlement Request'**
  String get settlementRequest;

  /// Settlement request dialog description
  ///
  /// In en, this message translates to:
  /// **'Request a settlement for your account balance'**
  String get settlementRequestDescription;

  /// Settlement amount field label
  ///
  /// In en, this message translates to:
  /// **'Enter settlement amount'**
  String get enterSettlementAmount;

  /// Settlement amount input hint
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get settlementAmountHint;

  /// Settlement notes input hint
  ///
  /// In en, this message translates to:
  /// **'Optional notes for this settlement request'**
  String get settlementNotesHint;

  /// Submit settlement request button text
  ///
  /// In en, this message translates to:
  /// **'Submit Settlement Request'**
  String get submitSettlementRequest;

  /// Settlement request submission loading message
  ///
  /// In en, this message translates to:
  /// **'Submitting settlement request...'**
  String get submittingSettlementRequest;

  /// Settlement request success message
  ///
  /// In en, this message translates to:
  /// **'Settlement request submitted successfully!'**
  String get settlementRequestSubmitted;

  /// Settlement request failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to submit settlement request'**
  String get settlementRequestFailed;

  /// Settlement amount required validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a settlement amount'**
  String get pleaseEnterSettlementAmount;

  /// Invalid settlement amount validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid settlement amount'**
  String get pleaseEnterValidSettlementAmount;

  /// Settlement amount minimum validation message
  ///
  /// In en, this message translates to:
  /// **'Settlement amount must be greater than 0'**
  String get settlementAmountMustBeGreaterThanZero;

  /// Filter bottom sheet description
  ///
  /// In en, this message translates to:
  /// **'Filter your transactions by date range and type'**
  String get filterDescription;

  /// PDF export confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to export your finance data as a PDF?'**
  String get confirmExportPdf;

  /// Storage permission required message
  ///
  /// In en, this message translates to:
  /// **'Storage permission is required to save files. Please grant permission in app settings.'**
  String get storagePermissionRequired;

  /// Storage access error message
  ///
  /// In en, this message translates to:
  /// **'Unable to access storage. Please check your device storage and try again.'**
  String get unableToAccessStorage;

  /// Manual permission enable message
  ///
  /// In en, this message translates to:
  /// **'Please manually enable storage permission in app settings'**
  String get manuallyEnablePermission;

  /// File saved to downloads message
  ///
  /// In en, this message translates to:
  /// **'File saved to Downloads folder'**
  String get fileSavedToDownloads;

  /// Check file manager message
  ///
  /// In en, this message translates to:
  /// **'Check your file manager'**
  String get checkFileManager;

  /// No filters applied message
  ///
  /// In en, this message translates to:
  /// **'No filters'**
  String get noFilters;

  /// From date label
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// To date label
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// Exit app dialog title
  ///
  /// In en, this message translates to:
  /// **'Exit App'**
  String get exitApp;

  /// Exit app confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the app?'**
  String get exitAppConfirmation;

  /// Exit button text
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// Stay button text
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stay;

  /// Settlement amount exceeds balance error
  ///
  /// In en, this message translates to:
  /// **'The requested amount exceeds your current balance. Please enter a smaller amount.'**
  String get settlementAmountExceedsBalance;

  /// Insufficient balance error
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance. Please check your account balance.'**
  String get insufficientBalance;

  /// Invalid settlement amount error
  ///
  /// In en, this message translates to:
  /// **'Invalid settlement amount. Please enter a valid amount.'**
  String get invalidSettlementAmount;

  /// Settlement request already exists error
  ///
  /// In en, this message translates to:
  /// **'A settlement request already exists. Please wait for it to be processed.'**
  String get settlementRequestAlreadyExists;

  /// Minimum settlement amount error
  ///
  /// In en, this message translates to:
  /// **'The settlement amount is below the minimum required amount.'**
  String get minimumSettlementAmount;

  /// Maximum settlement amount error
  ///
  /// In en, this message translates to:
  /// **'The settlement amount exceeds the maximum allowed amount.'**
  String get maximumSettlementAmount;

  /// Account not found error
  ///
  /// In en, this message translates to:
  /// **'Account not found. Please contact support.'**
  String get accountNotFound;

  /// Session expired error
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get sessionExpired;

  /// Access denied error
  ///
  /// In en, this message translates to:
  /// **'Access denied. You don\'t have permission to perform this action.'**
  String get accessDenied;

  /// Resource not found error
  ///
  /// In en, this message translates to:
  /// **'The requested resource was not found.'**
  String get resourceNotFound;

  /// Validation failed error
  ///
  /// In en, this message translates to:
  /// **'Validation failed. Please check your input and try again.'**
  String get validationFailed;

  /// Service unavailable error
  ///
  /// In en, this message translates to:
  /// **'Service is temporarily unavailable. Please try again later.'**
  String get serviceUnavailable;

  /// Too many requests error
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a moment and try again.'**
  String get tooManyRequests;

  /// Payment required error
  ///
  /// In en, this message translates to:
  /// **'Payment required to access this feature.'**
  String get paymentRequired;

  /// Resource conflict error
  ///
  /// In en, this message translates to:
  /// **'The resource already exists or conflicts with existing data.'**
  String get resourceConflict;

  /// Precondition failed error
  ///
  /// In en, this message translates to:
  /// **'Precondition failed. Please try again.'**
  String get preconditionFailed;

  /// Request too large error
  ///
  /// In en, this message translates to:
  /// **'Request is too large. Please reduce the data size.'**
  String get requestTooLarge;

  /// Unsupported media type error
  ///
  /// In en, this message translates to:
  /// **'Unsupported media type. Please check your file format.'**
  String get unsupportedMediaType;

  /// Unprocessable entity error
  ///
  /// In en, this message translates to:
  /// **'The request could not be processed. Please check your input.'**
  String get unprocessableEntity;

  /// Resource locked error
  ///
  /// In en, this message translates to:
  /// **'The resource is locked and cannot be modified.'**
  String get resourceLocked;

  /// Failed dependency error
  ///
  /// In en, this message translates to:
  /// **'The request failed due to a dependency issue.'**
  String get failedDependency;

  /// Upgrade required error
  ///
  /// In en, this message translates to:
  /// **'An upgrade is required to access this feature.'**
  String get upgradeRequired;

  /// Precondition required error
  ///
  /// In en, this message translates to:
  /// **'A precondition is required for this request.'**
  String get preconditionRequired;

  /// Too many connections error
  ///
  /// In en, this message translates to:
  /// **'Too many connections. Please try again later.'**
  String get tooManyConnections;

  /// Unavailable for legal reasons error
  ///
  /// In en, this message translates to:
  /// **'This service is unavailable for legal reasons.'**
  String get unavailableForLegalReasons;

  /// Bad request error
  ///
  /// In en, this message translates to:
  /// **'Bad request. Please check your input and try again.'**
  String get badRequest;

  /// Unauthorized error
  ///
  /// In en, this message translates to:
  /// **'Unauthorized access. Please log in again.'**
  String get unauthorized;

  /// Forbidden error
  ///
  /// In en, this message translates to:
  /// **'Access forbidden. You don\'t have permission.'**
  String get forbidden;

  /// Not found error
  ///
  /// In en, this message translates to:
  /// **'The requested resource was not found.'**
  String get notFound;

  /// Method not allowed error
  ///
  /// In en, this message translates to:
  /// **'This method is not allowed for this resource.'**
  String get methodNotAllowed;

  /// Not acceptable error
  ///
  /// In en, this message translates to:
  /// **'The request is not acceptable.'**
  String get notAcceptable;

  /// Gone error
  ///
  /// In en, this message translates to:
  /// **'The resource is no longer available.'**
  String get gone;

  /// Length required error
  ///
  /// In en, this message translates to:
  /// **'Content length is required for this request.'**
  String get lengthRequired;

  /// Payload too large error
  ///
  /// In en, this message translates to:
  /// **'The request payload is too large.'**
  String get payloadTooLarge;

  /// URI too long error
  ///
  /// In en, this message translates to:
  /// **'The request URI is too long.'**
  String get uriTooLong;

  /// Range not satisfiable error
  ///
  /// In en, this message translates to:
  /// **'The requested range is not satisfiable.'**
  String get rangeNotSatisfiable;

  /// Expectation failed error
  ///
  /// In en, this message translates to:
  /// **'The expectation could not be met.'**
  String get expectationFailed;

  /// I'm a teapot error
  ///
  /// In en, this message translates to:
  /// **'I\'m a teapot. This is a joke error.'**
  String get imATeapot;

  /// Misdirected request error
  ///
  /// In en, this message translates to:
  /// **'The request was misdirected.'**
  String get misdirectedRequest;

  /// Locked error
  ///
  /// In en, this message translates to:
  /// **'The resource is locked.'**
  String get locked;

  /// Too early error
  ///
  /// In en, this message translates to:
  /// **'The request was made too early.'**
  String get tooEarly;

  /// Request header fields too large error
  ///
  /// In en, this message translates to:
  /// **'Request header fields are too large.'**
  String get requestHeaderFieldsTooLarge;

  /// Internal server error
  ///
  /// In en, this message translates to:
  /// **'Internal server error. Please try again later.'**
  String get internalServerError;

  /// Not implemented error
  ///
  /// In en, this message translates to:
  /// **'This feature is not implemented yet.'**
  String get notImplemented;

  /// Bad gateway error
  ///
  /// In en, this message translates to:
  /// **'Bad gateway. Please try again later.'**
  String get badGateway;

  /// Gateway timeout error
  ///
  /// In en, this message translates to:
  /// **'Gateway timeout. Please try again later.'**
  String get gatewayTimeout;

  /// HTTP version not supported error
  ///
  /// In en, this message translates to:
  /// **'HTTP version not supported.'**
  String get httpVersionNotSupported;

  /// Variant also negotiates error
  ///
  /// In en, this message translates to:
  /// **'Variant also negotiates error.'**
  String get variantAlsoNegotiates;

  /// Insufficient storage error
  ///
  /// In en, this message translates to:
  /// **'Insufficient storage on the server.'**
  String get insufficientStorage;

  /// Loop detected error
  ///
  /// In en, this message translates to:
  /// **'Infinite loop detected.'**
  String get loopDetected;

  /// Not extended error
  ///
  /// In en, this message translates to:
  /// **'Not extended error.'**
  String get notExtended;

  /// Network authentication required error
  ///
  /// In en, this message translates to:
  /// **'Network authentication required.'**
  String get networkAuthenticationRequired;

  /// Invalid amount error
  ///
  /// In en, this message translates to:
  /// **'Invalid amount. Please enter a valid number.'**
  String get invalidAmount;

  /// Invalid email error
  ///
  /// In en, this message translates to:
  /// **'Invalid email address. Please enter a valid email.'**
  String get invalidEmail;

  /// Invalid phone error
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number. Please enter a valid phone number.'**
  String get invalidPhone;

  /// Invalid password error
  ///
  /// In en, this message translates to:
  /// **'Invalid password. Please check your password.'**
  String get invalidPassword;

  /// Field required error
  ///
  /// In en, this message translates to:
  /// **'This field is required. Please fill it out.'**
  String get fieldRequired;

  /// Bad response error
  ///
  /// In en, this message translates to:
  /// **'Bad response from server. Please try again.'**
  String get badResponse;

  /// Connection timeout error
  ///
  /// In en, this message translates to:
  /// **'Connection timeout. Please check your internet connection.'**
  String get connectionTimeout;

  /// Send timeout error
  ///
  /// In en, this message translates to:
  /// **'Send timeout. Please try again.'**
  String get sendTimeout;

  /// Receive timeout error
  ///
  /// In en, this message translates to:
  /// **'Receive timeout. Please try again.'**
  String get receiveTimeout;

  /// Request cancelled error
  ///
  /// In en, this message translates to:
  /// **'Request was cancelled.'**
  String get requestCancelled;

  /// Unknown error message
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred. Please try again.'**
  String get unknownError;

  /// Form progress indicator title
  ///
  /// In en, this message translates to:
  /// **'Form Progress'**
  String get formProgress;

  /// Estimated completion time
  ///
  /// In en, this message translates to:
  /// **'2-3 min'**
  String get estimatedTime;

  /// Station type label
  ///
  /// In en, this message translates to:
  /// **'Station'**
  String get station;

  /// Hub type label
  ///
  /// In en, this message translates to:
  /// **'Hub'**
  String get hub;

  /// No stations available message
  ///
  /// In en, this message translates to:
  /// **'No Stations Available'**
  String get noStationsAvailable;

  /// No hubs available message
  ///
  /// In en, this message translates to:
  /// **'No Hubs Available'**
  String get noHubsAvailable;

  /// Stations placeholder message
  ///
  /// In en, this message translates to:
  /// **'Stations will appear here once the API is available.'**
  String get stationsWillAppearHere;

  /// Hubs placeholder message
  ///
  /// In en, this message translates to:
  /// **'Hubs will appear here once the API is available.'**
  String get hubsWillAppearHere;

  /// Tap to view on map instruction
  ///
  /// In en, this message translates to:
  /// **'Tap to view on map'**
  String get tapToViewOnMap;

  /// Tap to view instruction
  ///
  /// In en, this message translates to:
  /// **'Tap to view'**
  String get tapToView;

  /// Show all locations tooltip
  ///
  /// In en, this message translates to:
  /// **'Show all locations'**
  String get showAllLocations;

  /// Stations and hubs count
  ///
  /// In en, this message translates to:
  /// **'{stations} Stations • {hubs} Hubs'**
  String stationsAndHubsCount(int stations, int hubs);

  /// Danger zone section title
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// Danger zone warning message
  ///
  /// In en, this message translates to:
  /// **'This action is permanent and cannot be undone. Please proceed with caution.'**
  String get dangerZoneWarning;

  /// This will consequences list header
  ///
  /// In en, this message translates to:
  /// **'This will:'**
  String get thisWill;

  /// Permanently delete data consequence
  ///
  /// In en, this message translates to:
  /// **'Permanently delete all your data'**
  String get permanentlyDeleteData;

  /// Remove orders and history consequence
  ///
  /// In en, this message translates to:
  /// **'Remove all your orders and history'**
  String get removeOrdersHistory;

  /// Cancel pending transactions consequence
  ///
  /// In en, this message translates to:
  /// **'Cancel any pending transactions'**
  String get cancelPendingTransactions;

  /// Cannot be reversed consequence
  ///
  /// In en, this message translates to:
  /// **'Cannot be reversed or undone'**
  String get cannotBeReversed;

  /// Understand consequences warning
  ///
  /// In en, this message translates to:
  /// **'Please make sure you understand the consequences.'**
  String get understandConsequences;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// Final confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Are you absolutely sure?'**
  String get areYouAbsolutelySure;

  /// Last chance warning message
  ///
  /// In en, this message translates to:
  /// **'This is your last chance to cancel. Once deleted, your account cannot be recovered.'**
  String get lastChanceWarning;

  /// Keep account button text
  ///
  /// In en, this message translates to:
  /// **'Keep My Account'**
  String get keepMyAccount;

  /// Warning label with emoji
  ///
  /// In en, this message translates to:
  /// **'⚠️ Warning'**
  String get warningLabel;

  /// Switch to Arabic text
  ///
  /// In en, this message translates to:
  /// **'التبديل إلى العربية'**
  String get switchToArabic;

  /// Switch to English text
  ///
  /// In en, this message translates to:
  /// **'Switch to English'**
  String get switchToEnglish;

  /// Arabic language name
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Arabic language code
  ///
  /// In en, this message translates to:
  /// **'AR'**
  String get arabicCode;

  /// English language code
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get englishCode;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
