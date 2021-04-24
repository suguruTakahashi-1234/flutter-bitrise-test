class PublishOrderRequest {
  String appName;
  String eventName;
  String messageAppName;
  String messageEventName;
  String timestamp;
  int customerId;
  int storeId;
  int orderId;
  int totalAmount;
  List<int> products;
  String deliveryMethod;
  String paymentMethod;
  double lat;
  double lon;

  PublishOrderRequest(
      {this.appName = 'preOrder',
      this.eventName = 'order',
      this.messageAppName = 'preOrder',
      this.messageEventName = 'order',
      this.timestamp,
      this.customerId,
      this.storeId,
      this.orderId,
      this.totalAmount,
      this.products,
      this.deliveryMethod,
      this.paymentMethod,
      this.lat,
      this.lon});

  Map<String, dynamic> toJson() => {
        'appName': appName,
        'eventName': eventName,
        'message': {
          'appName': messageAppName,
          'eventName': messageEventName,
          'timestamp': timestamp,
          'customerId': customerId,
          'storeId': storeId,
          'orderId': orderId,
          'totalAmount': totalAmount,
          'products': products,
          'deliveryMethod': deliveryMethod,
          'paymentMethod':paymentMethod,
          'location': {
            'lat': lat,
            'lon': lon,
          }
        }
      };
}
