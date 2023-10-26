import 'package:flutter/material.dart';
import 'package:nielts/components/header.dart';
import 'package:nielts/context/token_service.dart';
import 'package:nielts/screens/auth/login_screen.dart';
import 'package:nielts/screens/profile/blocks/friends.dart';
import 'package:nielts/screens/profile/blocks/statistics.dart';
import 'blocks/block.dart';

class ProfileScreen extends StatelessWidget {
  final int? userId;

  const ProfileScreen({Key? key, this.userId}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Header(pageTitle: 'Profile'),
                  const SizedBox(height: 10),
                  ProfileBlock(userId: userId),
                  const SizedBox(height: 15),
                  StatisticsBlock(userId: userId),
                  const SizedBox(height: 15),
                  if (userId == null) const FriendsBlock(),
                  if (userId == null) ElevatedButton(
                      onPressed: () async {
                        await logout(context);
                      },
                      child: const Text('Logout'),
                    ),
                ],
              ))),
    );
  }
  Future<void> logout(BuildContext context) async {
    final tokenService = TokenService();
    await tokenService.deleteTokens();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
