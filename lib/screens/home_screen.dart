import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/notificacao.dart';
import '../providers/notificacao_provider.dart';
import '../services/notificacao_service.dart';
import '../widgets/notificacao_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _mensagemController = TextEditingController();
  final NotificacaoService _service = NotificacaoService();
  bool _isEnviando = false;
  bool _conectado = true;

  @override
  void initState() {
    super.initState();
    _verificarConectividade();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<NotificacaoProvider>(context, listen: false);
      provider.iniciarPolling();
    });
  }

  Future<void> _verificarConectividade() async {
    final conectado = await _service.verificarConectividade();
    if (!mounted) return;
    setState(() {
      _conectado = conectado;
    });
  }

  Future<void> _enviarNotificacao() async {
    final conteudoMensagem = _mensagemController.text.trim();

    if (conteudoMensagem.isEmpty) {
      _mostrarSnackBar('Por favor, digite uma mensagem', isError: true);
      return;
    }

    setState(() {
      _isEnviando = true;
    });

    final provider = Provider.of<NotificacaoProvider>(context, listen: false);
    String? mensagemId;

    try {
      const uuid = Uuid();
      mensagemId = uuid.v4();

      final notificacao = Notificacao(
        mensagemId: mensagemId,
        conteudoMensagem: conteudoMensagem,
        status: StatusNotificacao.aguardando,
        dataEnvio: DateTime.now(),
      );

      provider.adicionarNotificacao(notificacao);

      await _service.enviarNotificacao(
        mensagemId: mensagemId,
        conteudoMensagem: conteudoMensagem,
      );

      _mensagemController.clear();

      if (!mounted) return;
      _mostrarSnackBar('Notificação enviada com sucesso!');
    } catch (e) {
      if (mensagemId != null) {
        provider.atualizarStatus(
          mensagemId,
          StatusNotificacao.falha,
        );
      }

      if (!mounted) return;
      _mostrarSnackBar(
        'Erro ao enviar notificação: ${e.toString()}',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isEnviando = false;
        });
      }
    }
  }

  void _mostrarSnackBar(String mensagem, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _mensagemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Notificações'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_conectado ? Icons.wifi : Icons.wifi_off),
            onPressed: _verificarConectividade,
            tooltip: _conectado
                ? 'Conectado ao backend'
                : 'Desconectado - Clique para verificar',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _mensagemController,
                  decoration: const InputDecoration(
                    labelText: 'Conteúdo da Mensagem',
                    hintText: 'Digite sua mensagem aqui...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  enabled: !_isEnviando,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _isEnviando ? null : _enviarNotificacao,
                  icon: _isEnviando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  label: Text(_isEnviando ? 'Enviando...' : 'Enviar Notificação'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Consumer<NotificacaoProvider>(
              builder: (context, provider, child) {
                final notificacoes = provider.notificacoes;

                if (notificacoes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma notificação enviada',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Envie uma notificação para começar',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: ListView.builder(
                    itemCount: notificacoes.length,
                    itemBuilder: (context, index) {
                      return NotificacaoItem(
                        notificacao: notificacoes[index],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

