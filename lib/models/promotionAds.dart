
class PromotionAds {
  final int id;
  final String promotion_title;
  final String promotion_image;
  final String start_date;
  final String expiry_date;
  final String image_url;

  PromotionAds(
      {required this.id,
        required this.promotion_title,
        required this.promotion_image,
        required this.start_date,
        required this.expiry_date,
        required this.image_url});

  factory PromotionAds.fromJson(Map<String, dynamic> json) => PromotionAds(
    id: json['id'],
    promotion_title: json['promotion_title'],
    promotion_image: json['promotion_image'],
    start_date: json['start_date'],
    expiry_date: json['expiry_date'],
    image_url: json['image_url'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'promotion_title': promotion_title,
    'promotion_image': promotion_image,
    'start_date':start_date,
    'expiry_date':expiry_date,
    'image_url': image_url,
  };
}



