import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nielts/context/token_service.dart';
import 'package:nielts/constants/urls.dart';
import 'package:http/http.dart' as http;

class GapFillQuestion {
  final String question;
  final List<String> options;
  final int correctOption;

  GapFillQuestion({
    required this.question,
    required this.options,
    required this.correctOption,
  });

  factory GapFillQuestion.fromJson(Map<String, dynamic> json) {
    return GapFillQuestion(
      question: json['question'],
      options: [
        json['option_1'],
        json['option_2'],
        json['option_3'],
        json['option_4']
      ],
      correctOption: json['correct_option'],
    );
  }
}

class GapFillTestScreen extends StatefulWidget {
  const GapFillTestScreen({super.key});

  @override
  State<GapFillTestScreen> createState() => _GapFillTestScreenState();
}

class _GapFillTestScreenState extends State<GapFillTestScreen> {
  late Future<GapFillQuestion> futureQuestion;

  Future<GapFillQuestion> fetchRandomGapFillQuestion() async {
    final String? access = await TokenService().getAccessToken();
    final response = await http.get(
      Uri.parse(loadTestGapFillRef),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access',
      },
    );
    if (response.statusCode == 200) {
      return GapFillQuestion.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load question');
    }
  }

  @override
  void initState() {
    super.initState();
    futureQuestion = fetchRandomGapFillQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<GapFillQuestion>(
        future: fetchRandomGapFillQuestion(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Text(
                    snapshot.data!.question,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(4, (index) {
                    return Column(children: [
                      ElevatedButton(
                        onPressed: () {
                          if (index + 1 == snapshot.data!.correctOption) {
                            setState(() {
                              futureQuestion = fetchRandomGapFillQuestion();
                            });
                          } else {
                            // Показать ошибку
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Incorrect! Try again.')),
                            );
                          }
                        },
                        child: Text(snapshot.data!.options[index]),
                      ),
                      const SizedBox(height: 20),
                    ]);
                  }),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
