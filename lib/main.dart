import 'package:flutter/material.dart';
import 'register_screen/register_screen.dart';
import 'sing_in_screen/sing_in_screen.dart';
import 'forgot_password_screen/forgot_pass_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Urbanist', // Встановлення шрифту Urbanist за замовчуванням
      ),
      home: const SignInScreen(), // Початковий екран
      routes: {
        '/signIn': (context) => const SignInScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgotPass': (context) => const ForgotPassScreen(),
      },
    );
  }
}
