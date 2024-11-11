import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scorekeeper/register_screen/successful_register.dart';
import '../sing_in_screen/sing_in_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState(); // Повертаємо стан для цього екрану
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Ініціалізація контролерів для текстових полів ( отримуємо данні полів)
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String errorMessage = ''; // Змінна для зберігання повідомлення про помилки

  // Ініціалізація FirebaseAuth для реєстрації користувачів
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Функція для реєстрації користувача
  void _register() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in all fields'; // Виводимо повідомлення, якщо поля порожні
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        errorMessage = 'Passwords do not match'; // Виводимо повідомлення, якщо паролі не співпадають
      });
      return;
    }

    setState(() {
      errorMessage = ''; // Очищаємо попередні помилки
    });

    try {
      // Якщо користувач успішно створений, переходимо на екран успішної реєстрації
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // перевірка чи користувач успішно створений
      if (userCredential.user != null) {
        // переходимо на екран упішної регистрації
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SuccessfulRegisterScreen()),
        );
      } else {
        setState(() {
          errorMessage = 'Registration failed. Please try again.'; // невдача
        });
      }
    } on FirebaseAuthException catch (e) {
      // Заміна помилок від firebase
      setState(() {
        if (e.code == 'weak-password') {
          errorMessage = 'The password is too weak. Please use at least 6 characters.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The email is already registered. Please use a different email.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is not valid.';
        } else {
          // Log unexpected FirebaseAuth errors with details
          errorMessage = 'Registration failed: ${e.message}';
          print('FirebaseAuthException: ${e.code} - ${e.message}');
        }
      });
    } catch (e) {
      setState(() {
      });

      // Перехід на екран успішної реєстрації
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SuccessfulRegisterScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch, // Розтягуємо елементи на всю ширину
          children: [
            Center(
              child: Image.asset(
                'assets/scorekeeper_logo.png',
                height: 100.0,
              ),
            ),
            const SizedBox(height: 8.0), // Відступ між елементами
            const Center(
              child: Text(
                'Register to get started!',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            _buildTextField('Email', controller: emailController),
            const SizedBox(height: 16.0),
            _buildTextField('Password', obscureText: true, controller: passwordController),
            const SizedBox(height: 16.0),
            _buildTextField('Confirm Password', obscureText: true, controller: confirmPasswordController),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
            if (errorMessage.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 16.0),
            const Center(
              child: Text(
                'Or register with',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: SizedBox(
                width: 60.0,
                height: 60.0,
                child: IconButton(
                  icon: Image.asset('assets/google_ic.png'),
                  iconSize: 40.0,
                  onPressed: () {
                    // TODO: Add Google Register Logic
                  },
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Login Now',
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, {bool obscureText = false, TextEditingController? controller}) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        hintText: labelText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
