import 'package:client_app/l10n/app_localizations.dart';

extension AppLocalizationsExtras on AppLocalizations {
  String get noAddressesYet =>
      localeName.startsWith('ar') ? 'لا توجد عناوين بعد' : 'No Addresses Yet';

  String get addYourFirstAddressHint =>
      localeName.startsWith('ar')
          ? 'أضف عنوانك الأول لتسهيل إنشاء الطلب'
          : 'Add your first address to make\norder creation easier';

  String get deleteAddress =>
      localeName.startsWith('ar') ? 'حذف العنوان' : 'Delete Address';

  String deleteAddressConfirmation(String name) =>
      localeName.startsWith('ar')
          ? 'هل أنت متأكد من حذف العنوان "$name"؟'
          : 'Are you sure you want to delete "$name" address?';
}
