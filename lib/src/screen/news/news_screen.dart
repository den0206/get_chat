import 'dart:ui';

import 'package:flutter/cupertino.dart';
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
        title: Obx(() => Text(controller.currentTopic.title)),
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
                      shape: CircleBorder(),
                    ),
                    onPressed: () async {
                      await controller.selectTopic(index);
                    },
                    child: topic != Topic.flutter
                        ? ClipOval(
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              topic.imagePath,
                              fit: BoxFit.contain,
                            ),
                          )
                        : FlutterLogo(
                            size: 40,
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
            Flexible(
              child: CustomScrollView(
                controller: controller.sC,
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () async {
                      await Future.delayed(const Duration(seconds: 1));
                      print("refresh");
                      await controller.refresh();
                    },
                  ),
                  Obx(
                    () => SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final article = controller.topicList[index];

                          if (index == controller.topicList.length - 1) {
                            controller.fetchTopic();
                            if (controller.isLoading)
                              return LoadingCellWidget();
                          }
                          return ArticleCell(
                            article: article,
                          );
                        },
                        childCount: controller.topicList.length,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleCell extends GetView<NewsController> {
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
        onTap: () {
          controller.launchUrl(article);
        },
        child: article.isNew
            ? ClipRect(
                child: Banner(
                  message: "New",
                  location: BannerLocation.topStart,
                  color: Colors.red,
                  child: _artcleCell(),
                ),
              )
            : _artcleCell(),
      ),
    );
  }

  Container _artcleCell() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.green.shade400,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              article.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 12,
              right: 4,
              left: 4,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  /// likes count
                  Spacer(),
                  ClipOval(
                    child: Image.network(
                      article.user.iconUrl,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error),
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

 /// likes Count
// Column(
  //   mainAxisSize: MainAxisSize.min,
  //   children: [
  //     Text(
  //       article.likesCount.toString(),
  //       style: TextStyle(
  //         color: Colors.white,
  //       ),
  //     ),
  //     Icon(
  //       Icons.favorite,
  //       color: Colors.red,
  //       size: 30,
  //     ),
  //   ],
  // ),