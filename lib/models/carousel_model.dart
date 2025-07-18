
class CarouselModel {
  final int id;
  final String ads_title;
  final String ads_image;
  final String image_url;

  CarouselModel(
      {required this.id,
        required this.ads_title,
        required this.ads_image,
        required this.image_url});

  factory CarouselModel.fromJson(Map<String, dynamic> json) => CarouselModel(
    id: json['id'],
    ads_title: json['ads_title'],
    ads_image: json['ads_image'],
    image_url: json['image_url'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'ads_title': ads_title,
    'ads_image': ads_image,
    'image_url': image_url,
  };
}



