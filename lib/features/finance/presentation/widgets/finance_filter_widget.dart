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

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => _FinanceFilterBottomSheet(
            currentFilter: widget.currentFilter,
            onFilterChanged: widget.onFilterChanged,
          ),
    );
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
      child: InkWell(
        onTap: _showFilterBottomSheet,
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
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _buildFilterDisplayText() {
    final parts = <String>[];

    if (_fromDate != null && _toDate != null) {
      parts.add('${_formatDate(_fromDate!)} - ${_formatDate(_toDate!)}');
    } else if (_fromDate != null) {
      parts.add(
        '${AppLocalizations.of(context)!.from} ${_formatDate(_fromDate!)}',
      );
    } else if (_toDate != null) {
      parts.add('${AppLocalizations.of(context)!.to} ${_formatDate(_toDate!)}');
    }

    if (_transactionType != TransactionType.all) {
      parts.add(_transactionType.value);
    }

    return parts.join(' • ');
  }
}

/// Bottom sheet widget for finance filtering
class _FinanceFilterBottomSheet extends StatefulWidget {
  final FinanceFilter? currentFilter;
  final Function(FinanceFilter?) onFilterChanged;

  const _FinanceFilterBottomSheet({
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  State<_FinanceFilterBottomSheet> createState() =>
      _FinanceFilterBottomSheetState();
}

class _FinanceFilterBottomSheetState extends State<_FinanceFilterBottomSheet> {
  DateTime? _fromDate;
  DateTime? _toDate;
  TransactionType _transactionType = TransactionType.all;

  @override
  void initState() {
    super.initState();
    _initializeFromCurrentFilter();
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
    Navigator.of(context).pop();
  }

  void _clearFilters() {
    setState(() {
      _fromDate = null;
      _toDate = null;
      _transactionType = TransactionType.all;
    });
    widget.onFilterChanged(null);
    Navigator.of(context).pop();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  String _getLocalizedTransactionType(TransactionType type) {
    final localizations = AppLocalizations.of(context)!;
    switch (type) {
      case TransactionType.all:
        return localizations.all;
      case TransactionType.cod:
        return localizations.codTransaction;
      case TransactionType.fee:
        return localizations.feeTransaction;
      case TransactionType.settlement:
        return localizations.settlementTransaction;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.primaryColor,
                    theme.primaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.filter_list_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.filter,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          localizations.filterDescription,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ),

            // Filter Content
            Padding(
              padding: const EdgeInsets.all(24),
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
                                _getLocalizedTransactionType(type),
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

                  const SizedBox(height: 28),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: OutlinedButton(
                            onPressed: _clearFilters,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              localizations.clear,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [
                                theme.primaryColor,
                                theme.primaryColor.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _applyFilter,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              localizations.apply,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
