import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';

class LocalizedText {
  const LocalizedText({
    required this.pt,
    required this.en,
  });

  final String pt;
  final String en;

  String resolve(Locale locale) {
    if (locale.languageCode == 'pt') {
      return pt;
    }

    return en;
  }
}

class ProfileContent {
  const ProfileContent({
    required this.fullName,
    required this.title,
    required this.location,
    required this.email,
    required this.tagline,
    required this.introParagraphs,
    required this.focusTags,
  });

  final String fullName;
  final LocalizedText title;
  final String location;
  final String email;
  final LocalizedText tagline;
  final List<LocalizedText> introParagraphs;
  final List<String> focusTags;
}

class SocialLink {
  const SocialLink({
    required this.label,
    required this.url,
    required this.icon,
  });

  final String label;
  final String url;
  final IconData icon;
}

class PortfolioStat {
  const PortfolioStat({
    required this.label,
    required this.value,
  });

  final LocalizedText label;
  final String value;
}

class SkillGroup {
  const SkillGroup({
    required this.title,
    required this.skills,
  });

  final LocalizedText title;
  final List<String> skills;
}

class HighlightProject {
  const HighlightProject({
    required this.name,
    required this.description,
    required this.stack,
    required this.url,
    this.isExternal = false,
  });

  final String name;
  final LocalizedText description;
  final List<String> stack;
  final String url;
  final bool isExternal;
}

class AchievementItem {
  const AchievementItem({
    required this.title,
    required this.description,
    required this.year,
  });

  final LocalizedText title;
  final LocalizedText description;
  final String year;
}

class TimelineItem {
  const TimelineItem({
    required this.yearRange,
    required this.title,
    required this.organization,
    required this.description,
  });

  final String yearRange;
  final LocalizedText title;
  final String organization;
  final LocalizedText description;
}

class PortfolioContent {
  const PortfolioContent({
    required this.profile,
    required this.socialLinks,
    required this.stats,
    required this.skillGroups,
    required this.featuredProjects,
    required this.achievements,
    required this.timeline,
  });

  final ProfileContent profile;
  final List<SocialLink> socialLinks;
  final List<PortfolioStat> stats;
  final List<SkillGroup> skillGroups;
  final List<HighlightProject> featuredProjects;
  final List<AchievementItem> achievements;
  final List<TimelineItem> timeline;

