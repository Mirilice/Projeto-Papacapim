# Projeto Papacapim

Um novo projeto Flutter.

## Estrutura de Pastas

A estrutura do código-fonte da aplicação está concentrada na pasta `lib/` e foi organizada da seguinte maneira para focar em componentes reutilizáveis, separação de responsabilidades e escalabilidade:

- **`components/`**: Contém os widgets visuais e elementos de interface menores e reutilizáveis por todo o aplicativo (ex: `MyButton.dart`, `MyInput.dart`, `MyPost.dart`).
- **`models/`**: Guarda os modelos de dados e entidades da aplicação que trafegam entre as camadas (ex: `CreateUser.dart`, `UserSession.dart`).
- **`repositories/`**: Camada encarregada de fazer a comunicação com as fontes de dados (APIs REST, banco de dados local, etc.) e abstrair essa interação (ex: `UserRepository.dart`).
- **`services/`**: Concentra a lógica de negócios da aplicação e orquestra as chamadas aos repositórios correspondentes (ex: `UserService.dart`).
- **`templates/`**: Representa as páginas ou telas completas, montadas através da união dos componentes visuais (ex: `LoginTemplate.dart`, `FeedTemplate.dart`, `RegisterTemplate.dart`).
- **`main.dart`**: Ponto de entrada (Entry point) responsável por inicializar a aplicação Flutter.

---

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
