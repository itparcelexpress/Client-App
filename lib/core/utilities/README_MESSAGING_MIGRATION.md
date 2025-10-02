# SnackBar to Modern Messaging System Migration Guide

This guide explains how to migrate from the old SnackBar system to the new modern messaging system in the ParcelExpress Client App.

## 🚀 **Why Migrate?**

### **Problems with SnackBars:**
- ❌ **Poor UX**: SnackBars appear at the bottom and can be easily missed
- ❌ **Inconsistent styling**: Different SnackBar implementations across the app
- ❌ **Limited customization**: Hard to customize appearance and behavior
- ❌ **No animations**: Basic slide-in animation only
- ❌ **Accessibility issues**: Poor screen reader support
- ❌ **Overlay conflicts**: Can be covered by other UI elements

### **Benefits of New Messaging System:**
- ✅ **Better UX**: Toast notifications appear in better positions
- ✅ **Consistent design**: Unified styling across the entire app
- ✅ **Rich animations**: Smooth slide and fade animations
- ✅ **Better accessibility**: Proper screen reader support
- ✅ **Multiple types**: Toast, Banner, Dialog, and Modal options
- ✅ **Action buttons**: Support for action buttons in notifications
- ✅ **Auto-dismiss**: Smart auto-dismiss with manual dismiss option
- ✅ **Overlay system**: Proper overlay management

## 📋 **Migration Checklist**

### **Step 1: Add Import**
```dart
import 'package:client_app/core/services/messaging_service.dart';
```

### **Step 2: Replace SnackBar Calls**

#### **Success Messages**
```dart
// ❌ OLD WAY
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Success message'),
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);

// ✅ NEW WAY
MessagingService.showSuccessToast(context, 'Success message');
```

#### **Error Messages**
```dart
// ❌ OLD WAY
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Error message'),
    backgroundColor: Colors.red,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);

// ✅ NEW WAY
MessagingService.showErrorToast(context, 'Error message');
```

#### **Warning Messages**
```dart
// ❌ OLD WAY
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Warning message'),
    backgroundColor: Colors.orange,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);

// ✅ NEW WAY
MessagingService.showWarningToast(context, 'Warning message');
```

#### **Info Messages**
```dart
// ❌ OLD WAY
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Info message'),
    backgroundColor: Colors.blue,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);

// ✅ NEW WAY
MessagingService.showInfoToast(context, 'Info message');
```

### **Step 3: Handle Action Buttons**

#### **With Action Button**
```dart
// ❌ OLD WAY
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('File saved successfully'),
    backgroundColor: Colors.green,
    action: SnackBarAction(
      label: 'Open',
      textColor: Colors.white,
      onPressed: () {
        // Open file
      },
    ),
  ),
);

// ✅ NEW WAY
MessagingService.showSuccessToast(
  context,
  'File saved successfully',
  actionLabel: 'Open',
  onActionTap: () {
    // Open file
  },
);
```

### **Step 4: Use Banner Notifications for Important Messages**

#### **Success Banner**
```dart
MessagingService.showSuccessBanner(context, 'Important success message');
```

#### **Error Banner**
```dart
MessagingService.showErrorBanner(context, 'Critical error message');
```

#### **Warning Banner**
```dart
MessagingService.showWarningBanner(context, 'Important warning message');
```

#### **Info Banner**
```dart
MessagingService.showInfoBanner(context, 'Important info message');
```

## 🎨 **Available Messaging Types**

### **Toast Notifications** (Bottom of screen)
- `MessagingService.showSuccessToast()`
- `MessagingService.showErrorToast()`
- `MessagingService.showWarningToast()`
- `MessagingService.showInfoToast()`

### **Banner Notifications** (Top of screen)
- `MessagingService.showSuccessBanner()`
- `MessagingService.showErrorBanner()`
- `MessagingService.showWarningBanner()`
- `MessagingService.showInfoBanner()`

### **Dialog Notifications** (Modal)
- `MessagingService.showConfirmationDialog()`
- `MessagingService.showLoadingDialog()`
- `MessagingService.hideLoadingDialog()`

### **Custom Modals**
- `MessagingService.showCustomBottomSheet()`

## 🔧 **Advanced Usage**

### **Custom Toast with Duration**
```dart
MessagingService.showToast(
  context,
  message: 'Custom message',
  type: ToastType.success,
  duration: Duration(seconds: 5),
  actionLabel: 'Action',
  onActionTap: () {
    // Handle action
  },
);
```

