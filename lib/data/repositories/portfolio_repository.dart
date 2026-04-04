import 'package:repositoriobryzzen/data/datasources/devto_datasource.dart';
import 'package:repositoriobryzzen/data/datasources/github_datasource.dart';
import 'package:repositoriobryzzen/data/datasources/linkedin_datasource.dart';
import 'package:repositoriobryzzen/data/models/portfolio_content.dart';

class PortfolioRepositoryData {
  const PortfolioRepositoryData({
    required this.content,
    required this.githubProjects,
    required this.devtoArticles,
    required this.linkedinProfile,
  });

  final PortfolioContent content;
  final List<GithubRepositorySummary> githubProjects;
  final List<DevtoArticleSummary> devtoArticles;
  final LinkedinProfileSummary? linkedinProfile;
}

class PortfolioRepository {
  PortfolioRepository({
    GithubDatasource? githubDatasource,
    DevtoDatasource? devtoDatasource,
    LinkedinDatasource? linkedinDatasource,
  })  : _githubDatasource = githubDatasource ?? GithubDatasource(),
        _devtoDatasource = devtoDatasource ?? DevtoDatasource(),
        _linkedinDatasource = linkedinDatasource ?? LinkedinDatasource();

  final GithubDatasource _githubDatasource;
  final DevtoDatasource _devtoDatasource;
  final LinkedinDatasource _linkedinDatasource;

  Future<PortfolioRepositoryData> load() async {
    final PortfolioContent localContent = PortfolioContent.buildDefault();
    final String linkedinUrl = localContent.socialLinks
        .firstWhere(
          (SocialLink link) => link.label == 'LinkedIn',
        )
        .url;

    try {
      final List<GithubRepositorySummary> githubProjects =
          await _githubDatasource.fetchTopRepositories(
        username: 'alvaro-carlisbino',
        limit: 6,
      );

      final List<DevtoArticleSummary> devtoArticles =
          await _devtoDatasource.fetchLatestArticles(
        username: 'alvaro-carlisbino',
        limit: 3,
      );
      final LinkedinProfileSummary? linkedinProfile =
          await _linkedinDatasource.fetchPublicProfile(profileUrl: linkedinUrl);

      return PortfolioRepositoryData(
        content: localContent,
        githubProjects: githubProjects,
        devtoArticles: devtoArticles,
        linkedinProfile: linkedinProfile,
      );
    } catch (_) {
      return PortfolioRepositoryData(
        content: localContent,
        githubProjects: const <GithubRepositorySummary>[],
        devtoArticles: const <DevtoArticleSummary>[],
        linkedinProfile: null,
      );
    }
  }
}
