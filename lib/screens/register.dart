import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bw_treka/provider/auth.dart';

class Register extends StatelessWidget {
  const Register({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Container(
      color: Colors.white,
      child: TextButton(
          child: Text('REGISTER'),
          onPressed: () {
            auth.signIn();
          }),
    );
  }
}
