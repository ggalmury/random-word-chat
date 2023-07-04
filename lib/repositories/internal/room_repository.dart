import 'package:random_word_chat/models/external/room_dto.dart';
import 'package:random_word_chat/models/internal/room.dart';
import 'package:random_word_chat/repositories/db_provider.dart';

class RoomRepository {
  final DbProvider _dbProvider = DbProvider();
  final String tableName = "room";

  Future<Room> insertRoom(RoomDto roomDto) async {
    final db = await _dbProvider.database;

    int insertedId = await db.insert(tableName, roomDto.toJson());

    var result =
        await db.query(tableName, where: "id = ?", whereArgs: [insertedId]);

    return Room.fromJson(result[0]);
  }

  Future<List<Room>> selectAllRooms() async {
    final db = await _dbProvider.database;

    var result = await db.query(tableName);

    List<Room> rooms = result.map((room) {
      return Room.fromJson(room);
    }).toList();

    return rooms;
  }
}
