import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nielts/constants/urls.dart';
import 'package:nielts/context/token_service.dart';
import 'package:http/http.dart' as http;

class ProfileBlock extends StatefulWidget {
  final int? userId;

  const ProfileBlock({Key? key, this.userId}) : super(key: key);

  @override
  State<ProfileBlock> createState() => _ProfileBlockState();
}

class _ProfileBlockState extends State<ProfileBlock> {
  Map<String, dynamic>? userProfile;

  Future<void> _fetchProfileData() async {
    final String? access = await TokenService().getAccessToken();
    final String url = widget.userId != null ? profileRef + widget.userId.toString() : profileRef;
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        userProfile = json.decode(response.body);
      });
    } else {
      print('Error viewing profile.');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }


  @override
  Widget build(BuildContext context) {
    if (userProfile == null) {
      return const CircularProgressIndicator();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/profile_image.jpg',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${userProfile!['first_name']} ${userProfile!['last_name']}',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '@${userProfile!['username']}',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
