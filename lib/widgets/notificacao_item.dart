import 'package:flutter/material.dart';
import '../models/notificacao.dart';

class NotificacaoItem extends StatelessWidget {
  final Notificacao notificacao;

  const NotificacaoItem({
    super.key,
    required this.notificacao,
  });

  IconData _getStatusIcon() {
    switch (notificacao.status) {
      case StatusNotificacao.aguardando:
        return Icons.hourglass_empty;
      case StatusNotificacao.processado:
        return Icons.check_circle;
      case StatusNotificacao.falha:
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  Color _getStatusColor(BuildContext context) {
    switch (notificacao.status) {
      case StatusNotificacao.aguardando:
        return Colors.orange;
      case StatusNotificacao.processado:
        return Colors.green;
      case StatusNotificacao.falha:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel() {
    switch (notificacao.status) {
      case StatusNotificacao.aguardando:
        return 'Aguardando Processamento';
      case StatusNotificacao.processado:
        return 'Processado com Sucesso';
      case StatusNotificacao.falha:
        return 'Falha no Processamento';
      default:
        return notificacao.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getStatusIcon(),
                  color: _getStatusColor(context),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getStatusLabel(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(context),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'ID: ${notificacao.mensagemId}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              notificacao.conteudoMensagem,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Enviado em: ${_formatDateTime(notificacao.dataEnvio)}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}:'
        '${dateTime.second.toString().padLeft(2, '0')}';
  }
}

