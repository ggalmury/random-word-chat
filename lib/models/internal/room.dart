import 'package:equatable/equatable.dart';

class Room extends Equatable {
  final int id;
  final String roomId;
  final DateTime time;
  final String userName;
  final String? roomName;

  const Room(
      {required this.id,
      required this.roomId,
      required this.time,
      required this.userName,
      this.roomName});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json["id"],
      roomId: json["roomId"],
      time: json["time"],
      userName: json["userName"],
      roomName: json["roomName"],
    );
  }

  @override
  List<Object> get props => [roomId];
}