class Article {
  final String title;
  final String url;
  final QUser user;

  Article({required this.title, required this.url, required this.user});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      url: json['url'],
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
