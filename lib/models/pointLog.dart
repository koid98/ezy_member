class MemberPointLog{
  final String DocNo;
  final String user_id;
  final String point_action;
  final String point;
  final String total_point;
  final String date_time;

  MemberPointLog({
    required this.DocNo,
    required this.user_id,
    required this.point_action,
    required this.point,
    required this.total_point,
    required this.date_time
  });

  factory MemberPointLog.fromJson(Map<String, dynamic> json) => MemberPointLog(
      DocNo: json['DocNo'].toString(),
      user_id: json['user_id'],
      point_action: json['point_action'],
      point: json['point'],
      total_point: json['total_point'],
      date_time: json['date_time']
  );
}