
import 'package:flutter/material.dart';

class MandapVerificationScreen extends StatefulWidget {
  final String applicationId;

  const MandapVerificationScreen({
    super.key,
    required this.applicationId,
  });

  @override
  State<MandapVerificationScreen> createState() =>
      _MandapVerificationScreenState();
}

class _MandapVerificationScreenState
    extends State<MandapVerificationScreen> {
  String structuralInspected = '';
  String roadObstruction = '';
  String obstructionType = '';
  String trafficImpact = '';
  String roadWidth = '';
  String actionRequired = '';

  String emergencyVerified = '';
  String emergencyAccess = '';

  String remarks = '';

  String errorMessage = '';
  String successMessage = '';

  void saveVerification() {
    setState(() {
      errorMessage = '';
      successMessage = '';
    });

    if (structuralInspected.isEmpty) {
      setState(() {
        errorMessage =
            'Please answer: Structural Stability of Mandap Inspected?';
      });
      return;
    }

    if (structuralInspected == 'NO') {
      if (remarks.trim().isEmpty) {
        setState(() {
          errorMessage =
              'Reason / Remarks are mandatory when Structural Stability Inspection is NO.';
        });
        return;
      }

      setState(() {
        successMessage =
            'Mandap verification saved. This case will be included in NO / Pending monitoring.';
      });

      return;
    }

    if (roadObstruction.isEmpty) {
      setState(() {
        errorMessage =
            'Please answer: Road Block / Obstruction from Traffic Point of View?';
      });
      return;
    }

    if (roadObstruction == 'YES') {
      if (obstructionType.isEmpty) {
        setState(() {
          errorMessage =
              'Please select Obstruction Type.';
        });
        return;
      }

      if (trafficImpact.isEmpty) {
        setState(() {
          errorMessage =
              'Please select Impact on Traffic.';
        });
        return;
      }

      if (roadWidth.trim().isEmpty) {
        setState(() {
          errorMessage =
              'Please enter Road Width Available.';
        });
        return;
      }

      if (actionRequired.isEmpty) {
        setState(() {
          errorMessage =
              'Please select Action Required.';
        });
        return;
      }
    }

    if (emergencyVerified.isEmpty) {
      setState(() {
        errorMessage =
            'Please answer: Access for Emergency Vehicles Verified?';
      });
      return;
    }

    if (emergencyVerified == 'NO') {
      if (remarks.trim().isEmpty) {
        setState(() {
          errorMessage =
              'Reason / Remarks are mandatory when Emergency Vehicle Access Verification is NO.';
        });
        return;
      }

      setState(() {
        successMessage =
            'Mandap verification saved with NO / Pending exception.';
      });

      return;
    }

    if (emergencyVerified == 'YES' &&
        emergencyAccess.isEmpty) {
      setState(() {
        errorMessage =
            'Please select Emergency Vehicle Access status.';
      });
      return;
    }

    setState(() {
      successMessage =
          'Mandap-Based Verification saved successfully.';
    });
  }

  Widget yesNoButtons({
    required String value,
    required void Function(String) onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: () => onChanged('YES'),
            style: FilledButton.styleFrom(
              backgroundColor: value == 'YES'
                  ? Colors.green
                  : const Color(0xFFE2E8F0),
              foregroundColor: value == 'YES'
                  ? Colors.white
                  : Colors.black87,
            ),
            child: const Text('YES'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: () => onChanged('NO'),
            style: FilledButton.styleFrom(
              backgroundColor: value == 'NO'
                  ? Colors.red
                  : const Color(0xFFE2E8F0),
              foregroundColor: value == 'NO'
                  ? Colors.white
                  : Colors.black87,
            ),
            child: const Text('NO'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Mandap-Based Verification'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Application ID',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      widget.applicationId,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF17365D),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Structural Stability of Mandap Inspected?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    yesNoButtons(
                      value: structuralInspected,
                      onChanged: (value) {
                        setState(() {
                          structuralInspected =
                              value;
                        });
                      },
                    ),

                    if (structuralInspected ==
                        'NO') ...[
                      const SizedBox(height: 18),

                      const Text(
                        'NO-type Reason / Remarks *',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        maxLines: 4,
                        onChanged: (value) {
                          remarks = value;
                        },
                        decoration:
                            const InputDecoration(
                          hintText:
                              'Enter reason',
                          border:
                              OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            if (structuralInspected == 'YES') ...[
              const SizedBox(height: 14),

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Road Block / Obstruction from Traffic Point of View?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 14),

                      yesNoButtons(
                        value: roadObstruction,
                        onChanged: (value) {
                          setState(() {
                            roadObstruction =
                                value;
                          });
                        },
                      ),

                      if (roadObstruction ==
                          'YES') ...[
                        const SizedBox(
                            height: 18),

                        DropdownButtonFormField<
                            String>(
                          initialValue:
                              obstructionType
                                      .isEmpty
                                  ? null
                                  : obstructionType,
                          decoration:
                              const InputDecoration(
                            labelText:
                                'Obstruction Type *',
                            border:
                                OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'MANDAP',
                              child: Text('Mandap'),
                            ),
                            DropdownMenuItem(
                              value: 'PARKING',
                              child: Text('Parking'),
                            ),
                            DropdownMenuItem(
                              value: 'BARRICADES',
                              child:
                                  Text('Barricades'),
                            ),
                            DropdownMenuItem(
                              value: 'OTHER',
                              child: Text('Other'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              obstructionType =
                                  value ?? '';
                            });
                          },
                        ),

                        const SizedBox(
                            height: 16),

                        DropdownButtonFormField<
                            String>(
                          initialValue:
                              trafficImpact
                                      .isEmpty
                                  ? null
                                  : trafficImpact,
                          decoration:
                              const InputDecoration(
                            labelText:
                                'Impact on Traffic *',
                            border:
                                OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'LOW',
                              child: Text('Low'),
                            ),
                            DropdownMenuItem(
                              value: 'MODERATE',
                              child:
                                  Text('Moderate'),
                            ),
                            DropdownMenuItem(
                              value: 'HIGH',
                              child: Text('High'),
                            ),
                            DropdownMenuItem(
                              value: 'CRITICAL',
                              child:
                                  Text('Critical'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              trafficImpact =
                                  value ?? '';
                            });
                          },
                        ),

                        const SizedBox(
                            height: 16),

                        TextField(
                          keyboardType:
                              const TextInputType
                                  .numberWithOptions(
                            decimal: true,
                          ),
                          onChanged: (value) {
                            roadWidth = value;
                          },
                          decoration:
                              const InputDecoration(
                            labelText:
                                'Road Width Available (ft.) *',
                            hintText:
                                'Example: 20',
                            border:
                                OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(
                            height: 16),

                        DropdownButtonFormField<
                            String>(
                          initialValue:
                              actionRequired
                                      .isEmpty
                                  ? null
                                  : actionRequired,
                          decoration:
                              const InputDecoration(
                            labelText:
                                'Action Required *',
                            border:
                                OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'NO_ACTION',
                              child:
                                  Text('No Action'),
                            ),
                            DropdownMenuItem(
                              value:
                                  'RECTIFICATION',
                              child: Text(
                                  'Rectification'),
                            ),
                            DropdownMenuItem(
                              value:
                                  'TRAFFIC_DIVERSION',
                              child: Text(
                                  'Traffic Diversion'),
                            ),
                            DropdownMenuItem(
                              value:
                                  'IMMEDIATE_ACTION',
                              child: Text(
                                  'Immediate Action'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              actionRequired =
                                  value ?? '';
                            });
                          },
                        ),

                        if (trafficImpact ==
                                'CRITICAL' ||
                            actionRequired ==
                                'IMMEDIATE_ACTION') ...[
                          const SizedBox(
                              height: 14),

                          Container(
                            padding:
                                const EdgeInsets
                                    .all(12),
                            decoration:
                                BoxDecoration(
                              color: const Color(
                                  0xFFFFF1F2),
                              borderRadius:
                                  BorderRadius
                                      .circular(10),
                            ),
                            child: const Text(
                              'Critical / Immediate Action finding. This case should be highlighted for supervisory monitoring.',
                              style: TextStyle(
                                color:
                                    Colors.red,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Access for Emergency Vehicles Verified?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 14),

                      yesNoButtons(
                        value:
                            emergencyVerified,
                        onChanged: (value) {
                          setState(() {
                            emergencyVerified =
                                value;
                          });
                        },
                      ),

                      if (emergencyVerified ==
                          'YES') ...[
                        const SizedBox(
                            height: 18),

                        DropdownButtonFormField<
                            String>(
                          initialValue:
                              emergencyAccess
                                      .isEmpty
                                  ? null
                                  : emergencyAccess,
                          decoration:
                              const InputDecoration(
                            labelText:
                                'Emergency Vehicle Access *',
                            border:
                                OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value:
                                  'ACCESSIBLE',
                              child: Text(
                                  'Accessible'),
                            ),
                            DropdownMenuItem(
                              value:
                                  'INACCESSIBLE',
                              child: Text(
                                  'Inaccessible'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              emergencyAccess =
                                  value ?? '';
                            });
                          },
                        ),

                        if (emergencyAccess ==
                            'INACCESSIBLE') ...[
                          const SizedBox(
                              height: 14),

                          Container(
                            padding:
                                const EdgeInsets
                                    .all(12),
                            decoration:
                                BoxDecoration(
                              color: const Color(
                                  0xFFFFF1F2),
                              borderRadius:
                                  BorderRadius
                                      .circular(10),
                            ),
                            child: const Text(
                              'Adverse Finding: Emergency vehicle access is inaccessible.',
                              style: TextStyle(
                                color:
                                    Colors.red,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],

                      if (emergencyVerified ==
                          'NO') ...[
                        const SizedBox(
                            height: 18),

                        const Text(
                          'NO-type Reason / Remarks *',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        TextField(
                          maxLines: 4,
                          onChanged: (value) {
                            remarks = value;
                          },
                          decoration:
                              const InputDecoration(
                            hintText:
                                'Enter reason',
                            border:
                                OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            if (errorMessage.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.all(12),
                margin:
                    const EdgeInsets.only(
                        bottom: 12),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFFEE2E2),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Text(
                  errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),

            if (successMessage.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.all(12),
                margin:
                    const EdgeInsets.only(
                        bottom: 12),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFDCFCE7),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Text(
                  successMessage,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),

            FilledButton.icon(
              onPressed: saveVerification,
              icon:
                  const Icon(Icons.save_outlined),
              label: const Text(
                'Save Mandap Verification',
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}