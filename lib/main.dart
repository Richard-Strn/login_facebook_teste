import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xml/xml.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() async {
// Carregar variáveis do arquivo .env
  await dotenv.load(fileName: ".env");
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
  String _xmlContent = '';

  @override
  void initState() {
    super.initState();
    _loadXml();
  }

  Future<void> _loadXml() async {
    try {
      // Carrega o arquivo XML
      final xmlString = await rootBundle
          .loadString('android/app/src/main/res/values/strings.xml');
      String updatedXmlString = xmlString;
      print("xmlAntes, \n${updatedXmlString}");

      // Substitui as variáveis no conteúdo do XML
      dotenv.env.forEach((key, value) {
        updatedXmlString = updatedXmlString.replaceAll('{{$key}}', value);
      });

      // Atualiza xml
      final document = XmlDocument.parse(updatedXmlString);

      // Converte o XML em uma string formatada
      setState(() {
        _xmlContent = document.toXmlString(pretty: true);
        print("xmlDepois,\n${_xmlContent}");
      });
    } catch (e) {
      setState(() {
        _xmlContent = 'Erro ao carregar o arquivo XML: $e';
      });
    }
  }

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
