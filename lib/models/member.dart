class CurrentMember{
  final int user_id;
  final String memberID;
  final String memberName;
  final String memberEmail;
  final String date_of_birth;
  final String address1;


  CurrentMember({
    required this.user_id,
    required this.memberID,
    required this.memberName,
    required this.memberEmail,
    required this.date_of_birth,
    required this.address1
  });

  factory CurrentMember.fromJson(Map<String, dynamic> json) => CurrentMember(
      user_id: json['id'],
      memberID: json['code'],
      memberName: json['name'],
      memberEmail: json['email'],
      date_of_birth: json['date_of_birth'].toString(),
      address1: json['address1'].toString()
  );

}