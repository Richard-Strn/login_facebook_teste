import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookAuthService {
  static Future<Map<String, dynamic>> login() async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
    );

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();
      return {
        'status': 'Logged in',
        'userData': userData,
        'accessToken': result.accessToken,
      };
    }

    return {
      'status': result.status.toString(),
      'userData': null,
      'accessToken': null,
    };
  }

  static Future<void> logout() async {
    await FacebookAuth.instance.logOut();
  }
}
