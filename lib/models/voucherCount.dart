class VoucherCount{
  int voucherCount;

  VoucherCount({
    required this.voucherCount
  });

  // You use this function to make a instance
  // of class SampleModel and use it inside an UI Widget
  factory VoucherCount.fromJson(Map<String, dynamic> json) => VoucherCount(
      voucherCount: json['VoucherCount']
  );

  Map<String, dynamic> toJson() => {
    'VoucherCount': voucherCount
  };
}