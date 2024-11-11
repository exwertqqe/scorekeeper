import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// Стан екрана HomeScreen
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Індеекс вибраної вкладки
  late User? _user;  // Змінна для користувача, що зараз увійшов

  // Ініціалізація стану
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser; // Отримуємо поточного користувача з Firebase
  }

  // Список екранів для навігації (зміст для кожної вкладки)
  final List<Widget> _screens = <Widget>[
    const HomeScreenContent(),
    const Center(child: Text('Your grade')),
    const AccountScreen(),
  ];

// Функція для зміни вибраної вкладки
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Your grade'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        currentIndex: _selectedIndex, // Поточний індекс вкладки
        selectedItemColor: Colors.green, // Колір для вибраної іконки
        unselectedItemColor: Colors.grey, // Колір для невибраних вкладок
        onTap: _onItemTapped, // Обробник натискання на вкладки
      ),
    );
  }
}

// Контент головного екрану
class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Отримуємо email поточного користувача з Firebase
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? "User";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 55.0),
              child: Image.asset(
                'assets/scorekeeper_logo.png',
                height: 80,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $userEmail',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Track Today, Succeed\nTomorrow.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to grade creation screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 16.0),
                ),
                child: const Text(
                  'Create your grade',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Account Settings'),
    );
  }
}
