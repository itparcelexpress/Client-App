// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Parcel Express';

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
  String get email => 'عنوان البريد الإلكتروني';

  @override
  String get emailAddress => 'عنوان البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get alternatePhone => 'الهاتف البديل';

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
  String get orderDetails => 'تفاصيل الطلب';

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
  String get deleteAccountTitle => 'حذف الحساب';

  @override
  String get deleteAccountSubtitle => 'إلغاء تنشيط حسابك نهائيًا';

  @override
  String get deleteAccountConfirm =>
      'هل تريد بالتأكيد حذف حسابك؟ سيتم إلغاء تنشيط الحساب ولن تتمكن من الوصول إليه بعد الآن.';

  @override
  String get accountDeletedSuccess => 'تم إلغاء تنشيط حسابك بنجاح.';

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
  String get fromDate => 'من تاريخ';

  @override
  String get toDate => 'إلى تاريخ';

  @override
  String get apply => 'تطبيق';

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
  String get connectionError =>
      'خطأ في الاتصال. يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get invalidData => 'بيانات غير صحيحة';

  @override
  String get orders => 'الطلبات';

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
  String get user => 'مستخدم';

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
  String get noResults => 'لا توجد نتائج';

  @override
  String get clearSearch => 'مسح البحث';

  @override
  String get recentTransactions => 'المعاملات الحديثة';

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
  String get trackingNo => 'رقم التتبع:';

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
  String daysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count أيام',
      one: 'منذ يوم واحد',
    );
    return '$_temp0';
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
  String get addressSaveFailed => 'فشل في حفظ العنوان. يرجى المحاولة مرة أخرى.';

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

  @override
  String get logoutSuccessful => 'تم تسجيل الخروج بنجاح';

  @override
  String get financialOverview => 'نظرة عامة مالية';

  @override
  String get totalValue => 'القيمة الإجمالية';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get balance => 'الرصيد';

  @override
  String get avgOrder => 'متوسط الطلب';

  @override
  String get parcelValue => 'قيمة الطرود';

  @override
  String get performanceMetrics => 'مقاييس الأداء';

  @override
  String get deliveryRate => 'معدل التوصيل';

  @override
  String get taskCompletion => 'إنجاز المهام';

  @override
  String get delivered => 'تم التسليم';

  @override
  String get activeTasks => 'المهام النشطة';

  @override
  String get completedTasks => 'مكتملة';

  @override
  String get recentActivity => 'النشاط الأخير';

  @override
  String get viewAllActivities => 'عرض جميع الأنشطة';

  @override
  String get ordersCreated => 'طلبات تم إنشاؤها';

  @override
  String get activityOn => 'نشاط في';

  @override
  String get noRecentActivity => 'لا يوجد نشاط حديث';

  @override
  String get recentActivitiesWillAppearHere => 'أنشطتك الحديثة ستظهر هنا';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get myOrders => 'طلباتي';

  @override
  String get searchByTrackingNumber => 'البحث برقم التتبع...';

  @override
  String get status => 'الحالة';

  @override
  String get allStatus => 'جميع الحالات';

  @override
  String get dateRange => 'نطاق التاريخ';

  @override
  String get loadingOrders => 'جاري تحميل الطلبات...';

  @override
  String showingOrdersCount(int shown, int total) {
    return 'عرض $shown من $total طلب';
  }

  @override
  String pageCount(int current, int total) {
    return 'صفحة $current من $total';
  }

  @override
  String get trackingNumber => 'رقم التتبع';

  @override
  String get trackingNumberCopied => 'تم نسخ رقم التتبع! 📋';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get selectDateRange => 'اختر نطاق التاريخ';

  @override
  String get filterOrders => 'تصفية الطلبات';

  @override
  String get scan => 'مسح';

  @override
  String get trackingAlreadyTaken =>
      'رقم التتبع مستخدم بالفعل. يرجى مسح ملصقًا آخر.';

  @override
  String get invalidDimensions => 'يرجى إدخال أبعاد الطرد بشكل صحيح.';

  @override
  String get recipient => 'المستلم';

  @override
  String get deliveryAddress => 'عنوان التوصيل';

  @override
  String get payment => 'الدفع';

  @override
  String get created => 'تم الإنشاء';

  @override
  String get previous => 'السابق';

  @override
  String get noOrdersYet => 'لا توجد طلبات حتى الآن';

  @override
  String get ordersWillAppearHere => 'ستظهر طلباتك هنا عندما تبدأ في إنشائها';

  @override
  String get createFirstOrder => 'إنشاء أول طلب';

  @override
  String get payments => 'المدفوعات';

  @override
  String get filterTransactions => 'تصفية المعاملات';

  @override
  String get applyFilters => 'تطبيق الفلاتر';

  @override
  String get tryAdjustingFilters => 'حاول تعديل الفلاتر أو تحقق لاحقاً.';

  @override
  String get errorLoadingPayments => 'خطأ في تحميل المدفوعات';

  @override
  String get noPaymentData => 'لا توجد بيانات مدفوعات';

  @override
  String get noPaymentTransactionsFound =>
      'لم يتم العثور على معاملات مدفوعات.\nتحقق لاحقاً للتحديثات.';

  @override
  String get type => 'النوع:';

  @override
  String get customer => 'المستلم';

  @override
  String get phone => 'الهاتف:';

  @override
  String get date => 'التاريخ:';

  @override
  String get paymentSummary => 'ملخص المدفوعات';

  @override
  String get codCollected => 'الدفع عند الاستلام المحصل';

  @override
  String get settled => 'تم التسوية';

  @override
  String get pending => 'معلق';

  @override
  String get totalBalance => 'الرصيد الإجمالي';

  @override
  String get totalAmount => 'المبلغ الإجمالي';

  @override
  String get paid => 'مدفوع';

  @override
  String get overdue => 'متأخر';

  @override
  String id(int id) {
    return 'الرقم: $id';
  }

  @override
  String get all => 'الكل';

  @override
  String get cod => 'الدفع عند الاستلام';

  @override
  String get card => 'بطاقة';

  @override
  String get bank => 'بنك';

  @override
  String get completed => 'مكتمل';

  @override
  String get failed => 'فشل';

  @override
  String get na => 'غير متوفر';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get languageChangedToArabic => 'تم تغيير اللغة إلى العربية';

  @override
  String get languageChangedToEnglish => 'Language changed to English';

  @override
  String get orderCreationFailed =>
      'فشل في إنشاء الطلب. يرجى المحاولة مرة أخرى.';

  @override
  String get addressSavedSuccessfully => 'تم حفظ العنوان بنجاح!';

  @override
  String get addressDeletedSuccessfully => 'تم حذف العنوان بنجاح!';

  @override
  String get addressDeleteFailed =>
      'فشل في حذف العنوان. يرجى المحاولة مرة أخرى.';

  @override
  String get addressUpdatedSuccessfully => 'تم تحديث العنوان بنجاح!';

  @override
  String get addressUpdateFailed =>
      'فشل في تحديث العنوان. يرجى المحاولة مرة أخرى.';

  @override
  String get settingsSavedSuccessfully => 'تم حفظ الإعدادات بنجاح!';

  @override
  String get settingsSaveFailed =>
      'فشل في حفظ الإعدادات. يرجى المحاولة مرة أخرى.';

  @override
  String get logoutSuccessfully => 'تم تسجيل الخروج بنجاح!';

  @override
  String get logoutFailed => 'فشل في تسجيل الخروج. يرجى المحاولة مرة أخرى.';

  @override
  String get loginSuccessfully => 'تم تسجيل الدخول بنجاح!';

  @override
  String get loginFailed => 'فشل تسجيل الدخول. يرجى التحقق من البيانات.';

  @override
  String get loginErrorIncorrectPassword =>
      'كلمة المرور غير صحيحة. حاول مرة أخرى.';

  @override
  String get loginErrorNoAccount =>
      'لا يوجد حساب مرتبط بهذا البريد الإلكتروني.';

  @override
  String get loginErrorAccountDisabled =>
      'تم تعطيل حسابك. يرجى التواصل مع الدعم.';

  @override
  String get loginErrorTooManyAttempts =>
      'محاولات تسجيل دخول كثيرة. حاول لاحقاً.';

  @override
  String get loginErrorValidation =>
      'يرجى التحقق من المدخلات والمحاولة مرة أخرى.';

  @override
  String get loginErrorUnknown => 'تعذر تسجيل الدخول. يرجى المحاولة مرة أخرى.';

  @override
  String get networkError => 'خطأ في الشبكة. يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get serverError => 'خطأ في الخادم. يرجى المحاولة مرة أخرى لاحقاً.';

  @override
  String get validationError => 'يرجى التحقق من المدخلات والمحاولة مرة أخرى.';

  @override
  String get operationSuccess => 'تم إكمال العملية بنجاح!';

  @override
  String get operationFailed => 'فشلت العملية. يرجى المحاولة مرة أخرى.';

  @override
  String get dataLoadedSuccessfully => 'تم تحميل البيانات بنجاح!';

  @override
  String get dataLoadFailed => 'فشل في تحميل البيانات. يرجى المحاولة مرة أخرى.';

  @override
  String get fileDownloadedSuccessfully => 'تم تحميل الملف بنجاح!';

  @override
  String get fileDownloadFailed =>
      'فشل في تحميل الملف. يرجى المحاولة مرة أخرى.';

  @override
  String get copyToClipboardSuccess => 'تم النسخ إلى الحافظة!';

  @override
  String get copyToClipboardFailed => 'فشل في النسخ إلى الحافظة.';

  @override
  String get confirmLogout => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get confirmDelete => 'هل أنت متأكد من حذف هذا العنصر؟';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get processing => 'قيد المعالجة';

  @override
  String get uploading => 'جاري الرفع...';

  @override
  String get downloading => 'جاري التحميل...';

  @override
  String get saving => 'جاري الحفظ...';

  @override
  String get deleting => 'جاري الحذف...';

  @override
  String get updating => 'جاري التحديث...';

  @override
  String get refreshing => 'جاري التحديث...';

  @override
  String get searching => 'جاري البحث...';

  @override
  String get filtering => 'جاري التصفية...';

  @override
  String get sorting => 'جاري الترتيب...';

  @override
  String get connecting => 'جاري الاتصال...';

  @override
  String get disconnecting => 'جاري قطع الاتصال...';

  @override
  String get syncing => 'جاري المزامنة...';

  @override
  String get backingUp => 'جاري النسخ الاحتياطي...';

  @override
  String get restoring => 'جاري الاستعادة...';

  @override
  String get installing => 'جاري التثبيت...';

  @override
  String get uninstalling => 'جاري إلغاء التثبيت...';

  @override
  String get updatingApp => 'جاري تحديث التطبيق...';

  @override
  String get checkingForUpdates => 'جاري التحقق من التحديثات...';

  @override
  String get noUpdatesAvailable => 'لا توجد تحديثات متاحة';

  @override
  String get updateAvailable => 'تحديث متاح';

  @override
  String get updateDownloaded => 'تم تحميل التحديث';

  @override
  String get updateInstalled => 'تم تثبيت التحديث';

  @override
  String get updateFailed => 'فشل التحديث';

  @override
  String get restartRequired => 'إعادة تشغيل مطلوبة';

  @override
  String get restartNow => 'إعادة التشغيل الآن';

  @override
  String get restartLater => 'إعادة التشغيل لاحقاً';

  @override
  String get orderCreatedViaMobileApp => 'تم إنشاء الطلب عبر التطبيق المحمول';

  @override
  String get addAddress => 'إضافة عنوان';

  @override
  String get updateAddress => 'تحديث العنوان';

  @override
  String get addYourFirstAddress => 'أضف عنوانك الأول للبدء';

  @override
  String get errorLoadingAddresses => 'خطأ في تحميل العناوين';

  @override
  String get pleaseSelectAllLocationFields => 'يرجى اختيار جميع حقول الموقع';

  @override
  String get prepaid => 'مدفوع مسبقاً';

  @override
  String get tapToSelectAddress => 'انقر لاختيار العنوان';

  @override
  String get clearSelection => 'مسح الاختيار';

  @override
  String get phoneNumberHint => '12345678';

  @override
  String get alternatePhoneHint => '12345678';

  @override
  String fullPhoneNumberPreview(String fullNumber) {
    return 'رقم الهاتف الكامل: $fullNumber';
  }

  @override
  String get phoneNumberInfo => 'أدخل رقم هاتفك بدون رمز الدولة';

  @override
  String get alternatePhoneInfo => 'أدخل رقم هاتف بديل (اختياري)';

  @override
  String get emailPlaceholder => 'example@email.com';

  @override
  String get streetAddressHint => 'المبنى، الشارع، المنطقة';

  @override
  String get locationUrlPlaceholder => 'https://maps.app.goo.gl/...';

  @override
  String get noAddressesYet => 'لا توجد عناوين بعد';

  @override
  String get addYourFirstAddressHint => 'أضف عنوانك الأول لتسهيل إنشاء الطلب';

  @override
  String get deleteAddress => 'حذف العنوان';

  @override
  String deleteAddressConfirmation(String name) {
    return 'هل أنت متأكد من حذف العنوان \"$name\"؟';
  }

  @override
  String get feePayer => 'دافع الرسوم';

  @override
  String get dimensionsAndWeight => 'الأبعاد والوزن';

  @override
  String get measurementUnit => 'وحدة القياس';

  @override
  String get packageDimensions => 'أبعاد الطرد';

  @override
  String get width => 'العرض';

  @override
  String get height => 'الارتفاع';

  @override
  String get length => 'الطول';

  @override
  String get weight => 'الوزن';

  @override
  String get items => 'العناصر';

  @override
  String get itemName => 'اسم العنصر';

  @override
  String get itemNameHint => 'أدخل اسم العنصر...';

  @override
  String get category => 'الفئة';

  @override
  String get categoryHint => 'الفئة...';

  @override
  String get quantity => 'الكمية';

  @override
  String get quantityHint => '1';

  @override
  String get addAnotherItem => 'إضافة عنصر آخر';

  @override
  String get client => 'المرسل';

  @override
  String get kg => 'كيلو';

  @override
  String get lengthUnit => 'الطول';

  @override
  String get deliveryFeeHint => '0.00';

  @override
  String get amountHint => '0.00';

  @override
  String get dimensionHint => '0.0';

  @override
  String get pleaseEnterDeliveryFee => 'يرجى إدخال رسوم التوصيل';

  @override
  String get pleaseEnterAmountField => 'يرجى إدخال المبلغ';

  @override
  String get pleaseEnterBothEmailAndPassword =>
      'يرجى إدخال البريد الإلكتروني وكلمة المرور';

  @override
  String get emailAndPasswordRequired =>
      'البريد الإلكتروني وكلمة المرور مطلوبان';

  @override
  String get loginFailedGeneric => 'فشل تسجيل الدخول';

  @override
  String get networkConnectionError => 'خطأ في الاتصال بالشبكة';

  @override
  String get pleaseCheckInternetConnection =>
      'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى';

  @override
  String get requestTimeout => 'انتهت مهلة الطلب. يرجى المحاولة مرة أخرى.';

  @override
  String get requestTookTooLong =>
      'استغرق الطلب وقتاً طويلاً. يرجى المحاولة مرة أخرى';

  @override
  String get unexpectedErrorOccurred => 'حدث خطأ غير متوقع';

  @override
  String get pleaseTryAgainLater => 'يرجى المحاولة مرة أخرى لاحقاً';

  @override
  String get loginSuccess => 'تم تسجيل الدخول بنجاح';

  @override
  String get or => 'أو';

  @override
  String get cameraPermissionDenied => 'تم رفض إذن الكاميرا';

  @override
  String get clientApp => 'تطبيق العميل';

  @override
  String get egypt => 'مصر';

  @override
  String get saudiArabia => 'المملكة العربية السعودية';

  @override
  String get unitedArabEmirates => 'الإمارات العربية المتحدة';

  @override
  String get kuwait => 'الكويت';

  @override
  String get qatar => 'قطر';

  @override
  String get bahrain => 'البحرين';

  @override
  String get oman => 'عُمان';

  @override
  String get jordan => 'الأردن';

  @override
  String get lebanon => 'لبنان';

  @override
  String get unitedStates => 'الولايات المتحدة';

  @override
  String get unitedKingdom => 'المملكة المتحدة';

  @override
  String get selectCountry => 'اختر الدولة';

  @override
  String get popularCountries => 'الدول الشائعة';

  @override
  String get allCountries => 'جميع الدول';

  @override
  String get noCountriesFound => 'لم يتم العثور على دول';

  @override
  String get tryDifferentSearchTerm => 'جرب مصطلح بحث مختلف';

  @override
  String get selectGovernorate => 'اختر المحافظة';

  @override
  String get noGovernoratesFound => 'لم يتم العثور على محافظات';

  @override
  String get selectState => 'اختر الولاية';

  @override
  String get noStatesFound => 'لم يتم العثور على ولايات';

  @override
  String get selectPlace => 'اختر المكان';

  @override
  String get noPlacesFound => 'لم يتم العثور على أماكن';

  @override
  String get canada => 'كندا';

  @override
  String get searchCountry => 'البحث عن دولة';

  @override
  String get startTypingToSearch => 'ابدأ الكتابة للبحث';

  @override
  String get failedToLoadNotifications => 'فشل في تحميل الإشعارات';

  @override
  String get errorLoadingNotifications => 'خطأ في تحميل الإشعارات';

  @override
  String get failedToLoadMoreNotifications =>
      'فشل في تحميل المزيد من الإشعارات';

  @override
  String get errorLoadingMoreNotifications =>
      'خطأ في تحميل المزيد من الإشعارات';

  @override
  String get examplePhoneNumber => '123xxxx';

  @override
  String itemNumber(Object number) {
    return 'عنصر $number';
  }

  @override
  String get thisTrackingNumberIsAlreadyUsed =>
      'رقم التتبع هذا مستخدم بالفعل. يرجى مسح ملصق مختلف.';

  @override
  String get pleaseCheckYourInputAndTryAgain =>
      'يرجى التحقق من المدخلات والمحاولة مرة أخرى.';

  @override
  String get anErrorOccurred => 'حدث خطأ';

  @override
  String get selectAddress => 'اختيار عنوان';

  @override
  String get addNew => 'إضافة جديد';

  @override
  String get noAddressesFound => 'لم يتم العثور على عناوين';

  @override
  String get editAddress => 'تعديل العنوان';

  @override
  String get addNewAddress => 'إضافة عنوان جديد';

  @override
  String get addressManagementDisabled =>
      'إدارة العناوين معطلة حالياً. يمكنك فقط اختيار من العناوين الموجودة.';

  @override
  String get addressManagementDisabledMain =>
      'إدارة العناوين معطلة حالياً. يمكنك عرض العناوين الموجودة ولكن لا يمكنك إضافة أو تعديل أي منها.';

  @override
  String get pleaseEnterYourFullName => 'يرجى إدخال اسمك الكامل';

  @override
  String get pleaseEnterYourEmailAddress => 'يرجى إدخال عنوان بريدك الإلكتروني';

  @override
  String get pleaseEnterAValidEmailAddress =>
      'يرجى إدخال عنوان بريد إلكتروني صحيح';

  @override
  String get alternatePhoneNumber => 'رقم هاتف بديل';

  @override
  String get pleaseEnterYourStreetAddress => 'يرجى إدخال عنوان الشارع';

  @override
  String get zipCodeOptional => 'الرمز البريدي (اختياري)';

  @override
  String get locationUrlOptional => 'رابط الموقع (اختياري)';

  @override
  String pleaseSelect(Object label) {
    return 'يرجى اختيار $label';
  }

  @override
  String get contactInformation => 'معلومات الاتصال';

  @override
  String get primaryPhone => 'الهاتف الأساسي';

  @override
  String get country => 'البلد';

  @override
  String get zipCode => 'الرمز البريدي';

  @override
  String get failedToLoadClientSettings => 'فشل في تحميل إعدادات العميل';

  @override
  String get errorLoadingClientSettings => 'خطأ في تحميل إعدادات العميل';

  @override
  String get noCurrentSettingsAvailable => 'لا توجد إعدادات حالية متاحة';

  @override
  String get failedToUpdateNotificationSettings =>
      'فشل في تحديث إعدادات الإشعارات';

  @override
  String get errorUpdatingNotificationSettings =>
      'خطأ في تحديث إعدادات الإشعارات';

  @override
  String get noNotificationSettingsAvailable => 'لا توجد إعدادات إشعارات متاحة';

  @override
  String get whatsappNotificationsEnabled => 'تم تفعيل إشعارات واتساب';

  @override
  String get whatsappNotificationsDisabled => 'تم إلغاء تفعيل إشعارات واتساب';

  @override
  String get failedToToggleWhatsappNotifications =>
      'فشل في تبديل إشعارات واتساب';

  @override
  String get errorTogglingWhatsappNotifications =>
      'خطأ في تبديل إشعارات واتساب';

  @override
  String get emailNotificationsEnabled => 'تم تفعيل إشعارات البريد الإلكتروني';

  @override
  String get emailNotificationsDisabled =>
      'تم إلغاء تفعيل إشعارات البريد الإلكتروني';

  @override
  String get failedToToggleEmailNotifications =>
      'فشل في تبديل إشعارات البريد الإلكتروني';

  @override
  String get errorTogglingEmailNotifications =>
      'خطأ في تبديل إشعارات البريد الإلكتروني';

  @override
  String get unableToReadBarcode => 'غير قادر على قراءة الباركود';

  @override
  String get shipped => 'تم الشحن';

  @override
  String get cancelled => 'ملغي';

  @override
  String get couldNotAccessDeviceStorage => 'لا يمكن الوصول إلى تخزين الجهاز';

  @override
  String get pdfSavedSuccessfully => 'تم حفظ PDF بنجاح';

  @override
  String get failedToOpenPdf => 'فشل في فتح PDF';

  @override
  String get errorSavingPdf => 'خطأ في حفظ PDF';

  @override
  String get update_required => 'تحديث مطلوب';

  @override
  String get update_available => 'تحديث متاح';

  @override
  String get current_version => 'الإصدار الحالي:';

  @override
  String get latest_version => 'أحدث إصدار:';

  @override
  String get update_now => 'تحديث الآن';

  @override
  String get later => 'لاحقاً';

  @override
  String get critical_update_required => 'تحديث حرج مطلوب. يرجى التحديث فوراً.';

  @override
  String get update_required_message => 'تحديث مطلوب للاستخدام المستمر.';

  @override
  String get update_available_message => 'إصدار جديد متاح مع تحسينات.';

  @override
  String get forced_update_warning_message =>
      'يجب عليك تحديث التطبيق للمتابعة. لن يعمل التطبيق حتى تقوم بتثبيت أحدث إصدار.';

  @override
  String get version_7_required_message =>
      'هذا الإصدار لم يعد مدعوماً. يرجى التحديث إلى الإصدار 7.0.0 أو أحدث للمتابعة.';

  @override
  String get copyright_text => '© 2024 Parcel Express. جميع الحقوق محفوظة.';

  @override
  String version_text(String version) {
    return 'الإصدار $version';
  }

  @override
  String get stations => 'المحطات';

  @override
  String get hubs => 'المراكز';

  @override
  String selected(String name) {
    return 'المحدد: $name';
  }

  @override
  String get map => 'محطاتنا';

  @override
  String get viewLocationsAndRoutes => 'شاهدنا على الخريطة';

  @override
  String get mapView => 'عرض الخريطة';

  @override
  String get listView => 'عرض القائمة';

  @override
  String get switchToListView => 'التبديل إلى عرض القائمة';

  @override
  String get switchToMapView => 'التبديل إلى عرض الخريطة';

  @override
  String get refreshData => 'تحديث البيانات';

  @override
  String get noLocationsAvailable => 'لا توجد مواقع متاحة';

  @override
  String get stationsAndHubsWillAppearHere =>
      'ستظهر المحطات والمراكز هنا بمجرد توفر واجهة برمجة التطبيقات.';

  @override
  String locationsCount(int count) {
    return 'المواقع ($count)';
  }

  @override
  String get finance => 'المالية';

  @override
  String get viewFinance => 'المالية';

  @override
  String get viewFinanceSubtitle => 'عرض رصيد الحساب والمعاملات';

  @override
  String get accountBalance => 'رصيد الحساب';

  @override
  String get totalCod => 'إجمالي الدفع عند الاستلام';

  @override
  String get totalFees => 'إجمالي الرسوم';

  @override
  String get totalSettlements => 'إجمالي التسويات';

  @override
  String get currentBalance => 'الرصيد الحالي';

  @override
  String get transactionHistory => 'تاريخ المعاملات';

  @override
  String get loadingFinanceData => 'جاري تحميل البيانات المالية...';

  @override
  String get errorLoadingFinance => 'خطأ في تحميل البيانات المالية';

  @override
  String get noFinanceData => 'لا توجد بيانات مالية';

  @override
  String get noTransactionsYet => 'لا توجد معاملات حتى الآن';

  @override
  String get transactionsWillAppearHere =>
      'ستظهر سجل معاملاتك هنا بمجرد بدء إجراء المعاملات.';

  @override
  String get transactionType => 'النوع';

  @override
  String get transactionReference => 'المرجع';

  @override
  String get transactionDescription => 'الوصف';

  @override
  String get transactionAmount => 'المبلغ';

  @override
  String get transactionDate => 'التاريخ';

  @override
  String get codTransaction => 'الدفع عند الاستلام';

  @override
  String get feeTransaction => 'الرسوم';

  @override
  String get settlementTransaction => 'التسوية';

  @override
  String get credit => 'ائتمان';

  @override
  String get debit => 'خصم';

  @override
  String get loadMoreTransactions => 'تحميل المزيد من المعاملات';

  @override
  String get noMoreTransactions => 'لا توجد معاملات أخرى للتحميل';

  @override
  String get financeSummary => 'ملخص المالية';

  @override
  String get totalTransactions => 'إجمالي المعاملات';

  @override
  String showingTransactionsCount(int shown, int total) {
    return 'عرض $shown من $total معاملة';
  }

  @override
  String get refreshFinanceData => 'تحديث البيانات المالية';

  @override
  String get exportToExcel => 'تصدير إلى Excel';

  @override
  String get exportingToExcel => 'جاري التصدير إلى Excel...';

  @override
  String get excelExportSuccess => 'تم تصدير ملف Excel بنجاح!';

  @override
  String get excelExportFailed => 'فشل في تصدير ملف Excel';

  @override
  String get exportToPdf => 'تصدير إلى PDF';

  @override
  String get exportingToPdf => 'جاري التصدير إلى PDF...';

  @override
  String get pdfExportSuccess => 'تم تصدير ملف PDF بنجاح!';

  @override
  String get pdfExportFailed => 'فشل في تصدير ملف PDF';

  @override
  String get welcomeToParcelExpress => 'مرحباً بك في ParcelExpress';

  @override
  String get permissionRequestSubtitle =>
      'لتوفير أفضل تجربة لك، نحتاج إلى بعض الأذونات';

  @override
  String get weNeedThesePermissions => 'نحتاج هذه الأذونات:';

  @override
  String get grantPermissions => 'منح الأذونات';

  @override
  String get skipForNow => 'تخطي الآن';

  @override
  String get continueButton => 'متابعة';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get continueAnyway => 'متابعة على أي حال';

  @override
  String get allPermissionsGranted => 'تم منح جميع الأذونات!';

  @override
  String permissionsPartiallyGranted(int granted, int total) {
    return '$granted من $total أذونات تم منحها';
  }

  @override
  String get permissionsDeniedMessage =>
      'تم رفض بعض الأذونات. يمكنك تفعيلها لاحقاً في الإعدادات.';

  @override
  String get whyDoWeNeedPermissions => 'لماذا نحتاج هذه الأذونات؟';

  @override
  String get permissionBenefits =>
      '• تصدير بياناتك المالية إلى PDF و Excel\n• مسح رموز QR لتتبع الطرود\n• إرسال إشعارات مهمة عن التسليم';

  @override
  String get permissionsRequiredMessage =>
      'بعض الأذونات مطلوبة للوظائف الكاملة';

  @override
  String requestingPermission(String permission) {
    return 'طلب $permission...';
  }

  @override
  String excelFileSaved(String filePath) {
    return 'تم حفظ ملف Excel في: $filePath';
  }

  @override
  String get openExcelFile => 'فتح ملف Excel';

  @override
  String get excelExportError => 'خطأ تصدير Excel';

  @override
  String get exportedOn => 'تم التصدير في';

  @override
  String get requestSettlement => 'طلب تسوية';

  @override
  String get settlementRequest => 'طلب التسوية';

  @override
  String get settlementRequestDescription => 'اطلب تسوية لرصيد حسابك';

  @override
  String get enterSettlementAmount => 'أدخل مبلغ التسوية';

  @override
  String get settlementAmountHint => '0.00';

  @override
  String get settlementNotesHint => 'ملاحظات اختيارية لطلب التسوية هذا';

  @override
  String get submitSettlementRequest => 'إرسال طلب التسوية';

  @override
  String get submittingSettlementRequest => 'جاري إرسال طلب التسوية...';

  @override
  String get settlementRequestSubmitted => 'تم إرسال طلب التسوية بنجاح!';

  @override
  String get settlementRequestFailed => 'فشل في إرسال طلب التسوية';

  @override
  String get pleaseEnterSettlementAmount => 'يرجى إدخال مبلغ التسوية';

  @override
  String get pleaseEnterValidSettlementAmount => 'يرجى إدخال مبلغ تسوية صحيح';

  @override
  String get settlementAmountMustBeGreaterThanZero =>
      'يجب أن يكون مبلغ التسوية أكبر من 0';

  @override
  String get filterDescription => 'قم بتصفية معاملاتك حسب النطاق الزمني والنوع';

  @override
  String get confirmExportPdf =>
      'هل أنت متأكد من تصدير بياناتك المالية كملف PDF؟';

  @override
  String get storagePermissionRequired =>
      'مطلوب إذن التخزين لحفظ الملفات. يرجى منح الإذن في إعدادات التطبيق.';

  @override
  String get unableToAccessStorage =>
      'غير قادر على الوصول للتخزين. يرجى التحقق من تخزين الجهاز والمحاولة مرة أخرى.';

  @override
  String get manuallyEnablePermission =>
      'يرجى تمكين إذن التخزين يدوياً في إعدادات التطبيق';

  @override
  String get fileSavedToDownloads => 'تم حفظ الملف في مجلد التحميلات';

  @override
  String get checkFileManager => 'تحقق من مدير الملفات';

  @override
  String get noFilters => 'لا توجد مرشحات';

  @override
  String get from => 'من';

  @override
  String get to => 'إلى';

  @override
  String get exitApp => 'إغلاق التطبيق';

  @override
  String get exitAppConfirmation => 'هل أنت متأكد من أنك تريد إغلاق التطبيق؟';

  @override
  String get exit => 'إغلاق';

  @override
  String get stay => 'البقاء';

  @override
  String get settlementAmountExceedsBalance =>
      'المبلغ المطلوب يتجاوز رصيدك الحالي. يرجى إدخال مبلغ أصغر.';

  @override
  String get insufficientBalance => 'رصيد غير كافٍ. يرجى التحقق من رصيد حسابك.';

  @override
  String get invalidSettlementAmount =>
      'مبلغ تسوية غير صحيح. يرجى إدخال مبلغ صحيح.';

  @override
  String get settlementRequestAlreadyExists =>
      'طلب تسوية موجود بالفعل. يرجى الانتظار حتى يتم معالجته.';

  @override
  String get minimumSettlementAmount =>
      'مبلغ التسوية أقل من الحد الأدنى المطلوب.';

  @override
  String get maximumSettlementAmount =>
      'مبلغ التسوية يتجاوز الحد الأقصى المسموح به.';

  @override
  String get accountNotFound => 'الحساب غير موجود. يرجى التواصل مع الدعم.';

  @override
  String get sessionExpired =>
      'انتهت صلاحية جلستك. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get accessDenied =>
      'الوصول مرفوض. ليس لديك صلاحية لتنفيذ هذا الإجراء.';

  @override
  String get resourceNotFound => 'المورد المطلوب غير موجود.';

  @override
  String get validationFailed =>
      'فشل التحقق. يرجى التحقق من المدخلات والمحاولة مرة أخرى.';

  @override
  String get serviceUnavailable =>
      'الخدمة غير متاحة مؤقتاً. يرجى المحاولة مرة أخرى لاحقاً.';

  @override
  String get tooManyRequests =>
      'طلبات كثيرة جداً. يرجى الانتظار قليلاً والمحاولة مرة أخرى.';

  @override
  String get paymentRequired => 'مطلوب دفع للوصول إلى هذه الميزة.';

  @override
  String get resourceConflict =>
      'المورد موجود بالفعل أو يتعارض مع البيانات الموجودة.';

  @override
  String get preconditionFailed => 'فشل الشرط المسبق. يرجى المحاولة مرة أخرى.';

  @override
  String get requestTooLarge => 'الطلب كبير جداً. يرجى تقليل حجم البيانات.';

  @override
  String get unsupportedMediaType =>
      'نوع الوسائط غير مدعوم. يرجى التحقق من تنسيق الملف.';

  @override
  String get unprocessableEntity =>
      'لا يمكن معالجة الطلب. يرجى التحقق من المدخلات.';

  @override
  String get resourceLocked => 'المورد مقفل ولا يمكن تعديله.';

  @override
  String get failedDependency => 'فشل الطلب بسبب مشكلة في التبعية.';

  @override
  String get upgradeRequired => 'مطلوب ترقية للوصول إلى هذه الميزة.';

  @override
  String get preconditionRequired => 'مطلوب شرط مسبق لهذا الطلب.';

  @override
  String get tooManyConnections =>
      'اتصالات كثيرة جداً. يرجى المحاولة مرة أخرى لاحقاً.';

  @override
  String get unavailableForLegalReasons =>
      'هذه الخدمة غير متاحة لأسباب قانونية.';

  @override
  String get badRequest =>
      'طلب غير صحيح. يرجى التحقق من المدخلات والمحاولة مرة أخرى.';

  @override
  String get unauthorized => 'وصول غير مصرح به. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get forbidden => 'الوصول محظور. ليس لديك صلاحية.';

  @override
  String get notFound => 'المورد المطلوب غير موجود.';

  @override
  String get methodNotAllowed => 'هذه الطريقة غير مسموحة لهذا المورد.';

  @override
  String get notAcceptable => 'الطلب غير مقبول.';

  @override
  String get gone => 'المورد لم يعد متاحاً.';

  @override
  String get lengthRequired => 'طول المحتوى مطلوب لهذا الطلب.';

  @override
  String get payloadTooLarge => 'حمولة الطلب كبيرة جداً.';

  @override
  String get uriTooLong => 'رابط الطلب طويل جداً.';

  @override
  String get rangeNotSatisfiable => 'النطاق المطلوب غير قابل للتحقق.';

  @override
  String get expectationFailed => 'لا يمكن تلبية التوقع.';

  @override
  String get imATeapot => 'أنا إبريق شاي. هذا خطأ مزاح.';

  @override
  String get misdirectedRequest => 'الطلب كان في الاتجاه الخطأ.';

  @override
  String get locked => 'المورد مقفل.';

  @override
  String get tooEarly => 'الطلب تم في وقت مبكر جداً.';

  @override
  String get requestHeaderFieldsTooLarge => 'حقول رأس الطلب كبيرة جداً.';

  @override
  String get internalServerError =>
      'خطأ داخلي في الخادم. يرجى المحاولة مرة أخرى لاحقاً.';

  @override
  String get notImplemented => 'هذه الميزة غير مطبقة بعد.';

  @override
  String get badGateway => 'بوابة سيئة. يرجى المحاولة مرة أخرى لاحقاً.';

  @override
  String get gatewayTimeout =>
      'انتهت مهلة البوابة. يرجى المحاولة مرة أخرى لاحقاً.';

  @override
  String get httpVersionNotSupported => 'إصدار HTTP غير مدعوم.';

  @override
  String get variantAlsoNegotiates => 'خطأ المتغير يتفاوض أيضاً.';

  @override
  String get insufficientStorage => 'تخزين غير كافٍ على الخادم.';

  @override
  String get loopDetected => 'تم اكتشاف حلقة لا نهائية.';

  @override
  String get notExtended => 'خطأ غير ممدد.';

  @override
  String get networkAuthenticationRequired => 'مطلوب مصادقة الشبكة.';

  @override
  String get invalidAmount => 'مبلغ غير صحيح. يرجى إدخال رقم صحيح.';

  @override
  String get invalidEmail =>
      'عنوان بريد إلكتروني غير صحيح. يرجى إدخال بريد صحيح.';

  @override
  String get invalidPhone => 'رقم هاتف غير صحيح. يرجى إدخال رقم هاتف صحيح.';

  @override
  String get invalidPassword =>
      'كلمة مرور غير صحيحة. يرجى التحقق من كلمة المرور.';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب. يرجى ملؤه.';

  @override
  String get badResponse => 'استجابة سيئة من الخادم. يرجى المحاولة مرة أخرى.';

  @override
  String get connectionTimeout =>
      'انتهت مهلة الاتصال. يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get sendTimeout => 'انتهت مهلة الإرسال. يرجى المحاولة مرة أخرى.';

  @override
  String get receiveTimeout => 'انتهت مهلة الاستقبال. يرجى المحاولة مرة أخرى.';

  @override
  String get requestCancelled => 'تم إلغاء الطلب.';

  @override
  String get unknownError => 'حدث خطأ غير معروف. يرجى المحاولة مرة أخرى.';

  @override
  String get formProgress => 'تقدم النموذج';

  @override
  String get estimatedTime => '2-3 دقائق';

  @override
  String get station => 'محطة';

  @override
  String get hub => 'مركز';

  @override
  String get noStationsAvailable => 'لا توجد محطات متاحة';

  @override
  String get noHubsAvailable => 'لا توجد مراكز متاحة';

  @override
  String get stationsWillAppearHere =>
      'ستظهر المحطات هنا بمجرد توفر واجهة برمجة التطبيقات.';

  @override
  String get hubsWillAppearHere =>
      'ستظهر المراكز هنا بمجرد توفر واجهة برمجة التطبيقات.';

  @override
  String get tapToViewOnMap => 'اضغط لعرض على الخريطة';

  @override
  String get tapToView => 'اضغط للعرض';

  @override
  String get showAllLocations => 'عرض جميع المواقع';

  @override
  String stationsAndHubsCount(int stations, int hubs) {
    return '$stations محطات • $hubs مراكز';
  }

  @override
  String get dangerZone => 'منطقة الخطر';

  @override
  String get dangerZoneWarning =>
      'هذا الإجراء دائم ولا يمكن التراجع عنه. يرجى المتابعة بحذر.';

  @override
  String get thisWill => 'سيؤدي هذا إلى:';

  @override
  String get permanentlyDeleteData => 'حذف جميع بياناتك نهائياً';

  @override
  String get removeOrdersHistory => 'إزالة جميع طلباتك وسجل عملك';

  @override
  String get cancelPendingTransactions => 'إلغاء أي معاملات معلقة';

  @override
  String get cannotBeReversed => 'لا يمكن التراجع عنه أو إلغاؤه';

  @override
  String get understandConsequences => 'يرجى التأكد من فهمك للعواقب.';

  @override
  String get continueAction => 'متابعة';

  @override
  String get areYouAbsolutelySure => 'هل أنت متأكد تماماً؟';

  @override
  String get lastChanceWarning =>
      'هذه فرصتك الأخيرة للإلغاء. بمجرد الحذف، لا يمكن استرداد حسابك.';

  @override
  String get keepMyAccount => 'الاحتفاظ بحسابي';

  @override
  String get warningLabel => '⚠️ تحذير';

  @override
  String get switchToArabic => 'التبديل إلى العربية';

  @override
  String get switchToEnglish => 'Switch to English';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get arabicCode => 'AR';

  @override
  String get englishCode => 'EN';
}
