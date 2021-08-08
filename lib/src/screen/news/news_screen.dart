import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/news/news_controller.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: GetX<NewsController>(
        init: NewsController(),
        initState: (state) async {
          await state.controller!.fetchNews();
        },
        builder: (controller) {
          return ListView.builder(
            itemCount: controller.news.length,
            itemBuilder: (BuildContext context, int index) {
              final article = controller.news[index];
              return ListTile(
                title: Text("${article.title}"),
              );
            },
          );
        },
      ),
    );
  }
}
