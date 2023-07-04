import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:random_word_chat/models/external/message_dto.dart';
import 'package:random_word_chat/models/internal/message.dart';
import 'package:random_word_chat/repositories/internal/message_repository.dart';

class LastMessageBloc
    extends Bloc<DefaulLastMessageEvent, DefaultLastMessageState> {
  final MessageRepository _messageRepository;

  LastMessageBloc(this._messageRepository) : super(InitLastMessageState()) {
    on<DefaulLastMessageEvent>((event, emit) {
      if (event is GetAllLastMessageEvent) {
        _getAllLastMessageHandler(event, emit);
      }
      if (event is UpdateLastMessageEvent) {
        _updateLastMessageHandler(event, emit);
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
    Message insertedMessage =
        await _messageRepository.insertMessage(messageDto);

    Map<String, Message> lastMessageState = state.lastMessage;

    lastMessageState[insertedMessage.roomId] = insertedMessage;

    emit(CurrentLastMessageState(lastMessage: lastMessageState));
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
