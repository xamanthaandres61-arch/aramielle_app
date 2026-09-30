class TableModel {
  final String id;
  final String name;
  final int capacity;
  bool isOccupied;
  String? occupiedByUserId;
  String? occupiedByUserEmail;
  String? occupiedByUserName;

  TableModel({
    required this.id,
    required this.name,
    this.capacity = 4,
    this.isOccupied = false,
    this.occupiedByUserId,
    this.occupiedByUserEmail,
    this.occupiedByUserName,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'capacity': capacity,
        'isOccupied': isOccupied,
        'occupiedByUserId': occupiedByUserId,
        'occupiedByUserEmail': occupiedByUserEmail,
        'occupiedByUserName': occupiedByUserName,
      };

  factory TableModel.fromJson(Map<String, dynamic> json) => TableModel(
        id: json['id'],
        name: json['name'],
        capacity: json['capacity'] ?? 4,
        isOccupied: json['isOccupied'] ?? false,
        occupiedByUserId: json['occupiedByUserId'],
        occupiedByUserEmail: json['occupiedByUserEmail'],
        occupiedByUserName: json['occupiedByUserName'],
      );
}
