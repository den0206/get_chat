import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_chat/src/model/article.dart';
import 'package:getx_chat/src/model/topic.dart';
import 'package:getx_chat/src/service/news_service.dart';

import 'package:get/get.dart';
import 'package:getx_chat/src/widgets/custom_dialog.dart';

class NewsController extends GetxController {
  List<RxList<Article>> topicLists = [<Article>[].obs];

  final Map<String, int> currentPages = {};
  final ScrollController sC = ScrollController();
  RxInt currentIndex = 0.obs;

  /// computed
  RxList<Article> get topicList {
    return topicLists[currentIndex.value];
  }

  Topic get currentTopic {
    return allTopics[currentIndex.value];
  }

  int get currentPage {
    return currentPages[currentTopic.title]!;
  }

  bool reachLast = false;
  bool isLoading = false;

  final NewsService service = NewsService();
  @override
  void onInit() {
    super.onInit();
    setTopic();

    fetchTopic();
  }

  void setTopic() {
    topicLists = List.generate(allTopics.length, (index) => <Article>[].obs,
        growable: false);

    allTopics.forEach((topic) {
      currentPages[topic.title] = 1;
    });
  }

  Future<void> selectTopic(int index) async {
    currentIndex.value = index;

    if (currentPage == 1) {
      await fetchTopic();
    }
    await sC.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  Future<void> fetchTopic() async {
    if (isLoading) {
      return;
    }

    isLoading = true;

    try {
      final tempNews = await service.fetchNews(
        topic: currentTopic,
        currentPage: currentPage,
      );

      topicLists[currentTopic.getToicIndex()].addAll(tempNews);
      currentPages[currentTopic.title] = currentPage + 1;

      print(currentPages);
    } catch (e) {
      showError(e);
    } finally {
      isLoading = false;
    }
  }
}

// final news = <Article>[].obs;

// Future<void> fetchNews() async {
//   if (reachLast) {
//     return;
//   }
//   isLoading = true;

//   try {
//     final tempNews = await service.fetchNews(currentPage: currentPage);
//     if (tempNews.length < service.perPage) {
//       reachLast = true;
//     }
//     news.addAll(tempNews);
//   } catch (e) {
//     showError(e);
//   } finally {
//     isLoading = false;
//   }
// }
