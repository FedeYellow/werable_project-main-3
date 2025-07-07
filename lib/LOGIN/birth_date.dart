import 'package:flutter/material.dart';

class BirthDatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const BirthDatePicker({super.key, required this.onDateSelected});

  @override
  State<BirthDatePicker> createState() => _BirthDatePickerState();
}

class _BirthDatePickerState extends State<BirthDatePicker> {
  DateTime? _selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF3E5F8A), // color botón
              onPrimary: Colors.white, // texto sobre primary
              surface: Colors.grey[200]!, // fondo del calendario
              onSurface: Color(0xFF3E5F8A), // color textos
            ),
            dialogBackgroundColor: Colors.grey[200], // fondo total del cuadro
          ),
          child: child!,
        );
      },    
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateSelected(picked); // Enviamos la fecha al padre
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              //fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
