class CreateOrderResponse {
  final String id;
  final int amount;
  final String status;

  const CreateOrderResponse({
    required this.id,
    required this.amount,
    required this.status,
  });

  factory CreateOrderResponse.fromJson(
      Map<String, dynamic> json) {
    return CreateOrderResponse(
      id: json['id'],
      amount: json['amount'],
      status: json['status'],
    );
  }
}