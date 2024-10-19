class Move {
  final String estimateId;
  final String userId;
  final String movingFrom;
  final String movingTo;
  final String movingOn;
  final String distance;
  final String propertySize;


  Move({
    required this.estimateId,
    required this.userId,
    required this.movingFrom,
    required this.movingTo,
    required this.movingOn,
    required this.distance,
    required this.propertySize,

  });

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(
      estimateId: json['estimate_id'],
      userId: json['user_id'],
      movingFrom: json['moving_from'],
      movingTo: json['moving_to'],
      movingOn: json['moving_on'],
      distance: json['distance'],
      propertySize: json['property_size'],

    );
  }
}
