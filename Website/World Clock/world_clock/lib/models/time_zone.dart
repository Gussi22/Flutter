class TimeZone {
  final String name;
  final Duration offset;

  TimeZone({required this.name, required this.offset});

  @override
  String toString() {
    return name;
  }

  Duration toDuration() {
    return offset;
  }
}
