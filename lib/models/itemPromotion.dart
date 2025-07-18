class ItemPromotion {
  final String PromotionKey;
  final String ItemCode;
  final String Description;
  final String Image;
  final String MinPQty;
  final String MaxPQty;
  final String UnitPrice;
  final String Discount;
  final String TotalPrice;
  final String MemberPrice1;
  final String MemberDiscount1;
  final String MemberTotalPrice;
  final String FromDate;
  final String ToDate;

  ItemPromotion(
      {required this.PromotionKey,
        required this.ItemCode,
        required this.Description,
        required this.Image,
        required this.MinPQty,
        required this.MaxPQty,
        required this.UnitPrice,
        required this.Discount,
        required this.TotalPrice,
        required this.MemberPrice1,
        required this.MemberDiscount1,
        required this.MemberTotalPrice,
        required this.FromDate,
        required this.ToDate
      });

  factory ItemPromotion.fromJson(Map<String, dynamic> json) => ItemPromotion(
      PromotionKey: json['PromotionKey'].toString(),
      ItemCode: json['ItemCode'].toString(),
      Description: json['Description'].toString(),
      Image: json['Image'].toString(),
      MinPQty: json['MinPQty'].toString(),
      MaxPQty: json['MaxPQty'].toString(),
      UnitPrice: json['UnitPrice'].toString(),
      Discount: json['Discount'].toString(),
      TotalPrice: json['TotalPrice'].toString(),
      MemberPrice1: json['MemberPrice1'].toString(),
      MemberDiscount1: json['MemberDiscount1'].toString(),
      MemberTotalPrice: json['MemberTotalPrice'].toString(),
      FromDate: json['FromDate'].toString(),
      ToDate: json['ToDate'].toString()
  );

  Map<String, dynamic> toJson() => {
    'PromotionKey': PromotionKey,
    'ItemCode': ItemCode,
    'Description': Description,
    'Image': Image,
    'MinPQty': MinPQty,
    'MaxPQty': MaxPQty,
    'UnitPrice': UnitPrice,
    'Discount': Discount,
    'TotalPrice': TotalPrice,
    'MemberPrice1': MemberPrice1,
    'MemberDiscount1': MemberDiscount1,
    'MemberTotalPrice': MemberTotalPrice,
    'FromDate': FromDate,
    'ToDate': ToDate
  };
}
