class UserVolume {
  final num volume;
  final String userId;
  UserVolume({
    required this.volume,
    required this.userId,
  });

  factory UserVolume.fromJson(Map<String, dynamic> json) => UserVolume(
        volume: json['volume'],
        userId: json['userId'],
      );
}
