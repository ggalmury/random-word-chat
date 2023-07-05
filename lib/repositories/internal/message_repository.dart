import 'package:random_word_chat/repositories/db_provider.dart';
import '../../models/external/message_dto.dart';
import '../../models/internal/message.dart';

class MessageRepository {
  final DbProvider _dbProvider = DbProvider();
  final String tableName = "message";

  Future<Message> insertMessage(MessageDto messageDto) async {
    final db = await _dbProvider.database;

    messageDto.time = DateTime.now().toString();
    int insertedId = await db.insert(tableName, messageDto.toJson());

    var result =
        await db.query(tableName, where: "id = ?", whereArgs: [insertedId]);

    return Message.fromJson(result[0]);
  }

  Future<List<Message>> selectMessagesByRoomId(String roomId) async {
    final db = await _dbProvider.database;

    var result = await db.query(tableName,
        where: "roomId = ?", whereArgs: [roomId], orderBy: 'id ASC');

    List<Message> messages = result.map((message) {
      return Message.fromJson(message);
    }).toList();

    return messages;
  }

  Future<Map<String, Message>> selectAllLastMessages() async {
    final db = await _dbProvider.database;

    var result = await db.query(tableName,
        groupBy: "roomId", orderBy: "createdDt DESC", limit: 1);

    Map<String, Message> lastMessageMap = {};

    for (var message in result) {
      String roomId = message['roomId'] as String;
      lastMessageMap[roomId] = message as Message;
    }

    return lastMessageMap;
  }
}
