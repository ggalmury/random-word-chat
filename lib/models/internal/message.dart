import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final int id;
  final String type;
  final String roomId;
  final String sender;
  final String message;
  final String time;

  const Message(
      {required this.id,
      required this.type,
      required this.roomId,
      required this.sender,
      required this.message,
      required this.time});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'type': type,
      'roomId': roomId,
      'sender': sender,
      'message': message,
      "createdDt": time
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        id: json["id"],
        type: json['type'],
        roomId: json['roomId'],
        sender: json['sender'],
        message: json['message'],
        time: json['time']);
  }

  @override
  List<Object> get props => [roomId];
}
