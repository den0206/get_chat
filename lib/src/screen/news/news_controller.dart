import 'dart:io';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_chat/src/model/Article.dart';
import 'package:getx_chat/src/utils/sec.dart';
import 'package:getx_chat/src/widgets/custom_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

class NewsController extends GetxController {
  final news = <Article>[].obs;
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchNews() async {
    final queryParameters = {
      "page": "1",
      "per_page": "10",
    };
    final uri = Uri.https("qiita.com", "/api/v2/items", queryParameters);
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: 'Bearer ${APIKey.qitaKey}',
      },
    );

    if (response.statusCode != 200) {
      final Exception error = Exception("StatusCode is ${response.statusCode}");
      showError(error);
      return;
    }

    final List<dynamic> jsonData = json.decode(response.body);
    news.value = jsonData.map((json) => Article.fromJson(json)).toList();
  }
}
