# Portfolio - Alvaro Carlisbino

Portfolio em Flutter Web com foco em narrativa profissional, design renovado e dados atualizados.

## O que foi atualizado

- Redesign completo com direcao visual hibrida (profissional + moderno)
- Nova estrutura de narrativa na Home: Hero, Projetos, Skills, Conquistas e CTA final
- Contrato central de conteudo para facilitar manutencao
- Integracao com GitHub para carregar repositorios recentes com fallback local
- Tema claro/escuro e suporte de localizacao mantidos

## Estrutura principal

```txt
lib/
├── data/
│   ├── datasources/github_datasource.dart
│   ├── models/portfolio_content.dart
│   └── repositories/portfolio_repository.dart
├── pages/home/home.dart
├── config/theme/app_theme.dart
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

