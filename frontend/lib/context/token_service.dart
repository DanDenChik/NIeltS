import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:nielts/constants/urls.dart';

class TokenService {
  final storage = const FlutterSecureStorage();
  final String _refreshTokenKey = 'refresh';
  final String _accessTokenKey = 'access';

  Future<void> saveRefreshToken(String refreshToken) async {
    await storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: _refreshTokenKey);
  }

  Future<void> saveAccessToken(String accessToken) async {
    await storage.write(key: _accessTokenKey, value: accessToken);
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: _accessTokenKey);
  }

  Future<void> deleteTokens() async {
    await storage.delete(key: _refreshTokenKey);
    await storage.delete(key: _accessTokenKey);
  }

  Future<void> refreshToken() async {
    final refreshToken = await getRefreshToken();
    
    if (refreshToken != null) {
      final response = await http.post(
        Uri.parse(refreshRef), 
        body: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final accessToken = response.body;
        await saveAccessToken(accessToken);
      } else {
        print('cringe');
      }
    }
  }
  Future<bool> isLoggedIn() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }
}
