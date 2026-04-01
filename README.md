# Papacapim 🐦

Projeto final da disciplina **Desenvolvimento Mobile** ministrada pelo professor João Paulo Just.

Papacapim é uma rede social mobile desenvolvida em Flutter, inspirada no conceito de microblogging. O app consome a API REST [Papacapim](https://api.papacapim.just.pro.br) e permite que usuários publiquem posts, interajam entre si e gerenciem seus perfis.

## ✨ Funcionalidades

- Cadastro e login de usuários
- Feed de posts com scroll infinito e pull-to-refresh
- Criação e exclusão de posts
- Curtidas em posts
- Respostas a posts
- Busca de usuários e posts
- Visualização e edição de perfil
- Exclusão de conta

## 🏗️ Arquitetura

O projeto segue uma arquitetura em camadas:

- **Templates** — telas da aplicação
- **Components** — widgets reutilizáveis
- **Repositories** — intermediários entre UI e serviços
- **Services** — comunicação com a API via HTTP
- **Models** — representação dos dados

## 📁 Estrutura de Pastas
```
lib/
  main.dart
  components/
    MyButton.dart
    MyInput.dart
    MyText.dart
    MyTitle.dart
    MyUnderText.dart
    PostCard.dart
  models/
    CreateUser.dart
    Follow.dart
    FollowRelation.dart
    Like.dart
    Post.dart
    UpdateUser.dart
    UserSession.dart
  repositories/
    FollowRepository.dart
    PostRepository.dart
    UserRepository.dart
  services/
    FollowService.dart
    PostService.dart
    UserService.dart
  templates/
    EditUserTemplate.dart
    FeedTemplate.dart
    LoginTemplate.dart
    NewPostTemplate.dart
    PostDetailTemplate.dart
    RegisterTemplate.dart
    UserTemplate.dart
```

## 🛠️ Tecnologias

- [Flutter](https://flutter.dev) 3.35.7
- [Dart](https://dart.dev)
- [Google Fonts](https://pub.dev/packages/google_fonts)
- API REST [Papacapim](https://api.papacapim.just.pro.br)

## ▶️ Como rodar

```bash
# Clone o repositório
git clone <LINK_DO_GITHUB>

# Entre na pasta do projeto
cd flutter_application_papacapim

# Instale as dependências
flutter pub get

# Rode o app
flutter run
```

## 👩‍💻 Desenvolvido por

**Mirilice** e **Cabralles** — Projeto Final · Desenvolvimento Mobile · 2026
