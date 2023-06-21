class MessageDto {
  final String type;
  final String roomId;
  final String sender;
  final String message;

  MessageDto(
      {required this.type,
      required this.roomId,
      required this.sender,
      required this.message});

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'roomId': roomId,
      'sender': sender,
      'message': message,
    };
  }

  factory MessageDto.fromJson(Map<String, dynamic> json) {
    return MessageDto(
      type: json['type'],
      roomId: json['roomId'],
      sender: json['sender'],
      message: json['message'],
    );
  }
}
