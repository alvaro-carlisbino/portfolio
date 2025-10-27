import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:repositoriobryzzen/l10n/core/constants/translation_keys.dart';
import 'package:repositoriobryzzen/viewmodels/theme_viewmodel.dart';
import 'package:repositoriobryzzen/viewmodels/localization_viewmodel.dart';
import 'package:repositoriobryzzen/utils/colors.dart';
import 'package:repositoriobryzzen/utils/text_styles.dart';
import 'package:repositoriobryzzen/widgets/glass_card.dart';
import 'package:repositoriobryzzen/widgets/skill_card.dart';
import 'package:repositoriobryzzen/widgets/animated_title.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late LocalizationViewModel _localization;
  late ThemeViewModel _theme;

  bool get isDarkMode => _theme.isDarkMode;

  String translate(String key) => _localization.translate(key);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localization = Provider.of<LocalizationViewModel>(context);
    _theme = Provider.of<ThemeViewModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(
      builder: (context) => Scaffold(
        backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildHeader(),

              _buildProfileSection()
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideY(begin: 0.2, end: 0),

              _buildSkillsSection()
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 300.ms),

              _buildHackathonsSection()
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 400.ms),

              const SizedBox(height: 50),

              _buildProjectsSection()
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 600.ms),

              const SizedBox(height: 50),

              _buildFooter().animate().fadeIn(duration: 600.ms, delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "AC",
            style: GoogleFonts.poppins(
              fontSize: 5.sw,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppColors.textLight : AppColors.textDark,
            ),
          ).animate().fadeIn(duration: 600.ms),

          Row(
            children: [
              _buildControlButton(
                icon: Icons.brightness_4,
                onPressed: () {
                  setState(() {
                    _theme.toggleTheme();
                  });
                },
              ),
              const SizedBox(width: 12),
              _buildControlButton(
                icon: Icons.translate,
                onPressed: () => _showLanguageDialog(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.glassDark : AppColors.glassLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              color: isDarkMode ? AppColors.textLight : AppColors.textDark,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          translate(TranslationKeys.selectLanguage),
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDarkMode ? AppColors.textLight : AppColors.textDark,
          ),
        ),
        backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.cardLight,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('English', 'en', 'US'),
            _buildLanguageOption('Português', 'pt', 'BR'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
      String language, String languageCode, String countryCode) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(
        language,
        style: GoogleFonts.poppins(
          fontSize: 2.sw,
          color: isDarkMode ? AppColors.textLight : AppColors.textDark,
        ),
      ),
      onTap: () {
        final localization = Provider.of<LocalizationViewModel>(context, listen: false);
        localization.setLocale(Locale(languageCode, countryCode));
        Navigator.pop(context);
      },
      hoverColor: isDarkMode
          ? AppColors.textLight.withOpacity(0.1)
          : AppColors.textDark.withOpacity(0.05),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      margin: const EdgeInsets.only(top: 100, bottom: 60),
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: const BoxConstraints(maxWidth: 900),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.neonBlue,
                  AppColors.neonPurple,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonBlue.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 20,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 132,
                height: 132,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
                ),
                child: Center(
                  child: Text(
                    "AC",
                    style: GoogleFonts.poppins(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [
                            AppColors.neonBlue,
                            AppColors.neonPurple,
                          ],
                        ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                    ),
                  ),
                ),
              ),
            ),
          ).animate()
            .fadeIn(duration: 600.ms)
            .scale(begin: Offset(0.8, 0.8), end: Offset(1, 1)),
          
          const SizedBox(height: 32),

          Text(
            "Alvaro Carlisbino",
            style: GoogleFonts.poppins(
              fontSize: 5.sw,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : AppColors.blackBackgroundColor,
            ),
          ).animate()
            .fadeIn(duration: 600.ms, delay: 200.ms)
            .slideY(begin: 0.2, end: 0),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.neonBlue.withOpacity(0.2),
                  AppColors.neonPurple.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isDarkMode 
                  ? AppColors.neonBlue.withOpacity(0.3)
                  : AppColors.neonPurple.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              translate(TranslationKeys.devRole),
              style: GoogleFonts.poppins(
                fontSize: 2.8.sw,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? AppColors.neonBlue : AppColors.neonPurple,
              ),
            ),
          ).animate()
            .fadeIn(duration: 600.ms, delay: 300.ms)
            .scale(begin: Offset(0.9, 0.9), end: Offset(1, 1)),

          const SizedBox(height: 32),

          Text(
            translate(TranslationKeys.welcomePortfolio),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 2.2.sw,
              height: 1.6,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.8)
                  : AppColors.blackBackgroundColor.withOpacity(0.7),
            ),
          ).animate()
            .fadeIn(duration: 600.ms, delay: 400.ms),

          const SizedBox(height: 40),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildSocialButton(SimpleIcons.github, "GitHub",
                  "https://github.com/alvaro-carlisbino"),
              _buildSocialButton(SimpleIcons.linkedin, "LinkedIn",
                  "https://www.linkedin.com/in/alvaro-carlisbino/"),
              _buildSocialButton(SimpleIcons.gmail, "Email",
                  "mailto:alvaromathe123@gmail.com"),
            ],
          ).animate()
            .fadeIn(duration: 600.ms, delay: 500.ms)
            .slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label, String url) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            AppColors.neonBlue.withOpacity(0.1),
            AppColors.neonPurple.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: isDarkMode 
            ? AppColors.neonBlue.withOpacity(0.3)
            : AppColors.neonPurple.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => launchUrl(Uri.parse(url)),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isDarkMode ? AppColors.neonBlue : AppColors.neonPurple,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHackathonsSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          AnimatedTitle(
            text: "Hackathons",
            style: AppTextStyles.h2.copyWith(
              color: isDarkMode ? AppColors.white : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Conquistas em competições de inovação",
            style: AppTextStyles.body1.copyWith(
              color: isDarkMode ? AppColors.white.withOpacity(0.7) : AppColors.textDark.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 40),
          _buildHackathonCarousel(),
        ],
      ),
    );
  }

  Widget _buildHackathonCarousel() {
    return FlutterCarousel(
      items: [0, 1, 2].map((i) {
        var nomes = [
          translate(TranslationKeys.inovaAgro),
          translate(TranslationKeys.decoCx),
          translate(TranslationKeys.ctfw)
        ];
        var desc = [
          translate(TranslationKeys.monobox),
          translate(TranslationKeys.fluxus),
          translate(TranslationKeys.cianorte)
        ];
        var fotos = [
          "assets/inovaagro.jpg",
          "assets/fluxo_deco.png",
          "assets/ctfw.HEIC"
        ];

        return GestureDetector(
          onTap: () {
            if (i == 0) {
              launchUrl(Uri.parse(
                  "https://pr.agenciasebrae.com.br/inovacao-e-tecnologia/projeto-de-box-para-cultivo-de-morangos-vence-hackathon-inova-agro-na-expoinga/"));
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.cardDark
                  : AppColors.cardLight,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(fotos[i]),
                opacity: 0.5,
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nomes[i],
                    style: GoogleFonts.poppins(
                      fontSize: 3.5.sw,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    desc[i],
                    style: GoogleFonts.poppins(
                      fontSize: 2.sw,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (i == 0)
                    ElevatedButton(
                      onPressed: () {
                        launchUrl(Uri.parse(
                            "https://pr.agenciasebrae.com.br/inovacao-e-tecnologia/projeto-de-box-para-cultivo-de-morangos-vence-hackathon-inova-agro-na-expoinga/"));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        translate(TranslationKeys.seeMore),
                        style: GoogleFonts.poppins(
                          fontSize: 1.8.sw,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 500.0,
        showIndicator: true,
        slideIndicator: const CircularSlideIndicator(),
        viewportFraction: 0.8,
      ),
    );
  }

  Widget _buildProjectsSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      constraints: const BoxConstraints(maxWidth: 1400),
      child: Column(
        children: [
          AnimatedTitle(
            text: translate(TranslationKeys.projects),
            style: AppTextStyles.h2.copyWith(
              color: isDarkMode ? AppColors.white : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Projetos e contribuições",
            style: AppTextStyles.body1.copyWith(
              color: isDarkMode ? AppColors.white.withOpacity(0.7) : AppColors.textDark.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 50),
          _buildProjectsGrid(),
        ],
      ),
    );
  }

  Widget _buildProjectsGrid() {
    final projects = [
      {
        'title': 'Assistente-Virtual-SESI',
        'icon': SimpleIcons.nodedotjs,
        'iconColor': Colors.green,
        'description': translate(TranslationKeys.sesi),
        'url': 'https://github.com/alvaro-carlisbino/Assistente-Virtual-SESI'
      },
      {
        'title': 'GolangAPI',
        'icon': SimpleIcons.goland,
        'iconColor': Colors.black,
        'description': translate(TranslationKeys.golangApi),
        'url': 'https://github.com/alvaro-carlisbino/GolangAPI'
      },
      {
        'title': 'Pokedex',
        'icon': SimpleIcons.html5,
        'iconColor': Colors.red,
        'description': translate(TranslationKeys.pokedex),
        'url': 'https://github.com/alvaro-carlisbino/Pokedex'
      },
      {
        'title': 'Fluxus',
        'icon': SimpleIcons.html5,
        'iconColor': Colors.red,
        'description': translate(TranslationKeys.fluxus),
        'url': 'https://github.com/alvaro-carlisbino/fluxus'
      },
      {
        'title': translate(TranslationKeys.repository),
        'icon': SimpleIcons.flutter,
        'iconColor': Colors.blue,
        'description': translate(TranslationKeys.repoDesc),
        'url': 'https://github.com/alvaro-carlisbino/portfolio'
      },
      {
        'title': translate(TranslationKeys.molda),
        'icon': SimpleIcons.flutter,
        'iconColor': Colors.blue,
        'description': translate(TranslationKeys.moldaDesc),
        'url': 'https://molda.online'
      },
      {
        'title': translate(TranslationKeys.luna),
        'icon': SimpleIcons.flutter,
        'iconColor': Colors.blue,
        'description': translate(TranslationKeys.lunaDesc),
        'url': 'https://github.com/alvaro-carlisbino/lunaboneti'
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (constraints.maxWidth < 600) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 1000) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 3;
        }

        return Padding(
          padding: EdgeInsets.zero,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.8,
            ),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return _buildProjectCard(
                title: projects[index]['title'].toString(),
                icon: projects[index]['icon'] as IconData,
                iconColor: projects[index]['iconColor'] as Color,
                description: projects[index]['description'].toString(),
                url: projects[index]['url'].toString(),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProjectCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String description,
    required String url,
  }) {
    return GlassCard(
      isDark: isDarkMode,
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(url)),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.neonBlue.withOpacity(0.2),
                          AppColors.neonPurple.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: isDarkMode ? AppColors.neonBlue : AppColors.neonPurple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.body1.copyWith(
                        color: isDarkMode ? AppColors.textLight : AppColors.textDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body2.copyWith(
                  color: isDarkMode
                      ? AppColors.textLight.withOpacity(0.7)
                      : AppColors.textDark.withOpacity(0.7),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate()
      .fadeIn(duration: 400.ms, delay: 100.ms * (title.length % 3))
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildSkillsSection() {
    final skills = [
      {'name': 'Flutter', 'icon': SimpleIcons.flutter, 'proficiency': 1.0},
      {'name': 'Dart', 'icon': SimpleIcons.dart, 'proficiency': 1.0},
      {'name': 'Supabase', 'icon': SimpleIcons.supabase, 'proficiency': 1.0},
      {'name': 'Firebase', 'icon': SimpleIcons.firebase, 'proficiency': 1.0},
      {'name': 'PostgreSQL', 'icon': SimpleIcons.postgresql, 'proficiency': 1.0},
      {'name': 'REST API', 'icon': SimpleIcons.postman, 'proficiency': 1.0},
      {'name': 'Git', 'icon': SimpleIcons.git, 'proficiency': 1.0},
      {'name': 'CI/CD', 'icon': SimpleIcons.githubactions, 'proficiency': 1.0},
      {'name': 'Unity Test', 'icon': SimpleIcons.flutter, 'proficiency': 1.0},
      {'name': 'MVVM', 'icon': SimpleIcons.flutter, 'proficiency': 1.0},
      {'name': 'Node.js', 'icon': SimpleIcons.nodedotjs, 'proficiency': 1.0},
      {'name': 'Go', 'icon': SimpleIcons.go, 'proficiency': 1.0},
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                AnimatedTitle(
                  text: translate(TranslationKeys.experienceTitle),
                  style: AppTextStyles.h2.copyWith(
                    color: isDarkMode ? AppColors.white : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 20),
                GlassCard(
                  isDark: isDarkMode,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Mobile Developer",
                                  style: AppTextStyles.h3.copyWith(
                                    color: isDarkMode ? AppColors.textLight : AppColors.textDark,
                                  ),
                                ),
                                Text(
                                  translate(TranslationKeys.periodExperience),
                                  style: AppTextStyles.body2.copyWith(
                                    color: isDarkMode 
                                        ? AppColors.textLight.withOpacity(0.7) 
                                        : AppColors.textDark.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              translate(TranslationKeys.yearsExperience).replaceAll('%s', _calculateExperience()),
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.neonBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.neonBlue,
                                AppColors.neonPurple,
                                AppColors.neonPink,
                              ],
                            ),
                          ),
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 40,
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Container(
                                      color: isDarkMode 
                                          ? AppColors.cardDark.withOpacity(0.5)
                                          : AppColors.cardLight.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                              Center(
                                child: Text(
                                  translate(TranslationKeys.mobileExperience).replaceAll('%s', _calculateExperience()),
                                  style: AppTextStyles.body2.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          AnimatedTitle(
            text: translate(TranslationKeys.skillsTitle),
            style: AppTextStyles.h2.copyWith(
              color: isDarkMode ? AppColors.white : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            translate(TranslationKeys.skillsDescription),
            style: AppTextStyles.body1.copyWith(
              color: isDarkMode ? AppColors.white.withOpacity(0.7) : AppColors.textDark.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: skills.map((skill) => Container(
              constraints: BoxConstraints(
                minWidth: 140,
                maxWidth: 160,
              ),
              child: GlassCard(
                isDark: isDarkMode,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        skill['icon'] as IconData,
                        size: 24,
                        color: isDarkMode ? AppColors.neonBlue : AppColors.neonPurple,
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          skill['name'] as String,
                          style: AppTextStyles.body2.copyWith(
                            color: isDarkMode ? AppColors.textLight : AppColors.textDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(
              duration: 400.ms,
              delay: 50.ms * skills.indexOf(skill),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode
              ? [
                  AppColors.darkBackground,
                  AppColors.cardDark,
                ]
              : [
                  AppColors.white,
                  AppColors.cardLight,
                ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              IconButton(
                onPressed: () => launchUrl(Uri.parse("https://github.com/alvaro-carlisbino")),
                icon: Icon(SimpleIcons.github, size: 24),
                color: isDarkMode ? AppColors.neonBlue : AppColors.neonPurple,
                tooltip: "GitHub",
              ),
              IconButton(
                onPressed: () => launchUrl(Uri.parse("https://www.linkedin.com/in/alvaro-carlisbino/")),
                icon: Icon(SimpleIcons.linkedin, size: 24),
                color: isDarkMode ? AppColors.neonBlue : AppColors.neonPurple,
                tooltip: "LinkedIn",
              ),
              IconButton(
                onPressed: () => launchUrl(Uri.parse("mailto:alvaromathe123@gmail.com")),
                icon: Icon(SimpleIcons.gmail, size: 24),
                color: isDarkMode ? AppColors.neonBlue : AppColors.neonPurple,
                tooltip: "Email",
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            translate(TranslationKeys.copy),
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.5)
                  : AppColors.blackBackgroundColor.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _calculateExperience() {
    final startDate = DateTime(2022, 6);
    final now = DateTime.now();
    
    final years = now.year - startDate.year;
    final months = now.month - startDate.month;
    
    final totalMonths = (years * 12) + months;
    final experienceYears = totalMonths / 12;
    
    final formattedYears = experienceYears.toStringAsFixed(1);
    return formattedYears;
  }

  String _calculateMonths() {
    final startDate = DateTime(2022, 6);
    final now = DateTime.now();
    
    final years = now.year - startDate.year;
    final months = now.month - startDate.month;
    
    return ((years * 12) + months).toString();
  }
}
