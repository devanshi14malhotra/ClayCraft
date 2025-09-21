enum OrderStatus { pending, confirmed, inProgress, completed, cancelled }

class Order {
  final String id;
  final String productId;
  final String productName;
  final String buyerId;
  final String artisanId;
  final double totalPrice;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime? estimatedCompletion;
  final String? customRequirements;
  final String? shippingAddress;
  final List<String>? progressImages;
  final String? trackingInfo;

  const Order({
    required this.id,
    required this.productId,
    required this.productName,
    required this.buyerId,
    required this.artisanId,
    required this.totalPrice,
    required this.status,
    required this.orderDate,
    this.estimatedCompletion,
    this.customRequirements,
    this.shippingAddress,
    this.progressImages,
    this.trackingInfo,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'productId': productId,
    'productName': productName,
    'buyerId': buyerId,
    'artisanId': artisanId,
    'totalPrice': totalPrice,
    'status': status.name,
    'orderDate': orderDate.toIso8601String(),
    'estimatedCompletion': estimatedCompletion?.toIso8601String(),
    'customRequirements': customRequirements,
    'shippingAddress': shippingAddress,
    'progressImages': progressImages,
    'trackingInfo': trackingInfo,
  };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'],
    productId: json['productId'],
    productName: json['productName'],
    buyerId: json['buyerId'],
    artisanId: json['artisanId'],
    totalPrice: json['totalPrice'].toDouble(),
    status: OrderStatus.values.firstWhere((e) => e.name == json['status']),
    orderDate: DateTime.parse(json['orderDate']),
    estimatedCompletion: json['estimatedCompletion'] != null
        ? DateTime.parse(json['estimatedCompletion'])
        : null,
    customRequirements: json['customRequirements'],
    shippingAddress: json['shippingAddress'],
    progressImages: json['progressImages']?.cast<String>(),
    trackingInfo: json['trackingInfo'],
  );
}