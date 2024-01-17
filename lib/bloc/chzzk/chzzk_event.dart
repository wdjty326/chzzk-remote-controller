import 'package:flutter/material.dart';

@immutable
abstract class ChzzkEvent {}

/// 액세스토큰을 가져올때 이벤트
class ChzzkAccessTokenEvent extends ChzzkEvent {
  final String channelId;

  ChzzkAccessTokenEvent(this.channelId);
}
