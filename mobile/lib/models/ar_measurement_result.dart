class ArMeasurementResult {
  final double valueFeet;
  final double valueMeters;

  final double startX;
  final double startY;
  final double startZ;

  final double endX;
  final double endY;
  final double endZ;

  final double? latitude;
  final double? longitude;
  final double? gpsAccuracy;

  final double? standingDistanceMeters;

  final DateTime measuredAt;

  final String measurementType;
  final String measurementMethod;

  final String? evidenceImagePath;

  const ArMeasurementResult({
    required this.valueFeet,
    required this.valueMeters,
    required this.startX,
    required this.startY,
    required this.startZ,
    required this.endX,
    required this.endY,
    required this.endZ,
    this.latitude,
    this.longitude,
    this.gpsAccuracy,
    this.standingDistanceMeters,
    required this.measuredAt,
    required this.measurementType,
    required this.measurementMethod,
    this.evidenceImagePath,
  });
}