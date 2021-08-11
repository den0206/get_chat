enum Topic { dart, flutter, c, go, java, javascript, php, ruby, swift }

extension TopicTypEXT on Topic {
  String get path {
    switch (this) {
      case Topic.dart:
        return "dart";
      case Topic.flutter:
        return "flutter";
      case Topic.c:
        return "c";
      case Topic.go:
        return "go";
      case Topic.java:
        return "java";
      case Topic.javascript:
        return "javascript";
      case Topic.php:
        return "php";
      case Topic.ruby:
        return "ruby";
      case Topic.swift:
        return "swift";
    }
  }

  String get title {
    switch (this) {
      default:
        return this.path.capitalize();
    }
  }

  String get imagePath {
    switch (this) {
      default:
        return "assets/lang/${this.path}.png";
    }
  }

  int getToicIndex() {
    return allTopics.indexOf(this);
  }
}

final allTopics = Topic.values;

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
