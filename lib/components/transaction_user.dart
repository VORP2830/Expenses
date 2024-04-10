import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'transaction_form.dart';
import 'transaction_list.dart';

class TransactionUser extends StatefulWidget {
  const TransactionUser({super.key});

  @override
  State<TransactionUser> createState() => _TransactionUserState();
}

class _TransactionUserState extends State<TransactionUser> {
  final _transactions = [
    Transaction(
      id: 'T1',
      title: 'Tenis de corrida',
      value: 999.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 'T2',
      title: 'Conta de energia',
      value: 211.36,
      date: DateTime.now(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TransactionList(
          _transactions,
        ),
        TransctionForm(),
      ],
    );
  }
}
