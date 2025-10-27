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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late LocalizationViewModel _localization;
  late ThemeViewModel _theme;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  
  int _hoveredProjectIndex = -1;
  int _hoveredSocialButton = -1;

  bool get isDarkMode => _theme.isDarkMode;

  String translate(String key) => _localization.translate(key);

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

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
        body: Stack(
          children: [
            _buildAnimatedBackground(),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),

                  _buildProfileSection()
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms)
                      .slideY(begin: 0.2, end: 0),

                  _buildAboutSection()
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 250.ms),

                  _buildSkillsSection()
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 300.ms),

                  _buildHackathonsSection()
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 400.ms),

                  _buildEducationSection()
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 450.ms),

                  const SizedBox(height: 50),

                  _buildProjectsSection()
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 600.ms),

                  const SizedBox(height: 50),

                  _buildFooter().animate().fadeIn(duration: 600.ms, delay: 800.ms),
                ],
              ),
            ),
            _buildFloatingControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(15, (index) {
            final offset = _particleController.value * 2 * 3.14159;
            final x = MediaQuery.of(context).size.width * 
                (0.1 + (index * 0.07) + (0.1 * (index % 3 - 1))) +
                (50 * (index % 2 == 0 ? 1 : -1) * (offset % 1));
            final y = MediaQuery.of(context).size.height * 
                (0.1 + (index * 0.06)) +
                (30 * (index % 3 - 1) * ((offset + index) % 1));
            
            return Positioned(
              left: x,
              top: y,
              child: Container(
                width: 4 + (index % 3) * 2,
                height: 4 + (index % 3) * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (isDarkMode ? AppColors.neonBlue : AppColors.neonPurple)
                          .withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildFloatingControls() {
    return Positioned(
      top: 20,
      right: 20,
      child: AnimatedBuilder(
        animation: _floatingController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 5 * _floatingController.value),
            child: child,
          );
        },
        child: Row(
          children: [
            _buildControlButton(
              icon: Icons.brightness_4,
              onPressed: () {
                setState(() {
                  _theme.toggleTheme();
                });
              },
            ).animate().fadeIn(duration: 600.ms).scale(begin: Offset(0.8, 0.8)),
            const SizedBox(width: 12),
            _buildControlButton(
              icon: Icons.translate,
              onPressed: () => _showLanguageDialog(),
            ).animate().fadeIn(duration: 600.ms, delay: 100.ms).scale(begin: Offset(0.8, 0.8)),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.neonBlue.withOpacity(0.2),
            AppColors.neonPurple.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode 
            ? AppColors.neonBlue.withOpacity(0.4)
            : AppColors.neonPurple.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
              ? AppColors.neonBlue.withOpacity(0.2)
              : AppColors.neonPurple.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Icon(
              icon,
              color: isDarkMode ? AppColors.neonBlue : AppColors.neonPurple,
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
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final pulse = (1 + 0.1 * _pulseController.value);
              return Transform.scale(
                scale: pulse,
                child: Container(
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
                        color: AppColors.neonBlue.withOpacity(0.3 * pulse),
                        spreadRadius: 2 * pulse,
                        blurRadius: 20 * pulse,
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
                ),
              );
            },
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

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: 18,
                color: isDarkMode 
                  ? AppColors.neonBlue.withOpacity(0.7)
                  : AppColors.neonPurple.withOpacity(0.7),
              ),
              const SizedBox(width: 6),
              Text(
                "Maringá, Brasil",
                style: GoogleFonts.poppins(
                  fontSize: 1.8.sw,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.6)
                      : AppColors.blackBackgroundColor.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 20),
              Icon(
                Icons.email_outlined,
                size: 18,
                color: isDarkMode 
                  ? AppColors.neonBlue.withOpacity(0.7)
                  : AppColors.neonPurple.withOpacity(0.7),
              ),
              const SizedBox(width: 6),
              Text(
                "alvaromathe123@gmail.com",
                style: GoogleFonts.poppins(
                  fontSize: 1.8.sw,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.6)
                      : AppColors.blackBackgroundColor.withOpacity(0.6),
                ),
              ),
            ],
          ).animate()
            .fadeIn(duration: 600.ms, delay: 250.ms)
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

          const SizedBox(height: 24),

          // Stats Row
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 30,
            runSpacing: 16,
            children: [
              _buildStatItem(translate(TranslationKeys.yearsExperience).replaceAll('%s', _calculateExperience()), "Anos de Experiência", Icons.work_outline),
              _buildStatItem("5+", "Hackathons Vencidos", Icons.emoji_events_outlined),
            ],
          ).animate()
            .fadeIn(duration: 600.ms, delay: 450.ms)
            .slideY(begin: 0.2, end: 0),

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

  Widget _buildAboutSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      padding: const EdgeInsets.all(40),
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: const BoxConstraints(maxWidth: 1000),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.neonBlue.withOpacity(0.05),
            AppColors.neonPurple.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDarkMode 
            ? AppColors.neonBlue.withOpacity(0.2)
            : AppColors.neonPurple.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
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
                  Icons.person_outline,
                  color: isDarkMode ? AppColors.neonBlue : AppColors.neonPurple,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                "Sobre Mim",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [
                        AppColors.neonBlue,
                        AppColors.neonPurple,
                      ],
                    ).createShader(Rect.fromLTWH(0, 0, 200, 50)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "Desenvolvedor Mobile apaixonado por criar experiências digitais excepcionais. "
            "Atualmente cursando Engenharia de Software na UNICV, com mais de 2 anos de experiência "
            "prática em Flutter e desenvolvimento mobile, transformo ideias em aplicativos funcionais, "
            "elegantes e escaláveis.",
            style: GoogleFonts.poppins(
              fontSize: 16,
              height: 1.8,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.85)
                  : AppColors.blackBackgroundColor.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Minha jornada começou em 2023 e desde então venho conquistando prêmios em hackathons, "
            "palestrando no Google Developer Group (GDG) e desenvolvendo soluções reais para empresas. "
            "Especializado em Flutter, também possuo experiência sólida em diversas tecnologias "
            "backend, cloud computing e arquiteturas escaláveis.",
            style: GoogleFonts.poppins(
              fontSize: 16,
              height: 1.8,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.85)
                  : AppColors.blackBackgroundColor.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildTagChip("🎯 Clean Code"),
              _buildTagChip("📱 Mobile First"),
              _buildTagChip("🚀 Performance"),
              _buildTagChip("🎨 UI/UX Design"),
              _buildTagChip("🧪 TDD"),
              _buildTagChip("🏆 Hackathon Winner"),
              _buildTagChip("🎤 Speaker GDG"),
              _buildTagChip("🎓 Estudante Eng. Software"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode 
          ? AppColors.neonBlue.withOpacity(0.15)
          : AppColors.neonPurple.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode 
            ? AppColors.neonBlue.withOpacity(0.3)
            : AppColors.neonPurple.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isDarkMode ? AppColors.textLight : AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label, String url) {
    final index = label == "GitHub" ? 0 : (label == "LinkedIn" ? 1 : 2);
    final isHovered = _hoveredSocialButton == index;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredSocialButton = index),
      onExit: (_) => setState(() => _hoveredSocialButton = -1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..translate(0.0, isHovered ? -5.0 : 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              AppColors.neonBlue.withOpacity(isHovered ? 0.2 : 0.1),
              AppColors.neonPurple.withOpacity(isHovered ? 0.2 : 0.1),
            ],
          ),
          border: Border.all(
            color: isDarkMode 
              ? AppColors.neonBlue.withOpacity(isHovered ? 0.6 : 0.3)
              : AppColors.neonPurple.withOpacity(isHovered ? 0.6 : 0.3),
            width: isHovered ? 2.0 : 1.5,
          ),
          boxShadow: isHovered ? [
            BoxShadow(
              color: (isDarkMode ? AppColors.neonBlue : AppColors.neonPurple)
                  .withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ] : null,
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
                    size: isHovered ? 22 : 20,
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
            text: "Hackathons & Conquistas",
            style: AppTextStyles.h2.copyWith(
              color: isDarkMode ? AppColors.white : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Múltiplas vitórias em competições de inovação e tecnologia pelo Brasil",
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

  Widget _buildEducationSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      constraints: const BoxConstraints(maxWidth: 1000),
      child: Column(
        children: [
          AnimatedTitle(
            text: "Educação & Conquistas",
            style: AppTextStyles.h2.copyWith(
              color: isDarkMode ? AppColors.white : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Meu percurso acadêmico e profissional em desenvolvimento",
            style: AppTextStyles.body1.copyWith(
              color: isDarkMode ? AppColors.white.withOpacity(0.7) : AppColors.textDark.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 40),
          _buildTimelineItem(
            year: "2025 - 2029",
            title: "Bacharelado em Engenharia de Software",
            institution: "UNICV - Universidade Cidade Verde",
            description: "Em andamento - Focado em arquitetura de software, desenvolvimento mobile, "
                "padrões de projeto, metodologias ágeis e boas práticas de engenharia.",
            icon: Icons.school_outlined,
            isFirst: true,
          ),
          _buildTimelineItem(
            year: "2025",
            title: "Palestrante - Google Developer Group",
            institution: "GDG (Google Developer Group)",
            description: "Palestrante sobre desenvolvimento mobile e boas práticas em Flutter, "
                "compartilhando conhecimento com a comunidade de desenvolvedores.",
            icon: Icons.groups_outlined,
          ),
          _buildTimelineItem(
            year: "2023-2024",
            title: "Múltiplas Vitórias em Hackathons",
            institution: "Competições de Inovação",
            description: "Vencedor de diversos hackathons incluindo Inova Agro (SEBRAE), "
                "Deco CX e CTFW, desenvolvendo soluções inovadoras para problemas reais.",
            icon: Icons.emoji_events_outlined,
          ),
          _buildTimelineItem(
            year: "2023",
            title: "Início na Jornada Mobile",
            institution: "Flutter & Desenvolvimento Mobile",
            description: "Início do aprendizado focado em Flutter e Dart, desenvolvimento de "
                "aplicativos mobile nativos e arquitetura de software.",
            icon: Icons.rocket_launch_outlined,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String year,
    required String title,
    required String institution,
    required String description,
    required IconData icon,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isFirst)
              Container(
                width: 2,
                height: 20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.neonBlue.withOpacity(0.3),
                      AppColors.neonPurple.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.neonBlue.withOpacity(0.2),
                    AppColors.neonPurple.withOpacity(0.2),
                  ],
                ),
                border: Border.all(
                  color: isDarkMode 
                    ? AppColors.neonBlue.withOpacity(0.5)
                    : AppColors.neonPurple.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                color: isDarkMode ? AppColors.neonBlue : AppColors.neonPurple,
                size: 24,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.neonBlue.withOpacity(0.3),
                      AppColors.neonPurple.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 40),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.neonBlue.withOpacity(0.05),
                  AppColors.neonPurple.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode 
                  ? AppColors.neonBlue.withOpacity(0.2)
                  : AppColors.neonPurple.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  year,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? AppColors.neonBlue : AppColors.neonPurple,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  institution,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode 
                      ? AppColors.textLight.withOpacity(0.7)
                      : AppColors.textDark.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    height: 1.6,
                    color: isDarkMode 
                      ? AppColors.textLight.withOpacity(0.8)
                      : AppColors.textDark.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
            "Uma seleção dos meus melhores trabalhos e contribuições open source",
            style: AppTextStyles.body1.copyWith(
              color: isDarkMode ? AppColors.white.withOpacity(0.7) : AppColors.textDark.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
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
                index: index,
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
    required int index,
  }) {
    final isHovered = _hoveredProjectIndex == index;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredProjectIndex = index),
      onExit: (_) => setState(() => _hoveredProjectIndex = -1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()
          ..translate(0.0, isHovered ? -10.0 : 0.0)
          ..scale(isHovered ? 1.03 : 1.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: isHovered ? [
              BoxShadow(
                color: (isDarkMode ? AppColors.neonBlue : AppColors.neonPurple)
                    .withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ] : null,
          ),
          child: GlassCard(
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
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.neonBlue.withOpacity(isHovered ? 0.3 : 0.2),
                                AppColors.neonPurple.withOpacity(isHovered ? 0.3 : 0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            icon,
                            size: isHovered ? 24 : 20,
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
                              fontSize: isHovered ? 17 : 16,
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
          ),
        ),
      ).animate()
        .fadeIn(duration: 400.ms, delay: 100.ms * index)
        .slideY(begin: 0.1, end: 0),
    );
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
      {'name': 'Python', 'icon': SimpleIcons.python, 'proficiency': 1.0},
      {'name': 'JavaScript', 'icon': SimpleIcons.javascript, 'proficiency': 1.0},
      {'name': 'TypeScript', 'icon': SimpleIcons.typescript, 'proficiency': 1.0},
      {'name': 'React', 'icon': SimpleIcons.react, 'proficiency': 1.0},
      {'name': 'HTML5', 'icon': SimpleIcons.html5, 'proficiency': 1.0},
      {'name': 'CSS3', 'icon': SimpleIcons.css3, 'proficiency': 1.0},
      {'name': 'Docker', 'icon': SimpleIcons.docker, 'proficiency': 1.0},
      {'name': 'AWS', 'icon': SimpleIcons.amazonaws, 'proficiency': 1.0},
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
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: skills.map((skill) => _buildSkillChip(
              skill['name'] as String,
              skill['icon'] as IconData,
              skills.indexOf(skill),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
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
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.neonBlue.withOpacity(0.05),
                  AppColors.neonPurple.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDarkMode 
                  ? AppColors.neonBlue.withOpacity(0.2)
                  : AppColors.neonPurple.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Text(
                  "Vamos construir algo incrível juntos?",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [
                          AppColors.neonBlue,
                          AppColors.neonPurple,
                        ],
                      ).createShader(Rect.fromLTWH(0, 0, 300, 50)),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "Estou sempre aberto a novos projetos e oportunidades",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.7)
                        : AppColors.blackBackgroundColor.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    IconButton(
                      onPressed: () => launchUrl(Uri.parse("https://github.com/alvaro-carlisbino")),
                      icon: Icon(SimpleIcons.github, size: 28),
                      color: isDarkMode ? AppColors.neonBlue : AppColors.neonPurple,
                      tooltip: "GitHub",
                    ),
                    IconButton(
                      onPressed: () => launchUrl(Uri.parse("https://www.linkedin.com/in/alvaro-carlisbino/")),
                      icon: Icon(SimpleIcons.linkedin, size: 28),
                      color: isDarkMode ? AppColors.neonBlue : AppColors.neonPurple,
                      tooltip: "LinkedIn",
                    ),
                    IconButton(
                      onPressed: () => launchUrl(Uri.parse("mailto:alvaromathe123@gmail.com")),
                      icon: Icon(SimpleIcons.gmail, size: 28),
                      color: isDarkMode ? AppColors.neonBlue : AppColors.neonPurple,
                      tooltip: "Email",
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Divider(
            color: isDarkMode 
              ? AppColors.neonBlue.withOpacity(0.2)
              : AppColors.neonPurple.withOpacity(0.2),
            thickness: 1,
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 30,
            runSpacing: 10,
            children: [
              Text(
                "Made with ❤️ using Flutter",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.6)
                      : AppColors.blackBackgroundColor.withOpacity(0.6),
                ),
              ),
              Text(
                "•",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.6)
                      : AppColors.blackBackgroundColor.withOpacity(0.6),
                ),
              ),
              Text(
                "Hosted on Vercel",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.6)
                      : AppColors.blackBackgroundColor.withOpacity(0.6),
                ),
              ),
              Text(
                "•",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.6)
                      : AppColors.blackBackgroundColor.withOpacity(0.6),
                ),
              ),
              Text(
                "100% Flutter Web",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.6)
                      : AppColors.blackBackgroundColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            translate(TranslationKeys.copy),
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
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
    final startDate = DateTime(2023, 6);
    final now = DateTime.now();
    
    final years = now.year - startDate.year;
    final months = now.month - startDate.month;
    
    final totalMonths = (years * 12) + months;
    final experienceYears = totalMonths / 12;
    
    final formattedYears = experienceYears.toStringAsFixed(1);
    return formattedYears;
  }

  String _calculateMonths() {
    final startDate = DateTime(2023, 6);
    final now = DateTime.now();
    
    final years = now.year - startDate.year;
    final months = now.month - startDate.month;
    
    return ((years * 12) + months).toString();
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.neonBlue.withOpacity(0.1),
            AppColors.neonPurple.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode 
            ? AppColors.neonBlue.withOpacity(0.3)
            : AppColors.neonPurple.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 28,
            color: isDarkMode ? AppColors.neonBlue : AppColors.neonPurple,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [
                    AppColors.neonBlue,
                    AppColors.neonPurple,
                  ],
                ).createShader(Rect.fromLTWH(0, 0, 100, 30)),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.7)
                  : AppColors.blackBackgroundColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String name, IconData icon, int index) {
    return MouseRegion(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.neonBlue.withOpacity(0.1),
              AppColors.neonPurple.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isDarkMode 
              ? AppColors.neonBlue.withOpacity(0.3)
              : AppColors.neonPurple.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (isDarkMode ? AppColors.neonBlue : AppColors.neonPurple).withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isDarkMode ? AppColors.neonBlue : AppColors.neonPurple,
            ),
            const SizedBox(width: 10),
            Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? AppColors.textLight : AppColors.textDark,
              ),
            ),
          ],
        ),
      )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .shimmer(
          duration: 2000.ms,
          delay: (index * 200).ms,
          color: (isDarkMode ? AppColors.neonBlue : AppColors.neonPurple).withOpacity(0.3),
        ),
    ).animate().fadeIn(
      duration: 400.ms,
      delay: 50.ms * index,
    ).scale(begin: Offset(0.9, 0.9), end: Offset(1, 1));
  }
}
