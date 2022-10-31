class PaymentParam {
  PaymentParam({
    required this.channel,
    required this.amount,
  });

  String channel;
  double amount;

  factory PaymentParam.fromJson(Map<String, dynamic> json) => PaymentParam(
        channel: json["channel"],
        amount: double.tryParse(json["amount"].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "channel": channel,
        "amount": amount,
      };
}
