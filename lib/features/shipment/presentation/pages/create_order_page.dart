import 'package:animate_do/animate_do.dart';
import 'package:client_app/core/models/location_models.dart';
import 'package:client_app/core/services/location_service.dart';
import 'package:client_app/core/utilities/responsive_utils.dart';
import 'package:client_app/core/utilities/taost_service.dart';
import 'package:client_app/core/utilities/unified_phone_input.dart';
import 'package:client_app/data/local/local_data.dart';
import 'package:client_app/features/address_book/address_book.dart';
import 'package:client_app/features/shipment/cubit/shipment_cubit.dart';
import 'package:client_app/features/auth/presentation/pages/home_page.dart';
import 'package:client_app/features/shipment/data/models/order_models.dart';
import 'package:client_app/injections.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
  // Sticker entry
  final _stickerController = TextEditingController();
  // Holds latest scanned/entered value via controller; kept for clarity if needed later
  // ignore: unused_field
  String? _stickerNumber;
  // New: Dimensions & items
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _lengthController = TextEditingController();
  final _weightController = TextEditingController();
  String _unit = 'Kg';
  String _feePayer = 'customer';
  final List<TextEditingController> _itemNameCtrls = [TextEditingController()];
  final List<TextEditingController> _itemCategoryCtrls = [
    TextEditingController(),
  ];
  final List<TextEditingController> _itemQuantityCtrls = [
    TextEditingController(),
  ];

  // Dropdown values
  String _paymentType = 'cod'; // Use key instead of display value
  final int _countryId = 165; // Default Oman

  // Location dropdowns
  List<Governorate> _governorates = [];
  List<StateModel> _states = [];
  List<Place> _places = [];

  Governorate? _selectedGovernorate;
  StateModel? _selectedState;
  Place? _selectedPlace;

  // Address book selection
  AddressBookEntry? _selectedAddress;

  // Track if form has data to suggest saving as address book entry
  bool get _hasFormData {
    return _nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _streetAddressController.text.isNotEmpty &&
        _selectedGovernorate != null &&
        _selectedState != null &&
        _selectedPlace != null;
  }

  // Track if user dismissed the save suggestion
  bool _dismissedSaveSuggestion = false;

  @override
  void initState() {
    super.initState();
    // Set default values
    _deliveryFeeController.text = '5.00';
    _amountController.text = '0';
    _loadLocationData();

    // Initialize from incoming sticker (if navigated with it)
    if (widget.stickerNumber != null && widget.stickerNumber!.isNotEmpty) {
      _stickerNumber = widget.stickerNumber;
      _stickerController.text = widget.stickerNumber!;
    }

    // Add listeners to form fields to detect when user has filled form
    _nameController.addListener(_onFormDataChanged);
    _phoneController.addListener(_onFormDataChanged);
    _emailController.addListener(_onFormDataChanged);
    _streetAddressController.addListener(_onFormDataChanged);
  }

  void _onFormDataChanged() {
    setState(() {
      // Reset dismissed flag when form data changes
      if (!_hasFormData) {
        _dismissedSaveSuggestion = false;
      }
    });
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

  void _onAddressSelected(AddressBookEntry? address) {
    setState(() {
      _selectedAddress = address;
    });

    if (address != null) {
      // Auto-fill form fields from selected address
      _nameController.text = address.name;
      _phoneController.text = address.cellphone;
      _alternatePhoneController.text = address.alternatePhone;
      _emailController.text = address.email;
      _streetAddressController.text = address.streetAddress;

      if (address.zipcode != null) {
        _zipcodeController.text = address.zipcode!;
      }

      // Set location dropdowns based on selected address
      if (address.governorate != null) {
        // Find and set governorate
        final governorate = _governorates.firstWhere(
          (g) => g.id == address.governorateId,
          orElse: () => _governorates.first,
        );
        _selectedGovernorate = governorate;
        _loadStatesForGovernorate(governorate.id);

        // Set state after loading
        Future.delayed(const Duration(milliseconds: 100), () {
          if (address.state != null && _states.isNotEmpty) {
            final stateIndex = _states.indexWhere(
              (s) => s.id == address.stateId,
            );
            final state = stateIndex >= 0 ? _states[stateIndex] : _states.first;

            setState(() {
              _selectedState = state;
            });
            _loadPlacesForState(state.id);

            // Set place after loading
            Future.delayed(const Duration(milliseconds: 100), () {
              if (address.place != null && _places.isNotEmpty) {
                final placeIndex = _places.indexWhere(
                  (p) => p.id == address.placeId,
                );
                final place =
                    placeIndex >= 0 ? _places[placeIndex] : _places.first;

                setState(() {
                  _selectedPlace = place;
                });
              }
            });
          }
        });
      }
    }
  }

  void _saveCurrentFormAsAddress() async {
    if (!_hasFormData) return;

    final request = AddressBookRequest(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      cellphone: _phoneController.text.trim(),
      alternatePhone: _alternatePhoneController.text.trim(),
      countryId: 165, // Oman's country ID
      governorateId: _selectedGovernorate!.id,
      stateId: _selectedState!.id,
      placeId: _selectedPlace!.id,
      streetAddress: _streetAddressController.text.trim(),
      zipcode:
          _zipcodeController.text.trim().isNotEmpty
              ? _zipcodeController.text.trim()
              : null,
      locationUrl:
          _locationUrlController.text.trim().isNotEmpty
              ? _locationUrlController.text.trim()
              : null,
    );

    try {
      // Create a temporary cubit to save the address
      final addressBookCubit = getIt<AddressBookCubit>();
      await addressBookCubit.createAddressBookEntry(request);

      setState(() {
        _dismissedSaveSuggestion = true;
      });

      if (mounted) {
        ToastService.showSuccess(
          context,
          AppLocalizations.of(context)!.addressSavedSuccessfully,
        );
      }
    } catch (e) {
      if (mounted) {
        ToastService.showError(
          context,
          AppLocalizations.of(context)!.addressSaveFailed,
        );
      }
    }
  }

  void _dismissSaveSuggestion() {
    setState(() {
      _dismissedSaveSuggestion = true;
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
    _stickerController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _lengthController.dispose();
    _weightController.dispose();
    for (final c in _itemNameCtrls) c.dispose();
    for (final c in _itemCategoryCtrls) c.dispose();
    for (final c in _itemQuantityCtrls) c.dispose();

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
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildHeader(),
                        SizedBox(
                          height: ResponsiveUtils.getResponsivePadding(
                            context,
                            32,
                          ),
                        ),
                        _buildStickerSection(),
                        SizedBox(
                          height: ResponsiveUtils.getResponsivePadding(
                            context,
                            32,
                          ),
                        ),
                        _buildAddressBookSection(),
                        SizedBox(
                          height: ResponsiveUtils.getResponsivePadding(
                            context,
                            32,
                          ),
                        ),
                        _buildPersonalInfoSection(),
                        SizedBox(
                          height: ResponsiveUtils.getResponsivePadding(
                            context,
                            32,
                          ),
                        ),
                        _buildAddressSection(),
                        SizedBox(
                          height: ResponsiveUtils.getResponsivePadding(
                            context,
                            32,
                          ),
                        ),
                        if (_hasFormData &&
                            _selectedAddress == null &&
                            !_dismissedSaveSuggestion)
                          _buildSaveAddressSuggestion(),
                        if (_hasFormData &&
                            _selectedAddress == null &&
                            !_dismissedSaveSuggestion)
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
                AppLocalizations.of(context)!.createOrder,
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
            AppLocalizations.of(context)!.newOrder,
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
              AppLocalizations.of(context)!.fillDetailsToCreateOrder,
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

  Widget _buildStickerSection() {
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  isRTL ? MainAxisAlignment.end : MainAxisAlignment.start,
              children:
                  isRTL
                      ? [
                        Text(
                          AppLocalizations.of(context)!.stickerNumber,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1a1a1a),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF10b981), Color(0xFF059669)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.qr_code_scanner,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ]
                      : [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF10b981), Color(0xFF059669)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.qr_code_scanner,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppLocalizations.of(context)!.stickerNumber,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1a1a1a),
                          ),
                        ),
                      ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children:
                  isRTL
                      ? [
                        ElevatedButton.icon(
                          onPressed: _openStickerScanner,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10b981),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.qr_code_scanner, size: 18),
                          label: Text(AppLocalizations.of(context)!.scan),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: _stickerController,
                            label: AppLocalizations.of(context)!.stickerNumber,
                            hint:
                                AppLocalizations.of(
                                  context,
                                )!.examplePhoneNumber,
                            icon: Icons.confirmation_number_outlined,
                            keyboardType: TextInputType.text,
                            validator:
                                (value) =>
                                    (value == null || value.trim().isEmpty)
                                        ? AppLocalizations.of(
                                          context,
                                        )!.pleaseEnterField(
                                          AppLocalizations.of(
                                            context,
                                          )!.stickerNumber,
                                        )
                                        : null,
                          ),
                        ),
                      ]
                      : [
                        Expanded(
                          child: _buildTextField(
                            controller: _stickerController,
                            label: AppLocalizations.of(context)!.stickerNumber,
                            hint:
                                AppLocalizations.of(
                                  context,
                                )!.examplePhoneNumber,
                            icon: Icons.confirmation_number_outlined,
                            keyboardType: TextInputType.text,
                            validator:
                                (value) =>
                                    (value == null || value.trim().isEmpty)
                                        ? AppLocalizations.of(
                                          context,
                                        )!.pleaseEnterField(
                                          AppLocalizations.of(
                                            context,
                                          )!.stickerNumber,
                                        )
                                        : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _openStickerScanner,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10b981),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.qr_code_scanner, size: 18),
                          label: Text(AppLocalizations.of(context)!.scan),
                        ),
                      ],
            ),
          ],
        ),
      ),
    );
  }

  void _openStickerScanner() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: ResponsiveUtils.getScreenHeight(context) * 0.6,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: MobileScanner(
                  onDetect: (capture) {
                    final code = capture.barcodes.first.rawValue;
                    if (code != null && code.isNotEmpty) {
                      Navigator.pop(context);
                      setState(() {
                        _stickerNumber = code;
                        _stickerController.text = code;
                      });
                      ToastService.showCustomToast(
                        message: AppLocalizations.of(
                          context,
                        )!.trackingLabel(code),
                        type: ToastType.success,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddressBookSection() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
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
                    gradient: const LinearGradient(
                      colors: [Color(0xFF06b6d4), Color(0xFF0891b2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.contacts_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.addressBook,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            BlocProvider(
              create: (context) => getIt<AddressBookCubit>(),
              child: AddressSelectionWidget(
                selectedAddress: _selectedAddress,
                onAddressSelected: _onAddressSelected,
                label: AppLocalizations.of(context)!.selectFromSavedAddresses,
                isRequired: false,
              ),
            ),
            if (_selectedAddress != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF10b981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF10b981).withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF10b981),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.formAutoFilled,
                      style: TextStyle(
                        color: Color(0xFF10b981),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => _onAddressSelected(null),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.clear,
                        style: TextStyle(
                          color: Color(0xFF10b981),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return _buildSection(
      title: AppLocalizations.of(context)!.personalInformation,
      icon: Icons.person_rounded,
      children: [
        _buildTextField(
          controller: _nameController,
          label: AppLocalizations.of(context)!.fullName,
          hint: AppLocalizations.of(
            context,
          )!.pleaseEnterField(AppLocalizations.of(context)!.fullName),
          icon: Icons.person_outline,
          validator:
              (value) =>
                  value?.isEmpty == true
                      ? AppLocalizations.of(context)!.nameRequired
                      : null,
        ),
        const SizedBox(height: 20),
        UnifiedPhoneInput(
          controller: _phoneController,
          label: AppLocalizations.of(context)!.phoneNumber,
          hint: AppLocalizations.of(context)!.phoneNumberInfo,
          isRequired: true,
          onPhoneChanged: (countryCode, phoneCode, fullPhoneNumber) {
            // Handle phone number change if needed
          },
        ),
        const SizedBox(height: 20),
        UnifiedPhoneInput(
          controller: _alternatePhoneController,
          label: AppLocalizations.of(context)!.alternatePhone,
          hint: AppLocalizations.of(context)!.alternatePhoneInfo,
          isRequired: false,
          onPhoneChanged: (countryCode, phoneCode, fullPhoneNumber) {
            // Handle alternate phone number change if needed
          },
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _emailController,
          label: AppLocalizations.of(context)!.emailAddress,
          hint: AppLocalizations.of(context)!.emailPlaceholder,
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value?.isEmpty == true)
              return AppLocalizations.of(context)!.emailRequired;
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
              return AppLocalizations.of(context)!.pleaseEnterValidEmail;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAddressSection() {
    return _buildSection(
      title: AppLocalizations.of(context)!.locationDetails,
      icon: Icons.location_on_rounded,
      children: [
        // Governorate Dropdown
        _buildLocationDropdown<Governorate>(
          label: AppLocalizations.of(context)!.governorate,
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
        const SizedBox(height: 20),
        // State Dropdown
        _buildLocationDropdown<StateModel>(
          label: AppLocalizations.of(context)!.state,
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
        const SizedBox(height: 20),
        // Place Dropdown
        _buildLocationDropdown<Place>(
          label: AppLocalizations.of(context)!.place,
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
        const SizedBox(height: 20),
        _buildTextField(
          controller: _streetAddressController,
          label: AppLocalizations.of(context)!.streetAddress,
          hint: AppLocalizations.of(context)!.streetAddressHint,
          icon: Icons.home_outlined,
          maxLines: 2,
          validator:
              (value) =>
                  value?.isEmpty == true
                      ? AppLocalizations.of(context)!.streetAddressRequired
                      : null,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _zipcodeController,
          label: AppLocalizations.of(context)!.zipcode,
          hint: AppLocalizations.of(
            context,
          )!.pleaseEnterField(AppLocalizations.of(context)!.zipcode),
          icon: Icons.mail_outlined,
          keyboardType: TextInputType.number,
          validator:
              (value) =>
                  value?.isEmpty == true
                      ? AppLocalizations.of(context)!.zipcodeRequired
                      : null,
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
          validator:
              (value) =>
                  value == null
                      ? AppLocalizations.of(context)!.pleaseEnterField(label)
                      : null,
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
      title: AppLocalizations.of(context)!.additionalInformation,
      icon: Icons.receipt_long_rounded,
      children: [
        _buildDropdownField(
          label: AppLocalizations.of(context)!.paymentType,
          value: _paymentType,
          icon: Icons.payment_rounded,
          items: const ['cod', 'prepaid'],
          onChanged: (value) => setState(() => _paymentType = value!),
        ),
        const SizedBox(height: 20),
        _buildDropdownField(
          label: AppLocalizations.of(context)!.feePayer,
          value: _feePayer,
          icon: Icons.account_balance_wallet_outlined,
          items: const ['customer', 'shipper'],
          onChanged: (value) => setState(() => _feePayer = value!),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _deliveryFeeController,
                label: AppLocalizations.of(context)!.deliveryFee,
                hint: AppLocalizations.of(context)!.deliveryFeeHint,
                icon: Icons.local_shipping_outlined,
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value?.isEmpty == true
                            ? AppLocalizations.of(
                              context,
                            )!.pleaseEnterDeliveryFee
                            : null,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildTextField(
                controller: _amountController,
                label: AppLocalizations.of(context)!.amount,
                hint: AppLocalizations.of(context)!.amountHint,
                icon: Icons.attach_money_rounded,
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value?.isEmpty == true
                            ? AppLocalizations.of(
                              context,
                            )!.pleaseEnterAmountField
                            : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Dimensions & Weight Section Header
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.straighten,
                color: Colors.blue.shade600,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              AppLocalizations.of(context)!.dimensionsAndWeight,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Unit Selection
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.measurementUnit,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      label: '',
                      value: _unit,
                      icon: Icons.straighten,
                      items: const ['Kg', 'length'],
                      onChanged: (v) => setState(() => _unit = v!),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Dimensions Grid
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.packageDimensions,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _widthController,
                      label: AppLocalizations.of(context)!.width,
                      hint: AppLocalizations.of(context)!.dimensionHint,
                      icon: Icons.straighten,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _heightController,
                      label: AppLocalizations.of(context)!.height,
                      hint: AppLocalizations.of(context)!.dimensionHint,
                      icon: Icons.height,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _lengthController,
                      label: AppLocalizations.of(context)!.length,
                      hint: AppLocalizations.of(context)!.dimensionHint,
                      icon: Icons.straighten,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _weightController,
                      label: AppLocalizations.of(context)!.weight,
                      hint: AppLocalizations.of(context)!.dimensionHint,
                      icon: Icons.monitor_weight_outlined,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Items Section Header
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                color: Colors.blue.shade600,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              AppLocalizations.of(context)!.items,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Items List
        ...List.generate(_itemNameCtrls.length, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                // Item Header with Delete Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${AppLocalizations.of(context)!.itemName} ${index + 1}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _itemNameCtrls.removeAt(index).dispose();
                            _itemCategoryCtrls.removeAt(index).dispose();
                            _itemQuantityCtrls.removeAt(index).dispose();
                          });
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red.shade600,
                          size: 18,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Item Fields
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildTextField(
                        controller: _itemNameCtrls[index],
                        label: AppLocalizations.of(context)!.itemName,
                        hint: AppLocalizations.of(context)!.itemNameHint,
                        icon: Icons.inventory_2_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _itemCategoryCtrls[index],
                        label: AppLocalizations.of(context)!.category,
                        hint: AppLocalizations.of(context)!.categoryHint,
                        icon: Icons.category_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _itemQuantityCtrls[index],
                        label: AppLocalizations.of(context)!.quantity,
                        hint: AppLocalizations.of(context)!.quantityHint,
                        icon: Icons.numbers,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),

        // Add Item Button
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8),
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _itemNameCtrls.add(TextEditingController());
                _itemCategoryCtrls.add(TextEditingController());
                _itemQuantityCtrls.add(TextEditingController());
              });
            },
            icon: Icon(Icons.add_circle_outline, color: Colors.white),
            label: Text(
              AppLocalizations.of(context)!.addAnotherItem,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Location URL field
        _buildTextField(
          controller: _locationUrlController,
          label:
              '${AppLocalizations.of(context)!.locationUrl} (${AppLocalizations.of(context)!.optional})',
          hint: AppLocalizations.of(context)!.locationUrlPlaceholder,
          icon: Icons.location_on_outlined,
          keyboardType: TextInputType.url,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final uri = Uri.tryParse(value);
              if (uri == null || !uri.hasAbsolutePath) {
                return AppLocalizations.of(
                  context,
                )!.pleaseEnterValidLocationUrl;
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
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
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.blue.shade600, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
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
    List<TextInputFormatter>? inputFormatters,
  }) {
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
          textAlign: isRTL ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 12),
        Directionality(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            maxLines: maxLines,
            inputFormatters: inputFormatters,
            textAlign: isRTL ? TextAlign.right : TextAlign.left,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon:
                  isRTL
                      ? null
                      : Icon(icon, color: Colors.grey.shade600, size: 20),
              suffixIcon:
                  isRTL
                      ? Icon(icon, color: Colors.grey.shade600, size: 20)
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red.shade400, width: 1),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
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
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey.shade600, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
          ),
          items:
              items.map((item) {
                String displayText = item;
                if (item == 'cod') {
                  displayText = AppLocalizations.of(context)!.cod;
                } else if (item == 'prepaid') {
                  displayText = AppLocalizations.of(context)!.prepaid;
                } else if (item == 'customer') {
                  displayText = AppLocalizations.of(context)!.customer;
                } else if (item == 'shipper') {
                  displayText = AppLocalizations.of(context)!.shipper;
                } else if (item == 'Kg') {
                  displayText = AppLocalizations.of(context)!.kg;
                } else if (item == 'length') {
                  displayText = AppLocalizations.of(context)!.lengthUnit;
                }
                return DropdownMenuItem(value: item, child: Text(displayText));
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<ShipmentCubit, ShipmentState>(
      builder: (context, state) {
        final isLoading = state is OrderCreating;

        return GestureDetector(
          onTap: isLoading ? null : _submitOrder,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: isLoading ? Colors.grey.shade400 : Colors.blue.shade600,
              borderRadius: BorderRadius.circular(12),
              boxShadow:
                  isLoading
                      ? null
                      : [
                        BoxShadow(
                          color: Colors.blue.shade600.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  const SpinKitThreeBounce(color: Colors.white, size: 20),
                  const SizedBox(width: 20),
                ] else ...[
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  isLoading
                      ? AppLocalizations.of(context)!.creatingOrder
                      : AppLocalizations.of(context)!.createOrder,
                  style: TextStyle(
                    color: isLoading ? Colors.grey[500] : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
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
        _showErrorToast(AppLocalizations.of(context)!.pleaseSelectGovernorate);
        return;
      }

      final user = LocalData.user;
      // Use the correct client ID from the user data
      final clientId =
          user?.client?.id ?? 1; // Default to 1 if no client ID found

      final request = CreateOrderRequest(
        stickerNumber:
            _stickerController.text.trim().isNotEmpty
                ? _stickerController.text.trim()
                : null,
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
        notes:
            AppLocalizations.of(
              context,
            )!.orderCreatedViaMobileApp, // Default note
        paymentType: _paymentType == 'cod' ? 'COD' : 'PREPAID',
        amount: double.parse(_amountController.text),
        deliveryFee: double.parse(_deliveryFeeController.text),
        clientId: clientId,
        locationUrl:
            _locationUrlController.text.trim().isEmpty
                ? "https://maps.app.goo.gl/q9CvYn3SKy9DVxBAA" // Default location URL if none provided
                : _locationUrlController.text.trim(),
        feePayer: _feePayer,
        width:
            _widthController.text.trim().isEmpty
                ? null
                : double.tryParse(_widthController.text.trim()),
        height:
            _heightController.text.trim().isEmpty
                ? null
                : double.tryParse(_heightController.text.trim()),
        length:
            _lengthController.text.trim().isEmpty
                ? null
                : double.tryParse(_lengthController.text.trim()),
        weight:
            _weightController.text.trim().isEmpty
                ? null
                : double.tryParse(_weightController.text.trim()),
        unitId: _unit.toLowerCase() == 'kg' ? 1 : 0,
        itemNames:
            _itemNameCtrls
                .map((c) => c.text.trim())
                .where((e) => e.isNotEmpty)
                .toList(),
        categories:
            _itemCategoryCtrls
                .map((c) => c.text.trim())
                .where((e) => e.isNotEmpty)
                .toList(),
        quantities:
            _itemQuantityCtrls
                .map((c) => int.tryParse(c.text.trim()) ?? 0)
                .toList(),
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
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.orderCreatedSuccessfully,
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
                          '${AppLocalizations.of(context)!.trackingNumber}: ${orderData.trackingNo}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF10b981),
                          ),
                        ),
                      ] else ...[
                        Text(
                          '${AppLocalizations.of(context)!.id(orderData.id)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF10b981),
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        '${AppLocalizations.of(context)!.forRecipient(orderData.consignee.name)}',
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
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomePage()),
                    (route) => false,
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.done,
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

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final lc = message.toLowerCase();

    String display = message;

    // Friendly, localized mappings for common server messages
    if (lc.contains('tracking') && lc.contains('taken')) {
      display =
          isArabic
              ? 'رقم التتبع مستخدم بالفعل. يرجى مسح ملصقًا آخر.'
              : AppLocalizations.of(context)!.thisTrackingNumberIsAlreadyUsed;
    } else if (lc.contains('validation') || lc.contains('unprocessable')) {
      display =
          isArabic
              ? 'يرجى التحقق من المدخلات والمحاولة مرة أخرى.'
              : AppLocalizations.of(context)!.pleaseCheckYourInputAndTryAgain;
    }

    ToastService.showCustomToast(message: display, type: ToastType.error);
  }

  Widget _buildSaveAddressSuggestion() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF06b6d4).withValues(alpha: 0.1),
              const Color(0xFF0891b2).withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF06b6d4).withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF06b6d4).withValues(alpha: 0.1),
              blurRadius: 15,
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
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF06b6d4), Color(0xFF0891b2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF06b6d4).withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.bookmark_add_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.saveForLater,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1a1a1a),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context)!.addToAddressBook,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_rounded,
                    color: const Color(0xFF06b6d4),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.saveAddressHint,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveCurrentFormAsAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF06b6d4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.save_rounded, size: 18),
                    label: Text(
                      AppLocalizations.of(context)!.saveAddress,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: _dismissSaveSuggestion,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.notNow,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
