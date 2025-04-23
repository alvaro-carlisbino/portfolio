import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repositoriobryzzen/main.dart';
import 'package:repositoriobryzzen/utils/colors.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(
      builder: (context) => Scaffold(
        backgroundColor:
            darkThemeIsEnabled ? RepoColors.blackBackgroundColor : Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(),

              // Profile Section
              _buildProfileSection()
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideY(begin: 0.2, end: 0),

              // Hackathons Section
              _buildHackathonsSection()
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 400.ms),

              const SizedBox(height: 50),

              // Projects Section
              _buildProjectsSection()
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 600.ms),

              const SizedBox(height: 50),

              // Footer
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
        color: darkThemeIsEnabled
            ? RepoColors.blackContainerColor
            : RepoColors.whiteContainerColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo/Brand
          Text(
            "AC",
            style: GoogleFonts.poppins(
              fontSize: 5.sw,
              fontWeight: FontWeight.bold,
              color: darkThemeIsEnabled
                  ? Colors.white
                  : RepoColors.blackBackgroundColor,
            ),
          ).animate().fadeIn(duration: 600.ms),

          // Controls
          Row(
            children: [
              _buildControlButton(
                icon: Icons.brightness_4,
                onPressed: () {
                  setState(() {
                    darkThemeIsEnabled = !darkThemeIsEnabled;
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
        color: darkThemeIsEnabled
            ? RepoColors.blackContainerColor.withOpacity(0.5)
            : Colors.white,
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
              color: darkThemeIsEnabled
                  ? Colors.white
                  : RepoColors.blackBackgroundColor,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    Get.defaultDialog(
      title: "Select a language",
      titleStyle: GoogleFonts.poppins(
        fontSize: 2.sw,
        fontWeight: FontWeight.bold,
        color:
            darkThemeIsEnabled ? Colors.white : RepoColors.blackBackgroundColor,
      ),
      backgroundColor: darkThemeIsEnabled
          ? RepoColors.blackContainerColor
          : RepoColors.whiteContainerColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageOption("English", 'en', 'US'),
          _buildLanguageOption("Português", 'pt', 'BR'),
          _buildLanguageOption("Español", 'es', 'ES'),
          _buildLanguageOption("日本語", 'jp', 'JP'),
        ],
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
          color: darkThemeIsEnabled
              ? Colors.white
              : RepoColors.blackBackgroundColor,
        ),
      ),
      onTap: () {
        Get.updateLocale(Locale(languageCode, countryCode));
        Get.back();
      },
      hoverColor: darkThemeIsEnabled
          ? Colors.white.withOpacity(0.1)
          : Colors.black.withOpacity(0.05),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      margin: const EdgeInsets.only(top: 80, bottom: 50),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: const BoxConstraints(maxWidth: 720),
      decoration: BoxDecoration(
        color: darkThemeIsEnabled
            ? RepoColors.blackContainerColor
            : RepoColors.whiteContainerColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: darkThemeIsEnabled
              ? [RepoColors.blackContainerColor, Color(0xFF1E1E1E)]
              : [RepoColors.whiteContainerColor, Color(0xFFF5F5F5)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile picture (circle avatar)
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: darkThemeIsEnabled
                  ? Colors.white.withOpacity(0.1)
                  : RepoColors.blackBackgroundColor.withOpacity(0.1),
              border: Border.all(
                color: darkThemeIsEnabled
                    ? Colors.white.withOpacity(0.2)
                    : RepoColors.blackBackgroundColor.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                "AC",
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: darkThemeIsEnabled
                      ? Colors.white
                      : RepoColors.blackBackgroundColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Name
          Text(
            "Alvaro Carlisbino",
            style: GoogleFonts.poppins(
              fontSize: 4.sw,
              fontWeight: FontWeight.bold,
              color: darkThemeIsEnabled
                  ? Colors.white
                  : RepoColors.blackBackgroundColor,
            ),
          ),

          const SizedBox(height: 12),

          // Title
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: darkThemeIsEnabled
                  ? Colors.white.withOpacity(0.1)
                  : RepoColors.blackBackgroundColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "dev_fullstack".tr,
              style: GoogleFonts.poppins(
                fontSize: 2.5.sw,
                fontWeight: FontWeight.w500,
                color: darkThemeIsEnabled
                    ? Colors.white
                    : RepoColors.blackBackgroundColor,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Description
          Text(
            "welcome_port".tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 2.sw,
              height: 1.5,
              color: darkThemeIsEnabled
                  ? Colors.white.withOpacity(0.9)
                  : RepoColors.blackBackgroundColor.withOpacity(0.8),
            ),
          ),

          const SizedBox(height: 32),

          // Social links
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildSocialButton(SimpleIcons.github, "GitHub",
                  "https://github.com/alvaro-carlisbino"),
              const SizedBox(width: 16),
              _buildSocialButton(SimpleIcons.linkedin, "LinkedIn",
                  "https://www.linkedin.com/in/alvaro-carlisbino/"),
              const SizedBox(width: 16),
              _buildSocialButton(SimpleIcons.gmail, "Email",
                  "mailto:alvaromathe123@gmail.com"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label, String url) {
    // Get screen width to adjust text size
    final screenWidth = MediaQuery.of(context).size.width;

    // On small screens, show only icons without labels
    final bool showLabel = screenWidth > 600;

    return ElevatedButton(
      onPressed: () => launchUrl(Uri.parse(url)),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          darkThemeIsEnabled
              ? Colors.white.withOpacity(0.1)
              : RepoColors.blackBackgroundColor.withOpacity(0.1),
        ),
        foregroundColor: MaterialStateProperty.all(
          darkThemeIsEnabled ? Colors.white : RepoColors.blackBackgroundColor,
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: showLabel ? 16 : 12,
            vertical: 12,
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      child: showLabel
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth < 800 ? 1.8.sw : 2.sw,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          : Icon(icon, size: 18), // Only show icon on small screens
    );
  }

  Widget _buildHackathonsSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        color: darkThemeIsEnabled
            ? RepoColors.blackContainerColor
            : RepoColors.whiteContainerColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40, bottom: 40),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 30,
                  decoration: BoxDecoration(
                    color: darkThemeIsEnabled
                        ? Colors.white
                        : RepoColors.blackBackgroundColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  "Hackathons",
                  style: GoogleFonts.montserrat(
                    fontSize: 5.sw,
                    fontWeight: FontWeight.bold,
                    color: darkThemeIsEnabled
                        ? Colors.white
                        : RepoColors.blackBackgroundColor,
                  ),
                ),
              ],
            ),
          ),
          _buildHackathonCarousel(),
        ],
      ),
    );
  }

  Widget _buildHackathonCarousel() {
    return FlutterCarousel(
      items: [0, 1, 2].map((i) {
        var nomes = ["inova_agro".tr, "deco_cx".tr, "ctfw".tr];
        var desc = ["monobox".tr, "fluxus".tr, "cianorte".tr];
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
              color: darkThemeIsEnabled
                  ? RepoColors.blackContainerColor
                  : RepoColors.whiteContainerColor,
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
                        "see_more".tr,
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
      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        color: darkThemeIsEnabled
            ? RepoColors.blackContainerColor
            : RepoColors.whiteContainerColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40, bottom: 40),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 30,
                  decoration: BoxDecoration(
                    color: darkThemeIsEnabled
                        ? Colors.white
                        : RepoColors.blackBackgroundColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  "projects".tr,
                  style: GoogleFonts.montserrat(
                    fontSize: 5.sw,
                    fontWeight: FontWeight.bold,
                    color: darkThemeIsEnabled
                        ? Colors.white
                        : RepoColors.blackBackgroundColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _buildProjectsGrid(),
        ],
      ),
    );
  }

  Widget _buildProjectsGrid() {
    // Project data
    final projects = [
      {
        'title': 'Assistente-Virtual-SESI',
        'icon': SimpleIcons.nodedotjs,
        'iconColor': Colors.green,
        'description': 'sesi'.tr,
        'url': 'https://github.com/alvaro-carlisbino/Assistente-Virtual-SESI'
      },
      {
        'title': 'GolangAPI',
        'icon': SimpleIcons.goland,
        'iconColor': Colors.black,
        'description': 'golangapi'.tr,
        'url': 'https://github.com/alvaro-carlisbino/GolangAPI'
      },
      {
        'title': 'Pokedex',
        'icon': SimpleIcons.html5,
        'iconColor': Colors.red,
        'description': 'pokedex'.tr,
        'url': 'https://github.com/alvaro-carlisbino/Pokedex'
      },
      {
        'title': 'Fluxus',
        'icon': SimpleIcons.html5,
        'iconColor': Colors.red,
        'description': 'fluxus'.tr,
        'url': 'https://github.com/alvaro-carlisbino/fluxus'
      },
      {
        'title': '${"repository".tr}',
        'icon': SimpleIcons.flutter,
        'iconColor': Colors.blue,
        'description': 'repodesc'.tr,
        'url': 'https://github.com/alvaro-carlisbino/portfolio'
      },
      {
        'title': '${"molda".tr}',
        'icon': SimpleIcons.flutter,
        'iconColor': Colors.blue,
        'description': 'molda_desc'.tr,
        'url': 'https://molda.online'
      },
      {
        'title': '${"luna".tr}',
        'icon': SimpleIcons.flutter,
        'iconColor': Colors.blue,
        'description': 'luna_desc'.tr,
        'url': 'https://github.com/alvaro-carlisbino/lunaboneti'
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate number of columns based on screen width
        int crossAxisCount;
        if (constraints.maxWidth < 600) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 1000) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 3;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.2,
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
    return Container(
      decoration: BoxDecoration(
        color: darkThemeIsEnabled
            ? RepoColors.blackBackgroundColor.withOpacity(0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: darkThemeIsEnabled
              ? Colors.white.withOpacity(0.1)
              : RepoColors.blackBackgroundColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => launchUrl(Uri.parse(url)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Project icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: darkThemeIsEnabled
                        ? Colors.white.withOpacity(0.1)
                        : RepoColors.blackBackgroundColor.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 40,
                    color: darkThemeIsEnabled
                        ? iconColor.withOpacity(0.9)
                        : iconColor,
                  ),
                ),

                const SizedBox(height: 20),

                // Project title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 2.5.sw,
                    fontWeight: FontWeight.bold,
                    color: darkThemeIsEnabled
                        ? Colors.white
                        : RepoColors.blackBackgroundColor,
                  ),
                ),

                const SizedBox(height: 12),

                // Project description
                Expanded(
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 1.8.sw,
                      color: darkThemeIsEnabled
                          ? Colors.white.withOpacity(0.7)
                          : RepoColors.blackBackgroundColor.withOpacity(0.7),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // View project button
                OutlinedButton(
                  onPressed: () => launchUrl(Uri.parse(url)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: darkThemeIsEnabled
                          ? Colors.white.withOpacity(0.3)
                          : RepoColors.blackBackgroundColor.withOpacity(0.3),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    "see_more".tr,
                    style: GoogleFonts.poppins(
                      fontSize: 1.8.sw,
                      color: darkThemeIsEnabled
                          ? Colors.white
                          : RepoColors.blackBackgroundColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 100.ms * (title.length % 3))
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildFooter() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      color: darkThemeIsEnabled
          ? RepoColors.blackContainerColor
          : RepoColors.whiteContainerColor,
      child: Column(
        children: [
          Divider(
            color: darkThemeIsEnabled
                ? Colors.white.withOpacity(0.1)
                : RepoColors.blackBackgroundColor.withOpacity(0.1),
            thickness: 1,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "copy".tr,
                style: GoogleFonts.poppins(
                  fontSize: 1.5.sw,
                  color: darkThemeIsEnabled
                      ? Colors.white.withOpacity(0.7)
                      : RepoColors.blackBackgroundColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Social links for footer
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildFooterSocialButton(
                  SimpleIcons.linkedin,
                  MediaQuery.of(context).size.width > 600 ? "LinkedIn" : "",
                  "https://www.linkedin.com/in/alvaro-carlisbino/"),
              _buildFooterSocialButton(
                  SimpleIcons.github,
                  MediaQuery.of(context).size.width > 600 ? "GitHub" : "",
                  "https://github.com/alvaro-carlisbino"),
              _buildFooterSocialButton(
                  SimpleIcons.gmail,
                  MediaQuery.of(context).size.width > 600 ? "Email" : "",
                  "mailto:alvaromathe123@gmail.com"),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "© 2025 Alvaro Carlisbino",
            style: GoogleFonts.poppins(
              fontSize: 1.4.sw,
              color: darkThemeIsEnabled
                  ? Colors.white.withOpacity(0.5)
                  : RepoColors.blackBackgroundColor.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSocialButton(IconData icon, String label, String url) {
    return TextButton.icon(
      onPressed: () => launchUrl(Uri.parse(url)),
      icon: Icon(
        icon,
        size: 20,
        color:
            darkThemeIsEnabled ? Colors.white : RepoColors.blackBackgroundColor,
      ),
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 1.8.sw,
          color: darkThemeIsEnabled
              ? Colors.white
              : RepoColors.blackBackgroundColor,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
