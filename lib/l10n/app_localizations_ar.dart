// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'باسيل إكسبريس';

  @override
  String get welcomeMessage => 'مرحباً بعودتك! يرجى تسجيل الدخول للمتابعة.';

  @override
  String get tagline => 'خدمة توصيل سريعة وموثوقة';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emailAddress => 'عنوان البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get alternatePhone => 'رقم هاتف بديل';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get customerName => 'اسم العميل';

  @override
  String get customerPhone => 'هاتف العميل';

  @override
  String get personalInformation => 'المعلومات الشخصية';

  @override
  String get customerInformation => 'معلومات العميل';

  @override
  String get locationDetails => 'تفاصيل الموقع';

  @override
  String get additionalInformation => 'معلومات إضافية';

  @override
  String get newOrder => 'طلب جديد';

  @override
  String get createOrder => 'إنشاء طلب';

  @override
  String get fillDetailsToCreateOrder => 'املأ التفاصيل لإنشاء طلبك';

  @override
  String get addressBook => 'دليل العناوين';

  @override
  String get scanOrEnter => 'امسح أو أدخل';

  @override
  String get addStickerNumber => 'أضف رقم الملصق للبدء';

  @override
  String get stickerNumber => 'رقم الملصق';

  @override
  String get amount => 'المبلغ';

  @override
  String get notes => 'ملاحظات';

  @override
  String get deliveryFee => 'رسوم التوصيل';

  @override
  String get paymentType => 'نوع الدفع';

  @override
  String get streetAddress => 'عنوان الشارع';

  @override
  String get zipcode => 'الرمز البريدي';

  @override
  String get governorate => 'المحافظة';

  @override
  String get state => 'الولاية';

  @override
  String get place => 'المكان';

  @override
  String get required => 'مطلوب';

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get phoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get validEmailRequired => 'أدخل بريد إلكتروني صحيح';

  @override
  String helloUser(String userName) {
    return 'مرحباً، $userName! 👋';
  }

  @override
  String get businessOverview => 'إليك نظرة عامة على أعمالك';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get viewNotifications => 'عرض الإشعارات';

  @override
  String get viewAllNotifications => 'عرض جميع الإشعارات';

  @override
  String get pricing => 'التسعير';

  @override
  String get viewPricing => 'عرض التسعير';

  @override
  String get viewDeliveryPricing => 'عرض تسعير التوصيل لكل ولاية';

  @override
  String get signOutAccount => 'تسجيل الخروج من حسابك';

  @override
  String get notificationSettings => 'إعدادات الإشعارات';

  @override
  String get manageNotificationPreferences =>
      'إدارة تفضيلات الإشعارات الخاصة بك';

  @override
  String get chooseNotificationMethod =>
      'اختر كيفية تلقي الإشعارات حول طلباتك وتحديثات الحساب.';

  @override
  String get aboutNotifications => 'حول الإشعارات';

  @override
  String get receiveNotificationsFor => 'ستتلقى إشعارات لـ:';

  @override
  String get orderConfirmations => 'تأكيدات الطلبات والتحديثات';

  @override
  String get pickupDeliveryNotifications => 'إشعارات الاستلام والتوصيل';

  @override
  String get paymentConfirmations => 'تأكيدات الدفع';

  @override
  String get accountUpdates => 'تحديثات مهمة للحساب';

  @override
  String get whatsapp => 'واتساب';

  @override
  String get emailNotifications => 'البريد الإلكتروني';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get done => 'تم';

  @override
  String get submit => 'إرسال';

  @override
  String get confirm => 'تأكيد';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get back => 'رجوع';

  @override
  String get next => 'التالي';

  @override
  String get search => 'بحث';

  @override
  String get filter => 'تصفية';

  @override
  String get refresh => 'تحديث';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجح';

  @override
  String get warning => 'تحذير';

  @override
  String get information => 'معلومات';

  @override
  String get noDataAvailable => 'لا توجد بيانات متاحة';

  @override
  String get pleaseWait => 'يرجى الانتظار...';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get connectionError => 'خطأ في الاتصال';

  @override
  String get invalidData => 'بيانات غير صحيحة';

  @override
  String get orders => 'الطلبات';

  @override
  String get invoices => 'الفواتير';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get createGuestOrder => 'إنشاء طلب ضيف';

  @override
  String get continueAsGuest => 'متابعة كضيف';

  @override
  String get totalOrders => 'إجمالي الطلبات';

  @override
  String get todayOrders => 'طلبات اليوم';

  @override
  String get pendingPickup => 'في انتظار الاستلام';

  @override
  String get pickedOrders => 'الطلبات المستلمة';

  @override
  String get loadingDashboard => 'جاري تحميل لوحة التحكم...';

  @override
  String get welcomeDashboard => 'مرحباً بك في لوحة التحكم';

  @override
  String get tapToLoadStats => 'اضغط لتحميل الإحصائيات';

  @override
  String get loadDashboard => 'تحميل لوحة التحكم';

  @override
  String get addressDetails => 'تفاصيل العنوان';

  @override
  String get district => 'المنطقة';

  @override
  String get identification => 'رقم الهوية';

  @override
  String get taxNumber => 'الرقم الضريبي';

  @override
  String get locationUrl => 'رابط الموقع';

  @override
  String get pleaseSelectGovernorate => 'يرجى اختيار المحافظة';

  @override
  String get pleaseSelectState => 'يرجى اختيار الولاية';

  @override
  String get pleaseSelectPlace => 'يرجى اختيار المكان';

  @override
  String get orderCreatedSuccessfully => 'تم إنشاء الطلب بنجاح!';

  @override
  String get trackingNumberIs => 'رقم التتبع الخاص بك هو:';

  @override
  String get optional => 'اختياري';

  @override
  String get requiredField => 'هذا الحقل مطلوب';

  @override
  String get districtRequired => 'المنطقة مطلوبة';

  @override
  String get zipcodeRequired => 'الرمز البريدي مطلوب';

  @override
  String get streetAddressRequired => 'عنوان الشارع مطلوب';

  @override
  String get customerNameRequired => 'اسم العميل مطلوب';

  @override
  String get customerPhoneRequired => 'هاتف العميل مطلوب';

  @override
  String get validLocationUrlRequired => 'أدخل رابط موقع صحيح';

  @override
  String get validAmountRequired => 'أدخل مبلغاً صحيحاً';

  @override
  String get user => 'المستخدم';

  @override
  String get notAvailable => 'غير متوفر';

  @override
  String get role => 'الدور';

  @override
  String get location => 'الموقع';

  @override
  String get settings => 'الإعدادات';

  @override
  String get logoutConfirmation => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get invoicesAndPayments => 'الفواتير والمدفوعات';

  @override
  String get searchByInvoiceNumber => 'البحث برقم الفاتورة...';

  @override
  String get loadingInvoices => 'جاري تحميل الفواتير...';

  @override
  String get noInvoices => 'لا توجد فواتير';

  @override
  String get noInvoicesYet => 'لا توجد لديك فواتير حتى الآن.';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String noInvoicesFound(String query) {
    return 'لم يتم العثور على فواتير لـ \"$query\"';
  }

  @override
  String get clearSearch => 'مسح البحث';

  @override
  String get recentTransactions => 'المعاملات الأخيرة';

  @override
  String get noTransactionsFound => 'لم يتم العثور على معاملات';

  @override
  String get adjustFilters => 'حاول تعديل الفلاتر أو تحقق لاحقاً.';

  @override
  String get filterPayments => 'تصفية المدفوعات';

  @override
  String get filterByType => 'تصفية حسب النوع';

  @override
  String get filterByStatus => 'تصفية حسب الحالة';

  @override
  String get transactionDetails => 'تفاصيل المعاملة';

  @override
  String get trackingNo => 'رقم التتبع';

  @override
  String get notificationMarkedAsRead => 'تم تحديد الإشعار كمقروء';

  @override
  String get notificationDeleted => 'تم حذف الإشعار';

  @override
  String get markAllAsRead => 'تحديد الكل كمقروء';

  @override
  String get markAllNotificationsAsRead => 'تحديد جميع الإشعارات كمقروءة';

  @override
  String get reload => 'إعادة تحميل';

  @override
  String get reloadNotifications => 'إعادة تحميل الإشعارات';

  @override
  String get markAsRead => 'تحديد كمقروء';

  @override
  String get markThisNotificationAsRead => 'تحديد هذا الإشعار كمقروء';

  @override
  String get removeThisNotification => 'إزالة هذا الإشعار';

  @override
  String get deleteNotification => 'حذف الإشعار';

  @override
  String get deleteNotificationConfirmation =>
      'هل أنت متأكد من حذف هذا الإشعار؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(int minutes) {
    return 'منذ $minutes دقيقة';
  }

  @override
  String hoursAgo(int hours) {
    return 'منذ $hours ساعة';
  }

  @override
  String daysAgo(int days) {
    return 'منذ $days يوم';
  }

  @override
  String get noNotificationsYet => 'لا توجد إشعارات حتى الآن';

  @override
  String get notificationsWillAppearHere =>
      'عندما تتلقى إشعارات جديدة،\\nستظهر هنا';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get pricingList => 'قائمة الأسعار';

  @override
  String get loadingPricingData => 'جاري تحميل بيانات الأسعار...';

  @override
  String get errorLoadingPricing => 'خطأ في تحميل الأسعار';

  @override
  String get noPricingData => 'لا توجد بيانات أسعار';

  @override
  String get searchByStateName => 'البحث باسم الولاية...';

  @override
  String get totalStates => 'إجمالي الولايات';

  @override
  String get avgDelivery => 'متوسط التوصيل';

  @override
  String get avgReturn => 'متوسط الإرجاع';

  @override
  String get whatsappNotifications => 'إشعارات الواتساب';

  @override
  String get receiveOrderUpdatesViaWhatsapp =>
      'استلام تحديثات الطلبات عبر الواتساب';

  @override
  String get emailNotificationsTitle => 'إشعارات البريد الإلكتروني';

  @override
  String get receiveOrderUpdatesViaEmail =>
      'استلام تحديثات الطلبات عبر البريد الإلكتروني';

  @override
  String get loadingSettings => 'جاري تحميل الإعدادات...';

  @override
  String get createShipment => 'إنشاء شحنة';

  @override
  String get scanOrEnterTitle => 'مسح أو إدخال';

  @override
  String get addStickerNumberToStart => 'أضف رقم الملصق للبدء';

  @override
  String get enterManually => 'إدخال يدوي';

  @override
  String get typeStickerNumber => 'اكتب رقم الملصق...';

  @override
  String get scanBarcode => 'مسح الباركود';

  @override
  String get startScanning => 'بدء المسح';

  @override
  String get scanFailed => 'فشل المسح';

  @override
  String get successfullyScanned => 'تم المسح بنجاح';

  @override
  String get numberEntered => 'تم إدخال الرقم';

  @override
  String get creatingOrder => 'جاري إنشاء الطلب...';

  @override
  String get savedAddresses => 'العناوين المحفوظة';

  @override
  String get selectFromSavedAddresses =>
      'اختر من العناوين المحفوظة للملء التلقائي';

  @override
  String get formAutoFilled => 'تم ملء النموذج بالعنوان المحدد';

  @override
  String get clear => 'مسح';

  @override
  String get saveForLater => 'حفظ للاستخدام لاحقاً';

  @override
  String get addToAddressBook => 'أضف هذا العنوان إلى دفتر العناوين';

  @override
  String get saveAddressHint =>
      'احفظ هذا العنوان لجعل الطلبات المستقبلية أسرع وأسهل!';

  @override
  String get saveAddress => 'حفظ العنوان';

  @override
  String get notNow => 'ليس الآن';

  @override
  String get addressSaved => 'تم حفظ العنوان في دفتر العناوين بنجاح!';

  @override
  String get addressSaveFailed => 'فشل حفظ العنوان. يرجى المحاولة مرة أخرى.';

  @override
  String get orderCreated => 'تم إنشاء الطلب بنجاح!';

  @override
  String trackingLabel(String trackingNo) {
    return 'التتبع: $trackingNo';
  }

  @override
  String orderIdLabel(String orderId) {
    return 'رقم الطلب: $orderId';
  }

  @override
  String forRecipient(String recipientName) {
    return 'للمستلم: $recipientName';
  }

  @override
  String get positionBarcodeInFrame => 'ضع الباركود داخل الإطار للمسح';

  @override
  String pleaseEnterField(String field) {
    return 'يرجى إدخال $field';
  }

  @override
  String fieldMinLength(String field, int length) {
    return 'يجب أن يحتوي $field على $length أحرف على الأقل';
  }

  @override
  String get pleaseEnterEmail => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get pleaseEnterValidEmail => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String pleaseEnterValidPhone(String field) {
    return 'يرجى إدخال رقم $field صحيح (8-15 رقم)';
  }

  @override
  String get pleaseEnterLocationUrl => 'يرجى إدخال رابط الموقع';

  @override
  String get pleaseEnterValidLocationUrl => 'يرجى إدخال رابط خرائط جوجل صحيح';

  @override
  String get pleaseEnterAmount => 'يرجى إدخال المبلغ';

  @override
  String get pleaseEnterValidAmount => 'يرجى إدخال مبلغ صحيح';

  @override
  String amountMustBeGreaterThan(String amount) {
    return 'يجب أن يكون المبلغ أكبر من $amount';
  }

  @override
  String get pleaseEnterZipcode => 'يرجى إدخال الرمز البريدي';

  @override
  String get pleaseEnterValidZipcode =>
      'يرجى إدخال رمز بريدي صحيح (4-10 أرقام)';

  @override
  String get taxNumberValidation => 'يجب أن يكون الرقم الضريبي من 5-20 رقم';

  @override
  String get identificationValidation =>
      'يجب أن يكون رقم الهوية من 5-20 حرف أو رقم';
}
