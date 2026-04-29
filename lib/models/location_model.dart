class LocationData {
  final int id;
  final String name;
  final String? imageBase64;

  LocationData({
    required this.id,
    required this.name,
    this.imageBase64,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      id: json['id'],
      name: json['name'],
      imageBase64: json['image_base64'],
    );
  }
}