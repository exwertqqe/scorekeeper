import 'package:flutter/material.dart';
import 'create_grade_screen.dart';
import 'account.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Трекер вибраного індексу

  // Список екранів для кожної вкладки
  static const List<Widget> _screens = <Widget>[
    HomeScreenContent(), // Основний контент екрану
    Center(child: Text('Your grade')), // Placeholder для екрана "Your grade"
    AccountScreen(), // Екран акаунту
  ];

  // Оновлюємо вибраний індекс при натисканні
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex], // Показуємо вибраний екран
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Your grade'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped, // Оновлення індексу при натисканні
      ),
    );
  }
}

// Окремий віджет для контенту головного екрану
class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'Hello, User User',
              style: TextStyle(
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
                  // Перехід на CreateGradeScreen при натисканні на кнопку
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateGradeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Create new grade',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Last Grade:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '24 May, 2024',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const ListTile(
              title: Text(
                'Math',
                style: TextStyle(fontSize: 18),
              ),
              trailing: Text(
                'Grade: 5',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const ListTile(
              title: Text(
                'IT',
                style: TextStyle(fontSize: 18),
              ),
              trailing: Text(
                'Grade: 5',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const ListTile(
              title: Text(
                'English',
                style: TextStyle(fontSize: 18),
              ),
              trailing: Text(
                'Grade: 5',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
