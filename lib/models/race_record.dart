class RaceRecord {
  final String raceId;
  final String raceName;
  final String raceDate;
  final String raceTime;
  final String raceLocation;
  final String raceLaps;
  final String warnings;
  final String averageSpeed;

  RaceRecord(
    this.warnings,
    this.averageSpeed, {
    required this.raceId,
    required this.raceName,
    required this.raceDate,
    required this.raceTime,
    required this.raceLocation,
    required this.raceLaps,
  });
}
