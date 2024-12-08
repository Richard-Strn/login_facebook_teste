import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _Facebook createState() => _Facebook();
}

class _Facebook extends State<HomeScreen> {
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  String _loginStatus = 'Logged out';

  Future<void> _login() async {
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

  Future<void> _logout() async {
    await FacebookAuth.instance.logOut();
    setState(() {
      _userData = null;
      _accessToken = null;
      _loginStatus = 'Logged out';
    });
  }

  String _getUserName() {
    return _userData != null ? _userData!['name'] : 'Unknown';
  }

  String _getUserId() {
    return _userData != null ? _userData!['id'] : 'Unknown';
  }

  String _getUserEmail() {
    return _userData != null ? _userData!['email'] : 'Unknown';
  }

  String _getUserPictureUrl() {
    return _userData != null ? _userData!['picture']['data']['url'] : '';
  }

  String _getUserToken() {
    return _accessToken != null ? _accessToken!.tokenString : 'No Token';
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
                  Text('Logged in as: ${_getUserName()}'),
                  SizedBox(height: 20),
                  Text('Email: ${_getUserEmail()}'),
                  SizedBox(height: 20),
                  Text('User Id: ${_getUserId()}'),
                  SizedBox(height: 20),
                  Image.network(_getUserPictureUrl()),
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
            Text('Access Token: ${_getUserToken()}'),
          ],
        ),
      ),
    );
  }
}
