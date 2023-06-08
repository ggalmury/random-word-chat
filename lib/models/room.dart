class Room {
  final String roomId;
  final String? roomName;
  final List<dynamic>? sessions;

  Room({required this.roomId, this.roomName, this.sessions});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
        roomId: json["roomId"],
        roomName: json["roomName"],
        sessions: json["sessions"]);
  }
}
