import 'package:flutter/material.dart';

/// A custom widget that allows users to pick a birth date.
/// The selected date is passed back to the parent widget via a callback.
class BirthDatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const BirthDatePicker({super.key, required this.onDateSelected});

  @override
  State<BirthDatePicker> createState() => _BirthDatePickerState();
}

class _BirthDatePickerState extends State<BirthDatePicker> {
  DateTime? _selectedDate; // Stores the currently selected date

  /// Opens the date picker dialog and updates the state if a date is selected.
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000), // Default selected date
      firstDate: DateTime(1900),   // Minimum selectable date
      lastDate: DateTime.now(),    // Maximum date: today
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF3E5F8A),         // Header and selection color
              onPrimary: Colors.white,           // Text color on primary
              surface: Colors.grey[200]!,        // Calendar background
              onSurface: Color(0xFF3E5F8A),       // Day text color
            ),
            dialogBackgroundColor: Colors.grey[200], // Dialog box background
          ),
          child: child!,
        );
      },
    );

    // If a date is picked, update local state and notify parent
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateSelected(picked); // Pass the date to the parent widget
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align text and button
      children: [
        Text(
          _selectedDate == null
              ? 'Select birth date'
              : 'Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
          style: const TextStyle(fontSize: 16),
        ),
        TextButton(
          onPressed: () => _pickDate(context),
          child: const Text(
            'Choose',
            style: TextStyle(
              color: Color(0xFF3E5F8A),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
