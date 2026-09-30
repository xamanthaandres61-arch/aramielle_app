import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_item_model.dart';
import '../models/order_model.dart';
import '../models/service_request_model.dart';
import '../models/table_model.dart';

class FirestoreService {
  FirebaseFirestore? _firestore;

  FirebaseFirestore? get _instance {
    try {
      _firestore ??= FirebaseFirestore.instance;
      return _firestore;
    } catch (_) {
      return null;
    }
  }

  // --- MENU ITEMS ---
  Stream<List<MenuItemModel>> getMenuItems() {
    final fs = _instance;
    if (fs == null) return const Stream.empty();

    return fs.collection('menu_items').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return MenuItemModel.fromMap(data, doc.id);
      }).toList();
    });
  }

  // --- TABLES ---
  Stream<List<TableModel>> getTables() {
    final fs = _instance;
    if (fs == null) return const Stream.empty();

    return fs.collection('tables').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return TableModel(
          id: doc.id,
          name: data['name'] ?? 'Table ${doc.id}',
          capacity: data['capacity'] ?? 4,
          isOccupied: data['isOccupied'] ?? false,
          occupiedByUserId: data['occupiedByUserId'],
          occupiedByUserEmail: data['occupiedByUserEmail'],
          occupiedByUserName: data['occupiedByUserName'],
        );
      }).toList();
    });
  }

  Future<void> updateTableStatus({
    required String tableId,
    required bool isOccupied,
    String? userId,
    String? userEmail,
    String? userName,
  }) async {
    final fs = _instance;
    if (fs == null) return;

    await fs.collection('tables').doc(tableId).set({
      'id': tableId,
      'name': 'Table $tableId',
      'isOccupied': isOccupied,
      'occupiedByUserId': userId,
      'occupiedByUserEmail': userEmail,
      'occupiedByUserName': userName,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // --- ORDERS ---
  Stream<List<OrderModel>> getOrders() {
    final fs = _instance;
    if (fs == null) return const Stream.empty();

    return fs
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return OrderModel.fromJson(data);
      }).toList();
    });
  }

  Future<void> createOrder(Map<String, dynamic> orderJson) async {
    final fs = _instance;
    if (fs == null) return;

    await fs.collection('orders').doc(orderJson['id']).set(orderJson);
  }

  // --- SERVICE REQUESTS (TABLE PAGER) ---
  Stream<List<ServiceRequestModel>> getServiceRequests() {
    final fs = _instance;
    if (fs == null) return const Stream.empty();

    return fs
        .collection('service_requests')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ServiceRequestModel(
          id: doc.id,
          tableNumber: data['tableNumber'] ?? 'Table 01',
          type: data['type'] ?? 'Call Waiter',
          status: data['status'] ?? 'In Progress',
          timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
    });
  }

  Future<void> createServiceRequest(ServiceRequestModel request) async {
    final fs = _instance;
    if (fs == null) return;

    await fs.collection('service_requests').doc(request.id).set({
      'id': request.id,
      'tableNumber': request.tableNumber,
      'type': request.type,
      'status': request.status,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
