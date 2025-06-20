# Order Creation Feature

## Overview
This feature allows users to create orders by scanning or manually entering sticker numbers, filling in order details, and viewing their order history in a modern, user-friendly interface.

## Architecture
The feature follows MVVM + Cubit architecture with clean separation of concerns:

```
lib/features/shipment/
├── data/
│   ├── models/
│   │   └── order_models.dart          # Order request/response models
│   └── repositories/
│       └── order_repository.dart      # API calls for orders
├── cubit/
│   ├── shipment_cubit.dart           # Business logic and state management
│   └── shipment_state.dart           # State definitions
└── presentation/
    └── pages/
        ├── shipment_page.dart        # Scan/manual entry page
        ├── create_order_page.dart    # Order form page
        └── orders_list_page.dart     # Orders history page
```

## Features

### 🔍 Sticker Number Input
- **Manual Entry**: Type sticker number directly
- **Barcode Scanning**: Use camera to scan barcodes
- **Real-time Validation**: Immediate feedback on input
- **Modern UI**: Clean, card-based design

### 📝 Order Creation Form
- **Personal Information**: Name, phone, email validation
- **Address Details**: Street address, zip code
- **Order Details**: Payment type, delivery fee, amount
- **Package Dimensions**: Optional width, height, length, weight
- **Smart Validation**: Form validation with error handling
- **Loading States**: Beautiful loading animations

### 📱 Orders List
- **Card-based Layout**: Each order in a clean card
- **Order Information**: Tracking number, recipient, payment type
- **Status Indicators**: Color-coded status badges
- **Copy Functionality**: Tap to copy tracking numbers
- **Pull to Refresh**: Swipe down to refresh orders
- **Empty States**: Helpful empty state with call-to-action

## API Integration

### Endpoints
- **POST** `/orders/store` - Create new order
- **GET** `/orders` - Fetch user orders
- **GET** `/orders/{id}` - Get order details

### Request Format (Create Order)
```json
{
  "sticker_number": "optional_scanned_number",
  "name": "Recipient Name",
  "phone": "+968XXXXXXXX",
  "alternatePhone": "+968XXXXXXXX",
  "email": "email@example.com",
  "country_id": 165,
  "governorate_id": 1,
  "state_id": 1,
  "place_id": 1,
  "zipcode": "12345",
  "streetAddress": "Full address",
  "delivery_fee": 5.00,
  "payment_type": "COD",
  "amount": 100.00,
  "width": 10.0,
  "height": 15.0,
  "length": 20.0,
  "weight": 2.5
}
```

### Response Format
```json
{
  "message": "Order created successfully.",
  "success": true,
  "data": {
    "tracking_no": "PE190625674430",
    "payment_type": "COD",
    "delivery_fee": "5.00",
    "amount": 100,
    "consignee": {
      "name": "Recipient Name",
      "email": "email@example.com",
      "cellphone": "+968XXXXXXXX"
    }
  }
}
```

## UI/UX Features

### 🎨 Modern Design
- **Gradient Backgrounds**: Beautiful purple-blue gradients
- **Card-based Layout**: Clean, Material Design inspired
- **Consistent Spacing**: 20px margins, proper padding
- **Typography Hierarchy**: Clear font weights and sizes

### ✨ Animations
- **Fade Animations**: Smooth entrance animations with animate_do
- **Loading States**: Spinkit loading animations
- **Success Dialogs**: Celebratory success modals
- **Error Handling**: Friendly error messages

### 📱 Responsive Design
- **Mobile-first**: Optimized for mobile devices
- **Scrollable Forms**: Long forms with proper scrolling
- **Input Validation**: Real-time form validation
- **Accessibility**: Proper focus management and labels

## State Management

### States
```dart
// Scanning/Input States
ShipmentInitial()
ShipmentLoading()
ShipmentScanSuccess(trackingNumber)
ShipmentScanError(message)
ShipmentNumberEntered(stickerNumber)

// Order Creation States
OrderCreating()
OrderCreated(orderData)
OrderCreationError(message)

// Order Listing States
OrdersLoading()
OrdersLoaded(orders)
OrdersError(message)
```

### Key Actions
```dart
// Input Actions
enterStickerNumber(String number)
onBarcodeDetected(BarcodeCapture capture)

// Order Actions
createOrder(CreateOrderRequest request)
loadOrders()
reset()
```

## Navigation Flow

1. **Home Page** → Quick Actions → Create Shipment
2. **Shipment Page** → Scan/Enter sticker → Create Order
3. **Create Order Page** → Fill form → Submit → Success
4. **Home Page** → Order History → View Orders

## Dependencies Used

### Core Packages
- `flutter_bloc` - State management
- `equatable` - Value comparison
- `get_it` - Dependency injection

### UI Packages
- `animate_do` - Smooth animations
- `flutter_spinkit` - Loading animations
- `mobile_scanner` - Barcode scanning
- `intl` - Date formatting

### Network & Storage
- `dio` - HTTP client (via app_request.dart)
- `shared_preferences` - Local storage (via local_data.dart)

## Error Handling

### Network Errors
- Connection timeouts
- Server errors (4xx, 5xx)
- Authentication failures
- Malformed responses

### User Input Errors
- Invalid email formats
- Empty required fields
- Invalid phone numbers
- Malformed numeric inputs

### Scanner Errors
- Camera permission denied
- Barcode not readable
- No barcode detected

## Security Features

- **Authentication Required**: All API calls use Bearer tokens
- **Input Validation**: Client-side validation prevents malformed data
- **Error Sanitization**: Sensitive information not exposed in errors

## Future Enhancements

### Potential Features
- [ ] Order status tracking
- [ ] Push notifications for order updates
- [ ] Multiple payment methods
- [ ] Order cancellation
- [ ] Bulk order creation
- [ ] Order search and filtering
- [ ] Export order history
- [ ] Offline order creation with sync

### Performance Optimizations
- [ ] Image caching for avatars
- [ ] Pagination for large order lists
- [ ] Background order sync
- [ ] Optimistic updates

## Testing Recommendations

### Unit Tests
- Order model serialization/deserialization
- Repository error handling
- Cubit state transitions
- Form validation logic

### Integration Tests
- API request/response handling
- Database operations
- Navigation flows

### Widget Tests
- Form input validation
- Loading state displays
- Error message displays
- Success dialogs

## Usage Instructions

1. **Create Order with Scan**:
   - Tap "Create Shipment" or "Quick Scan"
   - Allow camera permissions
   - Scan barcode or enter manually
   - Tap "Create Order"
   - Fill in all required fields
   - Submit order

2. **View Order History**:
   - Tap "Order History" from home
   - Pull down to refresh
   - Tap tracking number to copy

3. **Handle Errors**:
   - Check network connection
   - Verify all required fields
   - Ensure valid email format
   - Try again or contact support

## Support
For technical issues or questions, refer to the main application documentation or contact the development team. 