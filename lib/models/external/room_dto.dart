class RoomDto {
  final String roomId;
  final String? roomName;

  const RoomDto({required this.roomId, this.roomName});

  Map<String, dynamic> toJson() {
    return {"roomId": roomId, "roomName": roomName};
  }

  factory RoomDto.fromJson(Map<String, dynamic> json) {
    return RoomDto(
      roomId: json["roomId"],
      roomName: json["roomName"],
    );
  }
}
