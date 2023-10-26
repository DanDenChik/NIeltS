import 'package:flutter/material.dart';
import 'package:nielts/components/header.dart';
import 'package:nielts/screens/test/blocks/gapfill.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(pageTitle: 'Test'),
              SizedBox(height: 10),
              GapFillTestScreen(),
            ],
          ) 
        )
      ),
    );
  }
}


