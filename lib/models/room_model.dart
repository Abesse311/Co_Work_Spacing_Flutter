class Room {
  final int     id;
  final String  name;
  final double  price;
  final String? imageBase64;
  final int     capacity;
  final List<Map<String, dynamic>> bookingTypes;
  final String  openingTime;
  final String  closingTime;
  final String? midTime;

  Room({
    required this.id,
    required this.name,
    required this.price,
    this.imageBase64,
    required this.capacity,
    this.bookingTypes = const [],
    required this.openingTime,
    required this.closingTime,
    this.midTime,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    // Get booking types list
    final List<dynamic> types = json['booking_types'] ?? [];
    final List<Map<String, dynamic>> parsedTypes =
        types.map((e) => e as Map<String, dynamic>).toList();

    // Calculate price from first booking type or slot_price fallback
    double roomPrice = 0.0;
    if (json['slot_price'] != null) {
      roomPrice = double.parse(json['slot_price'].toString());
    } else if (parsedTypes.isNotEmpty) {
      roomPrice = (parsedTypes.first['price'] ?? 0).toDouble();
    }

    return Room(
      id:          json['id'],
      name:        json['name'],
      price:       roomPrice,
      imageBase64: json['image_base64'],
      capacity:    json['capacity'] ?? 0,
      bookingTypes: parsedTypes,
      openingTime: json['opening_time'] ?? '08:00',
      closingTime: json['closing_time'] ?? '20:00',
      midTime:     json['mid_time'],
    );
  }
}