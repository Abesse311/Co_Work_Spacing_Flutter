class TransactionHistory {
  final int id;
  final String type;   // 'booking', 'recharge', 'cancellation',
  final double amount;
  final String? refId;
  final String? roomName;      // null for non-room transactions (recharge, etc.)
  final String? locationName;  // null for non-room transactions
  final DateTime createdAt;

  TransactionHistory({
    required this.id,
    required this.type,
    required this.amount,
    this.refId,
    this.roomName,
    this.locationName,
    required this.createdAt,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    String dateStr = json['created_at'] ?? '';
    DateTime parsed;
    if (dateStr.isNotEmpty) {
      // If the string does not specify a timezone (no 'Z', '+', or trailing offset),
      // we assume it is in UTC (standard backend DB storage) and force UTC parsing.
      if (!dateStr.endsWith('Z') && !dateStr.contains('+') && !RegExp(r'-\d{2}:\d{2}$').hasMatch(dateStr)) {
        String formattedStr = dateStr.replaceAll(' ', 'T');
        if (!formattedStr.endsWith('Z')) {
          formattedStr += 'Z';
        }
        parsed = DateTime.parse(formattedStr).toLocal();
      } else {
        parsed = DateTime.parse(dateStr).toLocal();
      }
    } else {
      parsed = DateTime.now();
    }

    return TransactionHistory(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      refId: json['ref_id']?.toString(),
      roomName: json['room_name'] as String?,
      locationName: json['location_name'] as String?,
      createdAt: parsed,
    );
  }
}
