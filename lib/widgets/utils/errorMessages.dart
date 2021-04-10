import 'package:flutter/material.dart';

class SimpleErrorMessage extends StatelessWidget {
  const SimpleErrorMessage({Key? key, required this.snapshotError})
      : super(key: key);
  final String snapshotError;
  @override
  Widget build(BuildContext context) {
    return errorMessage('$snapshotError');
  }
}

Widget errorMessage(String messsage) {
  return Column(
    children: <Widget>[
      const Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 60,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text('Error: $messsage'),
      )
    ],
  );
}
