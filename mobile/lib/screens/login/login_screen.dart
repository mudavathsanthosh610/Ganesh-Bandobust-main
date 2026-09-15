import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController =
      TextEditingController(text: 'field1');

  final passwordController =
      TextEditingController(text: 'field123');

  bool obscurePassword = true;
  String errorMessage = '';

  void login() {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username == 'field1' && password == 'field123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(
            officerName: 'Field Officer Demo',
            role: 'FIELD OFFICER',
            policeStation: 'Demo Police Station',
            sector: '03',
          ),
        ),
      );

      return;
    }

    setState(() {
      errorMessage = 'Invalid username or password';
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),

              child: Card(
                elevation: 8,
                clipBehavior: Clip.antiAlias,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),

                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: const Color(0xFF17365D),

                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 34,
                      ),

                      child: const Column(
                        children: [
                          Icon(
                            Icons.local_police,
                            size: 48,
                            color: Colors.white,
                          ),

                          SizedBox(height: 15),

                          Text(
                            'OFFICIAL USE',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),

                          SizedBox(height: 12),

                          Text(
                            'GANESH FESTIVAL',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            'BANDOBUST MANAGEMENT SYSTEM',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: 12),

                          Text(
                            'Field Officer Mobile Application',
                            style: TextStyle(
                              color: Color(0xFFBFDBFE),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(26),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,

                        children: [
                          const Text(
                            'Official Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            'Authorized officers only',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF64748B),
                            ),
                          ),

                          const SizedBox(height: 30),

                          TextField(
                            controller: usernameController,

                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon:
                                  const Icon(Icons.person_outline),

                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          TextField(
                            controller: passwordController,
                            obscureText: obscurePassword,

                            decoration: InputDecoration(
                              labelText: 'Password',

                              prefixIcon:
                                  const Icon(Icons.lock_outline),

                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscurePassword =
                                        !obscurePassword;
                                  });
                                },

                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),

                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                            ),
                          ),

                          if (errorMessage.isNotEmpty) ...[
                            const SizedBox(height: 14),

                            Text(
                              errorMessage,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],

                          const SizedBox(height: 24),

                          SizedBox(
                            height: 52,

                            child: FilledButton(
                              onPressed: login,

                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF17365D),
                              ),

                              child: const Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'Demo Login\nfield1 / field123',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}