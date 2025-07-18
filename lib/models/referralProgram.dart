class ReferralProgram{
  final String user_id;
  final String generate_code;
  final String isUsed;

  ReferralProgram({
    required this.user_id,
    required this.generate_code,
    required this.isUsed
  });

  factory ReferralProgram.fromJson(Map<String, dynamic> json) => ReferralProgram(
      user_id: json['user_id'].toString(),
      generate_code: json['generate_code'].toString(),
      isUsed: json['isUsed'].toString()
  );
}