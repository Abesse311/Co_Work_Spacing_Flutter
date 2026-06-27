class LocationData {
  final int     id;
  final String  name;
  final String? imageBase64;
  final String  openingTime;
  final String  closingTime;
  final String? midTime;

  LocationData({
    required this.id,
    required this.name,
    this.imageBase64,
    required this.openingTime,
    required this.closingTime,
    this.midTime,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      id:          json['id'],
      name:        json['name'],
      imageBase64: json['image_base64'],
      openingTime: json['opening_time'] ?? '08:00',
      closingTime: json['closing_time'] ?? '20:00',
      midTime:     json['mid_time'],
    );
  }
}