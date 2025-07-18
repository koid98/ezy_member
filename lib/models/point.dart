class UserPoint{
  final String total_point;

  UserPoint({required this.total_point});

  factory UserPoint.fromJson(Map<String, dynamic> json) => UserPoint(
    total_point: json['total_point'],
  );
}