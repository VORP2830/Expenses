import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeButton extends StatelessWidget {
  final String label;
  final Function onPressed;

  AdaptativeButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              label,
            ),
            onPressed: null,
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            )
          )
        : ElevatedButton(
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).textTheme.button!.color,
              ),
            ),
            onPressed: null,
          );
  }
}
