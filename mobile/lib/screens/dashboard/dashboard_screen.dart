import 'package:flutter/material.dart';
import '../applications/my_idols_screen.dart';
import '../login/login_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String officerName;
  final String role;
  final String policeStation;
  final String sector;

  const DashboardScreen({
    super.key,
    required this.officerName,
    required this.role,
    required this.policeStation,
    required this.sector,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ganesh Bandobust 2026',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),

            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Logged-in Officer',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      officerName,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(role),
                    Text(policeStation),
                    Text('Sector: $sector'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'My Work',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF17365D),

                  child: Icon(
                    Icons.temple_hindu,
                    color: Colors.white,
                  ),
                ),

                title: const Text(
                  'My Idols / Applications',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: const Text(
                  '3 assigned applications',
                ),

                trailing:
                    const Icon(Icons.chevron_right),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const MyIdolsScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Festival Stages',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const _StageTile(
              number: '1',
              title: 'Pre-Installation',
              status: 'ACTIVE',
              active: true,
            ),

            const _StageTile(
              number: '2',
              title: 'Installation',
              status: 'Not Started',
            ),

            const _StageTile(
              number: '3',
              title: 'During Festivity',
              status: 'Not Started',
            ),

            const _StageTile(
              number: '4',
              title: 'Immersion',
              status: 'Not Started',
            ),

            const _StageTile(
              number: '5',
              title: 'Post-Immersion',
              status: 'Not Started',
            ),
          ],
        ),
      ),
    );
  }
}

class _StageTile extends StatelessWidget {
  final String number;
  final String title;
  final String status;
  final bool active;

  const _StageTile({
    required this.number,
    required this.title,
    required this.status,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: active
              ? const Color(0xFF17365D)
              : const Color(0xFFE2E8F0),

          foregroundColor:
              active ? Colors.white : Colors.black54,

          child: Text(number),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(status),

        trailing: active
            ? const Icon(Icons.check_circle,
                color: Colors.green)
            : const Icon(Icons.lock_outline),
      ),
    );
  }
}