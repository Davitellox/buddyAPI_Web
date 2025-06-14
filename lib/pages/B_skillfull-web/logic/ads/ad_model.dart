class AppAd {
  final String title;
  final String imageUrl;
  final String redirectUrl;
  final bool show;
  final String userType;

  AppAd({
    required this.title,
    required this.imageUrl,
    required this.redirectUrl,
    required this.show,
    required this.userType,
  });

  factory AppAd.fromMap(Map<String, dynamic> map) {
    return AppAd(
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      redirectUrl: map['redirectUrl'] ?? '',
      show: map['show'] ?? false,
      userType: map['userType'] ?? '',
    );
  }
}
