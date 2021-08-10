import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/model/article.dart';
import 'package:getx_chat/src/model/topic.dart';

import 'package:getx_chat/src/screen/news/news_controller.dart';
import 'package:getx_chat/src/widgets/loading_widget.dart';

class NewsScreen extends GetView<NewsController> {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NewsController());

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text('News'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 50,
              child: ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: allTopics.length,
                itemBuilder: (context, index) {
                  final topic = allTopics[index];

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0,
                    ),
                    clipBehavior: Clip.hardEdge,
                    onPressed: () async {
                      await controller.selectTopic(index);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(topic.imagePath),
                      radius: 30,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                color: Colors.white,
                height: 1,
              ),
            ),
            Obx(
              () => Flexible(
                child: GridView.builder(
                  itemCount: controller.topicList.length,
                  controller: controller.sC,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final article = controller.topicList[index];

                    if (index == controller.topicList.length - 1) {
                      controller.fetchTopic();
                      if (controller.isLoading) return LoadingCellWidget();
                    }
                    return ArticleCell(article: article);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleCell extends StatelessWidget {
  const ArticleCell({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkResponse(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Text(
              article.title,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}
