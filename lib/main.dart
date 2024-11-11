import 'package:flutter/material.dart';
import 'register_screen/register_screen.dart';  // Імпортуємо RegisterScreen
import 'sing_in_screen/sing_in_screen.dart';  // Імпортуємо SignInScreen
import 'forgot_password_screen/forgot_pass_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        '/register': (context) => const RegisterScreen(),  // Оновлений маршрут для реєстрації
        '/forgotPass': (context) => const ForgotPassScreen(),
      },
    );
  }
}
