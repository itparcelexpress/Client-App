import 'package:flutter/material.dart';

/// A reusable dropdown widget that handles text overflow gracefully
/// and provides consistent styling across the app
class OverflowSafeDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final void Function(T?) onChanged;
  final String Function(T) itemBuilder;
  final String? label;
  final IconData? icon;
  final String? Function(T?)? validator;
  final bool isRequired;
  final EdgeInsetsGeometry? contentPadding;
  final double? borderRadius;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? fillColor;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final double? iconSize;
  final Color? iconColor;
  final bool isDense;
  final double? dropdownHeight;

  const OverflowSafeDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemBuilder,
    this.label,
    this.icon,
    this.validator,
    this.isRequired = false,
    this.contentPadding,
    this.borderRadius,
    this.borderColor,
    this.focusedBorderColor,
    this.fillColor,
    this.textStyle,
    this.labelStyle,
    this.iconSize,
    this.iconColor,
    this.isDense = false,
    this.dropdownHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            isRequired ? '$label *' : label!,
            style:
                labelStyle ??
                const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1a1a1a),
                ),
          ),
          const SizedBox(height: 8),
        ],
        DropdownButtonFormField<T>(
          value: value,
          onChanged: onChanged,
          validator: validator,
          isDense: isDense,
          isExpanded: true,
          decoration: InputDecoration(
            prefixIcon:
                icon != null
                    ? Icon(
                      icon,
                      color: iconColor ?? Colors.grey[400],
                      size: iconSize ?? 20,
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
              borderSide: BorderSide(color: borderColor ?? Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
              borderSide: BorderSide(color: borderColor ?? Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
              borderSide: BorderSide(
                color: focusedBorderColor ?? const Color(0xFF667eea),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: fillColor ?? Colors.grey[50],
            contentPadding:
                contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          items:
              items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 20),
                    child: Text(
                      itemBuilder(item),
                      style:
                          textStyle ??
                          const TextStyle(
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                );
              }).toList(),
          selectedItemBuilder: (context) {
            return items.map((item) {
              return Container(
                constraints: const BoxConstraints(minHeight: 20),
                child: Text(
                  itemBuilder(item),
                  style:
                      textStyle ??
                      const TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}

/// A specialized dropdown for location selection with consistent styling
class LocationDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final void Function(T?) onChanged;
  final String Function(T) itemBuilder;
  final String label;
  final IconData icon;
  final String? Function(T?)? validator;
  final bool isRequired;

  const LocationDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemBuilder,
    required this.label,
    required this.icon,
    this.validator,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return OverflowSafeDropdown<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      label: label,
      icon: icon,
      validator: validator,
      isRequired: isRequired,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      borderRadius: 12,
      borderColor: Colors.grey[200],
      focusedBorderColor: const Color(0xFF667eea),
      fillColor: Colors.grey[50],
      textStyle: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1a1a1a),
      ),
      iconSize: 20,
      iconColor: Colors.grey[400],
    );
  }
}
