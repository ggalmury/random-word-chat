import 'dart:convert';
import 'package:random_word_chat/models/external/room_dto.dart';
import 'package:http/http.dart' as http;

class RoomApi {
  final String serverURL = "http://43.200.100.168:8080";

  Future<RoomDto> fetchRoomCreate(String roomName) async {
    final response = await http.post(Uri.parse("$serverURL/api/chat/create"),
        body: <String, String>{"name": roomName});

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);

      RoomDto roomDto = RoomDto.fromJson(responseData);

      return roomDto;
    } else {
      throw Exception("Failed to create room");
    }
  }

  Future<RoomDto> fetchRoomJoin(String roomId) async {
    final response =
        await http.get(Uri.parse("$serverURL/api/chat/enter/$roomId"));

    if (response.statusCode == 202) {
      final responseData = jsonDecode(response.body);
      final enterRoom = responseData["enter_room"];

      RoomDto roomDto = RoomDto.fromJson(enterRoom);

      return roomDto;
    } else {
      throw Exception("Failed to create room");
    }
  }

  // Future<List<RoomDto>> fetchRoomList() async {
  //   final response = await http.get(Uri.parse("$serverURL/api/chat/all"));

  //   if (response.statusCode == 202) {
  //     final responseData = jsonDecode(response.body) as List<dynamic>;

  //     List<RoomDto> rooms = responseData.map((room) {
  //       return RoomDto.fromJson(room);
  //     }).toList();

  //     return rooms;
  //   } else {
  //     throw Exception("Failed to fetch room list");
  //   }
  // }
}
