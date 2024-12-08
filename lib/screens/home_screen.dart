import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../services/facebook_auth_service.dart';
import '../widgets/user_info.dart';

class HomeScreen extends StatefulWidget {
  @override
  _Facebook createState() => _Facebook();
}

class _Facebook extends State<HomeScreen> {
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  String _loginStatus = 'Logged out';

  Future<void> _login() async {
    final result = await FacebookAuthService.login();
    setState(() {
      _userData = result['userData'];
      _accessToken = result['accessToken'];
      _loginStatus = result['status'];
    });
  }

  Future<void> _logout() async {
    await FacebookAuthService.logout();
    setState(() {
      _userData = null;
      _accessToken = null;
      _loginStatus = 'Logged out';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facebook Auth Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_userData == null)
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login with Facebook'),
              )
            else
              UserInfo(
                userData: _userData!,
                onLogout: _logout,
              ),
            const SizedBox(height: 20),
            Text('Login Status: $_loginStatus'),
            const SizedBox(height: 20),
            Text('Access Token: ${_accessToken?.tokenString ?? 'No Token'}'),
          ],
        ),
      ),
    );
  }
}
