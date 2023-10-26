// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:nielts/constants/urls.dart';
import 'package:nielts/screens/homepage.dart';
import 'package:nielts/screens/auth/login_screen.dart';
import 'package:nielts/context/token_service.dart';
import 'package:nielts/context/token_refresh_timer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistrationBlock extends StatefulWidget {
  const RegistrationBlock({super.key});

  @override
  State<RegistrationBlock> createState() => _RegistrationBlockState();
}

class _RegistrationBlockState extends State<RegistrationBlock> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  Future<void> _register() async {
    final response = await http.post(
      Uri.parse(registerRef),
      body: json.encode({
        'username': _usernameController.text,
        'password': _passwordController.text,
        'confirm_password': _confirmPasswordController.text,
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    final responseBody = json.decode(response.body);

    if (response.statusCode == 201) {
      final responseBody = json.decode(response.body);

      if (responseBody.containsKey('access') && responseBody.containsKey('refresh')) {
          final access = responseBody['access'];
          final refresh = responseBody['refresh'];

          if (access != null && refresh != null) {
              await TokenService().saveAccessToken(access);
              await TokenService().saveRefreshToken(refresh);
          } else {
              print('Access or Refresh token is null: $responseBody');
          }

      } else {
          print('Response does not contain expected keys: $responseBody');
      }

      TokenRefreshTimer().start();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      final errorText = responseBody['error'] ?? 'An error occurred.';
      String formatError(dynamic errorData) {
        if (errorData is String) {
          return errorData;
        } else if (errorData is Map<String, dynamic>) {
          List<String> errorMessages = [];
          errorData.forEach((key, value) {
            if (value is List<dynamic>) {
              List<String> messages = value.map((item) => '$item').toList();
              errorMessages.addAll(messages);
            } else {
              errorMessages.add('$value');
            }
          });
          return errorMessages.join('\n');
        } else {
          return 'An error occurred.';
        }
      }

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Registration Error'),
            content: Text(formatError(errorText)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFEFEFE),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username')),
            TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password')),
            TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Password confirm')),
            TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First name')),
            TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last name')),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _register,
                child: const Text(
                  'Register',
                  textWidthBasis: TextWidthBasis.parent,
                )),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                text: 'Already have an account? ',
                style: Theme.of(context).textTheme.bodySmall,
                children: <TextSpan>[
                  TextSpan(
                    text: 'SignIn',
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Material(
                              child: LoginScreen(),
                            ),
                          ),
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
