class TransactionHistory {
  final int id;
  final String type;   // 'booking', 'recharge', 'cancellation', etc.
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
    return TransactionHistory(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      refId: json['ref_id']?.toString(),
      roomName: json['room_name'] as String?,
      locationName: json['location_name'] as String?,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
