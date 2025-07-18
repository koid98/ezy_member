class VoucherDetail {
  final String id;
  final String prefix;
  final String voucher_code;
  final String batch_code;
  final String type;
  final String batch_desc;
  final String discount;
  final String min_spend;
  final String start_date;
  final String expiry_date;
  final String terms_condition;
  String voucher_type;
  final String claim_on;

  VoucherDetail(
      {required this .id,
        required this.prefix,
        required this.voucher_code,
        required this.batch_code,
        required this.type,
        required this.batch_desc,
        required this.discount,
        required this.min_spend,
        required this.start_date,
        required this.expiry_date,
        required this.terms_condition,
        required this.voucher_type,
        required this.claim_on
      });

  factory VoucherDetail.fromJson(Map<String, dynamic> json) => VoucherDetail(
    id: json['id'].toString(),
      prefix: json['prefix'].toString(),
      voucher_code: json['voucher_code'].toString(),
      batch_code: json['batch_code'].toString(),
      type: json['type'].toString(),
      batch_desc: json['batch_desc'].toString(),
      discount: json['discount'].toString(),
      min_spend: json['min_spend'].toString(),
      start_date: json['start_date'].toString(),
      expiry_date: json['expiry_date'].toString(),
      terms_condition: json['terms_condition'].toString(),
      voucher_type: "",
    claim_on: json['claim_on'].toString()
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'prefix': prefix,
    'voucher_code': voucher_code,
    'batch_code': batch_code,
    'type': type,
    'batch_desc': batch_desc,
    'discount': discount,
    'min_spend': min_spend,
    'start_date': start_date,
    'expiry_date': expiry_date,
    'terms_condition': terms_condition,
    'voucher_type': voucher_type
  };
}
