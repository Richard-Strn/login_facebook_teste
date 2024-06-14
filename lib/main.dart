import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  String _loginStatus = 'Logged out';

  void _login() async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
    );

    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;
      final userData = await FacebookAuth.instance.getUserData();
      setState(() {
        _userData = userData;
        _loginStatus = 'Logged in';
      });
    } else {
      setState(() {
        _loginStatus = result.status.toString();
      });
    }
  }

  void _logout() async {
    await FacebookAuth.instance.logOut();
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
        title: Text('Facebook Auth Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_userData == null)
              ElevatedButton(
                child: Text('Login with Facebook'),
                onPressed: _login,
              )
            else
              Column(
                children: [
                  Text('Logged in as: ${_userData!['name']}'),
                  SizedBox(height: 20),
                  Text('Email: ${_userData!['email']}'),
                  SizedBox(height: 20),
                  Text('User Id: ${_userData!['id']}'),
                  SizedBox(height: 20),
                  Image.network(_userData!['picture']['data']['url']),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('Logout'),
                    onPressed: _logout,
                  ),
                ],
              ),
            SizedBox(height: 20),
            Text('Login Status: $_loginStatus'),
            SizedBox(height: 20),
            if (_accessToken != null)
              Text('Access Token: ${_accessToken!.tokenString}'),
          ],
        ),
      ),
    );
  }
}
