class Reservation {
  final String title;
  final String location;
  final String date;
  final String startTime;
  final int slotCount;
  final String image;
  final dynamic price;
  final String status;

  Reservation({
    required this.title,
    required this.location,
    required this.date,
    required this.startTime,
    required this.slotCount,
    required this.image,
    required this.price,
    required this.status,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      title: json['room_name'] ?? 'Unknown Room',
      location: json['location'] ?? '',
      date: json['date'] ?? '',
      startTime: json['start_time'] ?? '',
      slotCount: json['slot_count'] ?? 0,
      image: json['room_image'] ?? 'img/default_room.jpg',
      price: json['price'] ?? '',
      status: json['status'] ?? 'Confirmed',
    );
  }

  String get subtitle => '$location | $date $startTime (${slotCount}h)';
}