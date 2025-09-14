import 'package:animate_do/animate_do.dart';
import 'package:client_app/core/models/location_models.dart';
import 'package:client_app/core/services/location_service.dart';
import 'package:client_app/core/utilities/responsive_utils.dart';
import 'package:client_app/core/utilities/taost_service.dart';
import 'package:client_app/core/utilities/unified_phone_input.dart';
import 'package:client_app/core/widgets/overflow_safe_dropdown.dart';
import 'package:client_app/features/address_book/cubit/address_book_cubit.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:client_app/features/address_book/cubit/address_book_state.dart';
import 'package:client_app/features/address_book/data/models/address_book_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAddressPage extends StatefulWidget {
  final AddressBookEntry? existingEntry;

  const AddAddressPage({super.key, this.existingEntry});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cellphoneController = TextEditingController();
  final _alternatePhoneController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _zipcodeController = TextEditingController();
  final _locationUrlController = TextEditingController();

  // Location selections
  Governorate? _selectedGovernorate;
  StateModel? _selectedState;
  Place? _selectedPlace;

  // Location lists
  List<Governorate> _governorates = [];
  List<StateModel> _states = [];
  List<Place> _places = [];

  bool _isLoading = false;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.existingEntry != null;
    _loadLocationData();
    if (_isEditMode) {
      _populateFormWithExistingData();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cellphoneController.dispose();
    _alternatePhoneController.dispose();
    _streetAddressController.dispose();
    _zipcodeController.dispose();
    _locationUrlController.dispose();
    super.dispose();
  }

  void _populateFormWithExistingData() {
    final entry = widget.existingEntry!;
    _nameController.text = entry.name;
    _emailController.text = entry.email;
    _cellphoneController.text = entry.cellphone;
    _alternatePhoneController.text = entry.alternatePhone;
    _streetAddressController.text = entry.streetAddress;
    _zipcodeController.text = entry.zipcode ?? '';
    _locationUrlController.text = entry.locationUrl ?? '';

    // Set selected location data
    if (entry.governorate != null) {
      _selectedGovernorate = Governorate(
        id: entry.governorate!.id,
        enName: entry.governorate!.enName,
        arName: entry.governorate!.arName,
        countryId: entry.countryId,
      );
    }

    if (entry.state != null) {
      _selectedState = StateModel(
        id: entry.state!.id,
        enName: entry.state!.enName,
        arName: entry.state!.arName,
        governorateId: entry.governorateId,
      );
    }

    if (entry.place != null) {
      _selectedPlace = Place(
        id: entry.place!.id,
        enName: entry.place!.enName,
        arName: entry.place!.arName,
        stateId: entry.stateId,
      );
    }
  }

  Future<void> _loadLocationData() async {
    try {
      _governorates = LocationService.getAllGovernorates();
      setState(() {});

      if (_selectedGovernorate != null) {
        _states = LocationService.getStatesByGovernorateId(
          _selectedGovernorate!.id,
        );
      }

      if (_selectedState != null) {
        _places = LocationService.getPlacesByStateId(_selectedState!.id);
      }

      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print('🔴 Error loading location data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: BlocListener<AddressBookCubit, AddressBookState>(
        listener: (context, state) {
          if (state is AddressBookCreating || state is AddressBookUpdating) {
            setState(() {
              _isLoading = true;
            });
          } else {
            setState(() {
              _isLoading = false;
            });
          }

          if (state is AddressBookEntryCreated) {
            ToastService.showSuccess(context, 'addressSavedSuccessfully');
            Navigator.pop(context);
          } else if (state is AddressBookEntryUpdated) {
            ToastService.showSuccess(context, 'addressUpdatedSuccessfully');
            Navigator.pop(context);
          } else if (state is AddressBookCreateError ||
              state is AddressBookUpdateError) {
            ToastService.showError(context, 'addressSaveFailed');
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
              context,
              const EdgeInsets.all(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Personal Information'),
                const SizedBox(height: 16),
                _buildPersonalInfoSection(),
                const SizedBox(height: 32),
                _buildSectionTitle('Location Details'),
                const SizedBox(height: 16),
                _buildLocationSection(),
                const SizedBox(height: 32),
                _buildSectionTitle('Additional Information'),
                const SizedBox(height: 16),
                _buildAdditionalInfoSection(),
                const SizedBox(height: 40),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: FadeInDown(
        duration: const Duration(milliseconds: 400),
        child: Text(
          _isEditMode ? 'Edit Address' : 'Add New Address',
          style: const TextStyle(
            color: Color(0xFF1a1a1a),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      centerTitle: true,
      leading: FadeInLeft(
        duration: const Duration(milliseconds: 400),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Color(0xFF1a1a1a),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: Text(
        title,
        style: TextStyle(
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1a1a1a),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
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
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: 'Email Address',
              icon: Icons.email_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            UnifiedPhoneInput(
              controller: _cellphoneController,
              label: 'Phone Number',
              isRequired: true,
              onPhoneChanged: (countryCode, phoneCode, fullPhoneNumber) {
                // Handle phone number change if needed
              },
            ),
            const SizedBox(height: 16),
            UnifiedPhoneInput(
              controller: _alternatePhoneController,
              label: 'Alternate Phone Number',
              isRequired: true,
              onPhoneChanged: (countryCode, phoneCode, fullPhoneNumber) {
                // Handle alternate phone number change if needed
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
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
          children: [
            LocationDropdown<Governorate>(
              value: _selectedGovernorate,
              label: 'Governorate',
              icon: Icons.location_city_rounded,
              items: _governorates,
              onChanged: (value) {
                setState(() {
                  _selectedGovernorate = value;
                  _selectedState = null;
                  _selectedPlace = null;
                  _states = [];
                  _places = [];
                });
                if (value != null) {
                  _loadStatesForGovernorate(value.id);
                }
              },
              itemBuilder: (governorate) => governorate.enName,
              validator:
                  (value) => value == null ? 'Please select Governorate' : null,
            ),
            const SizedBox(height: 16),
            LocationDropdown<StateModel>(
              value: _selectedState,
              label: 'State',
              icon: Icons.location_on_rounded,
              items: _states,
              onChanged: (value) {
                setState(() {
                  _selectedState = value;
                  _selectedPlace = null;
                  _places = [];
                });
                if (value != null) {
                  _loadPlacesForState(value.id);
                }
              },
              itemBuilder: (state) => state.enName,
              validator:
                  (value) => value == null ? 'Please select State' : null,
            ),
            const SizedBox(height: 16),
            LocationDropdown<Place>(
              value: _selectedPlace,
              label: 'Place',
              icon: Icons.place_rounded,
              items: _places,
              onChanged: (value) {
                setState(() {
                  _selectedPlace = value;
                });
              },
              itemBuilder: (place) => place.enName,
              validator:
                  (value) => value == null ? 'Please select Place' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _streetAddressController,
              label: 'Street Address',
              icon: Icons.home_rounded,
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your street address';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoSection() {
    return FadeInUp(
      duration: const Duration(milliseconds: 700),
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
          children: [
            _buildTextField(
              controller: _zipcodeController,
              label: 'Zip Code (Optional)',
              icon: Icons.markunread_mailbox_rounded,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _locationUrlController,
              label: 'Location URL (Optional)',
              icon: Icons.link_rounded,
              keyboardType: TextInputType.url,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF667eea)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF667eea),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child:
              _isLoading
                  ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : Text(
                    _isEditMode
                        ? AppLocalizations.of(context)!.updateAddress
                        : AppLocalizations.of(context)!.addAddress,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
        ),
      ),
    );
  }

  void _loadStatesForGovernorate(int governorateId) {
    _states = LocationService.getStatesByGovernorateId(governorateId);
    setState(() {});
  }

  void _loadPlacesForState(int stateId) {
    _places = LocationService.getPlacesByStateId(stateId);
    setState(() {});
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedGovernorate == null ||
          _selectedState == null ||
          _selectedPlace == null) {
        ToastService.showError(context, 'pleaseSelectAllLocationFields');
        return;
      }

      final request = AddressBookRequest(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        cellphone: _cellphoneController.text.trim(),
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

      if (_isEditMode && widget.existingEntry?.id != null) {
        context.read<AddressBookCubit>().updateAddressBookEntry(
          widget.existingEntry!.id!,
          request,
        );
      } else {
        context.read<AddressBookCubit>().createAddressBookEntry(request);
      }
    }
  }
}
