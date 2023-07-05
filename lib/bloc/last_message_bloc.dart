import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:random_word_chat/models/external/message_dto.dart';
import 'package:random_word_chat/models/internal/message.dart';
import 'package:random_word_chat/repositories/internal/message_repository.dart';

class LastMessageBloc
    extends Bloc<DefaulLastMessageEvent, DefaultLastMessageState> {
  final MessageRepository _messageRepository;

  LastMessageBloc(this._messageRepository) : super(InitLastMessageState()) {
    on<DefaulLastMessageEvent>((event, emit) async {
      if (event is GetAllLastMessageEvent) {
        await _getAllLastMessageHandler(event, emit);
      } else if (event is UpdateLastMessageEvent) {
        await _updateLastMessageHandler(event, emit);
      }
    });
  }

  Future<void> _getAllLastMessageHandler(
      GetAllLastMessageEvent event, emit) async {
    Map<String, Message> newLastMessage =
        await _messageRepository.selectAllLastMessages();

    emit(CurrentLastMessageState(lastMessage: newLastMessage));
  }

  Future<void> _updateLastMessageHandler(
      UpdateLastMessageEvent event, emit) async {
    MessageDto messageDto = event.messageDto;
    print("updateDto: ${messageDto.message}");
    Message insertedMessage =
        await _messageRepository.insertMessage(messageDto);
    print("updateMessage: ${insertedMessage.message}");
    Map<String, Message> copiedLastMessageMap = Map.from(state.lastMessage);

    copiedLastMessageMap[insertedMessage.roomId] = insertedMessage;
    print(
        "mapMessage: ${copiedLastMessageMap[insertedMessage.roomId]?.message}");
    emit(CurrentLastMessageState(lastMessage: copiedLastMessageMap));
  }
}

// event
abstract class DefaulLastMessageEvent extends Equatable {}

class UpdateLastMessageEvent extends DefaulLastMessageEvent {
  final MessageDto messageDto;

  UpdateLastMessageEvent({required this.messageDto});

  @override
  List<Object> get props => [messageDto];
}

class GetAllLastMessageEvent extends DefaulLastMessageEvent {
  GetAllLastMessageEvent();

  @override
  List<Object> get props => [];
}

// state
abstract class DefaultLastMessageState extends Equatable {
  final Map<String, Message> lastMessage;

  const DefaultLastMessageState({required this.lastMessage});
}

class InitLastMessageState extends DefaultLastMessageState {
  InitLastMessageState() : super(lastMessage: {});

  @override
  List<Object> get props => [lastMessage];
}

class CurrentLastMessageState extends DefaultLastMessageState {
  const CurrentLastMessageState({required super.lastMessage});

  @override
  List<Object> get props => [lastMessage];
}
