import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/app_state_provider.dart';

class TableManagementDialog extends StatefulWidget {
  const TableManagementDialog({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1F1F1F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const TableManagementDialog(),
    );
  }

  @override
  State<TableManagementDialog> createState() => _TableManagementDialogState();
}

class _TableManagementDialogState extends State<TableManagementDialog> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final totalCount = appState.tables.length; // Exactly 30 Tables
    final availableCount = appState.tables.where((t) => !t.isOccupied).length;
    final occupiedCount = appState.tables.where((t) => t.isOccupied).length;
    final myTable = appState.selectedTableNumber;

    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.table_restaurant, color: Color(0xFFFFC900)),
                  SizedBox(width: 8),
                  Text(
                    'TABLE MANAGEMENT',
                    style: TextStyle(
                      color: Color(0xFFFFC900),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 20),

          // Current Customer & Table Info Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFC900).withAlpha(100)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Current Table:',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    Text(
                      myTable ?? 'No table selected',
                      style: const TextStyle(
                        color: Color(0xFFFFC900),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Status:',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    Text(
                      myTable != null ? 'OCCUPIED' : 'None',
                      style: TextStyle(
                        color: myTable != null ? Colors.green : Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Real-time Table Status Counters (Total 30 Tables)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$availableCount',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Available (of $totalCount)',
                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$occupiedCount',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Text(
                        'Occupied Tables',
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const Text(
            'Select or Change Table (Table 01 to Table 30):',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 10),

          // 30 Tables Grid View
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 500 ? 5 : 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.1,
              ),
              itemCount: appState.tables.length, // Exactly 30 Tables
              itemBuilder: (context, index) {
                final table = appState.tables[index];
                final isMyTable = myTable == table.name;
                final isOccupied = table.isOccupied && !isMyTable;

                Color borderColor;
                Color cardBg;
                String labelText;

                if (isMyTable) {
                  borderColor = const Color(0xFFFFC900);
                  cardBg = const Color(0xFFFFC900).withAlpha(40);
                  labelText = 'YOUR TABLE';
                } else if (isOccupied) {
                  borderColor = Colors.red;
                  cardBg = Colors.red.withAlpha(20);
                  labelText = 'OCCUPIED';
                } else {
                  borderColor = Colors.green;
                  cardBg = Colors.green.withAlpha(20);
                  labelText = 'AVAILABLE';
                }

                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    if (isOccupied) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Sorry, ${table.name} is occupied by another customer.'),
                          backgroundColor: Colors.red[700],
                        ),
                      );
                    } else {
                      _showTableConfirmDialog(context, appState, table.name, isMyTable);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isMyTable
                              ? Icons.stars
                              : (isOccupied ? Icons.lock : Icons.event_seat),
                          color: borderColor,
                          size: 18,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          table.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          labelText,
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: borderColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showTableConfirmDialog(
    BuildContext context,
    AppStateProvider appState,
    String tableName,
    bool isMyTable,
  ) {
    if (isMyTable) return;

    final currentTable = appState.selectedTableNumber;
    final isChanging = currentTable != null;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(isChanging ? 'Change to $tableName?' : 'Use $tableName?'),
          content: Text(
            isChanging
                ? 'Change current table from $currentTable to $tableName?'
                : 'Use $tableName as your current restaurant table?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC900),
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(ctx);
                final success = appState.selectTable(tableName);
                if (success) {
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$tableName assigned successfully!'),
                      backgroundColor: Colors.green[700],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sorry, $tableName is no longer available.'),
                      backgroundColor: Colors.red[700],
                    ),
                  );
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
