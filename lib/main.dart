import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:scorekeeper/home_screen/home.dart';
import 'register_screen/register_screen.dart';
import 'sing_in_screen/sing_in_screen.dart';
import 'forgot_password_screen/forgot_pass_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

Future<bool> checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  // Перевірка, чи збережено статус входу
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  return isLoggedIn;
}

Future<void> setLoginStatus(bool status) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', status);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Urbanist',
      ),
      home: FutureBuilder(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Перевірка статусу авторизації через Firebase
          User? user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            // Якщо користувач залогінений через Firebase, відправляємо на головну сторінку
            return const HomeScreen();
          } else {
            // Якщо користувач не залогінений, відправляємо на екран входу
            return const SignInScreen();
          }
        },
      ),
      routes: {
        '/signIn': (context) => const SignInScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgotPass': (context) => const ForgotPassScreen(),
      },
    );
  }
}