### **Custom Banner with Duration**
```dart
MessagingService.showBanner(
  context,
  message: 'Important message',
  type: ToastType.warning,
  duration: Duration(seconds: 10),
  actionLabel: 'Dismiss',
  onActionTap: () {
    // Handle action
  },
);
```

### **Confirmation Dialog**
```dart
final result = await MessagingService.showConfirmationDialog(
  context,
  title: 'Confirm Action',
  message: 'Are you sure you want to proceed?',
  confirmText: 'Yes',
  cancelText: 'No',
  type: ToastType.warning,
);

if (result == true) {
  // User confirmed
}
```

### **Loading Dialog**
```dart
// Show loading
MessagingService.showLoadingDialog(context, message: 'Processing...');

// Hide loading
MessagingService.hideLoadingDialog(context);
```

## 📱 **Migration Examples by File**

### **Finance Page**
```dart
// Before
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(state.message),
    backgroundColor: Colors.green,
  ),
);

// After
MessagingService.showSuccessToast(context, state.message);
```

### **Address Book Page**
```dart
// Before
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(state.message),
    backgroundColor: Colors.red,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);

// After
MessagingService.showErrorToast(context, state.message);
```

### **Settings Page**
```dart
// Before
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Settings saved successfully'),
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);

// After
MessagingService.showSuccessToast(context, 'Settings saved successfully');
```

## 🎯 **Best Practices**

### **1. Choose the Right Type**
- **Toast**: For quick feedback (success, error, info)
- **Banner**: For important messages that need attention
- **Dialog**: For critical decisions or confirmations

### **2. Use Appropriate Colors**
- **Success**: Green (for successful operations)
- **Error**: Red (for errors and failures)
- **Warning**: Orange (for warnings and cautions)
- **Info**: Blue (for informational messages)

### **3. Keep Messages Concise**
- Keep messages short and clear
- Use action buttons for complex operations
- Provide context when needed

### **4. Handle Actions Properly**
- Always provide feedback for actions
- Use loading states for async operations
- Handle errors gracefully

### **5. Test Both Languages**
- Ensure messages work in both English and Arabic
- Test RTL layout for Arabic messages
- Verify proper text alignment

## 🔍 **Finding SnackBars to Replace**

Use this command to find all SnackBar usage:
```bash
grep -r "ScaffoldMessenger.of(context).showSnackBar" lib/
```

Or use this regex pattern in your IDE:
```
ScaffoldMessenger\.of\(context\)\.showSnackBar
```

## ✅ **Verification Checklist**

After migration, verify:
- [ ] All SnackBar calls replaced with MessagingService
- [ ] Import statements added
- [ ] Messages display correctly
- [ ] Animations work smoothly
- [ ] Action buttons function properly
- [ ] Auto-dismiss works as expected
- [ ] Both English and Arabic work
- [ ] No console errors
- [ ] UI looks consistent

## 🚨 **Common Issues**

### **Issue 1: Missing Import**
**Error**: `MessagingService` not found
**Solution**: Add `import 'package:client_app/core/services/messaging_service.dart';`

### **Issue 2: Context Issues**
**Error**: Context not available
**Solution**: Ensure you're calling from a widget with BuildContext

### **Issue 3: Animation Issues**
**Error**: Animations not working
**Solution**: Ensure `animate_do` package is properly imported

### **Issue 4: Localization Issues**
**Error**: Messages not localized
**Solution**: Use the existing ToastService methods for localized messages

## 📊 **Migration Progress**

### **Completed Files:**
- ✅ `lib/features/finance/presentation/pages/finance_page.dart`
- ✅ `lib/features/address_book/presentation/pages/address_book_page.dart`
- ✅ `lib/features/profile/presentation/pages/notification_settings_page.dart`

### **Remaining Files:**
- ⏳ `lib/features/auth/presentation/pages/home_page.dart`
- ⏳ `lib/features/notifications/presentation/pages/notifications_page.dart`
- ⏳ `lib/features/invoices/presentation/pages/invoice_detail_page.dart`
- ⏳ `lib/features/map/presentation/pages/locations_list_page.dart`

## 🎉 **Benefits After Migration**

1. **Consistent UX**: All messages look and behave the same
2. **Better Performance**: Overlay system is more efficient
3. **Easier Maintenance**: Centralized messaging logic
4. **Better Accessibility**: Proper screen reader support
5. **Modern Design**: Beautiful animations and styling
6. **Flexible Options**: Multiple message types for different use cases

The new messaging system provides a much better user experience and is easier to maintain. All SnackBar usage should be migrated to use the new MessagingService for consistency and better UX.
