# Localization Guide - Toast Messages & User Feedback

## Overview

This guide explains how to use the comprehensive localization system for toast messages and user feedback throughout the Parcel Express app. The system supports both English and Arabic languages with proper RTL (Right-to-Left) layout.

## 🎯 Localized Toast Service

### Basic Usage

The app now includes a `ToastService` class that provides localized toast messages. Here's how to use it:

```dart
import 'package:client_app/core/utilities/taost_service.dart';

// Show success message
ToastService.showSuccess(context, 'orderCreatedSuccessfully');

// Show error message
ToastService.showError(context, 'orderCreationFailed');

// Show info message
ToastService.showInfo(context, 'dataLoadedSuccessfully');

// Show warning message
ToastService.showWarning(context, 'validationError');
```

### Available Toast Methods

- `ToastService.showSuccess(context, messageKey)` - Green toast with ✅ icon
- `ToastService.showError(context, messageKey)` - Red toast with ❌ icon
- `ToastService.showInfo(context, messageKey)` - Blue toast with ℹ️ icon
- `ToastService.showWarning(context, messageKey)` - Orange toast with ⚠️ icon

### Available Message Keys

#### Order Operations
- `orderCreatedSuccessfully` - "Order created successfully!"
- `orderCreationFailed` - "Failed to create order. Please try again."

#### Address Book Operations
- `addressSavedSuccessfully` - "Address saved successfully!"
- `addressSaveFailed` - "Failed to save address. Please try again."
- `addressDeletedSuccessfully` - "Address deleted successfully!"
- `addressDeleteFailed` - "Failed to delete address. Please try again."
- `addressUpdatedSuccessfully` - "Address updated successfully!"
- `addressUpdateFailed` - "Failed to update address. Please try again."

#### Authentication Operations
- `loginSuccessfully` - "Logged in successfully!"
- `loginFailed` - "Login failed. Please check your credentials."
- `logoutSuccessfully` - "Logged out successfully!"
- `logoutFailed` - "Failed to logout. Please try again."

#### Settings Operations
- `settingsSavedSuccessfully` - "Settings saved successfully!"
- `settingsSaveFailed` - "Failed to save settings. Please try again."

#### File Operations
- `fileDownloadedSuccessfully` - "File downloaded successfully!"
- `fileDownloadFailed` - "Failed to download file. Please try again."
- `copyToClipboardSuccess` - "Copied to clipboard!"
- `copyToClipboardFailed` - "Failed to copy to clipboard."

#### Data Operations
- `dataLoadedSuccessfully` - "Data loaded successfully!"
- `dataLoadFailed` - "Failed to load data. Please try again."

#### Generic Operations
- `operationSuccess` - "Operation completed successfully!"
- `operationFailed` - "Operation failed. Please try again."
- `networkError` - "Network error. Please check your connection."
- `serverError` - "Server error. Please try again later."
- `validationError` - "Please check your input and try again."

#### Language Operations
- `languageChangedToArabic` - "تم تغيير اللغة إلى العربية"
- `languageChangedToEnglish` - "Language changed to English"

## 🔄 Migration from Hardcoded Messages

