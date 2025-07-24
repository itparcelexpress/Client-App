# Localization Usage Guide

## Overview
The app now supports full Arabic localization using Flutter's internationalization (intl) package. The app supports both English and Arabic languages with proper RTL (Right-to-Left) layout for Arabic.

## How to Use Localizations in Your Code

### Import the Localization Class
```dart
import 'package:client_app/l10n/app_localizations.dart';
```

### Access Localized Strings
```dart
// Get the localization instance
final localizations = AppLocalizations.of(context)!;

// Use localized strings
Text(localizations.appTitle), // "Parcel Express" in English, "باسيل إكسبريس" in Arabic
Text(localizations.welcomeMessage), // "Welcome back! Please sign in to continue."
Text(localizations.login), // "Login" / "تسجيل الدخول"
```

### Example: Updating Login Page
```dart
// Before (hardcoded):
Text('Parcel Express')

// After (localized):
Text(AppLocalizations.of(context)!.appTitle)

// Before:
Text('Welcome back! Please sign in to continue.')

// After:
Text(AppLocalizations.of(context)!.welcomeMessage)
```

### Example: Form Fields
```dart
TextFormField(
  decoration: InputDecoration(
    labelText: AppLocalizations.of(context)!.email,
    hintText: AppLocalizations.of(context)!.emailAddress,
  ),
)

TextFormField(
  decoration: InputDecoration(
    labelText: AppLocalizations.of(context)!.password,
  ),
)
```

### Example: Validation Messages
```dart
validator: (value) {
  if (value?.isEmpty == true) {
    return AppLocalizations.of(context)!.emailRequired;
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
    return AppLocalizations.of(context)!.validEmailRequired;
  }
  return null;
}
```

### Example: Dynamic Messages with Parameters
```dart
// For messages with parameters like usernames
Text(AppLocalizations.of(context)!.helloUser(userName))
// This will show: "Hello, John! 👋" in English or "مرحباً، John! 👋" in Arabic
```

## Language Switching

### Programmatic Language Change
```dart
// To change language programmatically, you would typically use a state management solution
// and rebuild the MaterialApp with the new locale:

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en'); // Default to English
  
  void _changeLanguage(String languageCode) {
    setState(() {
      _locale = Locale(languageCode);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // ... rest of your app
    );
  }
}
```

## Available Localized Strings

### App General
- `appTitle`: "Parcel Express" / "باسيل إكسبريس"
- `welcomeMessage`: Welcome message
- `tagline`: App tagline
- `loading`: "Loading..." / "جاري التحميل..."

### Authentication
- `login`: "Login" / "تسجيل الدخول"
- `logout`: "Logout" / "تسجيل الخروج"
- `email`: "Email" / "البريد الإلكتروني"
- `password`: "Password" / "كلمة المرور"

### Forms & Fields
- `fullName`: "Full Name" / "الاسم الكامل"
- `phoneNumber`: "Phone Number" / "رقم الهاتف"
- `streetAddress`: "Street Address" / "عنوان الشارع"
- `amount`: "Amount" / "المبلغ"
- `notes`: "Notes" / "ملاحظات"

### Navigation & Sections
- `dashboard`: "Dashboard" / "لوحة التحكم"
- `notifications`: "Notifications" / "الإشعارات"
- `addressBook`: "Address Book" / "دليل العناوين"
- `newOrder`: "New Order" / "طلب جديد"

### Actions
- `save`: "Save" / "حفظ"
- `cancel`: "Cancel" / "إلغاء"
- `delete`: "Delete" / "حذف"
- `edit`: "Edit" / "تعديل"
- `confirm`: "Confirm" / "تأكيد"

### Validation Messages
- `nameRequired`: "Name is required" / "الاسم مطلوب"
- `emailRequired`: "Email is required" / "البريد الإلكتروني مطلوب"
- `phoneRequired`: "Phone number is required" / "رقم الهاتف مطلوب"
- `validEmailRequired`: "Enter a valid email" / "أدخل بريد إلكتروني صحيح"

## RTL Support
The app automatically supports RTL layout for Arabic. When Arabic is selected:
- Text direction becomes right-to-left
- UI elements are mirrored appropriately
- Navigation flows are reversed

## Adding New Strings

### 1. Add to ARB Files
Add new strings to both `lib/l10n/intl_en.arb` and `lib/l10n/intl_ar.arb`:

```json
// intl_en.arb
{
  "newString": "New String in English",
  "@newString": {
    "description": "Description of the new string"
  }
}

// intl_ar.arb
{
  "newString": "النص الجديد بالعربية"
}
```

### 2. Regenerate Localization Files
```bash
flutter gen-l10n
```

### 3. Use in Code
```dart
Text(AppLocalizations.of(context)!.newString)
```

## Configuration Files

### l10n.yaml
```yaml
arb-dir: lib/l10n
template-arb-file: intl_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
preferred-supported-locales: ["en", "ar"]
```

### pubspec.yaml
```yaml
flutter:
  generate: true

dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2
```

## Best Practices

1. **Always use localized strings** instead of hardcoded text
2. **Test with both languages** to ensure UI looks good in both directions
3. **Keep ARB files synchronized** - every English string should have an Arabic translation
4. **Use descriptive keys** for localization strings
5. **Include context in descriptions** to help translators understand usage
6. **Consider text length differences** between languages when designing UI
7. **Test RTL layout** thoroughly to ensure proper alignment and spacing

## Common Issues & Solutions

### Issue: Text Overflow in Arabic
Arabic text can be longer than English. Use flexible widgets:
```dart
Flexible(child: Text(AppLocalizations.of(context)!.longText))
```

### Issue: Icons/Images not mirroring properly
Use Directionality widget for proper RTL behavior:
```dart
Directionality(
  textDirection: Localizations.of(context).textDirection,
  child: yourWidget,
)
```

### Issue: Debugging missing translations
Check if the string exists in both ARB files and regenerate localizations if needed. 