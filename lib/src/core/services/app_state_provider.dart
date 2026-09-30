import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/menu_item_model.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../models/service_request_model.dart';
import '../models/table_model.dart';
import '../models/user_model.dart';
import 'firestore_service.dart';
import 'sample_data.dart';

class AppStateProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  // Theme Mode (Dark Mode vs Light Mode)
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleThemeMode() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // Session Persistence State
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isSessionLoaded = false;
  bool get isSessionLoaded => _isSessionLoaded;

  // Centralized Table Management (30 Official Restaurant Tables: Table 01 to Table 30)
  final List<TableModel> _tables = List.generate(30, (i) {
    final numStr = (i + 1).toString().padLeft(2, '0');
    if (i == 1) {
      return TableModel(
        id: numStr,
        name: 'Table $numStr',
        isOccupied: true,
        occupiedByUserId: 'u_999',
        occupiedByUserEmail: 'customer_b@example.com',
        occupiedByUserName: 'Customer B',
      );
    }
    if (i == 4) {
      return TableModel(
        id: numStr,
        name: 'Table $numStr',
        isOccupied: true,
        occupiedByUserId: 'u_888',
        occupiedByUserEmail: 'customer_c@example.com',
        occupiedByUserName: 'Customer C',
      );
    }
    return TableModel(
      id: numStr,
      name: 'Table $numStr',
      isOccupied: false,
    );
  });

  List<TableModel> get tables => _tables;

  String? _selectedTableNumber;
  String? get selectedTableNumber => _selectedTableNumber;
  bool get hasSelectedTable =>
      _selectedTableNumber != null &&
      _selectedTableNumber!.isNotEmpty &&
      _selectedTableNumber != 'None';

  // Current logged in user
  UserModel _currentUser = const UserModel(
    id: 'u_101',
    name: 'Xamantha Andres',
    email: 'xamantha@example.com',
    phone: '+63 917 123 4567',
    allergies: ['Peanuts'],
    dietaryPreferences: ['Low Gluten'],
    isSeniorOrPwd: false,
  );

  UserModel get currentUser => _currentUser;

  // Complete Menu List (Initialized with 100% of complete menu items)
  final List<MenuItemModel> _menuItems = List.from(SampleData.sampleMenuItems);
  List<MenuItemModel> get menuItems => _menuItems;

  AppStateProvider() {
    _loadSavedSession();
    _listenToFirestoreMenu();
  }

  void _listenToFirestoreMenu() {
    try {
      _firestoreService.getMenuItems().listen(
        (firestoreItems) {
          if (firestoreItems.isNotEmpty) {
            final Map<String, MenuItemModel> menuMap = {};
            for (var item in SampleData.sampleMenuItems) {
              menuMap[item.name.toLowerCase().trim()] = item;
            }
            for (var item in firestoreItems) {
              if (item.name.trim().isNotEmpty) {
                menuMap[item.name.toLowerCase().trim()] = item;
              }
            }
            _menuItems.clear();
            _menuItems.addAll(menuMap.values);
            notifyListeners();
          }
        },
        onError: (_) {},
      );
    } catch (_) {}
  }

  Future<void> _loadSavedSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (_isLoggedIn) {
        final savedEmail = prefs.getString('userEmail') ?? 'xamantha@example.com';
        final savedName = prefs.getString('userName') ?? 'Xamantha Andres';

        _currentUser = UserModel(
          id: savedEmail.hashCode.toString(),
          name: savedName,
          email: savedEmail,
          phone: '+63 917 123 4567',
          allergies: _currentUser.allergies,
          dietaryPreferences: _currentUser.dietaryPreferences,
          isSeniorOrPwd: _currentUser.isSeniorOrPwd,
        );

        // Load customer-isolated table assignment key
        final savedTable = prefs.getString('table_$savedEmail');
        if (savedTable != null && savedTable.isNotEmpty) {
          _selectedTableNumber = savedTable;
          final tIndex = _tables.indexWhere((t) => t.name == savedTable);
          if (tIndex >= 0) {
            _tables[tIndex].isOccupied = true;
            _tables[tIndex].occupiedByUserId = _currentUser.id;
            _tables[tIndex].occupiedByUserEmail = savedEmail;
            _tables[tIndex].occupiedByUserName = savedName;
          }
        } else {
          _selectedTableNumber = null;
        }
      }
    } catch (_) {
      _isLoggedIn = false;
    } finally {
      _isSessionLoaded = true;
      notifyListeners();
    }
  }

  Future<void> saveUserSession({required String name, required String email}) async {
    _isLoggedIn = true;
    _currentUser = UserModel(
      id: email.hashCode.toString(),
      name: name,
      email: email,
      phone: '+63 917 123 4567',
      allergies: _currentUser.allergies,
      dietaryPreferences: _currentUser.dietaryPreferences,
      isSeniorOrPwd: _currentUser.isSeniorOrPwd,
    );

    // Restore table for this specific user if previously saved
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userName', name);
      await prefs.setString('userEmail', email);

      final savedTable = prefs.getString('table_$email');
      if (savedTable != null && savedTable.isNotEmpty) {
        _selectedTableNumber = savedTable;
        final tIndex = _tables.indexWhere((t) => t.name == savedTable);
        if (tIndex >= 0) {
          _tables[tIndex].isOccupied = true;
          _tables[tIndex].occupiedByUserId = _currentUser.id;
          _tables[tIndex].occupiedByUserEmail = email;
          _tables[tIndex].occupiedByUserName = name;
        }
      } else {
        _selectedTableNumber = null;
      }
    } catch (_) {}

    notifyListeners();
  }

  Future<void> clearUserSession() async {
    _isLoggedIn = false;
    final currentEmail = _currentUser.email;

    // Release user's table on logout
    if (_selectedTableNumber != null) {
      releaseTable(_selectedTableNumber!);
    }
    _selectedTableNumber = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('userName');
      await prefs.remove('userEmail');
      await prefs.remove('table_$currentEmail');
    } catch (_) {}
  }

  // Centralized Customer-Isolated Table Selection Actions
  void setTableNumber(String tableName) {
    selectTable(tableName);
  }

  bool selectTable(String tableName) {
    final targetIndex = _tables.indexWhere((t) => t.name == tableName);
    if (targetIndex >= 0) {
      final targetTable = _tables[targetIndex];
      // Prevent double booking (occupied by another customer)
      if (targetTable.isOccupied && targetTable.occupiedByUserEmail != _currentUser.email) {
        return false;
      }

      // Safe Change Table: Release previous table ONLY AFTER new assignment target is validated
      for (var t in _tables) {
        if (t.occupiedByUserEmail == _currentUser.email) {
          t.isOccupied = false;
          t.occupiedByUserId = null;
          t.occupiedByUserEmail = null;
          t.occupiedByUserName = null;
        }
      }

      // Mark new table as occupied by current user
      targetTable.isOccupied = true;
      targetTable.occupiedByUserId = _currentUser.id;
      targetTable.occupiedByUserEmail = _currentUser.email;
      targetTable.occupiedByUserName = _currentUser.name;
      _selectedTableNumber = tableName;
      notifyListeners();

      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('table_${_currentUser.email}', tableName);
      });

      return true;
    }
    return false;
  }

  void releaseTable(String tableName) {
    final index = _tables.indexWhere((t) => t.name == tableName);
    if (index >= 0) {
      _tables[index].isOccupied = false;
      _tables[index].occupiedByUserId = null;
      _tables[index].occupiedByUserEmail = null;
      _tables[index].occupiedByUserName = null;

      if (_selectedTableNumber == tableName) {
        _selectedTableNumber = null;
      }
      notifyListeners();

      SharedPreferences.getInstance().then((prefs) {
        prefs.remove('table_${_currentUser.email}');
      });
    }
  }

  // Selected Category filter
  String _selectedCuisine = 'All';
  String get selectedCuisine => _selectedCuisine;

  // Search Query
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // Allergen filter enabled
  bool _filterOutMyAllergies = false;
  bool get filterOutMyAllergies => _filterOutMyAllergies;

  // Cart
  final List<CartItemModel> _cart = [];
  List<CartItemModel> get cart => _cart;

  // Order Type: 'Dine-in' or 'Take-out'
  String _orderType = 'Dine-in';
  String get orderType => _orderType;

  // Senior / PWD Discount selection
  String _discountType = 'None'; // 'None', 'Senior Citizen', 'PWD'
  String get discountType => _discountType;

  String? _seniorPwdIdPath;
  String? get seniorPwdIdPath => _seniorPwdIdPath;

  String? _paymentReceiptPath;
  String? get paymentReceiptPath => _paymentReceiptPath;

  // Orders history & active orders
  final List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  OrderModel? get activeOrder {
    if (_orders.isEmpty) return null;
    return _orders.firstWhere(
      (o) => o.orderStatus != 'Served',
      orElse: () => _orders.first,
    );
  }

  // Active Service Requests (Digital Table Pager)
  final List<ServiceRequestModel> _serviceRequests = [];
  List<ServiceRequestModel> get serviceRequests => _serviceRequests;

  // --- ACTIONS ---

  void setCuisineFilter(String category) {
    _selectedCuisine = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleAllergenFilter(bool enable) {
    _filterOutMyAllergies = enable;
    notifyListeners();
  }

  void setOrderType(String type) {
    _orderType = type;
    notifyListeners();
  }

  void setDiscountType(String type) {
    _discountType = type;
    notifyListeners();
  }

  void setSeniorPwdIdPath(String path) {
    _seniorPwdIdPath = path;
    notifyListeners();
  }

  void setPaymentReceiptPath(String path) {
    _paymentReceiptPath = path;
    notifyListeners();
  }

  // Filtered Menu Items based on category, search, and user's allergen warnings
  List<MenuItemModel> get filteredMenuItems {
    return _menuItems.where((item) {
      // Category check
      if (_selectedCuisine != 'All') {
        final catLower = _selectedCuisine.toLowerCase();
        final itemCatLower = item.cuisine.toLowerCase();
        if (!itemCatLower.contains(catLower) && !catLower.contains(itemCatLower)) {
          return false;
        }
      }

      // Search check
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final nameMatch = item.name.toLowerCase().contains(query);
        final descMatch = item.description.toLowerCase().contains(query);
        final ingMatch = item.ingredients.any((i) => i.toLowerCase().contains(query));
        if (!nameMatch && !descMatch && !ingMatch) return false;
      }

      // Allergen filter check
      if (_filterOutMyAllergies) {
        final hasAllergy = item.allergens.any((a) => _currentUser.allergies.contains(a));
        if (hasAllergy) return false;
      }

      return true;
    }).toList();
  }

  // Cart operations
  void addToCart(MenuItemModel item, {int quantity = 1, String instructions = ''}) {
    final index = _cart.indexWhere((c) => c.item.id == item.id);
    if (index >= 0) {
      _cart[index].quantity += quantity;
      if (instructions.isNotEmpty) {
        _cart[index].specialInstructions = instructions;
      }
    } else {
      _cart.add(CartItemModel(
        item: item,
        quantity: quantity,
        specialInstructions: instructions,
      ));
    }
    notifyListeners();
  }

  void updateCartQuantity(String menuItemId, int newQuantity) {
    final index = _cart.indexWhere((c) => c.item.id == menuItemId);
    if (index >= 0) {
      if (newQuantity <= 0) {
        _cart.removeAt(index);
      } else {
        _cart[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void removeFromCart(String menuItemId) {
    _cart.removeWhere((c) => c.item.id == menuItemId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _discountType = 'None';
    _seniorPwdIdPath = null;
    _paymentReceiptPath = null;
    notifyListeners();
  }

  // Calculated totals
  double get cartSubtotal {
    return _cart.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get cartDiscountAmount {
    if (_discountType != 'None') {
      // 20% discount on total
      return cartSubtotal * 0.20;
    }
    return 0.0;
  }

  double get cartFinalTotal {
    return (cartSubtotal - cartDiscountAmount).clamp(0.0, double.infinity);
  }

  // Submit Order
  OrderModel submitOrder() {
    final tableAssigned = _orderType == 'Dine-in'
        ? (_selectedTableNumber ?? 'Table 01')
        : 'N/A';

    final newOrder = OrderModel(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      tableNumber: tableAssigned,
      orderType: _orderType,
      items: List.from(_cart),
      subtotal: cartSubtotal,
      discountAmount: cartDiscountAmount,
      totalAmount: cartFinalTotal,
      discountType: _discountType,
      paymentStatus: 'Pending Verification',
      orderStatus: 'Pending Verification',
      paymentReceiptUrl: _paymentReceiptPath ?? 'https://via.placeholder.com/150',
      createdAt: DateTime.now(),
    );

    _orders.insert(0, newOrder);
    _currentUser = UserModel(
      id: _currentUser.id,
      name: _currentUser.name,
      email: _currentUser.email,
      phone: _currentUser.phone,
      allergies: _currentUser.allergies,
      dietaryPreferences: _currentUser.dietaryPreferences,
      isSeniorOrPwd: _currentUser.isSeniorOrPwd,
    );

    clearCart();
    notifyListeners();

    // Save order to Firestore
    _firestoreService.createOrder(newOrder.toMap());

    // Simulate backend lifecycle transition: Pending -> Preparing -> Ready -> Served
    _simulateOrderProgress(newOrder.id);

    return newOrder;
  }

  void _simulateOrderProgress(String orderId) async {
    await Future.delayed(const Duration(seconds: 4));
    _updateOrderStatus(orderId, 'Preparing');

    await Future.delayed(const Duration(seconds: 8));
    _updateOrderStatus(orderId, 'Ready');

    await Future.delayed(const Duration(seconds: 12));
    _updateOrderStatus(orderId, 'Served');
  }

  void _updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      final old = _orders[index];
      _orders[index] = OrderModel(
        id: old.id,
        tableNumber: old.tableNumber,
        orderType: old.orderType,
        items: old.items,
        subtotal: old.subtotal,
        discountAmount: old.discountAmount,
        totalAmount: old.totalAmount,
        discountType: old.discountType,
        paymentStatus: newStatus == 'Pending Verification' ? 'Pending' : 'Paid',
        orderStatus: newStatus,
        paymentReceiptUrl: old.paymentReceiptUrl,
        createdAt: old.createdAt,
      );
      notifyListeners();
    }
  }

  // Digital Table Service Pager
  void sendServiceRequest(String requestType) {
    final req = ServiceRequestModel(
      id: 'REQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      tableNumber: _selectedTableNumber ?? 'Table 01',
      type: requestType,
      status: 'In Progress',
      timestamp: DateTime.now(),
    );

    _serviceRequests.insert(0, req);
    notifyListeners();

    // Save service request to Firestore
    _firestoreService.createServiceRequest(req);

    // Auto complete request after 6 seconds for simulation
    Future.delayed(const Duration(seconds: 6), () {
      final index = _serviceRequests.indexWhere((r) => r.id == req.id);
      if (index >= 0) {
        final current = _serviceRequests[index];
        _serviceRequests[index] = ServiceRequestModel(
          id: current.id,
          tableNumber: current.tableNumber,
          type: current.type,
          status: 'Completed',
          timestamp: current.timestamp,
        );
        notifyListeners();
      }
    });
  }

  // User Profile Updates
  void updateUserProfile({
    required String name,
    required String phone,
    required List<String> allergies,
    required List<String> dietaryPreferences,
  }) {
    _currentUser = UserModel(
      id: _currentUser.id,
      name: name,
      email: _currentUser.email,
      phone: phone,
      allergies: allergies,
      dietaryPreferences: dietaryPreferences,
      isSeniorOrPwd: _currentUser.isSeniorOrPwd,
    );
    notifyListeners();
  }
}
