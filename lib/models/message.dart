class Message {
  final String type;
  final String roomId;
  final String sender;
  final String message;

  Message({
    required this.type,
    required this.roomId,
    required this.sender,
    required this.message,
  });

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
    );
  }
}
