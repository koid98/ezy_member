class VoucherModel {
  final String voucher_code;
  final String voucher_Desc;
  final String voucher_type;
  final String voucher_vlidity;
  final String terms;

  VoucherModel(
      {required this.voucher_code,
        required this.voucher_Desc,
        required this.voucher_type,
        required this.voucher_vlidity,
        required this.terms});

  factory VoucherModel.fromJson(Map<String, dynamic> json) => VoucherModel(
    voucher_code: json['voucher_code'] ?? '',
    voucher_Desc: json['voucher_Desc'] ?? '',
    voucher_type: json['voucher_type'] ?? '',
    voucher_vlidity: json['voucher_vlidity'] ?? '',
    terms: json['terms'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'voucher_code': voucher_code,
    'voucher_Desc': voucher_Desc,
    'voucher_type': voucher_type,
    'voucher_vlidity': voucher_vlidity,
    'terms': terms,
  };
}
