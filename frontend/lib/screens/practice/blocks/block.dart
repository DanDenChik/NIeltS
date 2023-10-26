import 'package:flutter/material.dart';
import 'package:nielts/screens/practice/word_cards.dart';

class PracticeBlock extends StatelessWidget {
  const PracticeBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Select your level',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const CustomLevelSelector(
          title: 'Beginner',
          button1Text: 'A1',
          button2Text: 'A2',
          nextPage1: RandomWordScreen(level: 'A1'),
          nextPage2: RandomWordScreen(level: 'A2'),
        ),
        const CustomLevelSelector(
          title: 'Intermediate',
          button1Text: 'B1',
          button2Text: 'B2',
          nextPage1: RandomWordScreen(level: 'B1'),
          nextPage2: RandomWordScreen(level: 'B2'),
        ),
        const CustomLevelSelector(
          title: 'Advanced',
          button1Text: 'C1',
          button2Text: 'C2',
          nextPage1: RandomWordScreen(level: 'C1'),
          nextPage2: RandomWordScreen(level: 'C2'),
        ),
      ]),
    );
  }
}

class CustomLevelSelector extends StatelessWidget {
  final String title;
  final String button1Text;
  final String button2Text;
  final Widget nextPage1;
  final Widget nextPage2;

  const CustomLevelSelector({super.key, 
    required this.title,
    required this.button1Text,
    required this.button2Text,
    required this.nextPage1,
    required this.nextPage2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 25),
        Text(
          title,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 25),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => nextPage1),
            );
          },
          child: Text(
            button1Text,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => nextPage2),
            );
          },
          child: Text(
            button2Text,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 25),
        Container(
          height: 3,
          decoration: const BoxDecoration(color: Color(0xFFD9D9D9))),
      ],
    );
  }
}