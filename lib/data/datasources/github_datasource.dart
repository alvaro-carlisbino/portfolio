import 'package:dio/dio.dart';

class GithubRepositorySummary {
  const GithubRepositorySummary({
    required this.name,
    required this.description,
    required this.url,
    required this.language,
    required this.stars,
  });

  final String name;
  final String description;
  final String url;
  final String language;
  final int stars;
}

class GithubDatasource {
  GithubDatasource({
    Dio? dio,
  }) : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 7),
                receiveTimeout: const Duration(seconds: 7),
              ),
            );

  final Dio _dio;

  Future<List<GithubRepositorySummary>> fetchTopRepositories({
    required String username,
    int limit = 6,
  }) async {
    final Response<dynamic> response = await _dio.get(
      'https://api.github.com/users/$username/repos',
      queryParameters: <String, dynamic>{
        'sort': 'updated',
        'per_page': limit * 2,
      },
      options: Options(
        headers: <String, String>{
          'Accept': 'application/vnd.github+json',
          'X-GitHub-Api-Version': '2022-11-28',
        },
      ),
    );

    final List<dynamic> rawItems = response.data as List<dynamic>;
    final List<GithubRepositorySummary> summaries = <GithubRepositorySummary>[];

    for (final dynamic item in rawItems) {
      if (item is! Map<String, dynamic>) {
        continue;
      }

      final bool isFork = item['fork'] as bool? ?? false;
      if (isFork) {
        continue;
      }

      summaries.add(
        GithubRepositorySummary(
          name: item['name'] as String? ?? 'Repository',
          description: item['description'] as String? ?? 'No description.',
          url: item['html_url'] as String? ?? '',
          language: item['language'] as String? ?? 'Unknown',
          stars: item['stargazers_count'] as int? ?? 0,
        ),
      );

      if (summaries.length >= limit) {
        break;
      }
    }

    return summaries;
  }
}
