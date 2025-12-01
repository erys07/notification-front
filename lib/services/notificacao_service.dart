import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/notificacao.dart';

class NotificacaoService {
  final http.Client client;

  NotificacaoService({http.Client? client}) : client = client ?? http.Client();

  Future<NotificacaoResponse> enviarNotificacao({
    required String mensagemId,
    required String conteudoMensagem,
  }) async {
    try {
      final request = NotificacaoRequest(
        mensagemId: mensagemId,
        conteudoMensagem: conteudoMensagem,
      );

      final response = await client
          .post(
            Uri.parse(ApiConfig.notificarEndpoint),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 202) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return NotificacaoResponse.fromJson(jsonResponse);
      } else {
        throw Exception(
          'Erro ao enviar notificação: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao enviar notificação: $e');
    }
  }

  Future<StatusResponse> consultarStatus(String mensagemId) async {
    try {
      final response = await client
          .get(
            Uri.parse(ApiConfig.statusEndpoint(mensagemId)),
            headers: {
              'Content-Type': 'application/json',
            },
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return StatusResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 404) {
        throw Exception('Notificação não encontrada');
      } else {
        throw Exception(
          'Erro ao consultar status: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao consultar status: $e');
    }
  }

  Future<bool> verificarConectividade() async {
    try {
      final response = await client
          .get(
            Uri.parse('${ApiConfig.baseUrl}/health'),
          )
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

