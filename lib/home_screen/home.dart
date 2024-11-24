import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_grade_screen.dart';
import 'package:scorekeeper/sing_in_screen/sing_in_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Змінна для збереження індексу вибраної вкладки
  late User? _user;

  @override
  void initState() {
    super.initState();
    // Отримання поточного користувача з Firebase
    _user = FirebaseAuth.instance.currentUser;
  }

  // Метод для зміни вкладки при натисканні
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // навігаційне меню
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _selectedIndex == 0
          ? const HomeScreenContent()
          : _selectedIndex == 1
          ? const GradesScreen()
          : const AccountScreen(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Your grade'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Контент для головного екрану
class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Отримання email користувача
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? "User";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Image.asset(
            'assets/scorekeeper_logo.png',
            height: 80,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateGradeScreen()),
                  );
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
            const SizedBox(height: 50),
            const LastGradeSection(),
          ],
        ),
      ),
    );
  }
}

// віджет last grade
class LastGradeSection extends StatelessWidget {
  const LastGradeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('grades')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Center(child: Text("No grades available."));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final grades = data['grades'] as List<dynamic>?;

        if (grades == null || grades.isEmpty) {
          return const Center(child: Text("No grades available."));
        }

        // Get the last 4 grades
        final lastGrades = grades
            .map((e) => e as Map<String, dynamic>)
            .toList()
            .reversed
            .take(4)
            .toList();

        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Last Grades:',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...lastGrades.map((gradeData) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // вирівнюємо
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        gradeData['date'] ?? 'No date available',
                        style: const TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(
                        Icons.book,
                        color: Colors.green,
                      ),
                      title: Text(
                        gradeData['subject'] ?? 'Unknown Subject',
                        style: const TextStyle(fontSize: 18),
                      ),
                      trailing: Text(
                        'Grade: ${gradeData['grade'] ?? 'N/A'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const Divider(thickness: 1, color: Colors.grey),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

// Екран для перегляду та видалення оцінок
class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  _GradesScreenState createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  String _searchDate = ""; // Змінна для фільтрації оцінок за датою

  Future<void> _deleteGrade(int index) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final docRef = FirebaseFirestore.instance.collection('grades').doc(userId);

      // Отримуємо поточний документ з бази данних
      final snapshot = await docRef.get();
      if (!snapshot.exists || snapshot.data() == null) {
        throw Exception("User grades document does not exist.");
      }

      final data = snapshot.data() as Map<String, dynamic>;
      final grades = (data['grades'] as List<dynamic>);

      if (index < 0 || index >= grades.length) {
        throw Exception("Invalid index: $index");
      }

      // Видалити елемент за індексом
      grades.removeAt(index);

      // Оновити документ з новим масивом
      await docRef.update({'grades': grades});
    } catch (e) {
      // можна додати помилку
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Your Grades',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Поле пошуку за датою
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by Date (dd.mm.yyyy)',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchDate = value.trim();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('grades')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.data() == null) {
                  return const Center(child: Text("No grades available."));
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;
                final grades = data['grades'] as List<dynamic>?;

                if (grades == null || grades.isEmpty) {
                  return const Center(child: Text("No grades available."));
                }

                // Сортуємо оцінки за датою та фільтруємо за пошуком
                final filteredGrades = grades
                    .map((e) => e as Map<String, dynamic>)
                    .where((gradeData) =>
                _searchDate.isEmpty ||
                    (gradeData['date'] ?? "").contains(_searchDate))
                    .toList()
                  ..sort((a, b) => (b['date'] ?? "").compareTo(a['date'] ?? ""));

                // Групуємо оцінки за датою
                Map<String, List<Map<String, dynamic>>> groupedGrades = {};
                for (var grade in filteredGrades) {
                  String date = grade['date'] ?? '';
                  if (groupedGrades.containsKey(date)) {
                    groupedGrades[date]!.add(grade);
                  } else {
                    groupedGrades[date] = [grade];
                  }
                }

                return ListView.builder(
                  itemCount: groupedGrades.keys.length,
                  itemBuilder: (context, index) {
                    String date = groupedGrades.keys.elementAt(index);
                    List<Map<String, dynamic>> gradesForDate = groupedGrades[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Виведення дати
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            date,
                            style: const TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        // Виведення оцінок для цієї дати
                        ...gradesForDate.map((grade) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                            child: ListTile(
                              leading: const Icon(
                                Icons.book,
                                color: Colors.green,
                              ),
                              title: Text(
                                grade['subject'] ?? 'Unknown Subject',
                                style: const TextStyle(fontSize: 18),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Grade: ${grade['grade'] ?? 'N/A'}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _deleteGrade(filteredGrades.indexOf(grade));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        // Лінія між групами оцінок
                        const Divider(
                          color: Colors.grey,
                          height: 2,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  // діалогового вікно для підтвердження виходу
  Future<void> _showSignOutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Are you sure you want to sign out?'),
          content: const Text('You will be logged out of the account.'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
              child: const Text('Sign Out'),
              onPressed: () async {
                await FirebaseAuth.instance.signOut(); // Вихід з аккаунту
                if (!context.mounted) return;
                Navigator.of(context).pop();

                // перекинути на екран входу
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // діалогове вікно для підтвердження зміни паролю
  Future<void> _showChangePasswordDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Do you want to change your password?'),
          content: const Text('We will send you an email to reset your password. You will be logged out after this.'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
              child: const Text('Change Password'),
              onPressed: () async {
                try {
                  // відсилаємо на пошту повідомлення
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: FirebaseAuth.instance.currentUser!.email!);

                  // викидаємо з аккаунту
                  await FirebaseAuth.instance.signOut();
                  if (!context.mounted) return;
                  Navigator.of(context).pop();

                  // перекидуємо на екран входу
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                  );
                } catch (e) {
                  // помилка
                  print("Error sending password reset email: $e");
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Метод видалення даних користувача з Firestore (не працює)
  Future<void> _deleteUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
        print("User data deleted successfully.");
      } catch (e) {
        print("Error deleting user data: $e");
      }
    }
  }

  // діалог попередження для видалення аккаунту
  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Are you sure you want to delete your account?'),
          content: const Text('This will permanently delete your account and all associated data.'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete Account'),
              onPressed: () async {
                try {
                  // видалення данних користувача з firestore(теж не працює)
                  await _deleteUserData();

                  // видалення аккаунту
                  await FirebaseAuth.instance.currentUser!.delete();
                  if (!context.mounted) return; // фіксим варнінг Do not use BuildContexts across async gaps
                  Navigator.of(context).pop();

                  // перекидуємо на екран входу
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                  );
                } catch (e) {
                  // batman
                  print("Error deleting account: $e");
                  if (!context.mounted) return;
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Метод для відображення діалогу про розробника
  Future<void> _showDeveloperInfoDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('About the developer'),
          content: const Text(
            'Dmytro Zenko, course work, KN-32 LNTU',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green, // Колір тексту кнопки
              ),
              child: const Text('Ок'),
              onPressed: () {
                Navigator.of(context).pop(); // Закриває діалогове вікно
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? "User";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 160,
        centerTitle: true,
        title: Column(
          children: [
            const CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage('assets/avatar.png'),
            ),
            const SizedBox(height: 8),
            Text(
              'Hello, $userEmail',
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            const Text(
              'Ready to workout?',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Account Settings',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            ListTile(
              title: const Text('Sign out of the account'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showSignOutDialog(context);
              },
            ),
            ListTile(
              title: const Text('Change password'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showChangePasswordDialog(context); // виклик діалогу
              },
            ),
            ListTile(
              title: const Text('Delete account'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showDeleteAccountDialog(context);
              },
            ),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              'More',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('About the developer'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showDeveloperInfoDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}







