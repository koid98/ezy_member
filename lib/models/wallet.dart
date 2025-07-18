class UserWallet{
  final String balance;

  UserWallet({required this.balance});

  factory UserWallet.fromJson(Map<String, dynamic> json) => UserWallet(
    balance: json['balance'],
  );
}