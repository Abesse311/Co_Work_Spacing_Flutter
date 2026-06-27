class Reservation {
  final int id;           // booking_id used for cancellation
  final String title;
  final String location;
  final String date;      // display-friendly (may include "start to end" for weekly)
  final String rawDate;   // the raw start date string (e.g. "2026-05-22")
  final String startTime;
  final String endTime;
  final int slotCount;
  final String image;
  final dynamic price;
  final String status;
  final String type;

  Reservation({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.rawDate,
    required this.startTime,
    required this.endTime,
    required this.slotCount,
    required this.image,
    required this.price,
    required this.status,
    required this.type,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    final startTimeStr = json['start_time']?.toString() ?? '';
    final endTimeStr   = json['end_time']?.toString()   ?? '';

    int calculatedSlots = 0;
    if (json['slot_count'] != null) {
      calculatedSlots = json['slot_count'] as int;
    } else if (startTimeStr.isNotEmpty && endTimeStr.isNotEmpty) {
      try {
        final startParts = startTimeStr.split(':');
        final endParts   = endTimeStr.split(':');
        final startMin   = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
        final endMin     = int.parse(endParts[0])   * 60 + int.parse(endParts[1]);
        final diffMin    = endMin - startMin;
        if (diffMin > 0) calculatedSlots = (diffMin / 60).round();
      } catch (_) {}
    }

    final typeName = json['booking_type_name']?.toString()
        ?? json['type']?.toString()
        ?? json['booking_type']?.toString()
        ?? 'Reservation';

    final rawDate = json['date']?.toString()
        ?? json['start_date']?.toString()
        ?? json['booking_date']?.toString()
        ?? '';

    final endDateStr = json['end_date']?.toString();

    String displayDate = rawDate.isEmpty ? 'N/A' : rawDate;
    if (typeName.toLowerCase().contains('week') &&
        endDateStr != null &&
        endDateStr.isNotEmpty) {
      displayDate = '$rawDate to $endDateStr';
    }

    return Reservation(
      id:        json['id'] as int? ?? json['booking_id'] as int? ?? 0,
      title:     json['room_name']?.toString() ?? 'Unknown Room',
      location:  json['location']?.toString()  ?? '',
      date:      displayDate,
      rawDate:   rawDate,
      startTime: startTimeStr,
      endTime:   endTimeStr,
      slotCount: calculatedSlots,
      image:     json['room_image']?.toString() ?? 'img/default_room.jpg',
      price:     json['price'] ?? '',
      status:    json['status']?.toString() ?? 'Confirmed',
      type:      typeName,
    );
  }

  /// Returns true if this reservation can still be cancelled:
  ///   - Status must not already be cancelled
  ///   - Start datetime must be >= 24 h from now
  bool get canCancel {
    final s = status.toLowerCase();
    if (s == 'cancelled' || s == 'annulée') return false;

    if (rawDate.isEmpty) return false;
    try {
      final parts = rawDate.split('-');
      if (parts.length < 3) return false;

      final timeParts = startTime.isNotEmpty ? startTime.split(':') : ['00', '00'];
      final start = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
        int.parse(timeParts[0]),
        timeParts.length > 1 ? int.parse(timeParts[1]) : 0,
      );

      return start.difference(DateTime.now()).inHours >= 24;
    } catch (_) {
      return false;
    }
  }

  String get subtitle {
    final timeDisplay = endTime.isNotEmpty ? '$startTime - $endTime' : startTime;
    return '$location | $date $timeDisplay';
  }
}