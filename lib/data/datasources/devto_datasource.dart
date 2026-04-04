import 'package:dio/dio.dart';

class DevtoArticleSummary {
  const DevtoArticleSummary({
    required this.title,
    required this.url,
    required this.publishedAt,
  });

  final String title;
  final String url;
  final String publishedAt;
}

class DevtoDatasource {
  DevtoDatasource({
    Dio? dio,
  }) : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 7),
                receiveTimeout: const Duration(seconds: 7),
              ),
            );

  final Dio _dio;

  Future<List<DevtoArticleSummary>> fetchLatestArticles({
    required String username,
    int limit = 3,
  }) async {
    final Response<dynamic> response = await _dio.get(
      'https://dev.to/api/articles',
      queryParameters: <String, dynamic>{
        'username': username,
        'per_page': limit,
      },
    );

    final List<dynamic> rawItems = response.data as List<dynamic>;
    return rawItems
        .whereType<Map<String, dynamic>>()
        .map((Map<String, dynamic> item) {
      return DevtoArticleSummary(
        title: item['title'] as String? ?? 'Article',
        url: item['url'] as String? ?? '',
        publishedAt: item['published_at'] as String? ?? '',
      );
    }).toList();
  }
}
