import 'dart:io';

import 'package:getx_chat/src/model/article.dart';
import 'package:getx_chat/src/model/topic.dart';
import 'package:getx_chat/src/utils/sec.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  // int currentPage = 1;
  final perPage = 20;

  Future<List<Article>> fetchNews({
    required Topic topic,
    required int currentPage,
  }) async {
    List<Article> articles = [];

    final queryParameters = {
      "page": "$currentPage",
      "per_page": "$perPage",
    };

    final uri = Uri.https(
        "qiita.com", "/api/v2/tags/${topic.path}/items", queryParameters);
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: 'Bearer ${APIKey.qitaKey}',
      },
    );

    if (response.statusCode != 200) {
      final Exception error = Exception("StatusCode is ${response.statusCode}");
      throw error;
    }

    final List<dynamic> jsonData = json.decode(response.body);
    articles.addAll(jsonData.map((json) => Article.fromJson(json)).toList());
    // currentPage++;

    return articles;
  }
}
