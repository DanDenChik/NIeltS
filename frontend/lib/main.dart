import 'package:nielts/screens/homepage.dart';
import 'package:nielts/context/token_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TokenService _tokenService = TokenService();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IELTS prep',
      theme: ThemeData.light().copyWith(
        textTheme: const TextTheme(
            titleLarge: TextStyle(
              color: Color(0xFF1A1A1A),
              fontWeight: FontWeight.w500,
              fontSize: 21,
              fontFamily: 'Poppins',
            ),
            titleMedium: TextStyle(
              color: Color(0xFF1A1A1A),
              fontWeight: FontWeight.w500,
              fontSize: 18,
              fontFamily: 'Poppins',
            ),
            titleSmall: TextStyle(
              color: Color(0xFF1A1A1A),
              fontWeight: FontWeight.w500,
              fontSize: 15,
              fontFamily: 'Poppins',
            ),
            bodyLarge: TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 15,
              fontFamily: 'Poppins',
            ),
            bodyMedium: TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 15,
              fontFamily: 'Poppins',
            ),
            bodySmall: TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 18,
              fontFamily: 'Poppins',
            )),
        scaffoldBackgroundColor: const Color(0xFFFEFEFE),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF71C309),
          secondary: Color(0xFFFEFEFE),
          background: Color(0xFFFEFEFE),
          surface: Color(0xFFFDFDFD),
          error: Colors.red,
          onPrimary: Color(0xFFFEFEFE),
          onSecondary: Color(0xFF1A1A1A),
          onBackground: Color(0xFF1A1A1A),
          onSurface: Color(0xFF1A1A1A),
          onError: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Color(0xFF1A1A1A)),
          hintStyle: TextStyle(color: Color(0xFF1A1A1A)),
        ),
      ),
      home: FutureBuilder<bool>(
        future: _tokenService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.hasData && snapshot.data == true) {
              return const HomePage();
            } else {
              return Builder(
                builder: (context) => const HomePage(),
              );
            }
          }
        },
      ),
    );
  }
}