  static PortfolioContent buildDefault() {
    return const PortfolioContent(
      profile: ProfileContent(
        fullName: 'Alvaro Carlisbino',
        title: LocalizedText(
          pt: 'Desenvolvedor Mobile',
          en: 'Mobile Developer',
        ),
        location: 'Maringa, PR - Brazil',
        email: 'alvarocarlisbino@gmail.com',
        tagline: LocalizedText(
          pt: 'Construo apps escalaveis com foco em produto, UX e performance.',
          en: 'I build scalable apps focused on product, UX, and performance.',
        ),
        introParagraphs: [
          LocalizedText(
            pt: 'Atuo com Flutter e ecossistema mobile entregando produtos que equilibram velocidade de execucao e qualidade tecnica.',
            en: 'I work with Flutter and mobile ecosystems to ship products that balance execution speed and technical quality.',
          ),
          LocalizedText(
            pt: 'Hoje meu foco esta em arquitetura, refinamento de experiencia e resultados de negocio com tecnologia.',
            en: 'Today, my focus is architecture, experience refinement, and business outcomes through technology.',
          ),
        ],
        focusTags: [
          'Flutter',
          'Dart',
          'Arquitetura Limpa',
          'Design Systems',
          'Product Thinking',
          'Performance',
        ],
      ),
      socialLinks: [
        SocialLink(
          label: 'GitHub',
          url: 'https://github.com/alvaro-carlisbino',
          icon: SimpleIcons.github,
        ),
        SocialLink(
          label: 'LinkedIn',
          url:
              'https://www.linkedin.com/in/alvaro-matheus-madureira-carlisbino-786534286/',
          icon: SimpleIcons.linkedin,
        ),
        SocialLink(
          label: 'Email',
          url: 'mailto:alvarocarlisbino@gmail.com',
          icon: SimpleIcons.gmail,
        ),
      ],
      stats: [
        PortfolioStat(
          label: LocalizedText(
              pt: 'anos de experiencia', en: 'years of experience'),
          value: '3+',
        ),
        PortfolioStat(
          label:
              LocalizedText(pt: 'projetos entregues', en: 'projects shipped'),
          value: '20+',
        ),
        PortfolioStat(
          label: LocalizedText(pt: 'hackathons', en: 'hackathons'),
          value: '6+',
        ),
      ],
      skillGroups: [
        SkillGroup(
          title: LocalizedText(pt: 'Mobile', en: 'Mobile'),
          skills: ['Flutter', 'Dart', 'Android', 'iOS', 'Responsive UI'],
        ),
        SkillGroup(
          title: LocalizedText(pt: 'Arquitetura', en: 'Architecture'),
          skills: [
            'MVVM',
            'Clean Architecture',
            'SOLID',
            'Dependency Injection'
          ],
        ),
        SkillGroup(
          title: LocalizedText(pt: 'Dados e API', en: 'Data and API'),
          skills: ['REST', 'Dio', 'Firebase', 'PostgreSQL', 'Supabase'],
        ),
      ],
      featuredProjects: [
        HighlightProject(
          name: 'MONOBOX',
          description: LocalizedText(
            pt: 'Solucao para cultivo inteligente com monitoramento e automacao.',
            en: 'Smart farming solution with monitoring and automation.',
          ),
          stack: ['Flutter', 'IoT', 'Firebase'],
          url: 'https://github.com/alvaro-carlisbino',
        ),
        HighlightProject(
          name: 'MOLDA.AI',
          description: LocalizedText(
            pt: 'Plataforma para analise e previsao de tendencias futuras.',
            en: 'Platform for analysis and forecasting of future trends.',
          ),
          stack: ['Flutter', 'AI', 'Data'],
          url: 'https://molda.online',
          isExternal: true,
        ),
        HighlightProject(
          name: 'Portfolio',
          description: LocalizedText(
            pt: 'Aplicacao Flutter Web com foco em narrativa profissional.',
            en: 'Flutter Web app focused on professional storytelling.',
          ),
          stack: ['Flutter Web', 'Provider', 'UI/UX'],
          url: 'https://github.com/alvaro-carlisbino/portfolio',
        ),
      ],
      achievements: [
        AchievementItem(
          title: LocalizedText(
            pt: 'Inova Agro - 1o Lugar',
            en: 'Inova Agro - 1st Place',
          ),
          description: LocalizedText(
            pt: 'Desenvolvimento de proposta com alto impacto para agritech.',
            en: 'Developed a high-impact proposal for agritech.',
          ),
          year: '2024',
        ),
        AchievementItem(
          title: LocalizedText(
            pt: 'Deco.cx - Equipe Vencedora',
            en: 'Deco.cx - Winning Team',
          ),
          description: LocalizedText(
            pt: 'Produto digital orientado a experiencia e validacao rapida.',
            en: 'Digital product focused on experience and rapid validation.',
          ),
          year: '2024',
        ),
        AchievementItem(
          title: LocalizedText(
            pt: 'CTFW - 1o Lugar',
            en: 'CTFW - 1st Place',
          ),
          description: LocalizedText(
            pt: 'Solucoes de seguranca e automacao para desafios reais.',
            en: 'Security and automation solutions for real-world challenges.',
          ),
          year: '2023',
        ),
      ],
      timeline: [
        TimelineItem(
          yearRange: '2025 - Atual',
          title: LocalizedText(
            pt: 'Evolucao para Senioridade',
            en: 'Growth Toward Seniority',
          ),
          organization: 'Product and Engineering',
          description: LocalizedText(
            pt: 'Foco em arquitetura, confiabilidade e impacto em produto.',
            en: 'Focused on architecture, reliability, and product impact.',
          ),
        ),
        TimelineItem(
          yearRange: '2023 - 2024',
          title: LocalizedText(
            pt: 'Consolidacao em Flutter',
            en: 'Flutter Consolidation',
          ),
          organization: 'Mobile Development',
          description: LocalizedText(
            pt: 'Entrega de apps reais e participacao em hackathons de alto nivel.',
            en: 'Shipped real apps and joined high-level hackathons.',
          ),
        ),
        TimelineItem(
          yearRange: '2022 - 2023',
          title: LocalizedText(
            pt: 'Fundacao Tecnica',
            en: 'Technical Foundation',
          ),
          organization: 'Software Development',
          description: LocalizedText(
            pt: 'Base forte em desenvolvimento, APIs, e boas praticas.',
            en: 'Built a strong foundation in development, APIs, and best practices.',
          ),
        ),
      ],
    );
  }
}
