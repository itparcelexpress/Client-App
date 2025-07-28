import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:client_app/core/utilities/app_color.dart';

class UnifiedPhoneInput extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final bool isRequired;
  final String? initialCountryCode;
  final String? initialPhoneCode;
  final Function(String countryCode, String phoneCode, String fullPhoneNumber)?
  onPhoneChanged;

  const UnifiedPhoneInput({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.validator,
    this.isRequired = false,
    this.initialCountryCode,
    this.initialPhoneCode,
    this.onPhoneChanged,
  });

  @override
  State<UnifiedPhoneInput> createState() => _UnifiedPhoneInputState();
}

class _UnifiedPhoneInputState extends State<UnifiedPhoneInput> {
  String selectedCountryCode = 'OM';
  String selectedPhoneCode = '+968';
  String selectedCountryName = 'Oman';
  bool isCountryPickerOpen = false;

  @override
  void initState() {
    super.initState();
    selectedCountryCode = widget.initialCountryCode ?? 'OM';
    selectedPhoneCode = widget.initialPhoneCode ?? '+968';
    selectedCountryName = _getCountryName(selectedCountryCode);

    // Add listener to controller to update full phone number
    widget.controller.addListener(_onPhoneNumberChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onPhoneNumberChanged);
    super.dispose();
  }

  String _getCountryName(String countryCode) {
    final countryNames = {
      'EG': 'Egypt',
      'SA': 'Saudi Arabia',
      'AE': 'United Arab Emirates',
      'KW': 'Kuwait',
      'QA': 'Qatar',
      'BH': 'Bahrain',
      'OM': 'Oman',
      'JO': 'Jordan',
      'LB': 'Lebanon',
      'US': 'United States',
      'GB': 'United Kingdom',
      'CA': 'Canada',
    };
    return countryNames[countryCode] ?? 'Oman';
  }

  void _showCountryPicker() {
    if (isCountryPickerOpen) return;

    setState(() {
      isCountryPickerOpen = true;
    });

    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, color: Colors.black),
        bottomSheetHeight: 500,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search Country',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withValues(alpha: 0.2),
            ),
          ),
        ),
        searchTextStyle: const TextStyle(fontSize: 18, color: Colors.black),
      ),
      onSelect: (Country country) {
        setState(() {
          selectedCountryCode = country.countryCode;
          selectedPhoneCode = '+${country.phoneCode}';
          selectedCountryName = country.name;
        });
        _notifyPhoneChange();
      },
    );

    setState(() {
      isCountryPickerOpen = false;
    });
  }

  void _onPhoneNumberChanged() {
    _notifyPhoneChange();
  }

  void _notifyPhoneChange() {
    final fullPhoneNumber = '$selectedPhoneCode${widget.controller.text}';
    widget.onPhoneChanged?.call(
      selectedCountryCode,
      selectedPhoneCode,
      fullPhoneNumber,
    );
  }

  String? _validatePhone(String? value) {
    if (widget.validator != null) {
      return widget.validator!(value);
    }

    if (widget.isRequired && (value == null || value.isEmpty)) {
      return AppLocalizations.of(context)!.phoneRequired;
    }

    if (value != null && value.isNotEmpty) {
      // Basic phone validation - at least 8 digits
      final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
      if (digitsOnly.length < 8) {
        return AppLocalizations.of(context)!.pleaseEnterValidPhone('phone');
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColor.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Unified Phone Input Field
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Row(
            children: [
              // Country Code Selector
              InkWell(
                onTap: _showCountryPicker,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Flag
                      Container(
                        width: 20,
                        height: 14,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          image: DecorationImage(
                            image: AssetImage(
                              'packages/country_picker/assets/flags/${selectedCountryCode.toLowerCase()}.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Phone Code
                      Text(
                        selectedPhoneCode,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Dropdown Icon
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
              ),

              // Phone Number Input
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText:
                        widget.hint ??
                        AppLocalizations.of(context)!.phoneNumberHint,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    isDense: true,
                  ),
                  validator: _validatePhone,
                  onChanged: (value) {
                    _onPhoneNumberChanged();
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Display full phone number preview
        if (widget.controller.text.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.fullPhoneNumberPreview(
                      '$selectedPhoneCode${widget.controller.text}',
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
