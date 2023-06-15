class Message {
  final String type;
  final String roomId;
  final String sender;
  final String message;
  final DateTime? time;

  Message(
      {required this.type,
      required this.roomId,
      required this.sender,
      required this.message,
      this.time});

  Map<String, String> toJson() {
    return {
      'type': type,
      'roomId': roomId,
      'sender': sender,
      'message': message,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      type: json['type'],
      roomId: json['roomId'],
      sender: json['sender'],
      message: json['message'],
      time: json['time'],
    );
  }
}
