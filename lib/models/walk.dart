class Walk {
  final int? id;
  final DateTime date;
  final double distanceMeters;

  Walk({this.id, required this.date, required this.distanceMeters});

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date.toIso8601String(),
    'distanceMeters': distanceMeters,
  };

  factory Walk.fromMap(Map<String, dynamic> map) => Walk(
    id: map['id'],
    date: DateTime.parse(map['date']),
    distanceMeters: map['distanceMeters'],
  );
}
