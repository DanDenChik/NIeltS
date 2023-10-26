import 'package:flutter/material.dart';
import 'package:nielts/components/word_card.dart';

class RandomWordScreen extends StatefulWidget {
  final String level;

  const RandomWordScreen({super.key, required this.level});

  @override
  State<RandomWordScreen> createState() => _RandomWordScreenState();
}

class _RandomWordScreenState extends State<RandomWordScreen> {
  late Future<Word> futureWord;
  Key key = UniqueKey();

  @override
  void initState() {
    super.initState();
    _loadNewWord();
  }

  _loadNewWord() {
    setState(() {
      futureWord = fetchRandomWord(widget.level);
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Random Word for ${widget.level}")),
      body: Center(
        child: FutureBuilder<Word>(
          key: key,
          future: futureWord,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return GestureDetector(
                  onTap: _loadNewWord,
                  child: AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    child: WordCard(
                        key: ValueKey(snapshot.data!.word),
                        word: snapshot.data!),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
