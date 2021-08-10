enum Topic { dart, flutter }

extension TopicTypEXT on Topic {
  String get path {
    switch (this) {
      case Topic.dart:
        return "dart";
      case Topic.flutter:
        return "flutter";
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
