import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_chat/src/model/article.dart';
import 'package:getx_chat/src/model/topic.dart';
import 'package:getx_chat/src/screen/network_branch.dart/network_branch.dart';
import 'package:getx_chat/src/service/news_service.dart';

import 'package:get/get.dart';
import 'package:getx_chat/src/widgets/custom_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsController extends GetxController {
  List<RxList<Article>> topicLists = [<Article>[].obs];
  List<bool> reachBools = [];

  final Map<String, int> currentPages = {};
  final ScrollController sC = ScrollController();

  RxInt currentIndex = 0.obs;
  bool isLoading = false;

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

  bool get currentReach {
    return reachBools[currentTopic.getToicIndex()];
  }

  final NewsService service = NewsService();
  @override
  void onInit() {
    super.onInit();
    _init();

    fetchTopic();
  }

  void _init() {
    topicLists = List.generate(allTopics.length, (index) => <Article>[].obs,
        growable: false);

    reachBools = List.generate(allTopics.length, (index) => false);

    allTopics.forEach((topic) {
      currentPages[topic.title] = 1;
    });
  }

  Future<void> refresh() async {
    currentIndex.value = 0;
    topicLists = [<Article>[].obs];
    reachBools = [];
    currentPages.clear();

    _init();

    await fetchTopic();
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
    if (isLoading || currentReach) {
      return;
    }

    if (!NetworkManager.to.chackNetwork()) {
      return;
    }

    isLoading = true;

    try {
      final tempNews = await service.fetchNews(
        topic: currentTopic,
        currentPage: currentPage,
      );

      if (tempNews.length < service.perPage) {
        reachBools[currentTopic.getToicIndex()] = true;
      }

      topicLists[currentTopic.getToicIndex()].addAll(tempNews);
      currentPages[currentTopic.title] = currentPage + 1;

      print(currentPages);
    } catch (e) {
      showError(e);
    } finally {
      isLoading = false;
    }
  }

  Future<void> launchUrl(Article article) async {
    await canLaunch(article.url)
        ? await launch(article.url)
        : throw 'Could not launch ${article.url}';
  }
}
