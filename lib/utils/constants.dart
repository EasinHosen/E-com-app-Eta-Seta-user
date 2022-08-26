const String currencySymbol = '৳';

abstract class PaymentMethode {
  static const String cod = 'Cash On Delivery';
  static const String online = 'Online Payment';
}

abstract class OrderStatus {
  static const String pending = 'Pending';
  static const String processing = 'Processing';
  static const String delivered = 'Delivered';
  static const String cancelled = 'Cancelled';
}
