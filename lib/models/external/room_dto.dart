class RoomDto {
  final String roomId;
  final String? roomName;
  String? userName;

  RoomDto({required this.roomId, this.roomName, this.userName});

  Map<String, dynamic> toJson() {
    return {"roomId": roomId, "roomName": roomName, "userName": userName};
  }

  factory RoomDto.fromJson(Map<String, dynamic> json) {
    return RoomDto(
        roomId: json["roomId"],
        roomName: json["roomName"],
        userName: json["userName"]);
  }
}
