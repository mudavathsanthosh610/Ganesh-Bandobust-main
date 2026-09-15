import 'idol_verification_screen.dart';
import 'mandap_verification_screen.dart';
import 'location_verification_screen.dart';
import 'package:flutter/material.dart';

class PreInstallationScreen extends StatelessWidget {
  final String applicationId;
  final double declaredHeightFeet;

  const PreInstallationScreen({
    super.key,
    required this.applicationId,
    required this.declaredHeightFeet,
  });

  @override
  Widget build(BuildContext context) {
    final modules = [
      {
        'number': '1',
        'title': 'Location-Based Verification',
        'status': 'Ready',
      },
      {
        'number': '2',
        'title': 'Mandap-Based Verification',
        'status': 'Ready',
      },
      {
        'number': '3',
        'title': 'Idol-Based Verification',
        'status': 'Ready',
      },
      {
        'number': '4',
        'title': 'Route-Based Verification',
        'status': 'Pending',
      },
      {
        'number': '5',
        'title': 'Security-Based Verification',
        'status': 'Pending',
      },
      {
        'number': '6',
        'title': 'Organizer-Based Verification',
        'status': 'Pending',
      },
      {
        'number': '7',
        'title': 'Inter-Departmental Coordination / NOCs',
        'status': 'Pending',
      },
      {
        'number': '8',
        'title': 'Permission / SHO Review',
        'status': 'Pending',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pre-Installation Verification',
        ),
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFFEFF6FF),

            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const Text(
                  'APPLICATION',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  applicationId,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF17365D),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: modules.length,

              itemBuilder: (context, index) {
                final module = modules[index];

                final ready =
                    module['status'] == 'Ready';

                return Card(
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.all(12),

                    leading: CircleAvatar(
                      backgroundColor:
                          const Color(0xFF17365D),

                      child: Text(
                        module['number']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    title: Text(
                      module['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(
                      module['status']!,

                      style: TextStyle(
                        color: ready
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),

                    trailing: ready
                        ? const Icon(
                            Icons.chevron_right,
                          )
                        : const Icon(
                            Icons.lock_outline,
                          ),

              onTap: ready
    ? () {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  LocationVerificationScreen(
                applicationId:
                    applicationId,
              ),
            ),
          );

          return;
        }

        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  MandapVerificationScreen(
                applicationId:
                    applicationId,
              ),
            ),
          );

          return;
        }

        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  IdolVerificationScreen(
                applicationId:
                    applicationId,
                declaredHeightFeet:
                    declaredHeightFeet,
              ),
            ),
          );

          return;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              '${module['title']} will be developed next.',
            ),
          ),
        );
      }
    : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}