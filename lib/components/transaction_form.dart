import 'package:expenses/components/adaptative_button.dart';
import 'package:expenses/components/adaptative_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'adaptative_textfield.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;
  TransactionForm(this.onSubmit);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0.0) {
      return;
    }
    widget.onSubmit(
      title,
      value,
      _selectedDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: <Widget>[
              AdaptativeTextField(
                controller: _titleController,
                onSubmitted: (_) => _submitForm(),
                label: 'Título',
              ),
              AdaptativeTextField(
                controller: _valueController,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onSubmitted: (_) => _submitForm(),
                label: 'Valor (R\$)',
              ),
              AdaptativeDatePicker(
                selectedDate: _selectedDate,
                onDateChanged: (newDate) {
                  setState(() {
                    _selectedDate = newDate;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  AdaptativeButton(
                    label: 'Nova Tranação',
                    onPressed: _submitForm,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
