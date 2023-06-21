import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:random_word_chat/models/external/room_dto.dart';
import 'package:random_word_chat/models/internal/room.dart';
import 'package:random_word_chat/repositories/internal/room_repository.dart';

class RoomBloc extends Bloc<DefaultRoomEvent, DefaultRoomState> {
  final RoomRepository _roomRepository;

  RoomBloc(this._roomRepository) : super(InitRoomState()) {
    on<DefaultRoomEvent>((event, emit) async {
      if (event is GetAllRoomsEvent) await _getAllRoomsHandler(event, emit);
      if (event is CreateRoomEvent) await _createRoomHandler(event, emit);
    });
  }

  Future<void> _getAllRoomsHandler(GetAllRoomsEvent event, emit) async {
    List<Room> roomList = await _roomRepository.selectAllRooms();

    emit(CurrentRoomState(roomList: roomList));
  }

  Future<void> _createRoomHandler(CreateRoomEvent event, emit) async {
    List<Room> roomList = state.roomList;
    Room createdRoom = await _roomRepository.insertRoom(event.roomDto);

    roomList.add(createdRoom);

    emit(CurrentRoomState(roomList: roomList));
  }
}

// room event
abstract class DefaultRoomEvent extends Equatable {}

class CreateRoomEvent extends DefaultRoomEvent {
  final RoomDto roomDto;

  CreateRoomEvent({required this.roomDto});

  @override
  List<Object> get props => [roomDto];
}

class GetAllRoomsEvent extends DefaultRoomEvent {
  GetAllRoomsEvent();

  @override
  List<Object> get props => [];
}

// room state
abstract class DefaultRoomState extends Equatable {
  final List<Room> roomList;

  const DefaultRoomState({required this.roomList});
}

class InitRoomState extends DefaultRoomState {
  InitRoomState() : super(roomList: []);

  @override
  List<Object> get props => [roomList];
}

class CurrentRoomState extends DefaultRoomState {
  const CurrentRoomState({required super.roomList});

  @override
  List<Object> get props => [roomList];
}
