import 'package:getx_chat/src/utils/date_format.dart';

class Article {
  final String id;
  final String title;
  final String url;
  final QUser user;

  final int likesCount;
  final DateTime updatedAt;

  final _formatter = DateFormatter();

  String get formattedTime {
    return _formatter.getVerboseDateTimeRepresentation(updatedAt);
  }

  bool get isNew {
    return _formatter.isNewUntilYesterday(updatedAt);
  }

  Article({
    required this.id,
    required this.title,
    required this.url,
    required this.user,
    required this.likesCount,
    required this.updatedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      likesCount: json["likes_count"],
      updatedAt: DateTime.parse(json["updated_at"]),
      user: QUser.fromJson(json['user']),
    );
  }
}

class QUser {
  final String id;
  final String iconUrl;

  QUser({required this.id, required this.iconUrl});

  factory QUser.fromJson(Map<String, dynamic> json) {
    return QUser(
      id: json['id'],
      iconUrl: json['profile_image_url'],
    );
  }
}
