import 'dart:io';

class ApiConfig {
  static String get baseUrl {
    const envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }
    
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return 'http://localhost:8080';
    }
    
    return 'http://localhost:8080';
  }

  static String get notificarEndpoint => '$baseUrl/api/notificar';
  static String statusEndpoint(String mensagemId) =>
      '$baseUrl/api/notificacao/status/$mensagemId';
  static String get healthEndpoint => '$baseUrl/health';

  static const Duration requestTimeout = Duration(seconds: 30);

  static const Duration pollingInterval = Duration(seconds: 3);
}

