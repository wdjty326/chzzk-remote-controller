import 'dart:convert';

import 'package:chzzk_remote_controller/models/chzzk_model.dart';
import 'package:http/http.dart' as Http;

const APIBase = 'https://api.chzzk.naver.com';
const APIBaseCommon = 'https://comm-api.game.naver.com';

class ChzzkRepository {
  Future<ChzzkAPICommonModel<ChzzkLiveDetail?>> getLiveDetail(
      String channel) async {
    Http.Response response = await Http.get(
        Uri.parse('$APIBase/service/v2/channels/$channel/live-detail'),
        headers: {
          'Accept': 'application/json, text/plain, */*',
          'Origin': 'https://chzzk.naver.com',
          'Referer': 'https://chzzk.naver.com/live/$channel',
        });

    return ChzzkAPICommonModel.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)),
        (p0) => p0 != null ? ChzzkLiveDetail.fromJson(Map.from(p0)) : null);
  }

  Future<ChzzkAPICommonModel<ChzzkAccessToken?>> getChatAccessToken(
      String channel, String chatChannelId, String chatType) async {
    Http.Response response = await Http.get(
        Uri.parse(
            '$APIBaseCommon/nng_main/v1/chats/access-token?channelId=$chatChannelId&chatType=$chatType'),
        headers: {
          'Accept': 'application/json, text/plain, */*',
          'Origin': 'https://chzzk.naver.com',
          'Referer': 'https://chzzk.naver.com/live/$channel',
        });

    return ChzzkAPICommonModel.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)),
        (p0) => p0 != null ? ChzzkAccessToken.fromJson(Map.from(p0)) : null);
  }
}
