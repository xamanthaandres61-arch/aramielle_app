class ServiceRequestModel {
  final String id;
  final String tableNumber;
  final String type; // 'Water Refill', 'Bill Out', 'Call Waiter'
  final String status; // 'Pending', 'In Progress', 'Completed'
  final DateTime timestamp;

  const ServiceRequestModel({
    required this.id,
    required this.tableNumber,
    required this.type,
    required this.status,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tableNumber': tableNumber,
      'type': type,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ServiceRequestModel.fromMap(Map<String, dynamic> map, String docId) {
    return ServiceRequestModel(
      id: docId,
      tableNumber: map['tableNumber'] ?? '',
      type: map['type'] ?? '',
      status: map['status'] ?? 'Pending',
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}
