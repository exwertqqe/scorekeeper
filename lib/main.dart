import 'package:flutter/material.dart';
import 'package:scorekeeper/register_screen.dart';
import 'package:scorekeeper/sing_in_screen.dart';
import 'forgot_pass_screen.dart';


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
