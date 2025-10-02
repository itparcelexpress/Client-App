# Global Error Handling System

This document explains how to use the global error handling system in the ParcelExpress Client App.

## Overview

The global error handling system provides localized, user-friendly error messages for all API errors throughout the app. It supports both English and Arabic languages and handles various types of errors including:

- Settlement request errors
- Network errors
- Authentication errors
- Validation errors
- Server errors
- And many more...

## Components

### 1. GlobalErrorMapper

The main class that maps API errors to localized messages.

**Location:** `lib/core/utilities/global_error_mapper.dart`

**Key Methods:**
- `mapErrorToLocalizedMessage()` - Maps API response errors to localized messages
- `mapDioExceptionToLocalizedMessage()` - Maps DioException errors to localized messages
- `sanitizeAndMapError()` - Sanitizes and maps any error to a localized message

### 2. ErrorHandler

A utility class that provides easy-to-use methods for showing errors.

**Location:** `lib/core/utilities/error_handler.dart`

**Key Methods:**
- `showError()` - Shows error using ToastService
- `showErrorWithMessage()` - Shows error with custom message details
- `showDioError()` - Shows DioException errors
- `getLocalizedErrorMessage()` - Returns localized error message without showing it

## Usage Examples

### 1. In Repository Classes

```dart
import 'package:client_app/core/utilities/global_error_mapper.dart';

class MyRepository {
  Future<MyResponse> fetchData(BuildContext context) async {
    try {
      final response = await AppRequest.get('/api/endpoint');
      
      if (response.success) {
        return MyResponse.fromJson(response.data);
      } else {
        // Use global error mapper for API errors
        final localizedMessage = GlobalErrorMapper.mapErrorToLocalizedMessage(
          message: response.message,
          errors: response.origin?['errors'] as List<String>?,
          data: response.origin?['data'] as Map<String, dynamic>?,
          statusCode: response.statusCode,
          context: context,
        );
        
        throw Exception(localizedMessage);
      }
    } catch (e) {
      // Use global error mapper for any other errors
      final localizedMessage = GlobalErrorMapper.sanitizeAndMapError(
        error: e,
        context: context,
      );
      
      throw Exception(localizedMessage);
    }
  }
}
```

### 2. In Cubit/Bloc Classes

```dart
import 'package:client_app/core/utilities/error_handler.dart';

class MyCubit extends Cubit<MyState> {
  Future<void> performAction(BuildContext context) async {
    try {
      emit(MyLoadingState());
      
      final result = await _repository.performAction(context);
      
      emit(MySuccessState(result));
    } catch (e) {
      // Show error using ErrorHandler
      ErrorHandler.showError(context, e);
      emit(MyErrorState());
    }
  }
}
```

### 3. In UI Classes

```dart
import 'package:client_app/core/utilities/error_handler.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCubit, MyState>(
      listener: (context, state) {
        if (state is MyErrorState) {
          // Error is already handled in the cubit using ErrorHandler
          // No need to show error here again
        }
      },
      builder: (context, state) {
        // Build UI
      },
    );
  }
}
```

## Error Message Localization

All error messages are stored in the localization files:

- **English:** `lib/l10n/intl_en.arb`
- **Arabic:** `lib/l10n/intl_ar.arb`

### Adding New Error Messages

1. Add the error key to both `intl_en.arb` and `intl_ar.arb`
2. Add the corresponding method to `AppLocalizations` (auto-generated)
3. Add the error mapping logic to `GlobalErrorMapper`

Example:

**intl_en.arb:**
```json
{
  "myCustomError": "This is a custom error message.",
  "@myCustomError": {"description": "Custom error message"}
}
```

**intl_ar.arb:**
```json
{
  "myCustomError": "هذه رسالة خطأ مخصصة.",
  "@myCustomError": {"description": "رسالة خطأ مخصصة"}
}
```

**GlobalErrorMapper:**
```dart
if (msg.contains('my custom error')) {
  return localizations.myCustomError;
}
```

## Supported Error Types

### Settlement Request Errors
- `settlementAmountExceedsBalance` - Amount exceeds current balance
- `insufficientBalance` - Insufficient balance
- `invalidSettlementAmount` - Invalid settlement amount
- `settlementRequestAlreadyExists` - Settlement request already exists
- `minimumSettlementAmount` - Below minimum amount
- `maximumSettlementAmount` - Above maximum amount

### HTTP Status Code Errors
- 400 - Bad Request
- 401 - Unauthorized
- 403 - Forbidden
- 404 - Not Found
- 422 - Unprocessable Entity
- 500 - Internal Server Error
- And many more...

### Network Errors
- Connection timeout
- Send timeout
- Receive timeout
- Connection error
- Network error

### Validation Errors
- Invalid email
- Invalid phone
- Invalid password
- Field required
- Invalid amount

## Best Practices

1. **Always pass BuildContext** - The error mapper needs context for localization
2. **Use ErrorHandler for UI** - Use ErrorHandler.showError() for displaying errors
3. **Handle errors in Cubit/Bloc** - Don't show errors directly in UI widgets
4. **Provide meaningful fallbacks** - Always have a fallback error message
5. **Test both languages** - Ensure error messages work in both English and Arabic

## Migration Guide

To migrate existing error handling to use the global error mapper:

1. **Replace ErrorMessageSanitizer** with `GlobalErrorMapper`
2. **Add BuildContext parameter** to repository methods
3. **Update Cubit/Bloc calls** to pass context
4. **Replace manual error messages** with localized ones
5. **Test error scenarios** in both languages

## Example Migration

**Before:**
```dart
throw Exception(ErrorMessageSanitizer.sanitize('Error message'));
```

**After:**
```dart
throw Exception(GlobalErrorMapper.sanitizeAndMapError(
  error: e,
  context: context,
));
```

This ensures all error messages are properly localized and user-friendly across the entire application.
