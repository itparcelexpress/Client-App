import 'package:animate_do/animate_do.dart';
import 'package:client_app/core/models/location_models.dart';
import 'package:client_app/core/services/location_service.dart';
import 'package:client_app/core/utilities/app_color.dart';
import 'package:client_app/core/utilities/responsive_utils.dart';
import 'package:client_app/core/utilities/taost_service.dart';
import 'package:client_app/core/utilities/unified_phone_input.dart';
import 'package:client_app/core/utilities/validators.dart';
import 'package:client_app/core/widgets/overflow_safe_dropdown.dart';
import 'package:client_app/features/guest/cubit/guest_cubit.dart';
import 'package:client_app/features/guest/cubit/guest_state.dart';
import 'package:client_app/features/guest/data/models/guest_order_models.dart';
import 'package:client_app/l10n/app_localizations.dart';
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
  final Map<String, bool> _touchedFields = {};
  bool _formSubmitted = false;
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
    // Set initial amount
    _amountController.text = '5.0';
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

  void _markFieldAsTouched(String fieldName) {
    if (!_touchedFields.containsKey(fieldName)) {
      setState(() {
        _touchedFields[fieldName] = true;
      });
    }
  }

  bool _shouldShowError(String fieldName) {
    return _formSubmitted || _touchedFields[fieldName] == true;
  }

  String? _validateField(
    String? value,
    String fieldName,
    String? Function(String?) validator,
  ) {
    if (!_shouldShowError(fieldName)) {
      return null;
    }
    return validator(value);
  }

  void _onSubmit() {
    setState(() {
      _formSubmitted = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      final request = GuestOrderRequest(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        cellphone: _phoneController.text.trim(),
        alternatePhone: _alternatePhoneController.text.trim(),
        district: _districtController.text.trim(),
        zipcode: _zipcodeController.text.trim(),
        streetAddress: _streetAddressController.text.trim(),
        notes: _notesController.text.trim(),
        payment_type: 'COD',
        amount: double.tryParse(_amountController.text.trim()) ?? 5.0,
        customer_name: _customerNameController.text.trim(),
        customer_phone: _customerPhoneController.text.trim(),
        country_id: 165,
        governorate_id: selectedGovernorate?.id ?? 0,
        state_id: selectedState?.id ?? 0,
        place_id: selectedPlace?.id ?? 0,
        city_id: 1,
        identify: _identifyController.text.trim(),
        taxNumber: _taxNumberController.text.trim(),
        location_url: _locationUrlController.text.trim(),
      );

      context.read<GuestCubit>().createGuestOrder(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surfaceColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.createGuestOrder,
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                  : Text(
                                    AppLocalizations.of(context)!.createOrder,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    int? maxLines,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        errorStyle:
            !_shouldShowError(label)
                ? const TextStyle(fontSize: 0, height: 0)
                : null,
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
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      onTap: () => _markFieldAsTouched(label),
      onChanged: (_) => _markFieldAsTouched(label),
      validator: (value) => _validateField(value, label, validator),
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
            AppLocalizations.of(context)!.personalInformation,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.w600,
              color: AppColor.titleTextColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _nameController,
            label: AppLocalizations.of(context)!.fullName,
            validator:
                (value) => Validators.requiredField(
                  value,
                  context: context,
                  fieldName: AppLocalizations.of(context)!.fullName,
                ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailController,
            label: AppLocalizations.of(context)!.email,
            validator: (value) => Validators.email(value, context: context),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          UnifiedPhoneInput(
            controller: _phoneController,
            label: AppLocalizations.of(context)!.phoneNumber,
            isRequired: true,
            onPhoneChanged: (countryCode, phoneCode, fullPhoneNumber) {
              // Handle phone number change if needed
            },
          ),
          const SizedBox(height: 16),
          UnifiedPhoneInput(
            controller: _alternatePhoneController,
            label: AppLocalizations.of(context)!.alternatePhone,
            isRequired: false,
            onPhoneChanged: (countryCode, phoneCode, fullPhoneNumber) {
              // Handle alternate phone number change if needed
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _identifyController,
            label: AppLocalizations.of(context)!.identification,
            validator:
                (value) =>
                    Validators.identificationNumber(value, context: context),
            isRequired: false,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _taxNumberController,
            label: AppLocalizations.of(context)!.taxNumber,
            validator: (value) => Validators.taxNumber(value, context: context),
            isRequired: false,
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
            AppLocalizations.of(context)!.addressDetails,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.w600,
              color: AppColor.titleTextColor,
            ),
          ),
          const SizedBox(height: 16),
          LocationDropdown<Governorate>(
            value: selectedGovernorate,
            label: AppLocalizations.of(context)!.governorate,
            icon: Icons.location_city_outlined,
            items: governorates,
            onChanged: (gov) {
              setState(() {
                selectedGovernorate = gov;
                selectedState = null;
                selectedPlace = null;
                states.clear();
                places.clear();
                _markFieldAsTouched(AppLocalizations.of(context)!.governorate);
              });
              if (gov != null) {
                _loadStates(gov.id);
              }
            },
            itemBuilder: (gov) => gov.enName,
            validator:
                (value) => _validateField(
                  value?.toString(),
                  AppLocalizations.of(context)!.governorate,
                  (v) =>
                      value == null
                          ? AppLocalizations.of(
                            context,
                          )!.pleaseSelectGovernorate
                          : null,
                ),
          ),
          const SizedBox(height: 16),
          LocationDropdown<StateModel>(
            value: selectedState,
            label: AppLocalizations.of(context)!.state,
            icon: Icons.location_searching_outlined,
            items: states,
            onChanged: (state) {
              setState(() {
                selectedState = state;
                selectedPlace = null;
                places.clear();
                _markFieldAsTouched(AppLocalizations.of(context)!.state);
              });
              if (state != null) {
                _loadPlaces(state.id);
              }
            },
            itemBuilder: (state) => state.enName,
            validator:
                (value) => _validateField(
                  value?.toString(),
                  AppLocalizations.of(context)!.state,
                  (v) =>
                      value == null
                          ? AppLocalizations.of(context)!.pleaseSelectState
                          : null,
                ),
          ),
          const SizedBox(height: 16),
          LocationDropdown<Place>(
            value: selectedPlace,
            label: AppLocalizations.of(context)!.place,
            icon: Icons.place_outlined,
            items: places,
            onChanged: (place) {
              setState(() {
                selectedPlace = place;
                _markFieldAsTouched(AppLocalizations.of(context)!.place);
              });
            },
            itemBuilder: (place) => place.enName,
            validator:
                (value) => _validateField(
                  value?.toString(),
                  AppLocalizations.of(context)!.place,
                  (v) =>
                      value == null
                          ? AppLocalizations.of(context)!.pleaseSelectPlace
                          : null,
                ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _districtController,
            label: AppLocalizations.of(context)!.district,
            validator:
                (value) => Validators.requiredField(
                  value,
                  context: context,
                  fieldName: AppLocalizations.of(context)!.district,
                ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _zipcodeController,
            label: AppLocalizations.of(context)!.zipcode,
            validator: (value) => Validators.zipcode(value, context: context),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _streetAddressController,
            label: AppLocalizations.of(context)!.streetAddress,
            validator:
                (value) => Validators.requiredField(
                  value,
                  context: context,
                  fieldName: AppLocalizations.of(context)!.streetAddress,
                ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _locationUrlController,
            label: AppLocalizations.of(context)!.locationUrl,
            validator:
                (value) =>
                    Validators.optionalLocationUrl(value, context: context),
            keyboardType: TextInputType.url,
            isRequired: false,
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
            AppLocalizations.of(context)!.customerInformation,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.w600,
              color: AppColor.titleTextColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _customerNameController,
            label: AppLocalizations.of(context)!.customerName,
            validator:
                (value) => Validators.requiredField(
                  value,
                  context: context,
                  fieldName: AppLocalizations.of(context)!.customerName,
                ),
          ),
          const SizedBox(height: 16),
          UnifiedPhoneInput(
            controller: _customerPhoneController,
            label: AppLocalizations.of(context)!.customerPhone,
            isRequired: true,
            onPhoneChanged: (countryCode, phoneCode, fullPhoneNumber) {
              // Handle customer phone number change if needed
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _amountController,
            label: AppLocalizations.of(context)!.amount,
            validator:
                (value) =>
                    Validators.amount(value, context: context, minAmount: 5.0),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _notesController,
            label: AppLocalizations.of(context)!.notes,
            validator: (_) => null,
            maxLines: 3,
            isRequired: false,
          ),
        ],
      ),
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
                  Text(
                    AppLocalizations.of(context)!.orderCreatedSuccessfully,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!.trackingNumberIs,
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
                        child: Text(
                          AppLocalizations.of(context)!.done,
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
