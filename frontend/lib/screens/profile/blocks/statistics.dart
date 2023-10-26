import 'dart:convert';

import 'package:nielts/constants/urls.dart';
import 'package:nielts/context/token_service.dart';
import 'package:flutter/material.dart';
import 'package:nielts/components/bar.dart';
import 'package:http/http.dart' as http;

class StatisticsBlock extends StatefulWidget {
  final int? userId;

  const StatisticsBlock({Key? key, this.userId}) : super(key: key);

  @override
  State<StatisticsBlock> createState() => _StatisticsBlockState();
}

class _StatisticsBlockState extends State<StatisticsBlock> {
  DateTime selectedDate = DateTime.now();
  Map<String, dynamic>? userProfile;

  int wordsCount = 0;
  int testsCount = 0;

  void _updateSelectedDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  Future<void> _fetchUserData(int? userId) async {
    final String? access = await TokenService().getAccessToken();
    final String url = widget.userId != null
        ? profileRef + widget.userId.toString()
        : profileRef;
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
    _fetchData();
  }

  _fetchData() async {
    await _fetchUserData(widget.userId);
    setState(() {
      wordsCount = userProfile?['number_of_words'];
      testsCount = userProfile?['number_of_tests'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stats',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          const Bar(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(
                title: '$wordsCount',
                value: 'Words learned',
                icon: const Icon(Icons.work),
              ),
              const SizedBox(width: 5),
              _StatItem(
                title: '$testsCount',
                value: 'Tests completed',
                icon: const Icon(Icons.border_color),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final Icon icon;

  const _StatItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xff71C309),
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              const SizedBox(width: 10),
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 5),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
