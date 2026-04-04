import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:repositoriobryzzen/data/datasources/devto_datasource.dart';
import 'package:repositoriobryzzen/data/datasources/github_datasource.dart';
import 'package:repositoriobryzzen/data/datasources/linkedin_datasource.dart';
import 'package:repositoriobryzzen/data/models/portfolio_content.dart';
import 'package:repositoriobryzzen/data/repositories/portfolio_repository.dart';
import 'package:repositoriobryzzen/utils/colors.dart';
import 'package:repositoriobryzzen/utils/text_styles.dart';
import 'package:repositoriobryzzen/viewmodels/localization_viewmodel.dart';
import 'package:repositoriobryzzen/viewmodels/theme_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PortfolioRepository _repository;
  late Future<PortfolioRepositoryData> _portfolioFuture;

  @override
  void initState() {
    super.initState();
    _repository = PortfolioRepository();
    _portfolioFuture = _repository.load();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeViewModel themeViewModel = context.watch<ThemeViewModel>();
    final LocalizationViewModel localizationViewModel =
        context.watch<LocalizationViewModel>();
    final bool isDarkMode = themeViewModel.isDarkMode;
    final Locale locale = localizationViewModel.currentLocale;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.white,
      body: SafeArea(
        child: FutureBuilder<PortfolioRepositoryData>(
          future: _portfolioFuture,
          builder: (
            BuildContext context,
            AsyncSnapshot<PortfolioRepositoryData> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return _ErrorView(
                isDarkMode: isDarkMode,
                onRetry: () {
                  setState(() {
                    _portfolioFuture = _repository.load();
                  });
                },
              );
            }

            final PortfolioRepositoryData data = snapshot.data!;
            final PortfolioContent content = data.content;
            return CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: _TopControls(
                    isDarkMode: isDarkMode,
                    localizationViewModel: localizationViewModel,
                    onToggleTheme: themeViewModel.toggleTheme,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _HeroSection(
                    isDarkMode: isDarkMode,
                    locale: locale,
                    content: content,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _ProjectsSection(
                    isDarkMode: isDarkMode,
                    locale: locale,
                    featuredProjects: content.featuredProjects,
                    githubProjects: data.githubProjects,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _SkillSection(
                    isDarkMode: isDarkMode,
                    locale: locale,
                    groups: content.skillGroups,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _AchievementsSection(
                    isDarkMode: isDarkMode,
                    locale: locale,
                    achievements: content.achievements,
                    timeline: content.timeline,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _ContentSection(
                    isDarkMode: isDarkMode,
                    locale: locale,
                    devtoArticles: data.devtoArticles,
                    linkedinProfile: data.linkedinProfile,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _FooterSection(
                    isDarkMode: isDarkMode,
                    locale: locale,
                    socialLinks: content.socialLinks,
                    fullName: content.profile.fullName,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TopControls extends StatelessWidget {
  const _TopControls({
    required this.isDarkMode,
    required this.localizationViewModel,
    required this.onToggleTheme,
  });

  final bool isDarkMode;
  final LocalizationViewModel localizationViewModel;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _ControlButton(
            icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
            onTap: onToggleTheme,
          ),
          const SizedBox(width: 12),
          _ControlButton(
            icon: Icons.translate,
            onTap: () {
              _showLanguageDialog(context, localizationViewModel);
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    LocalizationViewModel localizationViewModel,
  ) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                localizationViewModel.supportedLocales.map((Locale locale) {
              return ListTile(
                title: Text(locale.toString()),
                onTap: () {
                  localizationViewModel.setLocale(locale);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.isDarkMode,
    required this.locale,
    required this.content,
  });

  final bool isDarkMode;
  final Locale locale;
  final PortfolioContent content;

  @override
  Widget build(BuildContext context) {
    final ProfileContent profile = content.profile;
    final bool isPt = locale.languageCode == 'pt';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(28),
                decoration: _panelDecoration(isDarkMode),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      profile.title.resolve(locale),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.neonBlue,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      profile.fullName,
                      style: AppTextStyles.h1.copyWith(
                        color: isDarkMode
                            ? AppColors.textLight
                            : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      profile.tagline.resolve(locale),
                      style: AppTextStyles.body1.copyWith(
                        color: isDarkMode
                            ? AppColors.textLight.withValues(alpha: 0.85)
                            : AppColors.textDark.withValues(alpha: 0.82),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: profile.focusTags
                          .map((String tag) => _TagChip(
                                label: tag,
                                isDarkMode: isDarkMode,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      children: <Widget>[
                        _InlineInfo(
                          icon: Icons.location_on_outlined,
                          label: profile.location,
                          isDarkMode: isDarkMode,
                        ),
                        _InlineInfo(
                          icon: Icons.email_outlined,
                          label: profile.email,
                          isDarkMode: isDarkMode,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: content.socialLinks.map((SocialLink link) {
                        return _LinkButton(
                          label: link.label,
                          icon: link.icon,
                          url: link.url,
                          isDarkMode: isDarkMode,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.06, end: 0),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final bool stacked = constraints.maxWidth < 820;
                  final List<Widget> children = <Widget>[
                    ...profile.introParagraphs.map((LocalizedText paragraph) {
                      return Expanded(
                        child: _InfoCard(
                          isDarkMode: isDarkMode,
                          title: isPt ? 'Visao' : 'Vision',
                          description: paragraph.resolve(locale),
                        ),
                      );
                    }),
                    Expanded(
                      child: _StatPanel(
                        isDarkMode: isDarkMode,
                        locale: locale,
                        stats: content.stats,
                      ),
                    ),
                  ];

                  if (stacked) {
                    return Column(
                      children: children
                          .map((Widget child) => Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: child,
                              ))
                          .toList(),
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children
                        .map((Widget child) => Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: child,
                            ))
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectsSection extends StatelessWidget {
  const _ProjectsSection({
    required this.isDarkMode,
    required this.locale,
    required this.featuredProjects,
    required this.githubProjects,
  });

  final bool isDarkMode;
  final Locale locale;
  final List<HighlightProject> featuredProjects;
  final List<GithubRepositorySummary> githubProjects;

  @override
  Widget build(BuildContext context) {
    final bool isPt = locale.languageCode == 'pt';
    return _SectionWrapper(
      title: isPt ? 'Projetos em destaque' : 'Featured projects',
      subtitle: isPt
          ? 'Curadoria com projetos autorais e repositorios atualizados.'
          : 'A curated mix of flagship products and fresh repositories.',
      isDarkMode: isDarkMode,
      child: Column(
        children: <Widget>[
          ...featuredProjects.map((HighlightProject project) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ProjectCard(
                isDarkMode: isDarkMode,
                title: project.name,
                description: project.description.resolve(locale),
                stack: project.stack,
                url: project.url,
              ),
            );
          }),
          if (githubProjects.isNotEmpty) const SizedBox(height: 8),
          if (githubProjects.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                isPt ? 'Atualizados via GitHub' : 'Updated from GitHub',
                style: AppTextStyles.h3.copyWith(
                  color: isDarkMode ? AppColors.textLight : AppColors.textDark,
                ),
              ),
            ),
          const SizedBox(height: 12),
          ...githubProjects.map((GithubRepositorySummary project) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ProjectCard(
                isDarkMode: isDarkMode,
                title: project.name,
                description:
                    '${project.description} · ${project.language} · ★${project.stars}',
                stack: const <String>['GitHub', 'Open Source'],
                url: project.url,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SkillSection extends StatelessWidget {
  const _SkillSection({
    required this.isDarkMode,
    required this.locale,
    required this.groups,
  });

  final bool isDarkMode;
  final Locale locale;
  final List<SkillGroup> groups;

  @override
  Widget build(BuildContext context) {
    final bool isPt = locale.languageCode == 'pt';
    return _SectionWrapper(
      title: isPt ? 'Stack e especialidades' : 'Stack and specialties',
      subtitle: isPt
          ? 'Ferramentas e competencias com foco em entrega de produto.'
          : 'Tools and capabilities focused on product delivery.',
      isDarkMode: isDarkMode,
      child: Wrap(
        spacing: 14,
        runSpacing: 14,
        children: groups.map((SkillGroup group) {
          return SizedBox(
            width: 320,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: _panelDecoration(isDarkMode),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    group.title.resolve(locale),
                    style: AppTextStyles.h3.copyWith(
                      color:
                          isDarkMode ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: group.skills
                        .map((String skill) => _TagChip(
                              label: skill,
                              isDarkMode: isDarkMode,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _AchievementsSection extends StatelessWidget {
  const _AchievementsSection({
    required this.isDarkMode,
    required this.locale,
    required this.achievements,
    required this.timeline,
  });

  final bool isDarkMode;
  final Locale locale;
  final List<AchievementItem> achievements;
  final List<TimelineItem> timeline;

  @override
  Widget build(BuildContext context) {
    final bool isPt = locale.languageCode == 'pt';
    return _SectionWrapper(
      title: isPt ? 'Conquistas e trajetoria' : 'Achievements and timeline',
      subtitle: isPt
          ? 'Evidencias de evolucao tecnica e impacto em projetos reais.'
          : 'Evidence of technical growth and impact in real projects.',
      isDarkMode: isDarkMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: achievements.map((AchievementItem item) {
              return SizedBox(
                width: 330,
                child: _InfoCard(
                  isDarkMode: isDarkMode,
                  title: '${item.year} · ${item.title.resolve(locale)}',
                  description: item.description.resolve(locale),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          ...timeline.map((TimelineItem item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: _panelDecoration(isDarkMode),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.neonBlue.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      item.yearRange,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.neonBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.title.resolve(locale),
                          style: AppTextStyles.body1.copyWith(
                            color: isDarkMode
                                ? AppColors.textLight
                                : AppColors.textDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.organization,
                          style: AppTextStyles.caption.copyWith(
                            color: isDarkMode
                                ? AppColors.textLight.withValues(alpha: 0.7)
                                : AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.description.resolve(locale),
                          style: AppTextStyles.body2.copyWith(
                            color: isDarkMode
                                ? AppColors.textLight.withValues(alpha: 0.85)
                                : AppColors.textDark.withValues(alpha: 0.82),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection({
    required this.isDarkMode,
    required this.locale,
    required this.socialLinks,
    required this.fullName,
  });

  final bool isDarkMode;
  final Locale locale;
  final List<SocialLink> socialLinks;
  final String fullName;

  @override
  Widget build(BuildContext context) {
    final bool isPt = locale.languageCode == 'pt';
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: _panelDecoration(isDarkMode),
            child: Column(
              children: <Widget>[
                Text(
                  isPt
                      ? 'Vamos construir algo relevante juntos?'
                      : 'Let us build something meaningful together.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h3.copyWith(
                    color:
                        isDarkMode ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isPt
                      ? 'Aberto para novos produtos, desafios e colaboracoes.'
                      : 'Open to new products, challenges, and collaborations.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body2.copyWith(
                    color: isDarkMode
                        ? AppColors.textLight.withValues(alpha: 0.8)
                        : AppColors.textDark.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: socialLinks.map((SocialLink link) {
                    return _LinkButton(
                      label: link.label,
                      icon: link.icon,
                      url: link.url,
                      isDarkMode: isDarkMode,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Text(
                  '© ${DateTime.now().year} $fullName',
                  style: AppTextStyles.caption.copyWith(
                    color: isDarkMode
                        ? AppColors.textLight.withValues(alpha: 0.6)
                        : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  const _ContentSection({
    required this.isDarkMode,
    required this.locale,
    required this.devtoArticles,
    required this.linkedinProfile,
  });

  final bool isDarkMode;
  final Locale locale;
  final List<DevtoArticleSummary> devtoArticles;
  final LinkedinProfileSummary? linkedinProfile;

  @override
  Widget build(BuildContext context) {
    final bool isPt = locale.languageCode == 'pt';
    final String linkedinText = linkedinProfile?.headline ??
        (isPt
            ? 'Perfil LinkedIn ativo e atualizado.'
            : 'LinkedIn profile is active and updated.');

    return _SectionWrapper(
      title: isPt ? 'Conteudo e presenca' : 'Content and presence',
      subtitle: isPt
          ? 'Resumo dos canais onde publico e compartilho atualizacoes.'
          : 'A summary of channels where I publish and share updates.',
      isDarkMode: isDarkMode,
      child: Column(
        children: <Widget>[
          _InfoCard(
            isDarkMode: isDarkMode,
            title: 'LinkedIn',
            description: linkedinText,
          ),
          if (devtoArticles.isNotEmpty) const SizedBox(height: 10),
          ...devtoArticles.map((DevtoArticleSummary article) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ProjectCard(
                isDarkMode: isDarkMode,
                title: article.title,
                description: article.publishedAt,
                stack: const <String>['Dev.to', 'Article'],
                url: article.url,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SectionWrapper extends StatelessWidget {
  const _SectionWrapper({
    required this.title,
    required this.subtitle,
    required this.isDarkMode,
    required this.child,
  });

  final String title;
  final String subtitle;
  final bool isDarkMode;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: AppTextStyles.h2.copyWith(
                  color: isDarkMode ? AppColors.textLight : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: AppTextStyles.body2.copyWith(
                  color: isDarkMode
                      ? AppColors.textLight.withValues(alpha: 0.8)
                      : AppColors.textDark.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 18),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.neonBlue.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.neonBlue.withValues(alpha: 0.24),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, size: 20, color: AppColors.neonBlue),
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    required this.isDarkMode,
    required this.title,
    required this.description,
    required this.stack,
    required this.url,
  });

  final bool isDarkMode;
  final String title;
  final String description;
  final List<String> stack;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _panelDecoration(isDarkMode),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.h3.copyWith(
                    color:
                        isDarkMode ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => _launch(url),
                icon: const Icon(Icons.open_in_new, size: 16),
                label: const Text('Open'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyles.body2.copyWith(
              color: isDarkMode
                  ? AppColors.textLight.withValues(alpha: 0.85)
                  : AppColors.textDark.withValues(alpha: 0.82),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: stack
                .map((String item) =>
                    _TagChip(label: item, isDarkMode: isDarkMode))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.isDarkMode,
    required this.title,
    required this.description,
  });

  final bool isDarkMode;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelDecoration(isDarkMode),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              color: isDarkMode ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyles.body2.copyWith(
              color: isDarkMode
                  ? AppColors.textLight.withValues(alpha: 0.82)
                  : AppColors.textDark.withValues(alpha: 0.82),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPanel extends StatelessWidget {
  const _StatPanel({
    required this.isDarkMode,
    required this.locale,
    required this.stats,
  });

  final bool isDarkMode;
  final Locale locale;
  final List<PortfolioStat> stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelDecoration(isDarkMode),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: stats.map((PortfolioStat stat) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  stat.label.resolve(locale),
                  style: AppTextStyles.body2.copyWith(
                    color: isDarkMode
                        ? AppColors.textLight.withValues(alpha: 0.75)
                        : AppColors.textDark.withValues(alpha: 0.75),
                  ),
                ),
                Text(
                  stat.value,
                  style: AppTextStyles.h3.copyWith(color: AppColors.neonBlue),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    required this.isDarkMode,
  });

  final String label;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.neonBlue.withValues(alpha: 0.13)
            : AppColors.neonBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.neonBlue.withValues(alpha: 0.24),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: isDarkMode ? AppColors.textLight : AppColors.textDark,
        ),
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  const _LinkButton({
    required this.label,
    required this.icon,
    required this.url,
    required this.isDarkMode,
  });

  final String label;
  final IconData icon;
  final String url;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _launch(url),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColors.neonBlue.withValues(alpha: 0.35)),
        foregroundColor: isDarkMode ? AppColors.textLight : AppColors.textDark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      icon: Icon(icon, size: 16),
      label: Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
    );
  }
}

class _InlineInfo extends StatelessWidget {
  const _InlineInfo({
    required this.icon,
    required this.label,
    required this.isDarkMode,
  });

  final IconData icon;
  final String label;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 15, color: AppColors.neonBlue),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isDarkMode
                ? AppColors.textLight.withValues(alpha: 0.8)
                : AppColors.textDark.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.isDarkMode,
    required this.onRetry,
  });

  final bool isDarkMode;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Falha ao carregar portfolio',
            style: AppTextStyles.h3.copyWith(
              color: isDarkMode ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
              onPressed: onRetry, child: const Text('Tentar novamente')),
        ],
      ),
    );
  }
}

BoxDecoration _panelDecoration(bool isDarkMode) {
  return BoxDecoration(
    color: isDarkMode ? AppColors.cardDark : Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: isDarkMode
          ? AppColors.neonBlue.withValues(alpha: 0.2)
          : AppColors.neonBlue.withValues(alpha: 0.16),
    ),
    boxShadow: AppColors.cardShadow,
  );
}

Future<void> _launch(String value) async {
  final Uri uri = Uri.parse(value);
  await launchUrl(uri, mode: LaunchMode.platformDefault);
}
