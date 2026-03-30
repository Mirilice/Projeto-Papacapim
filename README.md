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
- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado (já inclui o Dart).
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

A estrutura do código-fonte da aplicação está concentrada na pasta `flutter_application_papacapim/lib/` (isto é, dentro da pasta do aplicativo Flutter) e foi organizada da seguinte maneira para focar em componentes reutilizáveis, separação de responsabilidades e escalabilidade:

- **`components/`**: Contém os widgets visuais e elementos de interface menores e reutilizáveis por todo o aplicativo (ex: `MyButton.dart`, `MyInput.dart`, `MyPost.dart`).
- **`models/`**: Guarda os modelos de dados e entidades da aplicação que trafegam entre as camadas (ex: `CreateUser.dart`, `UserSession.dart`).
- **`repositories/`**: Camada encarregada de fazer a comunicação com as fontes de dados (APIs REST, banco de dados local, etc.) e abstrair essa interação (ex: `UserRepository.dart`).
- **`services/`**: Concentra a lógica de negócios da aplicação e orquestra as chamadas aos repositórios correspondentes (ex: `UserService.dart`).
- **`templates/`**: Representa as páginas ou telas completas, montadas através da união dos componentes visuais (ex: `LoginTemplate.dart`, `FeedTemplate.dart`, `RegisterTemplate.dart`).
- **`main.dart`**: Ponto de entrada (Entry point) responsável por inicializar a aplicação Flutter.
