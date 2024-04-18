import 'dart:io';
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
bool _showChart = false;

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

  Widget _getIconButton(IconData icon, Function() fn) {
    return Platform.isIOS
        ? GestureDetector(
            onTap: fn,
            child: Icon(
              icon,
            ),
          )
        : IconButton(
            icon: Icon(
              icon,
            ),
            onPressed: fn,
          );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandScap = mediaQuery.orientation == Orientation.landscape;
    final iconList = Platform.isIOS ? CupertinoIcons.square_list : Icons.list_alt_rounded;
    final chartIcon = Platform.isIOS ? CupertinoIcons.chart_bar_fill : Icons.bar_chart_rounded;
    final actions = <Widget>[
      if (isLandScap)
        _getIconButton(
          _showChart ? iconList : chartIcon,
          () {
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _openTransctionFormModal(context),
      ),
    ];
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Despesas pessoais'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            )
          )
        : AppBar(
            title: Text(
              'Despesas pessoais',
              style: TextStyle(
                fontSize: 20 * mediaQuery.textScaleFactor,
              ),
            ),
            actions: actions,
          ) as PreferredSizeWidget;
    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    final bodyPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // if (isLandScap)
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       'Exibir gráfico',
            //     ),
            //     Switch.adaptive(
            //       value: _showChart,
            //       onChanged: (newValue) {
            //         setState(
            //           () {
            //             _showChart = newValue;
            //           },
            //         );
            //       },
            //     ),
            //   ],
            // ),
            if (_showChart || !isLandScap)
              Container(
                height: availableHeight * (isLandScap ? 0.8 : 0.3),
                child: Chart(
                  _recentTransactions,
                ),
              ),
            if (!_showChart || !isLandScap)
              Container(
                height: availableHeight * (isLandScap ? 1 : 0.3),
                child: TransactionList(
                  _transactions,
                  _removeTransaction,
                ),
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text('Despesas Pessoais'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            ),
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
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
