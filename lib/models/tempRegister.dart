class TempRegister{
  final String name;
  final String email;
  final String phone_number1;

  TempRegister({
    required this.name,
    required this.email,
    required this.phone_number1
  });

  factory TempRegister.fromJson(Map<String, dynamic> json) => TempRegister(
      name: json['name'],
      email: json['email'],
      phone_number1: json['phone_number1']
  );
}