import 'package:dio/dio.dart';

class LinkedinProfileSummary {
  const LinkedinProfileSummary({
    required this.profileUrl,
    required this.headline,
  });

  final String profileUrl;
  final String headline;
}

class LinkedinDatasource {
  LinkedinDatasource({
    Dio? dio,
  }) : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 7),
                receiveTimeout: const Duration(seconds: 7),
              ),
            );

  final Dio _dio;

  Future<LinkedinProfileSummary?> fetchPublicProfile({
    required String profileUrl,
  }) async {
    try {
      final Response<String> response = await _dio.get<String>(profileUrl);
      final String html = response.data ?? '';
      final RegExp titleRegex = RegExp(
        r'<title>(.*?)</title>',
        caseSensitive: false,
        dotAll: true,
      );
      final RegExpMatch? match = titleRegex.firstMatch(html);
      final String pageTitle =
          match?.group(1)?.replaceAll('\n', ' ').trim() ?? '';
      if (pageTitle.isEmpty) {
        return null;
      }

      return LinkedinProfileSummary(
        profileUrl: profileUrl,
        headline: pageTitle,
      );
    } catch (_) {
      return null;
    }
  }
}
