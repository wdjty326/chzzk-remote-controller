import 'package:chzzk_remote_controller/models/chzzk_chat_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ChzzkState {}

class ChzzkInitialized extends ChzzkState {}

class ChzzkLoading extends ChzzkState {}

class ChzzkWaiting extends ChzzkState {}

class ChzzkFailure extends ChzzkState {
  final int code;
  final String? message;

  ChzzkFailure(this.code, [this.message]);
}

/// 액세스토큰을 가져올때 상태
class ChzzkAccessTokenState extends ChzzkState {
  final String accessToken;
  final String chatChannelId;

  ChzzkAccessTokenState(this.accessToken, this.chatChannelId);
}

class ChzzkChatConnectState extends ChzzkState {}

class ChzzkChatMessageState extends ChzzkState {
  final List<ChatMessageDataModel> list;

  ChzzkChatMessageState(this.list);
}

class ChzzkChatDisconnectState extends ChzzkState {}
