class WalletOTP{
  final String user_id;
  final String OTP;
  final String date_time;

  WalletOTP({
    required this.user_id,
    required this.OTP,
    required this.date_time
  });

  factory WalletOTP.fromJson(Map<String, dynamic> json) => WalletOTP(
      user_id: json['user_id'],
      OTP: json['OTP'],
      date_time: json['date_time']
  );
}