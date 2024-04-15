import 'dart:ui';
import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'components/transaction_form.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  final ThemeData tema = ThemeData();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomeApp(),
      theme: ThemeData(
        primaryColor: Colors.purple,
        secondaryHeaderColor: Colors.amber,
        useMaterial3: true,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleMedium: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              labelLarge: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          titleTextStyle: ThemeData.light().textTheme.headline6!.copyWith(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}

class MyHomeApp extends StatefulWidget {
  @override
  State<MyHomeApp> createState() => _MyHomeAppState();
}

final List<Transaction> _transactions = [];

List<Transaction> get _recentTransactions {
  return _transactions.where(
    (t) {
      return t.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    },
  ).toList();
}

class _MyHomeAppState extends State<MyHomeApp> {
  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(
        newTransaction,
      );
    });

    Navigator.of(
      context,
    ).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere(
        (tr) {
          return tr.id == id;
        },
      );
    });
  }

  _openTransctionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        'Despesas Pessoais',
      ),
      backgroundColor: Theme.of(context).primaryColor,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add,
          ),
          onPressed: () => _openTransctionFormModal(context),
        )
      ],
    );

    final availableHeight = MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top;
    
    return Scaffold(
      appBar: appBar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: availableHeight * 0.3,
            child: Chart(
              _recentTransactions,
            ),
          ),
          Expanded(
            child: Container(
              height: availableHeight * 0.7,
              child: TransactionList(
                _transactions,
                _removeTransaction,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            30,
          ),
        ),
        onPressed: () => _openTransctionFormModal(context),
      ),
    );
  }
}
