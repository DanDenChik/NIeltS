import 'dart:async';
import 'package:nielts/context/token_service.dart';

class TokenRefreshTimer {
  static const int refreshInterval = 5 * 60;
  final TokenService _tokenService = TokenService();
  late Timer _timer;

  void start() {
    _timer = Timer.periodic(const Duration(seconds: refreshInterval), (timer) async {
      await _tokenService.refreshToken();
    });
  }

  void stop() {
    _timer.cancel();
  }
}
