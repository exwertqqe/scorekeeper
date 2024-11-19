import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateGradeScreen extends StatefulWidget {
  const CreateGradeScreen({super.key});

  @override
  _CreateGradeScreenState createState() => _CreateGradeScreenState();
}

class _CreateGradeScreenState extends State<CreateGradeScreen> {
  // Створюємо контролери для текстових полів
  final _subjectController = TextEditingController();
  final _dayMonthYearController = TextEditingController();
  final _gradeController = TextEditingController();
  // ініціалізація Firebase Firestore та FirebaseAuth
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Функція для створення або оновлення оцінки
  Future<void> _createOrUpdateGrade() async {
    final user = _auth.currentUser; // Отримуємо поточного користувача
    // Якщо користувач не авторизований
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not logged in')),
      );
      return;
    }

    // Отримуємо введені значення з полів
    final userId = user.uid;
    final subject = _subjectController.text;
    final date = _dayMonthYearController.text;
    final grade = _gradeController.text;

    // Перевіряємо, чи заповнені всі поля
    if (subject.isEmpty || date.isEmpty || grade.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields!')),
      );
      return; // Якщо ні — вийти з функції
    }

    final gradesRef = _firestore.collection('grades').doc(userId);
    final userGrades = await gradesRef.get();

    // Якщо документ існує, додаємо нову оцінку
    if (userGrades.exists) {
      await gradesRef.update({
        'grades': FieldValue.arrayUnion([{
          'subject': subject,
          'date': date,
          'grade': grade,
        }])
      });
    } else {
      // Якшо документа немає, створюємо новий документ для користувача
      await gradesRef.set({
        'grades': [{
          'subject': subject,
          'date': date,
          'grade': grade,
        }]
      });
    }

    // повідомлення про успішне збереження
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grade saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create new grade',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fill in the details of the grade you want to create.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                hintText: 'Enter subject',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _dayMonthYearController,
              decoration: InputDecoration(
                hintText: 'Enter date (Day, Month, Year)',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _gradeController,
              decoration: InputDecoration(
                hintText: 'Enter grade',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _createOrUpdateGrade,
                child: const Text(
                  'Save Grade',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const Spacer(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
