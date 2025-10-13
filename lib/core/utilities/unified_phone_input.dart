import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client_app/l10n/app_localizations.dart';

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
        flagSize: 20,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 14, color: Colors.black),
        bottomSheetHeight: 450,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        inputDecoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.searchCountry,
          hintText: AppLocalizations.of(context)!.startTypingToSearch,
          prefixIcon: const Icon(Icons.search, size: 20),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        searchTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
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
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 6),
        ],

        // Compact Unified Phone Input Field - Always LTR structure
        Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            height: 48, // Fixed height for consistency
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade50,
            ),
            child: Row(
              children: [
                // Compact Country Code Selector - Always on the LEFT
                InkWell(
                  onTap: _showCountryPicker,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Compact Flag
                        Container(
                          width: 18,
                          height: 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1.5),
                            image: DecorationImage(
                              image: AssetImage(
                                'packages/country_picker/assets/flags/${selectedCountryCode.toLowerCase()}.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Compact Phone Code - Always LTR
                        Text(
                          selectedPhoneCode,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                        // Compact Dropdown Icon
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                ),

                // Compact Phone Number Input - Always LTR
                Expanded(
                  child: TextFormField(
                    controller: widget.controller,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade900),
                    decoration: InputDecoration(
                      hintText:
                          widget.hint ??
                          AppLocalizations.of(context)!.phoneNumberHint,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
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
        ),

        // Compact validation error display
        if (widget.controller.text.isNotEmpty &&
            _validatePhone(widget.controller.text) != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _validatePhone(widget.controller.text) ?? '',
              style: TextStyle(fontSize: 11, color: Colors.red.shade600),
            ),
          ),
      ],
    );
  }
}
