import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nielts/constants/urls.dart';
import 'package:nielts/context/token_service.dart';

Future<Word> fetchRandomWord(String level) async {
  final String? access = await TokenService().getAccessToken();
  final response = await http.get(
    Uri.parse('$loadWordCardRef$level/'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access',
    },
  );
  if (response.statusCode == 200) {
    return Word.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Failed to load word');
  }
}

class Word {
  final String word;
  final String definition;
  final List<String> synonyms;
  final String exampleSentence;
  final String translation;

  Word({
    required this.word,
    required this.definition,
    required this.synonyms,
    required this.exampleSentence,
    required this.translation,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'],
      definition: json['definition'],
      synonyms: List<String>.from(json['synonyms']),
      exampleSentence: json['example_sentence'],
      translation: json['translation'],
    );
  }
}

class WordCard extends StatelessWidget {
  final Word word;

  const WordCard({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: const Color(0xFFFDFDFD),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                word.word,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 40.0),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Definition: ",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextSpan(
                      text: word.definition,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 75.0),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Synonyms: ",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextSpan(
                      text: word.synonyms.join(', '),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 75.0),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Example sentence: ",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextSpan(
                      text: word.exampleSentence,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 75.0),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Translation: ",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextSpan(
                      text: word.translation,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
