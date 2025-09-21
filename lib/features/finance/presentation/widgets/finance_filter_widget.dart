import 'package:client_app/features/finance/data/models/finance_filter_model.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Finance filter widget for date range and transaction type filtering
class FinanceFilterWidget extends StatefulWidget {
  final FinanceFilter? currentFilter;
  final Function(FinanceFilter?) onFilterChanged;

  const FinanceFilterWidget({
    super.key,
    this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  State<FinanceFilterWidget> createState() => _FinanceFilterWidgetState();
}

class _FinanceFilterWidgetState extends State<FinanceFilterWidget> {
  DateTime? _fromDate;
  DateTime? _toDate;
  TransactionType _transactionType = TransactionType.all;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _initializeFromCurrentFilter();
  }

  @override
  void didUpdateWidget(FinanceFilterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentFilter != oldWidget.currentFilter) {
      _initializeFromCurrentFilter();
    }
  }

  void _initializeFromCurrentFilter() {
    if (widget.currentFilter != null) {
      _fromDate = widget.currentFilter!.fromDate;
      _toDate = widget.currentFilter!.toDate;
      _transactionType = widget.currentFilter!.transactionType;
    }
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isFromDate
              ? (_fromDate ?? DateTime.now())
              : (_toDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: const Color(0xFF667eea)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
          // If from date is after to date, clear to date
          if (_toDate != null && _fromDate!.isAfter(_toDate!)) {
            _toDate = null;
          }
        } else {
          _toDate = picked;
          // If to date is before from date, clear from date
          if (_fromDate != null && _toDate!.isBefore(_fromDate!)) {
            _fromDate = null;
          }
        }
      });
    }
  }

  void _applyFilter() {
    final filter = FinanceFilter(
      fromDate: _fromDate,
      toDate: _toDate,
      transactionType: _transactionType,
    );

    widget.onFilterChanged(filter);
    setState(() {
      _isExpanded = false;
    });
  }

  void _clearFilters() {
    setState(() {
      _fromDate = null;
      _toDate = null;
      _transactionType = TransactionType.all;
    });
    widget.onFilterChanged(null);
    setState(() {
      _isExpanded = false;
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final hasActiveFilters =
        _fromDate != null ||
        _toDate != null ||
        _transactionType != TransactionType.all;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
        children: [
          // Filter Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    color:
                        hasActiveFilters
                            ? const Color(0xFF667eea)
                            : Colors.grey[600],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.filter,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color:
                                hasActiveFilters
                                    ? const Color(0xFF667eea)
                                    : Colors.grey[800],
                          ),
                        ),
                        if (hasActiveFilters) ...[
                          const SizedBox(height: 2),
                          Text(
                            _buildFilterDisplayText(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),

          // Filter Content
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Range Section
                  Text(
                    localizations.dateRange,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF667eea),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      // From Date
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, true),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _fromDate != null
                                        ? _formatDate(_fromDate!)
                                        : localizations.fromDate,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          _fromDate != null
                                              ? Colors.black87
                                              : Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // To Date
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, false),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _toDate != null
                                        ? _formatDate(_toDate!)
                                        : localizations.toDate,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          _toDate != null
                                              ? Colors.black87
                                              : Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Transaction Type Section
                  Text(
                    localizations.transactionType,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF667eea),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        TransactionType.values.map((type) {
                          final isSelected = _transactionType == type;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _transactionType = type;
                              });
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? const Color(0xFF667eea)
                                        : Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? const Color(0xFF667eea)
                                          : Colors.grey[300]!,
                                ),
                              ),
                              child: Text(
                                type.value,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.grey[700],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _clearFilters,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey[400]!),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            localizations.clear,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _applyFilter,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF667eea),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            localizations.apply,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _buildFilterDisplayText() {
    final parts = <String>[];

    if (_fromDate != null && _toDate != null) {
      parts.add('${_formatDate(_fromDate!)} - ${_formatDate(_toDate!)}');
    } else if (_fromDate != null) {
      parts.add('From ${_formatDate(_fromDate!)}');
    } else if (_toDate != null) {
      parts.add('To ${_formatDate(_toDate!)}');
    }

    if (_transactionType != TransactionType.all) {
      parts.add(_transactionType.value);
    }

    return parts.join(' • ');
  }
}
