import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onLogout;

  UserInfo({required this.userData, required this.onLogout});

  String _getUserName() => userData['name'] ?? 'Unknown';
  String _getUserId() => userData['id'] ?? 'Unknown';
  String _getUserEmail() => userData['email'] ?? 'Unknown';
  String _getUserPictureUrl() => userData['picture']['data']['url'] ?? '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Logged in as: ${_getUserName()}'),
        const SizedBox(height: 20),
        Text('Email: ${_getUserEmail()}'),
        const SizedBox(height: 20),
        Text('User Id: ${_getUserId()}'),
        const SizedBox(height: 20),
        Image.network(_getUserPictureUrl()),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onLogout,
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
