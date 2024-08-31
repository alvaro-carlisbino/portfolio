import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repositoriobryzzen/main.dart';
import 'package:repositoriobryzzen/utils/colors.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

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
        backgroundColor: darkThemeIsEnabled == false
            ? Colors.white
            : RepoColors.blackBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                color: darkThemeIsEnabled == false
                    ? RepoColors.whiteContainerColor
                    : RepoColors.blackContainerColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 20, left: 50),
                        child: Text("AC",
                            style: GoogleFonts.poppins(
                              fontSize: 5.sw,
                              fontWeight: FontWeight.bold,
                              color: darkThemeIsEnabled == false
                                  ? RepoColors.blackBackgroundColor
                                  : Colors.white,
                            ))),
                    Container(
                      margin: EdgeInsets.only(right: 30),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: darkThemeIsEnabled == false
                                  ? Colors.white
                                  : RepoColors.blackContainerColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: RepoColors.blackBackgroundColor
                                      .withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.brightness_4,
                                color: darkThemeIsEnabled == false
                                    ? RepoColors.blackBackgroundColor
                                    : Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  darkThemeIsEnabled = !darkThemeIsEnabled;
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: darkThemeIsEnabled == false
                                  ? Colors.white
                                  : RepoColors.blackContainerColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: RepoColors.blackBackgroundColor
                                      .withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.translate,
                                color: darkThemeIsEnabled == false
                                    ? RepoColors.blackBackgroundColor
                                    : Colors.white,
                              ),
                              onPressed: () {
                                Get.defaultDialog(
                                  title: "Select a language",
                                  titleStyle: GoogleFonts.poppins(
                                    fontSize: 2.sw,
                                    fontWeight: FontWeight.bold,
                                    color: darkThemeIsEnabled == false
                                        ? RepoColors.blackBackgroundColor
                                        : Colors.white,
                                  ),
                                  backgroundColor: darkThemeIsEnabled == false
                                      ? RepoColors.whiteContainerColor
                                      : RepoColors.blackContainerColor,
                                  content: Column(
                                    children: [
                                      ListTile(
                                        title: Text("English",
                                            style: GoogleFonts.poppins(
                                              fontSize: 2.sw,
                                              color: darkThemeIsEnabled == false
                                                  ? RepoColors
                                                      .blackBackgroundColor
                                                  : Colors.white,
                                            )),
                                        onTap: () {
                                          Get.updateLocale(
                                              const Locale('en', 'US'));
                                          Get.back();
                                        },
                                      ),
                                      ListTile(
                                        title: Text("Português",
                                            style: GoogleFonts.poppins(
                                              fontSize: 2.sw,
                                              color: darkThemeIsEnabled == false
                                                  ? RepoColors
                                                      .blackBackgroundColor
                                                  : Colors.white,
                                            )),
                                        onTap: () {
                                          Get.updateLocale(
                                              const Locale('pt', 'BR'));
                                          Get.back();
                                        },
                                      ),
                                      ListTile(
                                        title: Text("Español",
                                            style: GoogleFonts.poppins(
                                              fontSize: 2.sw,
                                              color: darkThemeIsEnabled == false
                                                  ? RepoColors
                                                      .blackBackgroundColor
                                                  : Colors.white,
                                            )),
                                        onTap: () {
                                          Get.updateLocale(
                                              const Locale('es', 'ES'));
                                          Get.back();
                                        },
                                      ),
                                      ListTile(
                                        title: Text("日本語",
                                            style: GoogleFonts.poppins(
                                              fontSize: 2.sw,
                                              color: darkThemeIsEnabled == false
                                                  ? RepoColors
                                                      .blackBackgroundColor
                                                  : Colors.white,
                                            )),
                                        onTap: () {
                                          Get.updateLocale(
                                              const Locale('jp', 'JP'));
                                          Get.back();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 120, bottom: 50, left: 50, right: 30),
                alignment: Alignment.center,
                width: 512,
                height: 512,
                decoration: BoxDecoration(
                    color: darkThemeIsEnabled == false
                        ? RepoColors.whiteContainerColor
                        : RepoColors.blackContainerColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: RepoColors.blackBackgroundColor.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: const Offset(0, 1),
                      ),
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Alvaro Carlisbino",
                        style: GoogleFonts.poppins(
                          fontSize: 4.sw,
                          fontWeight: FontWeight.bold,
                          color: darkThemeIsEnabled == false
                              ? RepoColors.blackBackgroundColor
                              : Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 20, left: 20, right: 20),
                      child: Text(
                        "dev_fullstack".tr,
                        style: GoogleFonts.poppins(
                          fontSize: 3.sw,
                          fontWeight: FontWeight.w400,
                          color: darkThemeIsEnabled == false
                              ? RepoColors.blackBackgroundColor
                              : Colors.white,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 20, left: 20, right: 20),
                        child: Text(
                          "welcome_port".tr,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 2.sw,
                            color: darkThemeIsEnabled == false
                                ? RepoColors.blackBackgroundColor
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 200),
                padding: const EdgeInsets.only(bottom: 50),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: darkThemeIsEnabled == false
                        ? RepoColors.whiteContainerColor
                        : RepoColors.blackContainerColor,
                    boxShadow: [
                      BoxShadow(
                        color: RepoColors.blackBackgroundColor.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: const Offset(0, 1),
                      ),
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 40, left: 40),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Hackathons",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.montserrat(
                          fontSize: 5.sw,
                          fontWeight: FontWeight.bold,
                          color: darkThemeIsEnabled == false
                              ? RepoColors.blackBackgroundColor
                              : Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: FlutterCarousel(
                        items: [0, 1, 2].map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              var nomes = [
                                "inova_agro".tr,
                                "deco_cx".tr,
                                "ctfw".tr
                              ];
                              var desc = [
                                "monobox".tr,
                                "fluxus".tr,
                                "cianorte".tr
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
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      decoration: BoxDecoration(
                                        color: darkThemeIsEnabled == false
                                            ? RepoColors.whiteContainerColor
                                            : RepoColors.blackContainerColor,
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(fotos[i]),
                                          opacity: 0.6,
                                          fit: BoxFit.cover,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: RepoColors
                                                .blackBackgroundColor
                                                .withOpacity(0.1),
                                            spreadRadius: 5,
                                            blurRadius: 5,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, bottom: 20),
                                            child: Text(
                                              nomes[i],
                                              style: GoogleFonts.poppins(
                                                fontSize: 3.sw,
                                                fontWeight: FontWeight.bold,
                                                color: darkThemeIsEnabled ==
                                                        false
                                                    ? RepoColors
                                                        .blackBackgroundColor
                                                    : Colors.white,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20,
                                                bottom: 20,
                                                left: 20,
                                                right: 20),
                                            child: Text(
                                              desc[i],
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 2.sw,
                                                color: darkThemeIsEnabled ==
                                                        false
                                                    ? RepoColors
                                                        .blackBackgroundColor
                                                    : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              );
                            },
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 500.0,
                          showIndicator: true,
                          slideIndicator: const CircularSlideIndicator(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                margin: const EdgeInsets.only(top: 200),
                padding: const EdgeInsets.only(bottom: 50),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: darkThemeIsEnabled == false
                        ? RepoColors.whiteContainerColor
                        : RepoColors.blackContainerColor,
                    boxShadow: [
                      BoxShadow(
                        color: RepoColors.blackBackgroundColor.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: const Offset(0, 1),
                      ),
                    ]),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 40, left: 40),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "projects".tr,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.montserrat(
                            fontSize: 5.sw,
                            fontWeight: FontWeight.bold,
                            color: darkThemeIsEnabled == false
                                ? RepoColors.blackBackgroundColor
                                : Colors.white,
                          ),
                        ),
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            spacing: 20,
                            runSpacing: 20,
                            children: [
                              Container(
                                width: constraints.maxWidth < 600
                                    ? constraints.maxWidth * 0.8
                                    : constraints.maxWidth * 0.3,
                                margin:
                                    const EdgeInsets.only(top: 50, left: 50),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: RepoColors.blackBackgroundColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Assistente-Virtual-SESI",
                                      style: GoogleFonts.roboto(
                                        fontSize: 3.sw,
                                        fontWeight: FontWeight.bold,
                                        color: darkThemeIsEnabled == false
                                            ? RepoColors.blackBackgroundColor
                                            : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      "sesi".tr,
                                      style: GoogleFonts.roboto(
                                        fontSize: 2.sw,
                                        color: darkThemeIsEnabled == false
                                            ? RepoColors.blackBackgroundColor
                                            : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextButton(
                                      onPressed: () {
                                        launchUrl(Uri.parse(
                                            "https://github.com/alvaro-carlisbino/Assistente-Virtual-SESI"));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: darkThemeIsEnabled == false
                                              ? Colors.white
                                              : RepoColors.blackBackgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          "see_more".tr,
                                          style: GoogleFonts.poppins(
                                            fontSize: 2.sw,
                                            color: darkThemeIsEnabled == false
                                                ? RepoColors
                                                    .blackBackgroundColor
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: constraints.maxWidth < 600
                                    ? constraints.maxWidth * 0.8
                                    : constraints.maxWidth * 0.3,
                                margin:
                                    const EdgeInsets.only(top: 50, left: 50),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: RepoColors.blackBackgroundColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "GolangAPI",
                                      style: GoogleFonts.roboto(
                                        fontSize: 3.sw,
                                        fontWeight: FontWeight.bold,
                                        color: darkThemeIsEnabled == false
                                            ? RepoColors.blackBackgroundColor
                                            : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      "golangapi".tr,
                                      style: GoogleFonts.roboto(
                                        fontSize: 2.sw,
                                        color: darkThemeIsEnabled == false
                                            ? RepoColors.blackBackgroundColor
                                            : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextButton(
                                      onPressed: () {
                                        launchUrl(Uri.parse(
                                            "https://github.com/alvaro-carlisbino/GolangAPI"));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: darkThemeIsEnabled == false
                                              ? Colors.white
                                              : RepoColors.blackBackgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          "see_more".tr,
                                          style: GoogleFonts.poppins(
                                            fontSize: 2.sw,
                                            color: darkThemeIsEnabled == false
                                                ? RepoColors
                                                    .blackBackgroundColor
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: constraints.maxWidth < 600
                                    ? constraints.maxWidth * 0.8
                                    : constraints.maxWidth * 0.3,
                                margin: const EdgeInsets.only(
                                    top: 50, left: 50, right: 50),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: RepoColors.blackBackgroundColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Pokedex",
                                      style: GoogleFonts.roboto(
                                        fontSize: 3.sw,
                                        fontWeight: FontWeight.bold,
                                        color: darkThemeIsEnabled == false
                                            ? RepoColors.blackBackgroundColor
                                            : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      "pokedex".tr,
                                      style: GoogleFonts.roboto(
                                        fontSize: 2.sw,
                                        color: darkThemeIsEnabled == false
                                            ? RepoColors.blackBackgroundColor
                                            : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextButton(
                                      onPressed: () {
                                        launchUrl(Uri.parse(
                                            "https://github.com/alvaro-carlisbino/Pokedex"));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: darkThemeIsEnabled == false
                                              ? Colors.white
                                              : RepoColors.blackBackgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          "see_more".tr,
                                          style: GoogleFonts.poppins(
                                            fontSize: 2.sw,
                                            color: darkThemeIsEnabled == false
                                                ? RepoColors
                                                    .blackBackgroundColor
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: constraints.maxWidth < 600
                                    ? constraints.maxWidth * 0.8
                                    : constraints.maxWidth * 0.3,
                                margin: const EdgeInsets.only(
                                    top: 50, left: 50, right: 50),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: RepoColors.blackBackgroundColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Fluxus",
                                      style: GoogleFonts.roboto(
                                        fontSize: 3.sw,
                                        fontWeight: FontWeight.bold,
                                        color: darkThemeIsEnabled == false
                                            ? RepoColors.blackBackgroundColor
                                            : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      "fluxus".tr,
                                      style: GoogleFonts.roboto(
                                        fontSize: 2.sw,
                                        color: darkThemeIsEnabled == false
                                            ? RepoColors.blackBackgroundColor
                                            : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextButton(
                                      onPressed: () {
                                        launchUrl(Uri.parse(
                                            "https://github.com/alvaro-carlisbino/fluxus"));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: darkThemeIsEnabled == false
                                              ? Colors.white
                                              : RepoColors.blackBackgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          "see_more".tr,
                                          style: GoogleFonts.poppins(
                                            fontSize: 2.sw,
                                            color: darkThemeIsEnabled == false
                                                ? RepoColors
                                                    .blackBackgroundColor
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    ]),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                color: darkThemeIsEnabled == false
                    ? RepoColors.whiteContainerColor
                    : RepoColors.blackContainerColor,
                child: Column(
                  children: [
                    Divider(
                      color: darkThemeIsEnabled == false
                          ? RepoColors.blackBackgroundColor.withOpacity(0.2)
                          : Colors.white.withOpacity(0.2),
                      thickness: 1,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "copy".tr,
                          style: GoogleFonts.poppins(
                            fontSize: 1.5.sw,
                            color: darkThemeIsEnabled == false
                                ? RepoColors.blackBackgroundColor
                                : Colors.white,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 100),
                          child: Row(
                            children: [
                              TextButton.icon(
                                icon: Icon(
                                  Icons.linked_camera,
                                  color: darkThemeIsEnabled == false
                                      ? RepoColors.blackBackgroundColor
                                      : Colors.white,
                                ),
                                label: Text(
                                  "Meu Linkedin",
                                  style: TextStyle(
                                    color: darkThemeIsEnabled == false
                                        ? RepoColors.blackBackgroundColor
                                        : Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  launchUrl(Uri.parse(
                                      "https://www.linkedin.com/in/alvaro-carlisbino/"));
                                },
                              ),
                              TextButton.icon(
                                icon: Icon(
                                  SimpleIcons.github,
                                  color: darkThemeIsEnabled == false
                                      ? RepoColors.blackBackgroundColor
                                      : Colors.white,
                                ),
                                label: Text(
                                  "Meu GitHub",
                                  style: TextStyle(
                                    color: darkThemeIsEnabled == false
                                        ? RepoColors.blackBackgroundColor
                                        : Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  launchUrl(Uri.parse(
                                      "https://github.com/alvaro-carlisbino"));
                                },
                              ),
                              TextButton.icon(
                                icon: Icon(
                                  Icons.email,
                                  color: darkThemeIsEnabled == false
                                      ? RepoColors.blackBackgroundColor
                                      : Colors.white,
                                ),
                                label: Text(
                                  "Meu Email",
                                  style: TextStyle(
                                    color: darkThemeIsEnabled == false
                                        ? RepoColors.blackBackgroundColor
                                        : Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  launchUrl(Uri.parse(
                                      "mailto:alvaromathe123@gmail.com"));
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
