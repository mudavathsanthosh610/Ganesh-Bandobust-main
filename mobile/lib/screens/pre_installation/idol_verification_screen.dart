import 'dart:io';

import 'package:flutter/material.dart';

import '../measurement/ar_measurement_screen.dart';
import '../../models/ar_measurement_result.dart';
import '../../services/place_api_service.dart';

class IdolVerificationScreen extends StatefulWidget {
  final String applicationId;
  final double? declaredHeightFeet;

  const IdolVerificationScreen({
    super.key,
    required this.applicationId,
    this.declaredHeightFeet,
  });

  @override
  State<IdolVerificationScreen> createState() =>
      _IdolVerificationScreenState();
}

class _IdolVerificationScreenState
    extends State<IdolVerificationScreen> {
  String idolInstalled = '';
  String purchaseVerified = '';
  String purchaseWithinPs = '';
  String dimensionsVerified = '';

  final TextEditingController heightController =
      TextEditingController();

  String material = '';

  String heightMeasurementMethod = '';

  String? heightEvidenceImagePath;

  double? heightLatitude;
  double? heightLongitude;
  double? heightGpsAccuracy;

  DateTime? heightMeasuredAt;

  String remarks = '';

  String errorMessage = '';
  String successMessage = '';
  Map<String, dynamic>? placeDetails;
  bool isLoadingPlaceDetails = false;
  String placeApiError = '';

  @override
  void initState() {
    super.initState();
    loadPlaceDetails();
  }

  Future<void> loadPlaceDetails() async {
    setState(() {
      isLoadingPlaceDetails = true;
      placeApiError = '';
    });

    try {
      final details = await PlaceApiService.fetchPlaceDetails(
        widget.applicationId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        placeDetails = details;
        isLoadingPlaceDetails = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoadingPlaceDetails = false;
        placeApiError = 'Unable to load place details.';
      });
    }
  }

  @override
  void dispose() {
    heightController.dispose();
    super.dispose();
  }

  /* =========================================================
     DIGITAL AR MEASUREMENT
  ========================================================= */

  Future<void> openDigitalMeasurement(
    String type,
  ) async {
    final result =
        await Navigator.push<ArMeasurementResult>(
      context,
      MaterialPageRoute(
        builder: (_) => ArMeasurementScreen(
          applicationId: widget.applicationId,
          measurementType: type,
        ),
      ),
    );

    if (result == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      if (type == 'HEIGHT') {
        heightController.text =
            result.valueFeet.toStringAsFixed(2);

        heightMeasurementMethod =
            result.measurementMethod;

        heightEvidenceImagePath =
            result.evidenceImagePath;

        heightLatitude =
            result.latitude;

        heightLongitude =
            result.longitude;

        heightGpsAccuracy =
            result.gpsAccuracy;

        heightMeasuredAt =
            result.measuredAt;
      }

      successMessage =
          '$type digitally measured successfully: '
          '${result.valueFeet.toStringAsFixed(2)} ft';
    });
  }

  /* =========================================================
     SAVE VERIFICATION
  ========================================================= */

  void saveVerification() {
    setState(() {
      errorMessage = '';
      successMessage = '';
    });

    if (idolInstalled.isEmpty) {
      setState(() {
        errorMessage =
            'Please answer: Idol Installed or Not?';
      });

      return;
    }

    if (idolInstalled == 'NO') {
      if (remarks.trim().isEmpty) {
        setState(() {
          errorMessage =
              'Reason / Remarks are mandatory when Idol Installed is NO.';
        });

        return;
      }

      setState(() {
        successMessage =
            'Saved as Idol Not Installed and marked for NO / Pending monitoring.';
      });

      return;
    }

    if (purchaseVerified.isEmpty) {
      setState(() {
        errorMessage =
            'Please answer: Place of Purchase Verified?';
      });

      return;
    }

    if (purchaseVerified == 'NO' &&
        remarks.trim().isEmpty) {
      setState(() {
        errorMessage =
            'Reason / Remarks are mandatory when Place of Purchase is not verified.';
      });

      return;
    }

    if (purchaseWithinPs.isEmpty) {
      setState(() {
        errorMessage =
            'Please answer: Place of Purchase Falls Within This PS Limits?';
      });

      return;
    }

    /*
      IMPORTANT:
      purchaseWithinPs = NO is allowed
      WITHOUT mandatory remarks.
    */

    if (dimensionsVerified.isEmpty) {
      setState(() {
        errorMessage =
            'Please answer: Idol Height and Material Verified?';
      });

      return;
    }

    if (dimensionsVerified == 'NO') {
      setState(() {
        successMessage =
            'Idol verification saved with Height / Material pending.';
      });

      return;
    }

    if (heightController.text.trim().isEmpty) {
      setState(() {
        errorMessage =
            'Please enter or digitally measure Idol Height.';
      });

      return;
    }

    final measuredHeight =
        double.tryParse(heightController.text.trim());
    if (measuredHeight == null || measuredHeight <= 0) {
      setState(() {
        errorMessage =
            'Please enter a valid Idol Height or measure it automatically.';
      });

      return;
    }

    if (material.isEmpty) {
      setState(() {
        errorMessage =
            'Please select Idol Material.';
      });

      return;
    }

    setState(() {
      successMessage =
          'Idol-Based Verification saved successfully.';
    });
  }

  /* =========================================================
     YES / NO BUTTONS
  ========================================================= */

  Widget yesNoButtons({
    required String value,
    required void Function(String) onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: () {
              onChanged('YES');
            },
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
            onPressed: () {
              onChanged('NO');
            },
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

  Widget _placeRow(String label, dynamic value) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text('$label: $text'),
    );
  }

  /* =========================================================
     BUILD
  ========================================================= */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Idol-Based Verification'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,

          children: [
            /* APPLICATION DETAILS */

            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Application ID',
                      style: TextStyle(
                        color:
                            Color(0xFF64748B),
                      ),
                    ),

                    Text(
                      widget.applicationId,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            Color(0xFF17365D),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Place Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (isLoadingPlaceDetails)
                      const Center(child: CircularProgressIndicator())
                    else if (placeApiError.isNotEmpty)
                      Text(
                        placeApiError,
                        style: const TextStyle(color: Colors.red),
                      )
                    else ...[
                      _placeRow('Name', placeDetails?['name']),
                      _placeRow('Address', placeDetails?['address']),
                      _placeRow('Town', placeDetails?['town']),
                      _placeRow('District', placeDetails?['dist_name']),
                      _placeRow('Police Station', placeDetails?['ps_name']),
                      _placeRow('Road', placeDetails?['riv_name']),
                      _placeRow('Zone', placeDetails?['zone_name']),
                      _placeRow('Division', placeDetails?['division_name']),
                      _placeRow('PIN', placeDetails?['pin']),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            /* =================================================
               POINT 1 — IDOL INSTALLED
            ================================================= */

            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,

                  children: [
                    const Text(
                      'Point 1 — Idol Installed or Not?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 14),

                    yesNoButtons(
                      value: idolInstalled,

                      onChanged: (value) {
                        setState(() {
                          idolInstalled =
                              value;
                        });
                      },
                    ),

                    if (idolInstalled ==
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
                              'Enter reason why Idol is not installed',
                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Status will be recorded as Idol Not Installed.',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            if (idolInstalled == 'YES') ...[
              const SizedBox(height: 14),

              /* =================================================
                 POINT 2 — PURCHASE VERIFIED
              ================================================= */

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,

                    children: [
                      const Text(
                        'Point 2 — Place of Purchase Verified?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 14),

                      yesNoButtons(
                        value: purchaseVerified,

                        onChanged: (value) {
                          setState(() {
                            purchaseVerified =
                                value;
                          });
                        },
                      ),

                      if (purchaseVerified ==
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

              const SizedBox(height: 14),

              /* =================================================
                 POINT 3 — PURCHASE WITHIN PS
              ================================================= */

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,

                    children: [
                      const Text(
                        'Point 3 — Place of Purchase Falls Within This PS Limits?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 14),

                      yesNoButtons(
                        value: purchaseWithinPs,

                        onChanged: (value) {
                          setState(() {
                            purchaseWithinPs =
                                value;
                          });
                        },
                      ),

                      if (purchaseWithinPs ==
                          'NO') ...[
                        const SizedBox(
                            height: 14),

                        Container(
                          padding:
                              const EdgeInsets
                                  .all(12),

                          decoration:
                              BoxDecoration(
                            color: const Color(
                                0xFFEFF6FF),
                            borderRadius:
                                BorderRadius
                                    .circular(10),
                          ),

                          child: const Text(
                            'Purchase location is outside this Police Station limits. This NO does not require mandatory NO-type remarks.',
                            style: TextStyle(
                              color:
                                  Color(
                                      0xFF1D4ED8),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              /* =================================================
                 POINT 4 — HEIGHT / WIDTH / MATERIAL
              ================================================= */

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,

                    children: [
                      const Text(
                        'Point 4 — Idol Height and Material Verified?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 14),

                      yesNoButtons(
                        value:
                            dimensionsVerified,

                        onChanged: (value) {
                          setState(() {
                            dimensionsVerified =
                                value;
                          });
                        },
                      ),

                      if (dimensionsVerified ==
                          'YES') ...[
                        const SizedBox(
                            height: 20),

                        /* =========================================
                           AR MEASUREMENT
                        ========================================= */

                        Container(
                          padding:
                              const EdgeInsets
                                  .all(16),

                          decoration:
                              BoxDecoration(
                            color: const Color(
                                0xFFEFF6FF),
                            borderRadius:
                                BorderRadius
                                    .circular(12),
                            border: Border.all(
                              color: const Color(
                                  0xFFBFDBFE),
                            ),
                          ),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .stretch,

                            children: [
                              const Text(
                                'Idol Height Measurement',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight:
                                      FontWeight.bold,
                                  color:
                                      Color(
                                          0xFF17365D),
                                ),
                              ),

                              const SizedBox(
                                  height: 5),

                              const Text(
                                'Choose automatic AR measurement or enter the height manually.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color:
                                      Color(
                                          0xFF475569),
                                ),
                              ),

                              const SizedBox(
                                  height: 14),

                              FilledButton.icon(
                                onPressed: () {
                                  openDigitalMeasurement(
                                    'HEIGHT',
                                  );
                                },
                                icon: const Icon(
                                  Icons.height,
                                ),
                                label: const Text(
                                  'Measure Height Digitally',
                                ),
                              ),

                              const SizedBox(
                                  height: 10),

                              OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    heightMeasurementMethod =
                                        'MANUAL';
                                    heightEvidenceImagePath = null;
                                    heightMeasuredAt = null;
                                  });
                                  heightController.selection =
                                      TextSelection.collapsed(
                                    offset:
                                        heightController.text.length,
                                  );
                                },
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Enter Height Manually'),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                            height: 18),

                        /* HEIGHT */

                        TextField(
                          controller:
                              heightController,

                          onChanged: (_) {
                            if (heightMeasurementMethod !=
                                'MANUAL') {
                              setState(() {
                                heightMeasurementMethod =
                                    'MANUAL';
                                heightEvidenceImagePath = null;
                                heightMeasuredAt = null;
                              });
                            } else {
                              setState(() {});
                            }
                          },

                          keyboardType:
                              const TextInputType
                                  .numberWithOptions(
                            decimal: true,
                          ),

                          decoration:
                              InputDecoration(
                            labelText:
                                'Measured Height (ft.) *',

                            hintText:
                              'Enter height in feet',

                            border:
                                const OutlineInputBorder(),

                            suffixIcon:
                                heightMeasurementMethod ==
                                        'AR_3D_HIT_TEST'
                                    ? const Icon(
                                        Icons
                                            .verified,
                                        color: Colors
                                            .green,
                                      )
                                    : null,
                          ),
                        ),

                        if (heightMeasurementMethod
                            .isNotEmpty) ...[
                          const SizedBox(
                              height: 5),

                          Text(
                            'Measurement Method: $heightMeasurementMethod',
                            style:
                                const TextStyle(
                              fontSize: 12,
                              color: Color(
                                  0xFF64748B),
                            ),
                          ),
                        ],

                        if (widget.declaredHeightFeet != null &&
                          double.tryParse(heightController.text) !=
                            null) ...[
                          const SizedBox(height: 8),

                          Builder(
                            builder: (context) {
                              final measuredHeight =
                                  double.parse(heightController.text);
                              final declaredHeight =
                                  widget.declaredHeightFeet!;
                              final matches = declaredHeight > 0 &&
                                  (measuredHeight - declaredHeight).abs() /
                                          declaredHeight <=
                                      0.10;

                              return Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: matches
                                      ? const Color(0xFFDCFCE7)
                                      : const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  matches
                                      ? 'Height matches the declared height: '
                                          '${measuredHeight.toStringAsFixed(2)} ft'
                                      : 'Height does not match the declared height. '
                                          'Declared: ${declaredHeight.toStringAsFixed(2)} ft, '
                                          'Measured: ${measuredHeight.toStringAsFixed(2)} ft',
                                  style: TextStyle(
                                    color: matches
                                        ? Colors.green.shade800
                                        : Colors.red.shade800,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],

                        const SizedBox(
                            height: 16),

                        /* MATERIAL */

                        DropdownButtonFormField<
                            String>(
                          initialValue:
                              material.isEmpty
                                  ? null
                                  : material,

                          decoration:
                              const InputDecoration(
                            labelText:
                                'Material *',
                            border:
                                OutlineInputBorder(),
                          ),

                          items: const [
                            DropdownMenuItem(
                              value: 'CLAY',
                              child:
                                  Text('Clay'),
                            ),

                            DropdownMenuItem(
                              value: 'POP',
                              child:
                                  Text('POP'),
                            ),
                          ],

                          onChanged: (value) {
                            setState(() {
                              material =
                                  value ?? '';
                            });
                          },
                        ),

                        const SizedBox(
                            height: 18),

                        /* =========================================
                           MEASUREMENT EVIDENCE
                        ========================================= */

                        Container(
                          padding:
                              const EdgeInsets
                                  .all(14),

                          decoration:
                              BoxDecoration(
                            color: const Color(
                                0xFFF8FAFC),
                            borderRadius:
                                BorderRadius
                                    .circular(10),
                            border: Border.all(
                              color: const Color(
                                  0xFFE2E8F0),
                            ),
                          ),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .stretch,

                            children: [
                              const Text(
                                'Measurement Evidence',
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 12),

                              if (heightEvidenceImagePath !=
                                  null) ...[
                                const Text(
                                  'Height Evidence',
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                ClipRRect(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              10),

                                  child: Image.file(
                                    File(
                                      heightEvidenceImagePath!,
                                    ),

                                    height: 220,
                                    width:
                                        double.infinity,
                                    fit:
                                        BoxFit.cover,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  'Height: ${heightController.text} ft',
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),

                                Text(
                                  'Method: ${heightMeasurementMethod.isEmpty ? '-' : heightMeasurementMethod}',
                                ),

                                Text(
                                  'GPS: '
                                  '${heightLatitude?.toStringAsFixed(6) ?? '-'}, '
                                  '${heightLongitude?.toStringAsFixed(6) ?? '-'}',
                                ),

                                Text(
                                  'GPS Accuracy: '
                                  '${heightGpsAccuracy == null ? '-' : '±${heightGpsAccuracy!.toStringAsFixed(1)} m'}',
                                ),

                                Text(
                                  'Measured At: '
                                  '${heightMeasuredAt?.toLocal().toString() ?? '-'}',
                                ),

                                const SizedBox(height: 18),
                              ],

                              if (heightEvidenceImagePath ==
                                  null)
                                const Text(
                                  'No automatic AR measurement evidence captured yet.',
                                  style: TextStyle(
                                    color:
                                        Color(
                                            0xFF64748B),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],

                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            /* ERROR */

            if (errorMessage.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.all(12),

                margin:
                    const EdgeInsets.only(
                  bottom: 12,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      const Color(0xFFFEE2E2),

                  borderRadius:
                      BorderRadius.circular(
                          10),
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

            /* SUCCESS */

            if (successMessage.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.all(12),

                margin:
                    const EdgeInsets.only(
                  bottom: 12,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      const Color(0xFFDCFCE7),

                  borderRadius:
                      BorderRadius.circular(
                          10),
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

            /* SAVE */

            FilledButton.icon(
              onPressed:
                  saveVerification,

              icon: const Icon(
                Icons.save_outlined,
              ),

              label: const Text(
                'Save Idol Verification',
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}