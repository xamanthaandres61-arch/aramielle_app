import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/app_state_provider.dart';

class TablePagerScreen extends StatefulWidget {
  const TablePagerScreen({super.key});

  @override
  State<TablePagerScreen> createState() => _TablePagerScreenState();
}

class _TablePagerScreenState extends State<TablePagerScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppStateProvider>(context);
    final selectedTable = appState.selectedTableNumber ?? 'Table 01';
    final user = appState.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Table Pager'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. NO TABLE SELECTED / CURRENT TABLE CARD
            Card(
              color: theme.colorScheme.primary.withAlpha(30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.table_restaurant, color: Colors.black, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appState.hasSelectedTable
                                ? 'Current Table: $selectedTable'
                                : 'No Table Selected',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            appState.hasSelectedTable
                                ? '● Occupied by ${user.name}'
                                : "Tap 'Table Management' in top right to pick a table",
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withAlpha(180),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. ESP32 IOT KITCHEN STATUS BADGE
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[300]!),
              ),
              child: const Row(
                children: [
                  Icon(Icons.wifi, color: Colors.green, size: 22),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'ESP32 IoT Kitchen Order & Pager Hub Connected\n(5V Buzzer & LED Active)',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. SELECT ASSISTANCE REQUIRED
            Text(
              'Select Assistance Required',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _buildPagerCard(
                    context: context,
                    icon: Icons.water_drop_outlined,
                    color: Colors.blue,
                    title: 'Water Refill',
                    onTap: () => _sendPagerRequest(context, appState, 'Water Refill'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildPagerCard(
                    context: context,
                    icon: Icons.receipt_long_outlined,
                    color: Colors.orange,
                    title: 'Bill Out',
                    onTap: () => _sendPagerRequest(context, appState, 'Bill Out'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildPagerCard(
                    context: context,
                    icon: Icons.person_add_alt_outlined,
                    color: Colors.purple,
                    title: 'Call Waiter',
                    onTap: () => _sendPagerRequest(context, appState, 'Call Waiter'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // 4. ACTIVE ASSISTANCE CALLS
            Text(
              'Active Assistance Calls',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            if (appState.serviceRequests.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      'No active assistance calls for your table.',
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appState.serviceRequests.length,
                itemBuilder: (context, index) {
                  final req = appState.serviceRequests[index];
                  final isCompleted = req.status == 'Completed';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        isCompleted ? Icons.check_circle : Icons.notifications_active,
                        color: isCompleted ? Colors.green : theme.colorScheme.primary,
                      ),
                      title: Text(
                        req.type,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Requested at ${_formatTime(req.timestamp)} • ${req.tableNumber}',
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCompleted ? Colors.green[100] : Colors.amber[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          req.status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isCompleted ? Colors.green[800] : Colors.amber[900],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _sendPagerRequest(BuildContext context, AppStateProvider appState, String type) {
    appState.sendServiceRequest(type);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Signal "$type" sent for ${appState.selectedTableNumber ?? "Table 01"}! Waitstaff notified.'),
        backgroundColor: Colors.green[700],
      ),
    );
  }

  Widget _buildPagerCard({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}
