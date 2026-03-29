# Projeto Papacapim 🐦

Um aplicativo mobile desenvolvido em **Flutter** e **Dart**. Este projeto possui funcionalidades voltadas para a interação de usuários, com fluxo de autenticação, feed, criação de posts e gerenciamento de perfil.

## 🚀 Funcionalidades

- **Autenticação de Usuários:** Cadastro (`RegisterTemplate`) e Login (`LoginTemplate`).
- **Feed:** Visualização de postagens na tela principal (`FeedTemplate`).
- **Postagens:** Criação de novos posts (`NewPostTemplate`).
- **Gerenciamento de Perfil:** Visualização de perfil (`UserTemplate`) e Edição de dados do usuário (`EditUserTemplate`).

## 🛠️ Tecnologias Utilizadas

- **[Flutter](https://flutter.dev/):** Framework UI do Google para criar aplicativos nativos para mobile, web e desktop a partir de uma única base de código.
- **[Dart](https://dart.dev/):** Linguagem de programação otimizada para interfaces de usuário.

## ⚙️ Pré-requisitos

Antes de começar, certifique-se de que sua máquina atende aos requisitos abaixo:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.
- [Dart](https://dart.dev/get-dart) instalado.
- Emulador configurado (Android/iOS) ou um dispositivo físico conectado.
- *Para Windows (Desktop)*: Modo de desenvolvedor do Windows ativado e dependências do Visual Studio.

## 🏃 Como Rodar o Projeto

1. Clone o repositório (ou extraia os arquivos):
   ```bash
   git clone https://github.com/Mirilice/Projeto-Papacapim.git
   ```

2. Entre na pasta do aplicativo Flutter:
   ```bash
   cd flutter_application_papacapim
   ```

3. Instale as dependências executando:
   ```bash
   flutter pub get
   ```

4. Execute o aplicativo (pode ser no Chrome, Windows ou seu Emulador/Celular):
   ```bash
   flutter run
   ```
   *Dica: Você pode especificar o dispositivo com `flutter run -d chrome` ou `flutter run -d windows`.*

## 📂 Estrutura Principal de Pastas

```text
flutter_application_papacapim/
 ├── lib/
 │   ├── components/    # Widgets reutilizáveis (Botões, Inputs, etc.)
 │   ├── models/        # Estrutura de dados (UserPost, UserSession, etc.)
 │   ├── repositories/  # Comunicação com armazenamento/API (UserRepository)
 │   ├── services/      # Lógica de negócio (UserService)
 │   ├── templates/     # Telas do aplicativo (Login, Feed, Configurações, etc.)
 │   └── main.dart      # Ponto de entrada do aplicativo
```
