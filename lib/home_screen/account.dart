import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 160,
        centerTitle: true,
        title: const Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage('assets/profile_image.png'),
            ),
            SizedBox(height: 8),
            Text(
              'Hello, User User',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            Text(
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
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Edit profile'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
              },
            ),
            ListTile(
              title: const Text('Change password'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
              },
            ),
            ListTile(
              title: const Text('Delete account'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
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
              },
            ),
          ],
        ),
      ),

    );
  }
}
