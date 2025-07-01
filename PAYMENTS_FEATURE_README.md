# Payments Feature

This document describes the Payments feature that has been integrated with the existing Invoices feature.

## Overview

The Payments feature provides functionality to:
- View payment summary (COD collected, settled, pending amounts)
- List payment transactions with details
- Filter transactions by type and status
- View detailed transaction information

## API Endpoints

The feature uses two main API endpoints:

### 1. Payment Transactions
- **URL**: `{{url}}/client/payments/transactions`
- **Method**: GET
- **Response**: List of payment transactions

### 2. Payment Summary
- **URL**: `{{url}}/client/payments/summary`
- **Method**: GET
- **Response**: Payment summary with financial data

## Data Models

### PaymentTransaction
```dart
class PaymentTransaction {
  final int id;
  final String trackingNo;
  final String amount;
  final String type; // 'cod', 'card', 'bank'
  final String status; // 'pending', 'completed', 'failed'
  final DateTime createdAt;
  final String customerName;
  final String customerPhone;
}
```

### PaymentSummary
```dart
class PaymentSummary {
  final double codCollected;
  final double settled;
  final double pending;
}
```

## Architecture

The payments feature is integrated into the existing invoices feature structure:

```
lib/features/invoices/
├── cubit/
│   ├── invoice_cubit.dart       # Extended with payment methods
│   └── invoice_state.dart       # Added payment states
├── data/
│   ├── models/
│   │   └── invoice_models.dart  # Added payment models
│   └── repositories/
│       └── invoice_repository.dart # Added payment API methods
└── presentation/
    ├── pages/
    │   └── payments_page.dart   # New payments page
    └── widgets/
        ├── payment_summary_widget.dart      # Payment summary display
        └── payment_transaction_card.dart    # Transaction card widget
```

## Usage

### 1. Navigation to Payments Page
```dart
import 'package:client_app/features/invoices/invoices.dart';

// Navigate to payments page
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const PaymentsPage()),
);
```

### 2. Using Payment Cubit
```dart
// Load payment data
context.read<InvoiceCubit>().loadPaymentData();

// Load only summary
context.read<InvoiceCubit>().loadPaymentSummary();

// Load only transactions
context.read<InvoiceCubit>().loadPaymentTransactions();

// Filter transactions by type
context.read<InvoiceCubit>().filterTransactionsByType('cod');

// Filter transactions by status
context.read<InvoiceCubit>().filterTransactionsByStatus('pending');

// Refresh payment data
context.read<InvoiceCubit>().refreshPaymentData();
```

### 3. Listening to Payment States
```dart
BlocBuilder<InvoiceCubit, InvoiceState>(
  builder: (context, state) {
    if (state is PaymentLoading) {
      return const CircularProgressIndicator();
    } else if (state is PaymentCombinedLoaded) {
      return Column(
        children: [
          PaymentSummaryWidget(summary: state.summary),
          // Display transactions list
        ],
      );
    } else if (state is PaymentError) {
      return Text('Error: ${state.message}');
    }
    return const SizedBox();
  },
);
```

## Features

### Payment Summary Widget
- Displays COD collected, settled, and pending amounts
- Shows total balance calculation
- Color-coded cards for different payment types

### Payment Transaction Card
- Shows transaction details (tracking number, amount, type, status)
- Customer information (name, phone)
- Creation date and time
- Status indicator with color coding
- Tap to view detailed information

### Filtering
- Filter by payment type: COD, Card, Bank
- Filter by status: Pending, Completed, Failed
- Clear filters to show all transactions

### Pull-to-Refresh
- Swipe down to refresh payment data
- Automatic loading indicators

## Integration with Existing Features

The payments feature is seamlessly integrated with the existing invoices feature:

1. **Shared Cubit**: Uses the same `InvoiceCubit` for state management
2. **Shared Repository**: Payment methods added to `InvoiceRepository`
3. **Consistent UI**: Follows the same design patterns as invoices
4. **Unified Export**: All payment components exported through `invoices.dart`

## Error Handling

- Network errors with retry functionality
- Empty state handling when no transactions exist
- Loading states during API calls
- Error messages for failed requests

## Styling

The feature follows the app's design system:
- Uses `AppColors.primaryColor` for consistent theming
- Responsive design with proper spacing
- Material Design components
- Proper text styling hierarchy

## Dependencies

No additional dependencies were added. The feature uses existing packages:
- `flutter_bloc` for state management
- `json_annotation` for JSON serialization
- `intl` for date formatting
- Material Design widgets for UI

## Testing

To test the payments feature:

1. Ensure the API endpoints are working
2. Navigate to the payments page
3. Verify payment summary loads correctly
4. Check transaction list displays properly
5. Test filtering functionality
6. Verify pull-to-refresh works
7. Test error states with network issues 