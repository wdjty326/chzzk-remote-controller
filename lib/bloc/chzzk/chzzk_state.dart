import 'package:flutter/material.dart';

@immutable
abstract class ChzzkState {}

class ChzzkInitialized extends ChzzkState {}

class ChzzkLoading extends ChzzkState {}

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
