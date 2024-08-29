import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repositoriobryzzen/main.dart';
import 'package:repositoriobryzzen/utils/colors.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';

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
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, bottom: 20, right: 20),
                      child: Container(
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
                    )
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 120, bottom: 50, left: 50, right: 30),
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
                        "Desenvolvedor Full-Stack",
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
                          "👋 Bem-vindo ao meu portfólio! Aqui, transformo ideias em soluções inovadoras através de código.",
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
                margin: EdgeInsets.only(top: 200),
                padding: EdgeInsets.only(bottom: 50),
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
                      margin: EdgeInsets.only(top: 40, left: 40),
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
                      margin: EdgeInsets.only(top: 50),
                      child: FlutterCarousel(
                        items: [0, 1, 2].map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              var nomes = [
                                "Inova Agro 2024 - 1º Lugar",
                                "Deco.cx HACKATHON 4° Edição - 2º Lugar",
                                "Hackathon CTWF 2024 - 1º Lugar"
                              ];
                              var desc = [
                                "📦 Projeto de box de cultivo para hortaliças",
                                "🏪 E-commerce para o time de E-Sports Fluxo, com design inovador e exclusivo",
                                "🤖 I.A. para previsão de tendências futuras no setor têxtil."
                              ];
                              var fotos = [
                                "assets/inovaagro.jpg",
                                "assets/fluxo_deco.png",
                                "assets/ctfw.HEIC"
                              ];
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Container(
                                    margin: EdgeInsets.only(top: 20),
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
                                          color: RepoColors.blackBackgroundColor
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
                                              color: darkThemeIsEnabled == false
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
                                              color: darkThemeIsEnabled == false
                                                  ? RepoColors
                                                      .blackBackgroundColor
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                            },
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 500.0,
                          showIndicator: true,
                          slideIndicator: CircularSlideIndicator(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.only(top: 200),
                padding: EdgeInsets.only(bottom: 50),
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
                        margin: EdgeInsets.only(top: 40, left: 40),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Projetos",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              margin:
                                  EdgeInsets.only(top: 50, left: 50, right: 50),
                              padding: EdgeInsets.only(
                                  top: 20, bottom: 20, left: 20, right: 20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: RepoColors.blackBackgroundColor,
                                    width: 2),
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
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "🤖 Chatbot para o Colégio SESI, simplificando a comunicação.",
                                    style: GoogleFonts.roboto(
                                      fontSize: 2.sw,
                                      color: darkThemeIsEnabled == false
                                          ? RepoColors.blackBackgroundColor
                                          : Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        launchUrl(Uri.parse(
                                            "https://github.com/alvaro-carlisbino/Assistente-Virtual-SESI"));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color:
                                                RepoColors.blackBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          "Veja mais sobre o projeto",
                                          style: GoogleFonts.poppins(
                                            fontSize: 2.sw,
                                            color: darkThemeIsEnabled == false
                                                ? RepoColors
                                                    .blackBackgroundColor
                                                : Colors.white,
                                          ),
                                        ),
                                      ))
                                ],
                              )),
                          Container(
                              margin: EdgeInsets.only(top: 50, left: 50),
                              padding: EdgeInsets.only(
                                  top: 20, bottom: 20, left: 20, right: 20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: RepoColors.blackBackgroundColor,
                                    width: 2),
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
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "💻 RestAPI simples em golang para estudo",
                                    style: GoogleFonts.roboto(
                                      fontSize: 2.sw,
                                      color: darkThemeIsEnabled == false
                                          ? RepoColors.blackBackgroundColor
                                          : Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        launchUrl(Uri.parse(
                                            "https://github.com/alvaro-carlisbino/GolangAPI"));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color:
                                                RepoColors.blackBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          "Veja mais sobre o projeto",
                                          style: GoogleFonts.poppins(
                                            fontSize: 2.sw,
                                            color: darkThemeIsEnabled == false
                                                ? RepoColors
                                                    .blackBackgroundColor
                                                : Colors.white,
                                          ),
                                        ),
                                      ))
                                ],
                              )),
                          Container(
                              margin: EdgeInsets.only(top: 50, left: 50),
                              padding: EdgeInsets.only(
                                  top: 20, bottom: 20, left: 20, right: 20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: RepoColors.blackBackgroundColor,
                                    width: 2),
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
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "🐸 Projeto simples de Pokédex Pokémon para estudo de HTML",
                                    style: GoogleFonts.roboto(
                                      fontSize: 2.sw,
                                      color: darkThemeIsEnabled == false
                                          ? RepoColors.blackBackgroundColor
                                          : Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        launchUrl(Uri.parse(
                                            "https://github.com/alvaro-carlisbino/Pokedex"));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color:
                                                RepoColors.blackBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          "Veja mais sobre o projeto",
                                          style: GoogleFonts.poppins(
                                            fontSize: 2.sw,
                                            color: darkThemeIsEnabled == false
                                                ? RepoColors
                                                    .blackBackgroundColor
                                                : Colors.white,
                                          ),
                                        ),
                                      ))
                                ],
                              )),
                        ],
                      )
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
