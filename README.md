# Portfolio - Alvaro Carlisbino

Portfolio em Flutter Web com foco em narrativa profissional, visual neo-brutal e dados atualizados.

## O que foi atualizado

- Redesign completo com identidade neo-brutal e motion muito alto
- Nova estrutura de narrativa na Home com navegacao por ancoras e progress bar
- Contrato central de conteudo para facilitar manutencao
- Integracao com GitHub, Dev.to e LinkedIn com fallback local
- Componentes graficos reutilizaveis para densidade visual (cards, background e barra de secoes)
- Tema claro/escuro e suporte de localizacao mantidos

## Estrutura principal

```txt
lib/
├── data/
│   ├── datasources/github_datasource.dart
│   ├── datasources/devto_datasource.dart
│   ├── datasources/linkedin_datasource.dart
│   ├── models/portfolio_content.dart
│   └── repositories/portfolio_repository.dart
├── pages/home/home.dart
├── config/theme/app_theme.dart
├── widgets/neo_background.dart
├── widgets/neo_brutal_card.dart
├── widgets/section_anchor_bar.dart
├── utils/colors.dart
└── utils/text_styles.dart
```

## Executar localmente

```bash
fvm flutter pub get
fvm flutter run -d chrome
```

## Personalizacao rapida

Edite os dados em `lib/data/models/portfolio_content.dart` para atualizar:

- Bio e posicionamento
- Projetos em destaque
- Skills
- Conquistas e timeline
- Redes e links

