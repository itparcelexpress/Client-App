import 'package:animate_do/animate_do.dart';
import 'package:client_app/core/models/location_models.dart';
import 'package:client_app/core/services/location_service.dart';
import 'package:client_app/core/utilities/responsive_utils.dart';
import 'package:client_app/data/local/local_data.dart';
import 'package:client_app/features/shipment/cubit/shipment_cubit.dart';
import 'package:client_app/features/shipment/data/models/order_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateOrderPage extends StatefulWidget {
  final String? stickerNumber;

  const CreateOrderPage({super.key, this.stickerNumber});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _alternatePhoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _zipcodeController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _deliveryFeeController = TextEditingController();
  final _amountController = TextEditingController();
  final _locationUrlController = TextEditingController();

  // Dropdown values
  String _paymentType = 'COD';
  final int _countryId = 165; // Default Oman

  // Location dropdowns
  List<Governorate> _governorates = [];
  List<StateModel> _states = [];
  List<Place> _places = [];

  Governorate? _selectedGovernorate;
  StateModel? _selectedState;
  Place? _selectedPlace;

  @override
  void initState() {
    super.initState();
    // Set default values
    _deliveryFeeController.text = '5.00';
    _amountController.text = '0';
    _loadLocationData();
  }

  void _loadLocationData() {
    setState(() {
      _governorates = LocationService.getAllGovernorates();
      // Set default selection to first governorate
      if (_governorates.isNotEmpty) {
        _selectedGovernorate = _governorates.first;
        _loadStatesForGovernorate(_selectedGovernorate!.id);
      }
    });
  }

  void _loadStatesForGovernorate(int governorateId) {
    setState(() {
      _states = LocationService.getStatesByGovernorateId(governorateId);
      _selectedState = null;
      _selectedPlace = null;
      _places = [];

      // Set default selection to first state
      if (_states.isNotEmpty) {
        _selectedState = _states.first;
        _loadPlacesForState(_selectedState!.id);
      }
    });
  }

  void _loadPlacesForState(int stateId) {
    setState(() {
      _places = LocationService.getPlacesByStateId(stateId);
      _selectedPlace = null;

      // Set default selection to first place
      if (_places.isNotEmpty) {
        _selectedPlace = _places.first;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _alternatePhoneController.dispose();
    _emailController.dispose();
    _zipcodeController.dispose();
    _streetAddressController.dispose();
    _deliveryFeeController.dispose();
    _amountController.dispose();
    _locationUrlController.dispose();

    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: BlocListener<ShipmentCubit, ShipmentState>(
                listener: (context, state) {
                  if (state is OrderCreated) {
                    print('Order created successfully: ${state.orderData.id}');
                    _showSuccessDialog(state.orderData);
                  } else if (state is OrderCreationError) {
                    print('Order creation error: ${state.message}');
                    _showErrorToast(state.message);
                  }
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
                    context,
                    const EdgeInsets.all(20),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildHeader(),
                        SizedBox(
                          height: ResponsiveUtils.getResponsivePadding(
                            context,
                            24,
                          ),
                        ),
                        _buildStickerInfo(),
                        SizedBox(
                          height: ResponsiveUtils.getResponsivePadding(
                            context,
                            24,
                          ),
                        ),
                        _buildPersonalInfoSection(),
                        SizedBox(
                          height: ResponsiveUtils.getResponsivePadding(
                            context,
                            24,
                          ),
                        ),
                        _buildAddressSection(),
                        SizedBox(
                          height: ResponsiveUtils.getResponsivePadding(
                            context,
                            24,
                          ),
                        ),
                        _buildOrderDetailsSection(),
                        SizedBox(
                          height: ResponsiveUtils.getResponsivePadding(
                            context,
                            40,
                          ),
                        ),
                        _buildSubmitButton(),
                        SizedBox(
                          height: ResponsiveUtils.getResponsivePadding(
                            context,
                            20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return FadeInDown(
      duration: const Duration(milliseconds: 400),
      child: Container(
        padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
          context,
          const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        color: Colors.white,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back, size: 20),
              ),
            ),
            Expanded(
              child: Text(
                'Create Order',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1a1a1a),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          Container(
            width: ResponsiveUtils.getResponsiveWidth(context, 80),
            height: ResponsiveUtils.getResponsiveHeight(context, 80),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              Icons.add_box_rounded,
              color: Colors.white,
              size: ResponsiveUtils.getResponsiveWidth(context, 40),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 20)),
          Text(
            'New Order',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 28),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1a1a1a),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 8)),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsivePadding(context, 16),
            ),
            child: Text(
              'Fill in the details to create your order',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickerInfo() {
    if (widget.stickerNumber == null) return const SizedBox.shrink();

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF10b981), Color(0xFF059669)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sticker Number',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.stickerNumber!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return _buildSection(
      title: 'Personal Information',
      icon: Icons.person_rounded,
      children: [
        _buildTextField(
          controller: _nameController,
          label: 'Full Name',
          hint: 'Enter recipient full name',
          icon: Icons.person_outline,
          validator:
              (value) => value?.isEmpty == true ? 'Name is required' : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _phoneController,
          label: 'Phone Number',
          hint: '+968 XXXX XXXX',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator:
              (value) =>
                  value?.isEmpty == true ? 'Phone number is required' : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _alternatePhoneController,
          label: 'Alternate Phone',
          hint: '+968 XXXX XXXX',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator:
              (value) =>
                  value?.isEmpty == true ? 'Alternate phone is required' : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _emailController,
          label: 'Email Address',
          hint: 'example@email.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value?.isEmpty == true) return 'Email is required';
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
              return 'Enter a valid email';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAddressSection() {
    return _buildSection(
      title: 'Address Information',
      icon: Icons.location_on_rounded,
      children: [
        // Governorate Dropdown
        _buildLocationDropdown<Governorate>(
          label: 'Governorate',
          value: _selectedGovernorate,
          items: _governorates,
          onChanged: (governorate) {
            setState(() {
              _selectedGovernorate = governorate;
              if (governorate != null) {
                _loadStatesForGovernorate(governorate.id);
              }
            });
          },
          displayText: (governorate) => governorate.enName,
          icon: Icons.location_city_outlined,
        ),
        const SizedBox(height: 16),
        // State Dropdown
        _buildLocationDropdown<StateModel>(
          label: 'State',
          value: _selectedState,
          items: _states,
          onChanged: (state) {
            setState(() {
              _selectedState = state;
              if (state != null) {
                _loadPlacesForState(state.id);
              }
            });
          },
          displayText: (state) => state.enName,
          icon: Icons.location_searching_outlined,
        ),
        const SizedBox(height: 16),
        // Place Dropdown
        _buildLocationDropdown<Place>(
          label: 'Place',
          value: _selectedPlace,
          items: _places,
          onChanged: (place) {
            setState(() {
              _selectedPlace = place;
            });
          },
          displayText: (place) => place.enName,
          icon: Icons.place_outlined,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _streetAddressController,
          label: 'Street Address',
          hint: 'Building, street, area',
          icon: Icons.home_outlined,
          maxLines: 2,
          validator:
              (value) => value?.isEmpty == true ? 'Address is required' : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _zipcodeController,
          label: 'Zip Code',
          hint: 'Enter zip code',
          icon: Icons.mail_outlined,
          keyboardType: TextInputType.number,
          validator:
              (value) => value?.isEmpty == true ? 'Zip code is required' : null,
        ),
      ],
    );
  }

  Widget _buildLocationDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
    required String Function(T) displayText,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1a1a1a),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          onChanged: onChanged,
          validator: (value) => value == null ? '$label is required' : null,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          items:
              items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    displayText(item),
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildOrderDetailsSection() {
    return _buildSection(
      title: 'Order Details',
      icon: Icons.receipt_long_rounded,
      children: [
        _buildDropdownField(
          label: 'Payment Type',
          value: _paymentType,
          icon: Icons.payment_rounded,
          items: const ['COD', 'PREPAID'],
          onChanged: (value) => setState(() => _paymentType = value!),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _deliveryFeeController,
                label: 'Delivery Fee',
                hint: '0.00',
                icon: Icons.local_shipping_outlined,
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value?.isEmpty == true
                            ? 'Delivery fee is required'
                            : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _amountController,
                label: 'Amount',
                hint: '0.00',
                icon: Icons.attach_money_rounded,
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value?.isEmpty == true ? 'Amount is required' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _locationUrlController,
          label: 'Location URL (Optional)',
          hint: 'https://maps.app.goo.gl/...',
          icon: Icons.location_on_outlined,
          keyboardType: TextInputType.url,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              // Only validate if the field is not empty
              final uri = Uri.tryParse(value);
              if (uri == null || !uri.hasAbsolutePath) {
                return 'Please enter a valid URL';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF667eea).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFF667eea), size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1a1a1a),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFef4444), width: 1),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1a1a1a),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<ShipmentCubit, ShipmentState>(
      builder: (context, state) {
        final isLoading = state is OrderCreating;

        return FadeInUp(
          duration: const Duration(milliseconds: 800),
          child: GestureDetector(
            onTap: isLoading ? null : _submitOrder,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                gradient:
                    isLoading
                        ? null
                        : const LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                color: isLoading ? Colors.grey[300] : null,
                borderRadius: BorderRadius.circular(16),
                boxShadow:
                    isLoading
                        ? null
                        : [
                          BoxShadow(
                            color: const Color(
                              0xFF667eea,
                            ).withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading) ...[
                    const SpinKitThreeBounce(color: Colors.white, size: 20),
                    const SizedBox(width: 16),
                  ] else ...[
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    isLoading ? 'Creating Order...' : 'Create Order',
                    style: TextStyle(
                      color: isLoading ? Colors.grey[500] : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      // Validate location selections
      if (_selectedGovernorate == null ||
          _selectedState == null ||
          _selectedPlace == null) {
        _showErrorToast('Please select governorate, state, and place');
        return;
      }

      final user = LocalData.user;
      // Use the correct client ID from the user data
      final clientId =
          user?.client?.id ?? 1; // Default to 1 if no client ID found

      final request = CreateOrderRequest(
        stickerNumber:
            widget.stickerNumber, // Use the sticker number from widget
        name: _nameController.text.trim(),
        cellphone: _phoneController.text.trim(),
        alternatePhone: _alternatePhoneController.text.trim(),
        email: _emailController.text.trim(),
        district: "", // Default empty as per API spec
        countryId: _countryId,
        governorateId: _selectedGovernorate!.id,
        stateId: _selectedState!.id,
        placeId: _selectedPlace!.id,
        cityId: 1, // Default as per API spec
        zipcode: _zipcodeController.text.trim(),
        streetAddress: _streetAddressController.text.trim(),
        identify: "", // Default empty as per API spec
        taxNumber: "", // Default empty as per API spec
        longitude: "", // Default empty as per API spec
        latitude: "", // Default empty as per API spec
        shipperId: "", // Default empty as per API spec
        notes: "Order created via mobile app", // Default note
        paymentType: _paymentType,
        amount: double.parse(_amountController.text),
        deliveryFee: double.parse(_deliveryFeeController.text),
        clientId: clientId,
        locationUrl:
            _locationUrlController.text.trim().isEmpty
                ? "https://maps.app.goo.gl/q9CvYn3SKy9DVxBAA" // Default location URL if none provided
                : _locationUrlController.text.trim(),
      );

      context.read<ShipmentCubit>().createOrder(request);
    } else {
      // Scroll to first error
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showSuccessDialog(OrderData orderData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF10b981),
                  size: 60,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Order Created Successfully!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1a1a1a),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Show order ID and consignee info instead of tracking number if it's null/empty
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10b981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      if (orderData.trackingNo.isNotEmpty) ...[
                        Text(
                          'Tracking: ${orderData.trackingNo}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF10b981),
                          ),
                        ),
                      ] else ...[
                        Text(
                          'Order ID: ${orderData.id}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF10b981),
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        'For: ${orderData.consignee.name}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6b7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to previous screen
                },
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Color(0xFF667eea),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _showErrorToast(String message) {
    // Don't show empty error messages
    if (message.trim().isEmpty) return;

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: const Color(0xFFef4444),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
