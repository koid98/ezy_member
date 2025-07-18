class MemberData{
  final int id;
  final String code;
  final String name;
  final String email;
  final String phone_number1;
  final String phone_number2;
  final String gender_type;
  final String date_of_birth;
  final String address1;
  final String address2;
  final String address3;
  final String address4;
  final String postcode;
  final String state_name;
  final String area_name;
  final String races_name;

  MemberData({
    required this.id,
    required this.code,
    required this.name,
    required this.email,
    required this.phone_number1,
    required this.phone_number2,
    required this.gender_type,
    required this.date_of_birth,
    required this.address1,
    required this.address2,
    required this.address3,
    required this.address4,
    required this.postcode,
    required this.state_name,
    required this.area_name,
    required this.races_name,
  });

  factory MemberData.fromJson(Map<String, dynamic> json) => MemberData(
    id: json['id'],
    code: json['code'],
    name: json['name'],
    email: json['email'],
    phone_number1: json['phone_number1'],
    phone_number2: json['phone_number2'].toString(),
    gender_type: json['gender_type'].toString(),
    date_of_birth: json['date_of_birth'].toString(),
    address1: json['address1'].toString(),
    address2: json['address2'].toString(),
    address3: json['address3'].toString(),
    address4: json['address4'].toString(),
    postcode: json['postcode'].toString(),
    state_name: json['state_name'].toString(),
    area_name: json['area_name'].toString(),
    races_name: json['races_name'].toString(),
  );
}