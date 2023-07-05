class MessageDto {
  final String type;
  final String roomId;
  final String sender;
  final String message;
  String? time;

  MessageDto(
      {required this.type,
      required this.roomId,
      required this.sender,
      required this.message,
      this.time});

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'roomId': roomId,
      'sender': sender,
      'message': message,
      'time': time
    };
  }

  factory MessageDto.fromJson(Map<String, dynamic> json) {
    return MessageDto(
        type: json['type'],
        roomId: json['roomId'],
        sender: json['sender'],
        message: json['message'],
        time: json['time']);
  }
}
