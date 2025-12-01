class Notificacao {
  final String mensagemId;
  final String conteudoMensagem;
  String status;
  final DateTime dataEnvio;

  Notificacao({
    required this.mensagemId,
    required this.conteudoMensagem,
    required this.status,
    required this.dataEnvio,
  });

  factory Notificacao.fromJson(Map<String, dynamic> json) {
    return Notificacao(
      mensagemId: json['mensagemId'] as String,
      conteudoMensagem: json['conteudoMensagem'] as String? ?? '',
      status: json['status'] as String,
      dataEnvio: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mensagemId': mensagemId,
      'conteudoMensagem': conteudoMensagem,
      'status': status,
    };
  }
}

class NotificacaoRequest {
  final String mensagemId;
  final String conteudoMensagem;

  NotificacaoRequest({
    required this.mensagemId,
    required this.conteudoMensagem,
  });

  Map<String, dynamic> toJson() {
    return {
      'mensagemId': mensagemId,
      'conteudoMensagem': conteudoMensagem,
    };
  }
}

class NotificacaoResponse {
  final String mensagemId;
  final String status;
  final String? message;

  NotificacaoResponse({
    required this.mensagemId,
    required this.status,
    this.message,
  });

  factory NotificacaoResponse.fromJson(Map<String, dynamic> json) {
    return NotificacaoResponse(
      mensagemId: json['mensagemId'] as String,
      status: json['status'] as String,
      message: json['message'] as String?,
    );
  }
}

class StatusResponse {
  final String mensagemId;
  final String status;

  StatusResponse({
    required this.mensagemId,
    required this.status,
  });

  factory StatusResponse.fromJson(Map<String, dynamic> json) {
    return StatusResponse(
      mensagemId: json['mensagemId'] as String,
      status: json['status'] as String,
    );
  }
}

class StatusNotificacao {
  static const String aguardando = 'AGUARDANDO_PROCESSAMENTO';
  static const String processado = 'PROCESSADO_SUCESSO';
  static const String falha = 'FALHA_PROCESSAMENTO';
}

