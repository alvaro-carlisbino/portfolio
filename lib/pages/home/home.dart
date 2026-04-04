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
import 'package:repositoriobryzzen/widgets/neo_background.dart';
import 'package:repositoriobryzzen/widgets/neo_brutal_card.dart';
import 'package:repositoriobryzzen/widgets/section_anchor_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PortfolioRepository _repository;
  late Future<PortfolioRepositoryData> _portfolioFuture;
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List<GlobalKey>.generate(
    6,
    (_) => GlobalKey(),
  );

  double _scrollProgress = 0;
  int _activeSectionIndex = 0;

  @override
  void initState() {
    super.initState();
    _repository = PortfolioRepository();
    _portfolioFuture = _repository.load();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final double max = _scrollController.position.maxScrollExtent;
    final double current = _scrollController.offset.clamp(0, max);
    final double progress = max == 0 ? 0 : (current / max).clamp(0.0, 1.0);
    int newActive = _activeSectionIndex;

    for (int index = 0; index < _sectionKeys.length; index++) {
      final BuildContext? sectionContext = _sectionKeys[index].currentContext;
      if (sectionContext == null) {
        continue;
      }
      final RenderBox box = sectionContext.findRenderObject()! as RenderBox;
      final Offset position = box.localToGlobal(Offset.zero);
      if (position.dy <= 200) {
        newActive = index;
      }
    }

    if (progress != _scrollProgress || newActive != _activeSectionIndex) {
      setState(() {
        _scrollProgress = progress;
        _activeSectionIndex = newActive;
      });
    }
  }

  Future<void> _scrollToSection(int index) async {
    if (index < 0 || index >= _sectionKeys.length) {
      return;
    }
    final BuildContext? sectionContext = _sectionKeys[index].currentContext;
    if (sectionContext == null) {
      return;
    }
    await Scrollable.ensureVisible(
      sectionContext,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOutCubic,
      alignment: 0.04,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeViewModel themeViewModel = context.watch<ThemeViewModel>();
    final LocalizationViewModel localizationViewModel =
        context.watch<LocalizationViewModel>();
    final bool isDarkMode = themeViewModel.isDarkMode;
    final Locale locale = localizationViewModel.currentLocale;
    final bool isPt = locale.languageCode == 'pt';
    final List<String> sectionNames = <String>[
      isPt ? 'INICIO' : 'START',
      isPt ? 'PROJETOS' : 'PROJECTS',
      isPt ? 'STACK' : 'STACK',
      isPt ? 'CONQUISTAS' : 'WINS',
      isPt ? 'ATIVIDADE' : 'ACTIVITY',
      isPt ? 'CONTATO' : 'CONTACT',
    ];

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.white,
      body: Stack(
        children: <Widget>[
          NeoBackground(
            scrollOffset:
                _scrollController.hasClients ? _scrollController.offset : 0,
            isDarkMode: isDarkMode,
          ),
          SafeArea(
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
                  controller: _scrollController,
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Column(
                        children: <Widget>[
                          _topControlRow(
                            isDarkMode: isDarkMode,
                            localizationViewModel: localizationViewModel,
                            onToggleTheme: themeViewModel.toggleTheme,
                          ),
                          SectionAnchorBar(
                            sections: sectionNames,
                            activeIndex: _activeSectionIndex,
                            onTap: _scrollToSection,
                            isDarkMode: isDarkMode,
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      key: _sectionKeys[0],
                      child: _HeroSection(
                        isDarkMode: isDarkMode,
                        locale: locale,
                        content: content,
                      ),
                    ),
                    SliverToBoxAdapter(
                      key: _sectionKeys[1],
                      child: _ProjectsSection(
                        isDarkMode: isDarkMode,
                        locale: locale,
                        featuredProjects: content.featuredProjects,
                        githubProjects: data.githubProjects,
                      ),
                    ),
                    SliverToBoxAdapter(
                      key: _sectionKeys[2],
                      child: _SkillSection(
                        isDarkMode: isDarkMode,
                        locale: locale,
                        groups: content.skillGroups,
                      ),
                    ),
                    SliverToBoxAdapter(
                      key: _sectionKeys[3],
                      child: _AchievementsSection(
                        isDarkMode: isDarkMode,
                        locale: locale,
                        achievements: content.achievements,
                        timeline: content.timeline,
                      ),
                    ),
                    SliverToBoxAdapter(
                      key: _sectionKeys[4],
                      child: _ContentSection(
                        isDarkMode: isDarkMode,
                        locale: locale,
                        devtoArticles: data.devtoArticles,
                        linkedinProfile: data.linkedinProfile,
                      ),
                    ),
                    SliverToBoxAdapter(
                      key: _sectionKeys[5],
                      child: _FooterSection(
                        isDarkMode: isDarkMode,
                        locale: locale,
                        socialLinks: content.socialLinks,
                        fullName: content.profile.fullName,
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 42)),
                  ],
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: _scrollProgress,
              minHeight: 6,
              color: isDarkMode ? AppColors.neonYellow : AppColors.brutalRed,
              backgroundColor: Colors.transparent,
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: _FloatingCta(isDarkMode: isDarkMode),
          ),
        ],
      ),
    );
  }

  Widget _topControlRow({
    required bool isDarkMode,
    required LocalizationViewModel localizationViewModel,
    required VoidCallback onToggleTheme,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _ControlButton(
            icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
            onTap: onToggleTheme,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(width: 10),
          _ControlButton(
            icon: Icons.translate,
            onTap: () => _showLanguageDialog(context, localizationViewModel),
            isDarkMode: isDarkMode,
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
    final bool isPt = locale.languageCode == 'pt';
    final ProfileContent profile = content.profile;

    return _SectionShell(
      isDarkMode: isDarkMode,
      title: isPt ? 'NOVA FASE, NOVO NIVEL' : 'NEW PHASE, NEW LEVEL',
      subtitle: profile.tagline.resolve(locale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          NeoBrutalCard(
            isDarkMode: isDarkMode,
            backgroundColor:
                isDarkMode ? AppColors.neonYellow : AppColors.neonBlue,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    profile.fullName,
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.black,
                      fontSize: 52,
                    ),
                  ),
                ),
                const Icon(Icons.bolt, color: AppColors.black, size: 40),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.18, end: 0),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: content.socialLinks
                .map((SocialLink link) => _ActionTag(
                      label: link.label.toUpperCase(),
                      onTap: () => _launch(link.url),
                      isDarkMode: isDarkMode,
                    ))
                .toList(),
          ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 840) {
                return Column(
                  children: <Widget>[
                    _IntroPanel(
                      isDarkMode: isDarkMode,
                      locale: locale,
                      profile: profile,
                    ),
                    const SizedBox(height: 12),
                    _StatsPanel(
                      isDarkMode: isDarkMode,
                      locale: locale,
                      stats: content.stats,
                    ),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: _IntroPanel(
                      isDarkMode: isDarkMode,
                      locale: locale,
                      profile: profile,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _StatsPanel(
                      isDarkMode: isDarkMode,
                      locale: locale,
                      stats: content.stats,
                    ),
                  ),
                ],
              );
            },
          )
              .animate()
              .fadeIn(duration: 450.ms, delay: 220.ms)
              .slideY(begin: 0.08, end: 0),
        ],
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
    return _SectionShell(
      isDarkMode: isDarkMode,
      title: isPt ? 'PROJETOS COM IMPACTO' : 'HIGH-IMPACT PROJECTS',
      subtitle: isPt
          ? 'Selecao brutal de projetos e repositorios recentes.'
          : 'A bold mix of selected projects and fresh repositories.',
      alternate: true,
      child: Column(
        children: <Widget>[
          ...List<Widget>.generate(featuredProjects.length, (int index) {
            final HighlightProject project = featuredProjects[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ProjectRowCard(
                isDarkMode: isDarkMode,
                title: project.name,
                description: project.description.resolve(locale),
                stack: project.stack,
                url: project.url,
                accent:
                    index.isEven ? AppColors.neonPink : AppColors.neonYellow,
                reverse: index.isOdd,
              )
                  .animate()
                  .fadeIn(delay: (index * 90).ms, duration: 360.ms)
                  .slideX(begin: index.isEven ? -0.1 : 0.1, end: 0),
            );
          }),
          if (githubProjects.isNotEmpty) const SizedBox(height: 6),
          if (githubProjects.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                isPt ? 'ATIVIDADE GITHUB' : 'GITHUB ACTIVITY',
                style: AppTextStyles.h3.copyWith(
                  color: isDarkMode ? AppColors.white : AppColors.black,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: githubProjects.map((GithubRepositorySummary repo) {
              return SizedBox(
                width: 320,
                child: NeoBrutalCard(
                  isDarkMode: isDarkMode,
                  backgroundColor:
                      isDarkMode ? AppColors.mediumGray : AppColors.lightGray,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        repo.name.toUpperCase(),
                        style: AppTextStyles.caption.copyWith(
                          color: isDarkMode
                              ? AppColors.neonYellow
                              : AppColors.brutalRed,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        repo.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body2.copyWith(
                          color: isDarkMode ? AppColors.white : AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${repo.language} · ★${repo.stars}',
                        style: AppTextStyles.caption.copyWith(
                          color: isDarkMode ? AppColors.white : AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
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
    return _SectionShell(
      isDarkMode: isDarkMode,
      title: isPt ? 'STACK SEM FILTRO' : 'UNFILTERED STACK',
      subtitle: isPt
          ? 'Competencias centrais para construir produtos robustos.'
          : 'Core capabilities to build robust products.',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List<Widget>.generate(groups.length, (int index) {
          final SkillGroup group = groups[index];
          return SizedBox(
            width: 330,
            child: NeoBrutalCard(
              isDarkMode: isDarkMode,
              backgroundColor: index.isEven
                  ? (isDarkMode ? AppColors.cardDark : AppColors.white)
                  : (isDarkMode ? AppColors.mediumGray : AppColors.lightGray),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    group.title.resolve(locale).toUpperCase(),
                    style: AppTextStyles.caption.copyWith(
                      color: isDarkMode
                          ? AppColors.neonYellow
                          : AppColors.brutalRed,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: group.skills
                        .map((String skill) => _SkillPill(
                              label: skill,
                              isDarkMode: isDarkMode,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms, delay: (80 * index).ms).scale(
                begin: const Offset(0.96, 0.96), end: const Offset(1, 1)),
          );
        }),
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
    return _SectionShell(
      isDarkMode: isDarkMode,
      title: isPt ? 'CONQUISTAS REAIS' : 'REAL ACHIEVEMENTS',
      subtitle: isPt
          ? 'Resultados em competicao, produto e crescimento tecnico.'
          : 'Results in competitions, product execution, and technical growth.',
      alternate: true,
      child: Column(
        children: <Widget>[
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: achievements.map((AchievementItem achievement) {
              return SizedBox(
                width: 325,
                child: NeoBrutalCard(
                  isDarkMode: isDarkMode,
                  backgroundColor:
                      isDarkMode ? AppColors.cardDark : AppColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${achievement.year} · ${achievement.title.resolve(locale)}',
                        style: AppTextStyles.caption.copyWith(
                          color: isDarkMode
                              ? AppColors.neonYellow
                              : AppColors.brutalRed,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        achievement.description.resolve(locale),
                        style: AppTextStyles.body2.copyWith(
                          color: isDarkMode ? AppColors.white : AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          ...List<Widget>.generate(timeline.length, (int index) {
            final TimelineItem item = timeline[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _TimelineTile(
                isDarkMode: isDarkMode,
                yearRange: item.yearRange,
                title: item.title.resolve(locale),
                organization: item.organization,
                description: item.description.resolve(locale),
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: (90 * index).ms)
                  .slideX(begin: index.isEven ? -0.08 : 0.08, end: 0),
            );
          }),
        ],
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
    final String linkedinHeadline = linkedinProfile?.headline ??
        (isPt
            ? 'Perfil publico atualizado com foco em crescimento continuo.'
            : 'Public profile updated and focused on continuous growth.');

    return _SectionShell(
      isDarkMode: isDarkMode,
      title: isPt ? 'CONTEUDO E PRESENCA' : 'CONTENT AND PRESENCE',
      subtitle: isPt
          ? 'Onde compartilho aprendizados e evolucao profissional.'
          : 'Where I share insights and professional growth.',
      child: Column(
        children: <Widget>[
          _ProjectRowCard(
            isDarkMode: isDarkMode,
            title: 'LINKEDIN',
            description: linkedinHeadline,
            stack: const <String>['Brand', 'Networking'],
            url: linkedinProfile?.profileUrl ??
                'https://www.linkedin.com/in/alvaro-matheus-madureira-carlisbino-786534286/',
            accent: AppColors.neonBlue,
          ),
          if (devtoArticles.isNotEmpty) const SizedBox(height: 10),
          ...devtoArticles.map((DevtoArticleSummary article) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ProjectRowCard(
                isDarkMode: isDarkMode,
                title: article.title,
                description: article.publishedAt,
                stack: const <String>['Dev.to', 'Article'],
                url: article.url,
                accent: AppColors.acidGreen,
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
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: NeoBrutalCard(
            isDarkMode: isDarkMode,
            backgroundColor:
                isDarkMode ? AppColors.neonYellow : AppColors.brutalRed,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  isPt
                      ? 'VAMOS CONSTRUIR ALGO GRANDE?'
                      : 'LET US BUILD SOMETHING BIG?',
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.black,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: socialLinks
                      .map((SocialLink link) => _ActionTag(
                            label: link.label.toUpperCase(),
                            onTap: () => _launch(link.url),
                            isDarkMode: false,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12),
                Text(
                  '© ${DateTime.now().year} $fullName',
                  style: AppTextStyles.caption.copyWith(color: AppColors.black),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).scale(),
        ),
      ),
    );
  }
}

class _SectionShell extends StatelessWidget {
  const _SectionShell({
    required this.isDarkMode,
    required this.title,
    required this.subtitle,
    required this.child,
    this.alternate = false,
  });

  final bool isDarkMode;
  final String title;
  final String subtitle;
  final Widget child;
  final bool alternate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Container(
            decoration: BoxDecoration(
              color: alternate
                  ? (isDarkMode ? AppColors.mediumGray : AppColors.lightGray)
                  : Colors.transparent,
              border: Border.all(
                color: isDarkMode ? AppColors.white : AppColors.black,
                width: alternate ? 2 : 0,
              ),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: AppTextStyles.h2.copyWith(
                    color: isDarkMode ? AppColors.white : AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.body2.copyWith(
                    color: isDarkMode ? AppColors.lightGray : AppColors.black,
                  ),
                ),
                const SizedBox(height: 12),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IntroPanel extends StatelessWidget {
  const _IntroPanel({
    required this.isDarkMode,
    required this.locale,
    required this.profile,
  });

  final bool isDarkMode;
  final Locale locale;
  final ProfileContent profile;

  @override
  Widget build(BuildContext context) {
    return NeoBrutalCard(
      isDarkMode: isDarkMode,
      backgroundColor: isDarkMode ? AppColors.cardDark : AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            profile.title.resolve(locale).toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              color: isDarkMode ? AppColors.neonYellow : AppColors.brutalRed,
            ),
          ),
          const SizedBox(height: 8),
          ...profile.introParagraphs.map((LocalizedText paragraph) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                paragraph.resolve(locale),
                style: AppTextStyles.body2.copyWith(
                  color: isDarkMode ? AppColors.white : AppColors.black,
                ),
              ),
            );
          }),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.focusTags
                .map((String tag) => _SkillPill(
                    label: tag.toUpperCase(), isDarkMode: isDarkMode))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _StatsPanel extends StatelessWidget {
  const _StatsPanel({
    required this.isDarkMode,
    required this.locale,
    required this.stats,
  });

  final bool isDarkMode;
  final Locale locale;
  final List<PortfolioStat> stats;

  @override
  Widget build(BuildContext context) {
    return NeoBrutalCard(
      isDarkMode: isDarkMode,
      backgroundColor: isDarkMode ? AppColors.mediumGray : AppColors.lightGray,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: stats.map((PortfolioStat stat) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    stat.label.resolve(locale).toUpperCase(),
                    style: AppTextStyles.caption.copyWith(
                      color: isDarkMode
                          ? AppColors.neonYellow
                          : AppColors.brutalRed,
                    ),
                  ),
                ),
                Text(
                  stat.value,
                  style: AppTextStyles.h3.copyWith(
                    color: isDarkMode ? AppColors.white : AppColors.black,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ProjectRowCard extends StatefulWidget {
  const _ProjectRowCard({
    required this.isDarkMode,
    required this.title,
    required this.description,
    required this.stack,
    required this.url,
    required this.accent,
    this.reverse = false,
  });

  final bool isDarkMode;
  final String title;
  final String description;
  final List<String> stack;
  final String url;
  final Color accent;
  final bool reverse;

  @override
  State<_ProjectRowCard> createState() => _ProjectRowCardState();
}

class _ProjectRowCardState extends State<_ProjectRowCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final Widget content = NeoBrutalCard(
      isDarkMode: widget.isDarkMode,
      backgroundColor: widget.isDarkMode ? AppColors.cardDark : AppColors.white,
      offset: _isHovering ? const Offset(12, 12) : const Offset(8, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.title.toUpperCase(),
                  style: AppTextStyles.h3.copyWith(
                    color:
                        widget.isDarkMode ? AppColors.white : AppColors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.description,
                  style: AppTextStyles.body2.copyWith(
                    color: widget.isDarkMode
                        ? AppColors.lightGray
                        : AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: widget.stack
                      .map((String item) => _SkillPill(
                            label: item.toUpperCase(),
                            isDarkMode: widget.isDarkMode,
                            accent: widget.accent,
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () => _launch(widget.url),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.accent,
                border: Border.all(color: AppColors.black, width: 2),
              ),
              child: const Icon(Icons.open_in_new, color: AppColors.black),
            ),
          ),
        ],
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _isHovering ? -4 : 0, 0),
        child: content,
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    required this.isDarkMode,
    required this.yearRange,
    required this.title,
    required this.organization,
    required this.description,
  });

  final bool isDarkMode;
  final String yearRange;
  final String title;
  final String organization;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 10,
          height: 96,
          color: isDarkMode ? AppColors.neonYellow : AppColors.brutalRed,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: NeoBrutalCard(
            isDarkMode: isDarkMode,
            backgroundColor: isDarkMode ? AppColors.cardDark : AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  yearRange,
                  style: AppTextStyles.caption.copyWith(
                    color:
                        isDarkMode ? AppColors.neonYellow : AppColors.brutalRed,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: AppTextStyles.h3.copyWith(
                    color: isDarkMode ? AppColors.white : AppColors.black,
                  ),
                ),
                Text(
                  organization,
                  style: AppTextStyles.caption.copyWith(
                    color:
                        isDarkMode ? AppColors.lightGray : AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: AppTextStyles.body2.copyWith(
                    color: isDarkMode ? AppColors.white : AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SkillPill extends StatelessWidget {
  const _SkillPill({
    required this.label,
    required this.isDarkMode,
    this.accent,
  });

  final String label;
  final bool isDarkMode;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final Color base =
        accent ?? (isDarkMode ? AppColors.neonYellow : AppColors.brutalRed);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: base,
        border: Border.all(color: AppColors.black, width: 1.5),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: AppColors.black),
      ),
    );
  }
}

class _ActionTag extends StatefulWidget {
  const _ActionTag({
    required this.label,
    required this.onTap,
    required this.isDarkMode,
  });

  final String label;
  final VoidCallback onTap;
  final bool isDarkMode;

  @override
  State<_ActionTag> createState() => _ActionTagState();
}

class _ActionTagState extends State<_ActionTag> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final Color bg =
        widget.isDarkMode ? AppColors.neonYellow : AppColors.brutalRed;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.translationValues(0, _hover ? -3 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: AppColors.black, width: 2),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.65),
                blurRadius: 0,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          child: Text(
            widget.label,
            style: AppTextStyles.caption.copyWith(color: AppColors.black),
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
    required this.isDarkMode,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.neonYellow : AppColors.brutalRed,
          border: Border.all(color: AppColors.black, width: 2),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.6),
              blurRadius: 0,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.black, size: 20),
      ),
    );
  }
}

class _FloatingCta extends StatefulWidget {
  const _FloatingCta({required this.isDarkMode});

  final bool isDarkMode;

  @override
  State<_FloatingCta> createState() => _FloatingCtaState();
}

class _FloatingCtaState extends State<_FloatingCta> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => _launch('mailto:alvarocarlisbino@gmail.com'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          transform: Matrix4.translationValues(0, _hover ? -4 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isDarkMode ? AppColors.acidGreen : AppColors.neonBlue,
            border: Border.all(color: AppColors.black, width: 2),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: AppColors.black,
                blurRadius: 0,
                offset: Offset(5, 5),
              ),
            ],
          ),
          child: Text(
            'CONTACT',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.black,
            ),
          ),
        ),
      ),
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
      child: NeoBrutalCard(
        isDarkMode: isDarkMode,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Falha ao carregar portfolio',
              style: AppTextStyles.h3.copyWith(
                color: isDarkMode ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: onRetry, child: const Text('Tentar novamente')),
          ],
        ),
      ),
    );
  }
}

Future<void> _launch(String value) async {
  final Uri uri = Uri.parse(value);
  await launchUrl(uri, mode: LaunchMode.platformDefault);
}
