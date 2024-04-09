import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomeApp(),
    );
  }
}

class MyHomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Despesas Pessoais',
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Card(
              child: Text(
                'Grafico',
              ),
              elevation: 5,
            ),
          ),
          Card(
            child: Text(
              'Lista de Transações',
            ),
          ),
        ],
      ),
    );
  }
}
