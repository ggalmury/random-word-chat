import 'dart:convert';
import 'package:random_word_chat/models/room.dart';
import 'package:http/http.dart' as http;

class RoomRepository {
  final String serverURL = "http://43.200.100.168:8080";

  Future<Room> fetchRoomId(String roomName) async {
    final response = await http.post(Uri.parse("$serverURL/api/chat/create"),
        body: <String, String>{"name": roomName});

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);

      Room room = Room.fromJson(responseData);

      return room;
    } else {
      throw Exception("Failed to create room");
    }
  }
}
