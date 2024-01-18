import 'dart:convert';

import 'package:chzzk_remote_controller/bloc/chzzk/chzzk_event.dart';
import 'package:chzzk_remote_controller/bloc/chzzk/chzzk_state.dart';
import 'package:chzzk_remote_controller/models/chzzk_api_model.dart';
import 'package:chzzk_remote_controller/models/chzzk_chat_model.dart';
import 'package:chzzk_remote_controller/repository/chzzk_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChzzkBloc extends Bloc<ChzzkEvent, ChzzkState> {
  final ChzzkRepository chzzkRepository;

  WebSocketChannel? channel;

  ChzzkBloc(this.chzzkRepository) : super(ChzzkInitialized()) {
    on(getChzzkAccessToken);
    on(connectChatServer);
    on(disposeChatServer);
  }

  void getChzzkAccessToken(ChzzkAccessTokenEvent event, Emitter emit) async {
    emit(ChzzkLoading());

    ChzzkAPICommonModel<ChzzkLiveDetail?> resp0 =
        await chzzkRepository.getLiveDetail(event.channelId);
    if (resp0.content == null) {
      emit(ChzzkFailure(resp0.code, resp0.message));
      return;
    }

    ChzzkAPICommonModel<ChzzkAccessToken?> resp1 =
        await chzzkRepository.getChatAccessToken(
            event.channelId, resp0.content!.chatChannelId, 'STREAMING');
    if (resp1.content == null) {
      emit(ChzzkFailure(resp1.code, resp1.message));
      return;
    }

    emit(ChzzkAccessTokenState(
        resp1.content!.accessToken, resp0.content!.chatChannelId));
  }

  void connectChatServer(ChzzkChatConnectEvent event, Emitter emit) async {
    emit(ChzzkLoading());

    WebSocketChannel webSocketChannel = await chzzkRepository.connectChatServer(
        event.accessToken, event.chatChannelId);

    // webSocketChannel.stream.listen((message) async {
    //   ChatResponseModel response =
    //       ChatResponseModel.fromJson(jsonDecode(message));
    //   debugPrint('@debug data1 -> $message');

    //   try {
    //     switch (response.cmd) {
    //       /// pong
    //       case 0:
    //         webSocketChannel.sink.add(jsonEncode({
    //           'ver': '2',
    //           'cmd': 10000,
    //         }));
    //         break;
    //       case 100:
    //         break;

    //       case 93101:
    //       case 93102:
    //         ChatMessageResponseModel<List<ChatMessageDataModel>> data =
    //             ChatMessageResponseModel.fromJson(
    //                 jsonDecode(message),
    //                 (p0) => List.from(p0)
    //                     .map((e) => ChatMessageDataModel.fromJson(e))
    //                     .toList());
    //         // emit(ChzzkChatMessageState(data.bdy));
    //         break;

    //       /// 연결완료
    //       case 10100:
    //         debugPrint('@debug connect');
    //         // emit(ChzzkChatConnectState());
    //         break;
    //     }
    //   } catch (e) {
    //     debugPrint('@error->$e');
    //     debugPrint('@debug->$message');
    //     // emit(ChzzkFailure(-9999, ''));
    //   }
    // });

    webSocketChannel.sink.add(jsonEncode({
      'ver': '2',
      'cmd': 100,
      'svcid': 'game',
      'cid': event.chatChannelId,
      'bdy': {
        'uid': null,
        'devType': 2001,
        'accTkn': event.accessToken,
        'auth': 'READ'
      },
      'tid': 1,
    }));
    channel = webSocketChannel;

    await emit.forEach(webSocketChannel.stream, onData: (message) {
      ChatResponseModel response =
          ChatResponseModel.fromJson(jsonDecode(message));
      // debugPrint('@debug data -> $message');
      try {
        switch (response.cmd) {
          case 0:
            webSocketChannel.sink.add(jsonEncode({
              'ver': '2',
              'cmd': 10000,
            }));
            break;
          case 93101:
          case 93102:
            ChatMessageResponseModel<List<ChatMessageDataModel>> data =
                ChatMessageResponseModel.fromJson(
                    jsonDecode(message),
                    (p0) => List.from(p0)
                        .map((e) => ChatMessageDataModel.fromJson(e))
                        .toList());
            return ChzzkChatMessageState(data.bdy);
          case 10100:
            return ChzzkChatConnectState();
        }
      } catch (e) {
        debugPrint('@error->$e');
        debugPrint('@debug->$message');
        return ChzzkFailure(-9999, '');
      }

      return ChzzkWaiting();
    });
  }

  void disposeChatServer(ChzzkChatDisconnectEvent event, Emitter emit) async {
    emit(ChzzkLoading());
    try {
      if (channel != null) await channel!.sink.close();
      emit(ChzzkChatDisconnectState());
    } catch (e) {
      emit(ChzzkFailure(-9999));
    }
  }
}
