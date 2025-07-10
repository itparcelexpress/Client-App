import 'package:animate_do/animate_do.dart';
import 'package:client_app/core/models/location_models.dart';
import 'package:client_app/core/services/location_service.dart';
import 'package:client_app/core/utilities/app_color.dart';
import 'package:client_app/core/utilities/responsive_utils.dart';
import 'package:client_app/core/utilities/taost_service.dart';
import 'package:client_app/features/guest/cubit/guest_cubit.dart';
import 'package:client_app/features/guest/cubit/guest_state.dart';
import 'package:client_app/features/guest/data/models/guest_order_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CreateGuestOrderPage extends StatefulWidget {
  const CreateGuestOrderPage({super.key});

  @override
  State<CreateGuestOrderPage> createState() => _CreateGuestOrderPageState();
}

class _CreateGuestOrderPageState extends State<CreateGuestOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _alternatePhoneController = TextEditingController();
  final _districtController = TextEditingController();
  final _zipcodeController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _notesController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _identifyController = TextEditingController();
  final _taxNumberController = TextEditingController();
  final _amountController = TextEditingController(text: '5.0');
  final _locationUrlController = TextEditingController();

  List<Governorate> governorates = [];
  List<StateModel> states = [];
  List<Place> places = [];

  Governorate? selectedGovernorate;
  StateModel? selectedState;
  Place? selectedPlace;

  String? locationUrl;
  String? longitude;
  String? latitude;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    governorates = LocationService.getAllGovernorates();
    setState(() {});
  }

  Future<void> _loadStates(int governorateId) async {
    states = LocationService.getStatesByGovernorateId(governorateId);
    setState(() {});
  }

  Future<void> _loadPlaces(int stateId) async {
    places = LocationService.getPlacesByStateId(stateId);
    setState(() {});
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final request = GuestOrderRequest(
        name: _nameController.text,
        email: _emailController.text,
        cellphone: _phoneController.text,
        alternatePhone: _alternatePhoneController.text,
        district: _districtController.text,
        zipcode: _zipcodeController.text,
        streetAddress: _streetAddressController.text,
        notes: _notesController.text,
        payment_type: 'COD',
        amount: double.tryParse(_amountController.text) ?? 5.0,
        customer_name: _customerNameController.text,
        customer_phone: _customerPhoneController.text,
        country_id: 165,
        governorate_id: selectedGovernorate?.id ?? 0,
        state_id: selectedState?.id ?? 0,
        place_id: selectedPlace?.id ?? 0,
        city_id: 1,
        identify: _identifyController.text,
        taxNumber: _taxNumberController.text,
        location_url: _locationUrlController.text,
      );

      context.read<GuestCubit>().createGuestOrder(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surfaceColor,
      appBar: AppBar(
        title: const Text(
          'Create Guest Order',
          style: TextStyle(
            color: AppColor.titleTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColor.cardColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.titleTextColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<GuestCubit, GuestState>(
        listener: (context, state) {
          if (state is GuestOrderSuccess) {
            // Show success toast
            ToastService.showCustomToast(
              message: state.message,
              type: ToastType.success,
            );
            // Show success dialog with tracking number
            _showSuccessDialog(context, state.orderData.tracking_no);
          } else if (state is GuestOrderError) {
            // Show error toast
            ToastService.showCustomToast(
              message: state.message,
              type: ToastType.error,
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
                  context,
                  const EdgeInsets.all(16),
                ),
                child: FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildPersonalInfoSection(),
                        const SizedBox(height: 24),
                        _buildAddressSection(),
                        const SizedBox(height: 24),
                        _buildCustomerInfoSection(),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed:
                              state is GuestOrderLoading ? null : _onSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child:
                              state is GuestOrderLoading
                                  ? const SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 24,
                                  )
                                  : const Text(
                                    'Create Order',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (state is GuestOrderLoading)
                Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(
                    child: SpinKitCircle(
                      color: AppColor.primaryColor,
                      size: 50.0,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.w600,
              color: AppColor.titleTextColor,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: _inputDecoration('Full Name *'),
            validator:
                (value) =>
                    value?.isEmpty ?? true ? 'Please enter your name' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: _inputDecoration('Email *'),
            validator:
                (value) =>
                    value?.isEmpty ?? true ? 'Please enter your email' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: _inputDecoration('Phone Number *'),
            validator:
                (value) =>
                    value?.isEmpty ?? true ? 'Please enter your phone' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _alternatePhoneController,
            decoration: _inputDecoration('Alternate Phone'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _identifyController,
            decoration: _inputDecoration('Identification'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _taxNumberController,
            decoration: _inputDecoration('Tax Number'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Address Details',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.w600,
              color: AppColor.titleTextColor,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Governorate>(
            value: selectedGovernorate,
            decoration: _inputDecoration('Governorate'),
            items:
                governorates
                    .map(
                      (gov) =>
                          DropdownMenuItem(value: gov, child: Text(gov.enName)),
                    )
                    .toList(),
            onChanged: (gov) {
              setState(() {
                selectedGovernorate = gov;
                selectedState = null;
                selectedPlace = null;
                states.clear();
                places.clear();
              });
              if (gov != null) {
                _loadStates(gov.id);
              }
            },
            validator:
                (value) => value == null ? 'Please select a governorate' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<StateModel>(
            value: selectedState,
            decoration: _inputDecoration('State'),
            items:
                states
                    .map(
                      (state) => DropdownMenuItem(
                        value: state,
                        child: Text(state.enName),
                      ),
                    )
                    .toList(),
            onChanged: (state) {
              setState(() {
                selectedState = state;
                selectedPlace = null;
                places.clear();
              });
              if (state != null) {
                _loadPlaces(state.id);
              }
            },
            validator:
                (value) => value == null ? 'Please select a state' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Place>(
            value: selectedPlace,
            decoration: _inputDecoration('Place'),
            items:
                places
                    .map(
                      (place) => DropdownMenuItem(
                        value: place,
                        child: Text(place.enName),
                      ),
                    )
                    .toList(),
            onChanged: (place) {
              setState(() {
                selectedPlace = place;
              });
            },
            validator:
                (value) => value == null ? 'Please select a place' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _districtController,
            decoration: _inputDecoration('District'),
            validator:
                (value) =>
                    value?.isEmpty ?? true ? 'Please enter district' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _zipcodeController,
            decoration: _inputDecoration('Zipcode'),
            validator:
                (value) =>
                    value?.isEmpty ?? true ? 'Please enter zipcode' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _streetAddressController,
            decoration: _inputDecoration('Street Address'),
            validator:
                (value) =>
                    value?.isEmpty ?? true
                        ? 'Please enter street address'
                        : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _locationUrlController,
            decoration: _inputDecoration('Location URL *'),
            validator:
                (value) =>
                    value?.isEmpty ?? true ? 'Please enter location URL' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Information',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.w600,
              color: AppColor.titleTextColor,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _customerNameController,
            decoration: _inputDecoration('Customer Name *'),
            validator:
                (value) =>
                    value?.isEmpty ?? true
                        ? 'Please enter customer name'
                        : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _customerPhoneController,
            decoration: _inputDecoration('Customer Phone *'),
            validator:
                (value) =>
                    value?.isEmpty ?? true
                        ? 'Please enter customer phone'
                        : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            decoration: _inputDecoration('Amount *'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please enter amount';
              final amount = double.tryParse(value!);
              if (amount == null || amount <= 0)
                return 'Please enter a valid amount';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _notesController,
            decoration: _inputDecoration('Notes'),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.primaryColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  void _showSuccessDialog(BuildContext context, String trackingNo) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: FadeInUp(
            duration: const Duration(milliseconds: 500),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 64),
                  const SizedBox(height: 20),
                  const Text(
                    'Order Created Successfully!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your tracking number is:',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: SelectableText(
                      trackingNo,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                          Navigator.of(
                            context,
                          ).pop(); // Go back to previous screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _alternatePhoneController.dispose();
    _districtController.dispose();
    _zipcodeController.dispose();
    _streetAddressController.dispose();
    _notesController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _identifyController.dispose();
    _taxNumberController.dispose();
    _amountController.dispose();
    _locationUrlController.dispose();
    super.dispose();
  }
}
