class MemberWalletLog{
  final String DocNo;
  final String description;
  final String user_id;
  final String balance;
  final String remaining;
  final String date_time;

  MemberWalletLog({
    required this.DocNo,
    required this.description,
    required this.user_id,
    required this.balance,
    required this.remaining,
    required this.date_time
  });

  factory MemberWalletLog.fromJson(Map<String, dynamic> json) => MemberWalletLog(
      DocNo: json['DocNo'].toString(),
      description: json['description'].toString(),
      user_id: json['user_id'].toString(),
      balance: json['balance'].toString(),
      remaining: json['remaining'].toString(),
      date_time: json['date_time'].toString()
  );
}