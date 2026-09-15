import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
class LocationVerificationScreen extends StatefulWidget {
  final String applicationId;

  const LocationVerificationScreen({
    super.key,
    required this.applicationId,
  });

  @override
  State<LocationVerificationScreen> createState() =>
      _LocationVerificationScreenState();
}

class _LocationVerificationScreenState
    extends State<LocationVerificationScreen> {
  String locationVerified = '';
  String locationChanged = '';
  String samePoliceStation = '';
  String sector = '';
  String commissionerate = '';
  String policeStation = '';

  String sensitivityCompleted = '';
  String sensitivity = '';

  String remarks = '';

  double? latitude;
  double? longitude;
  double? gpsAccuracy;

  bool gpsLoading = false;

  String errorMessage = '';
  String successMessage = '';

  Future<void> captureLocation() async {
    if (gpsLoading || !mounted) {
      return;
    }

    setState(() {
      gpsLoading = true;
      errorMessage = '';
      successMessage = '';
    });

    try {
      bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) {
          return;
        }

        setState(() {
          errorMessage =
              'Location services are disabled. Please enable GPS.';
          gpsLoading = false;
        });

        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (!mounted) {
        return;
      }

      if (permission == LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
      }

      if (!mounted) {
        return;
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          errorMessage =
              'Location permission was denied.';
          gpsLoading = false;
        });

        return;
      }

      if (permission ==
          LocationPermission.deniedForever) {
        setState(() {
          errorMessage =
              'Location permission is permanently denied. Please enable it from device settings.';
          gpsLoading = false;
        });

        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        gpsAccuracy = position.accuracy;

        successMessage =
            'Current location captured successfully.';

        gpsLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        errorMessage =
            'Unable to capture GPS location.';
        gpsLoading = false;
      });
    }
  }

  void saveVerification() {
    setState(() {
      errorMessage = '';
      successMessage = '';
    });

    if (locationVerified.isEmpty) {
      setState(() {
        errorMessage =
            'Please answer: Location Verified?';
      });
      return;
    }

    if (locationVerified == 'NO') {
      if (remarks.trim().isEmpty) {
        setState(() {
          errorMessage =
              'Reason / Remarks are mandatory when Location Verified is NO.';
        });
        return;
      }

      setState(() {
        successMessage =
            'Saved as Location Not Verified and marked for NO / Pending monitoring.';
      });

      return;
    }

    if (locationChanged.isEmpty) {
      setState(() {
        errorMessage =
            'Please answer: Location Changed?';
      });
      return;
    }

    if (locationChanged == 'NO') {
      if (sector.isEmpty) {
        setState(() {
          errorMessage =
              'Please select Sector Number.';
        });
        return;
      }
    }

    if (locationChanged == 'YES') {
      if (samePoliceStation.isEmpty) {
        setState(() {
          errorMessage =
              'Please answer whether the new location falls under this Police Station.';
        });
        return;
      }

      if (samePoliceStation == 'YES') {
        if (sector.isEmpty) {
          setState(() {
            errorMessage =
                'Please select Sector Number.';
          });
          return;
        }

        if (latitude == null ||
            longitude == null) {
          setState(() {
            errorMessage =
                'New geo-mapping is mandatory when the location has changed within the same Police Station.';
          });
          return;
        }
      }

      if (samePoliceStation == 'NO') {
        if (commissionerate.isEmpty) {
          setState(() {
            errorMessage =
                'Please select Commissionerate.';
          });
          return;
        }

        if (policeStation.isEmpty) {
          setState(() {
            errorMessage =
                'Please select Police Station.';
          });
          return;
        }
      }
    }

    if (sensitivityCompleted.isEmpty) {
      setState(() {
        errorMessage =
            'Please answer: Assessment of Sensitivity of the Location Completed?';
      });
      return;
    }

    if (sensitivityCompleted == 'YES' &&
        sensitivity.isEmpty) {
      setState(() {
        errorMessage =
            'Please select Sensitivity Category.';
      });
      return;
    }

    if (sensitivityCompleted == 'NO' &&
        remarks.trim().isEmpty) {
      setState(() {
        errorMessage =
            'Reason / Remarks are mandatory when sensitivity assessment is not completed.';
      });
      return;
    }

    setState(() {
      successMessage =
          'Location-Based Verification saved successfully.';
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
            const Text('Location-Based Verification'),
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
                      'Point 1 — Location Verified?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    yesNoButtons(
                      value: locationVerified,
                      onChanged: (value) {
                        setState(() {
                          locationVerified = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            if (locationVerified == 'NO') ...[
              const SizedBox(height: 14),
              Card(
                color: const Color(0xFFFFF1F2),
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'NO-type Reason / Remarks *',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 8),
                      const Text(
                        'This case will be included in NO / Pending analytics.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            if (locationVerified == 'YES') ...[
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
                        'Point 2 — Location Changed?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      yesNoButtons(
                        value: locationChanged,
                        onChanged: (value) {
                          setState(() {
                            locationChanged =
                                value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              if (locationChanged == 'NO') ...[
                const SizedBox(height: 14),

                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(16),
                    child: DropdownButtonFormField<
                        String>(
                      initialValue:
                          sector.isEmpty
                              ? null
                              : sector,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Sector Number *',
                        border:
                            OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: '01',
                          child:
                              Text('Sector 01'),
                        ),
                        DropdownMenuItem(
                          value: '02',
                          child:
                              Text('Sector 02'),
                        ),
                        DropdownMenuItem(
                          value: '03',
                          child:
                              Text('Sector 03'),
                        ),
                        DropdownMenuItem(
                          value: '04',
                          child:
                              Text('Sector 04'),
                        ),
                        DropdownMenuItem(
                          value: '05',
                          child:
                              Text('Sector 05'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          sector = value ?? '';
                        });
                      },
                    ),
                  ),
                ),
              ],

              if (locationChanged == 'YES') ...[
                const SizedBox(height: 14),

                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .stretch,
                      children: [
                        const Text(
                          'New Location Falls Under This Police Station?',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 14),
                        yesNoButtons(
                          value:
                              samePoliceStation,
                          onChanged: (value) {
                            setState(() {
                              samePoliceStation =
                                  value;
                            });
                          },
                        ),

                        if (samePoliceStation ==
                            'YES') ...[
                          const SizedBox(
                              height: 18),

                          DropdownButtonFormField<
                              String>(
                            initialValue:
                                sector.isEmpty
                                    ? null
                                    : sector,
                            decoration:
                                const InputDecoration(
                              labelText:
                                  'Sector Number *',
                              border:
                                  OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: '01',
                                child: Text(
                                    'Sector 01'),
                              ),
                              DropdownMenuItem(
                                value: '02',
                                child: Text(
                                    'Sector 02'),
                              ),
                              DropdownMenuItem(
                                value: '03',
                                child: Text(
                                    'Sector 03'),
                              ),
                              DropdownMenuItem(
                                value: '04',
                                child: Text(
                                    'Sector 04'),
                              ),
                              DropdownMenuItem(
                                value: '05',
                                child: Text(
                                    'Sector 05'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                sector =
                                    value ?? '';
                              });
                            },
                          ),

                          const SizedBox(
                              height: 18),

                          FilledButton.icon(
                            onPressed: gpsLoading
                                ? null
                                : captureLocation,
                            icon: const Icon(
                                Icons.my_location),
                            label: Text(
                              gpsLoading
                                  ? 'Capturing GPS...'
                                  : 'Capture New Geo-Location',
                            ),
                          ),

                          if (latitude != null &&
                              longitude != null) ...[
                            const SizedBox(
                                height: 12),

                            Container(
                              padding:
                                  const EdgeInsets
                                      .all(12),
                              decoration:
                                  BoxDecoration(
                                color:
                                    const Color(
                                        0xFFEFF6FF),
                                borderRadius:
                                    BorderRadius
                                        .circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                      'Latitude: $latitude'),
                                  Text(
                                      'Longitude: $longitude'),
                                  Text(
                                    'GPS Accuracy: ${gpsAccuracy?.toStringAsFixed(1)} metres',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],

                        if (samePoliceStation ==
                            'NO') ...[
                          const SizedBox(
                              height: 18),

                          DropdownButtonFormField<
                              String>(
                            initialValue:
                                commissionerate
                                        .isEmpty
                                    ? null
                                    : commissionerate,
                            decoration:
                                const InputDecoration(
                              labelText:
                                  'Commissionerate *',
                              border:
                                  OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value:
                                    'Hyderabad',
                                child: Text(
                                    'Hyderabad'),
                              ),
                              DropdownMenuItem(
                                value:
                                    'Cyberabad',
                                child: Text(
                                    'Cyberabad'),
                              ),
                              DropdownMenuItem(
                                value:
                                    'Rachakonda',
                                child: Text(
                                    'Rachakonda'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                commissionerate =
                                    value ?? '';
                              });
                            },
                          ),

                          const SizedBox(
                              height: 16),

                          DropdownButtonFormField<
                              String>(
                            initialValue:
                                policeStation
                                        .isEmpty
                                    ? null
                                    : policeStation,
                            decoration:
                                const InputDecoration(
                              labelText:
                                  'Police Station *',
                              border:
                                  OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value:
                                    'Demo PS 1',
                                child:
                                    Text('Demo PS 1'),
                              ),
                              DropdownMenuItem(
                                value:
                                    'Demo PS 2',
                                child:
                                    Text('Demo PS 2'),
                              ),
                              DropdownMenuItem(
                                value:
                                    'Demo PS 3',
                                child:
                                    Text('Demo PS 3'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                policeStation =
                                    value ?? '';
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],

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
                        'Point 3 — Assessment of Sensitivity of the Location Completed?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 14),

                      yesNoButtons(
                        value:
                            sensitivityCompleted,
                        onChanged: (value) {
                          setState(() {
                            sensitivityCompleted =
                                value;
                          });
                        },
                      ),

                      if (sensitivityCompleted ==
                          'YES') ...[
                        const SizedBox(
                            height: 18),

                        DropdownButtonFormField<
                            String>(
                          initialValue:
                              sensitivity.isEmpty
                                  ? null
                                  : sensitivity,
                          decoration:
                              const InputDecoration(
                            labelText:
                                'Sensitivity Category *',
                            border:
                                OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'NORMAL',
                              child:
                                  Text('Normal'),
                            ),
                            DropdownMenuItem(
                              value: 'SENSITIVE',
                              child:
                                  Text('Sensitive'),
                            ),
                            DropdownMenuItem(
                              value:
                                  'HYPER_SENSITIVE',
                              child: Text(
                                  'Hyper Sensitive'),
                            ),
                            DropdownMenuItem(
                              value: 'CRITICAL',
                              child:
                                  Text('Critical'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              sensitivity =
                                  value ?? '';
                            });
                          },
                        ),
                      ],

                      if (sensitivityCompleted ==
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
                'Save Location Verification',
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}