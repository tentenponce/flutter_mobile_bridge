class PaymentResult {
  PaymentResult({
    required this.transactionId,
    required this.fee,
  });

  String transactionId;
  double fee;

  factory PaymentResult.fromJson(Map<String, dynamic> json) => PaymentResult(
        transactionId: json["transactionId"],
        fee: json["fee"],
      );

  Map<String, dynamic> toJson() => {
        "transactionId": transactionId,
        "fee": fee,
      };
}
