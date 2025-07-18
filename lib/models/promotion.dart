class Promotion {
  final String PromotionKey;
  final String Description;
  final String FromDate;
  final String ToDate;
  final String ValidOnWeekDay1;
  final String ValidOnWeekDay2;
  final String ValidOnWeekDay3;
  final String ValidOnWeekDay4;
  final String ValidOnWeekDay5;
  final String ValidOnWeekDay6;
  final String ValidOnWeekDay7;

  Promotion(
      {required this.PromotionKey,
        required this.Description,
        required this.FromDate,
        required this.ToDate,
        required this.ValidOnWeekDay1,
        required this.ValidOnWeekDay2,
        required this.ValidOnWeekDay3,
        required this.ValidOnWeekDay4,
        required this.ValidOnWeekDay5,
        required this.ValidOnWeekDay6,
        required this.ValidOnWeekDay7
      });

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
      PromotionKey: json['PromotionKey'].toString(),
      Description: json['Description'].toString(),
      FromDate: json['FromDate'].toString(),
      ToDate: json['ToDate'].toString(),
      ValidOnWeekDay1: json['ValidOnWeekDay1'],
      ValidOnWeekDay2: json['ValidOnWeekDay2'],
      ValidOnWeekDay3: json['ValidOnWeekDay3'],
      ValidOnWeekDay4: json['ValidOnWeekDay4'],
      ValidOnWeekDay5: json['ValidOnWeekDay5'],
      ValidOnWeekDay6: json['ValidOnWeekDay6'],
      ValidOnWeekDay7: json['ValidOnWeekDay7']
  );

  Map<String, dynamic> toJson() => {
    'PromotionKey': PromotionKey,
    'Description': Description,
    'FromDate': FromDate,
    'ToDate': ToDate,
    'ValidOnWeekDay1': ValidOnWeekDay1,
    'ValidOnWeekDay1': ValidOnWeekDay1,
    'ValidOnWeekDay1': ValidOnWeekDay1,
    'ValidOnWeekDay1': ValidOnWeekDay1,
    'ValidOnWeekDay1': ValidOnWeekDay1,
    'ValidOnWeekDay1': ValidOnWeekDay1,
    'ValidOnWeekDay1': ValidOnWeekDay1
  };
}
