import 'package:flutter/material.dart';
import 'package:nielts/screens/auth/blocks/login_block.dart';
import 'package:nielts/components/header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color(0xFFFEFEFE),
        child: const SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(pageTitle: 'Login'),
                  Material(
                    child: LoginBlock(),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
