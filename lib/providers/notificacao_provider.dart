import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/notificacao.dart';
import '../services/notificacao_service.dart';
import '../config/api_config.dart';

class NotificacaoProvider with ChangeNotifier {
  final NotificacaoService _service;
  final List<Notificacao> _notificacoes = [];
  Timer? _pollingTimer;
  bool _isPolling = false;

  NotificacaoProvider({NotificacaoService? service})
      : _service = service ?? NotificacaoService();

  List<Notificacao> get notificacoes => List.unmodifiable(_notificacoes);

  bool get isPolling => _isPolling;

  void adicionarNotificacao(Notificacao notificacao) {
    _notificacoes.insert(0, notificacao);
    notifyListeners();
  }

  void atualizarStatus(String mensagemId, String novoStatus) {
    final index = _notificacoes.indexWhere((n) => n.mensagemId == mensagemId);
    if (index != -1) {
      _notificacoes[index].status = novoStatus;
      notifyListeners();
    }
  }

  void iniciarPolling() {
    if (_isPolling) return;

    _isPolling = true;
    _pollingTimer = Timer.periodic(
      ApiConfig.pollingInterval,
      (timer) {
        _atualizarStatusPendentes();
      },
    );
    notifyListeners();
  }

  void pararPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _isPolling = false;
    notifyListeners();
  }

  Future<void> _atualizarStatusPendentes() async {
    final pendentes = _notificacoes.where((n) =>
        n.status == StatusNotificacao.aguardando).toList();

    if (pendentes.isEmpty) {
      return;
    }

    for (final notificacao in pendentes) {
      try {
        final statusResponse = await _service.consultarStatus(
          notificacao.mensagemId,
        );
        atualizarStatus(
          statusResponse.mensagemId,
          statusResponse.status,
        );
      } catch (e) {
        debugPrint('Erro ao atualizar status de ${notificacao.mensagemId}: $e');
      }
    }
  }

  void limparNotificacoes() {
    _notificacoes.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    pararPolling();
    super.dispose();
  }
}

