import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String pageTitle;
  const Header({Key? key, required this.pageTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Text(
            pageTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Container(
            height: 3,
            decoration: const BoxDecoration(color: Color(0xff71C309))),
      ],
    );
  }
}
