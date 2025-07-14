class UserScore {
  final String uid;
  final String name;
  final String email;
  final int score;
  final String imageUrl;

  UserScore({
    required this.uid,
    required this.name,
    required this.email,
    required this.score,
    required this.imageUrl,
  });

  factory UserScore.fromMap(String id, Map<String, dynamic> data) {
    return UserScore(
      uid: id,
      name: data['userName'] ?? '',
      email: data['email'] ?? '',
      score: data['score'] ?? 0,
      imageUrl: data['imgUrl'] ?? '',
    );
  }
}
