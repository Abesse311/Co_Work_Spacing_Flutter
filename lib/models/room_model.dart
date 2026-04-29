class Room {
  final int id;
  final String name;
  final double price;
  final String address;
  final String? imageBase64;
  final int capacity;

  Room({
    required this.id,
    required this.name,
    required this.price,
    required this.address,
    this.imageBase64,
    required this.capacity,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['slot_price'].toString()),
      address: '',
      imageBase64: json['image_base64'],
      capacity: json['capacity'] ?? 0,
    );
  }
}