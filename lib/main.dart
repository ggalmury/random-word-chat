import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:random_word_chat/bloc/last_message_bloc.dart';
import 'package:random_word_chat/bloc/room_bloc.dart';
import 'package:random_word_chat/repositories/internal/message_repository.dart';
import 'package:random_word_chat/repositories/internal/room_repository.dart';
import 'package:random_word_chat/screens/room_list.dart';

var logger = Logger(
  printer: PrettyPrinter(lineLength: 60, colors: true),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(lineLength: 60, methodCount: 0),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => RoomRepository()),
          RepositoryProvider(create: (context) => MessageRepository())
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) =>
                      RoomBloc(context.read<RoomRepository>())),
              BlocProvider(
                  create: (context) =>
                      LastMessageBloc(context.read<MessageRepository>()))
            ],
            child: MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                    fontFamily: "KBO",
                    scaffoldBackgroundColor: Colors.white,
                    appBarTheme: const AppBarTheme(
                      systemOverlayStyle: SystemUiOverlayStyle.dark,
                      elevation: 0,
                      foregroundColor: Colors.black,
                    )),
                home: const RoomList())));
  }
}
