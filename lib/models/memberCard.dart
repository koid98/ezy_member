
class MemberCard {
  final String card_type;
  final String card_desc;
  final String card_entitlement;
  final String image;
  final String member_card_number;
  final String member_card_month;
  final String member_card_year;

  MemberCard(
      {required this.card_type,
        required this.card_desc,
        required this.card_entitlement,
        required this.image,
        required this.member_card_number,
        required this.member_card_month,
        required this.member_card_year,
      });

  factory MemberCard.fromJson(Map<String, dynamic> json) => MemberCard(
    card_type: json['card_type'],
    card_desc: json['card_desc'],
    card_entitlement: json['card_entitlement'] ?? '',
    image: json['image'],
    member_card_number: json['member_card_number'],
    member_card_month: json['member_card_month'],
    member_card_year: json['member_card_year'],
  );

  Map<String, dynamic> toJson() => {
    'card_type': card_type,
    'card_desc': card_desc,
    'card_entitlement': card_entitlement,
    'image': image,
    'member_card_number': member_card_number,
    'member_card_month': member_card_month,
    'member_card_year': member_card_year,
  };
}
