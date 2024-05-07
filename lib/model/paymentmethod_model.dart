class PaymentMethod {
  final String? paymentMethodId;
  final String name;
  final bool isActive;
  final String createdBy;
  final DateTime createDate;
  final DateTime updatedDate;
  final String updatedBy;
  final String description;
  String icon;

  PaymentMethod(
      {required this.paymentMethodId,
      required this.name,
      required this.isActive,
      required this.createdBy,
      required this.createDate,
      required this.updatedDate,
      required this.updatedBy,
      required this.description,
      required this.icon});
}