### Before (Hardcoded)
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Order created successfully!'),
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);
```

### After (Localized)
```dart
ToastService.showSuccess(context, 'orderCreatedSuccessfully');
```

### Before (Fluttertoast)
```dart
Fluttertoast.showToast(
  msg: 'Order created successfully!',
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.TOP,
  backgroundColor: const Color(0xFFef4444),
  textColor: Colors.white,
  fontSize: 16.0,
);
```

### After (Localized)
```dart
ToastService.showSuccess(context, 'orderCreatedSuccessfully');
```

## 📱 Implementation Examples

### 1. Order Creation Success
```dart
// In create_order_page.dart
if (state is OrderCreatedSuccess) {
  ToastService.showSuccess(context, 'orderCreatedSuccessfully');
  Navigator.pop(context);
}
```

### 2. Order Creation Failure
```dart
// In create_order_page.dart
if (state is OrderCreationFailed) {
  ToastService.showError(context, 'orderCreationFailed');
}
```

### 3. Address Book Operations
```dart
// In add_address_page.dart
if (state is AddressBookEntryCreated) {
  ToastService.showSuccess(context, 'addressSavedSuccessfully');
  Navigator.pop(context);
} else if (state is AddressBookCreateError) {
  ToastService.showError(context, 'addressSaveFailed');
}
```

### 4. Authentication Operations
```dart
// In login_page.dart
if (state is AuthSuccess) {
  ToastService.showSuccess(context, 'loginSuccessfully');
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
} else if (state is AuthFailure) {
  ToastService.showError(context, 'loginFailed');
}
```

### 5. Language Change Feedback
```dart
// In home_page.dart
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
```

## 🌐 Adding New Localized Messages

### 1. Add to English ARB File (`lib/l10n/intl_en.arb`)
```json
"newMessageKey": "Your English message here",
"@newMessageKey": {
  "description": "Description of the new message"
}
```

### 2. Add to Arabic ARB File (`lib/l10n/intl_ar.arb`)
```json
"newMessageKey": "رسالتك العربية هنا"
```

### 3. Add to ToastService (`lib/core/utilities/taost_service.dart`)
```dart
case 'newMessageKey':
  return localizations.newMessageKey;
```

### 4. Regenerate Localization Files
```bash
flutter gen-l10n
```

### 5. Use in Your Code
```dart
ToastService.showSuccess(context, 'newMessageKey');
```

## 🎨 Customization

### Custom Toast Duration
```dart
// For longer messages
ToastService.showLocalizedToast(
  context: context,
  messageKey: 'longMessageKey',
  type: ToastType.success,
);
```

### Custom Toast Styling
The toast service uses consistent styling across the app:
- **Success**: Green background with ✅ icon
- **Error**: Red background with ❌ icon
- **Info**: Blue background with ℹ️ icon
- **Warning**: Orange background with ⚠️ icon

## 🔧 Error Handling

The toast service includes built-in error handling:

1. **Fallback to Key**: If a localized message is not found, it falls back to using the message key
2. **Null Safety**: If localizations are not available, it falls back to non-localized toast
3. **Auth Error Suppression**: Automatically suppresses auth-related errors during logout

## 📋 Best Practices

1. **Use Message Keys**: Always use message keys instead of hardcoded strings
2. **Consistent Naming**: Use descriptive, consistent naming for message keys
3. **Context-Aware**: Pass the correct context to ensure proper localization
4. **Error Handling**: Always handle both success and error cases
5. **User Feedback**: Provide immediate feedback for all user actions

## 🚀 Benefits

1. **Consistent UX**: All toast messages have the same look and feel
2. **Internationalization**: Full support for Arabic and English
3. **Maintainability**: Centralized message management
4. **Accessibility**: Proper RTL support for Arabic
5. **Performance**: Efficient message lookup and display

## 📝 Migration Checklist

- [ ] Replace all `ScaffoldMessenger.showSnackBar` calls with `ToastService`
- [ ] Replace all `Fluttertoast.showToast` calls with `ToastService`
- [ ] Add missing localized messages to ARB files
- [ ] Update ToastService with new message keys
- [ ] Test in both English and Arabic
- [ ] Verify RTL layout in Arabic

## 🔍 Testing

### Test in English
```dart
// Set locale to English
MyApp.of(context)?.setLocale(const Locale('en'));
```

### Test in Arabic
```dart
// Set locale to Arabic
MyApp.of(context)?.setLocale(const Locale('ar'));
```

### Test RTL Layout
- Verify toast positioning in Arabic
- Check text alignment
- Ensure proper icon placement

This localization system ensures that all user feedback is properly localized and provides a consistent experience across both English and Arabic users. 