import 'package:flutter/material.dart';
import 'package:nielts/components/header.dart';
import 'blocks/block.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(pageTitle: 'Practice'),
              SizedBox(height: 10),
              PracticeBlock(),
            ],
          ) 
        )
      ),
    );
  }
}


