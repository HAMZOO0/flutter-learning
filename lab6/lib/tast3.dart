import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final List<DashboardCard> cards = [
    DashboardCard(title: 'Users', value: '1.2K', icon: Icons.people),
    DashboardCard(title: 'Revenue', value: '\$25K', icon: Icons.attach_money),
    DashboardCard(title: 'Messages', value: '340', icon: Icons.message),
    DashboardCard(
      title: 'Notifications',
      value: '15',
      icon: Icons.notifications,
    ),
    DashboardCard(title: 'Tasks', value: '48', icon: Icons.task),
    DashboardCard(title: 'Storage', value: '85%', icon: Icons.storage),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = (screenWidth ~/ 180).clamp(2, 4);

    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final card = cards[index];
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: Text(card.title),
                        content: Text('Details about ${card.title}'),
                      ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(card.icon, size: 32, color: Colors.blue),
                    SizedBox(height: 12),
                    Text(
                      card.value,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(card.title, style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}

class DashboardCard {
  final String title;
  final String value;
  final IconData icon;

  DashboardCard({required this.title, required this.value, required this.icon});
}
