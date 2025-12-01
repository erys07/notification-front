# Frontend - Sistema de Notificações

App Flutter que permite enviar notificações e acompanhar o status em tempo real.

## O que faz

- Interface para digitar e enviar mensagens
- Lista todas as notificações enviadas
- Atualiza automaticamente o status quando o processamento termina
- Mostra indicador de conexão com o backend

## Como rodar

1. Instala as dependências:
```bash
flutter pub get
```

2. Roda o app:
```bash
flutter run
```

Para web:
```bash
flutter run -d chrome
```

## Configuração

Se for rodar no celular, precisa alterar o IP do backend no arquivo `lib/config/api_config.dart`. Para web pode deixar como está (localhost:8080).

## Estrutura

```
config/    - URL do backend
models/    - Modelos de dados
providers/ - Gerenciamento de estado e polling
screens/   - Telas
services/  - Comunicação com a API
widgets/   - Componentes da UI
```

## Como funciona

1. Você digita uma mensagem e envia
2. A notificação aparece na lista como "Aguardando"
3. O app verifica o status a cada 3 segundos
4. Quando processar, muda para "Processado com Sucesso"
# notification-front
