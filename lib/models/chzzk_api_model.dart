class ChzzkAPICommonModel<T> {
  final int code;
  final String? message;
  final T content;

  ChzzkAPICommonModel({
    required this.code,
    required this.message,
    required this.content,
  });

  factory ChzzkAPICommonModel.fromJson(
      Map<String, dynamic> data, T Function(dynamic) toObject) {
    return ChzzkAPICommonModel(
        code: data['code'],
        message: data['message'],
        content: toObject(data['content']));
  }
}

class ChzzkLiveDetail {
  final int liveId;
  final String liveTitle;
  final String status;
  final String liveImageUrl;
  final String? defaultThumbnailImageUrl;
  final int concurrentUserCount;
  final int accumulateCount;
  final String openDate;
  final String? closeDate;
  final bool adult;
  final String chatChannelId;
  final String? categoryType;
  final String liveCategory;
  final String liveCategoryValue;
  final bool chatActive;
  final String chatAvailableGroup;
  final bool paidPromotion;
  final String chatAvailableCondition;
  final int minFollowerMinute;
  final String livePlaybackJson;
  final ChzzkChannelInfo channel;
  final String livePollingStatusJson;

  /// TODO::타입이 확실하지 않음
  final dynamic userAdultStatus;

  const ChzzkLiveDetail({
    required this.liveId,
    required this.liveTitle,
    required this.status,
    required this.liveImageUrl,
    this.defaultThumbnailImageUrl,
    required this.concurrentUserCount,
    required this.accumulateCount,
    required this.openDate,
    this.closeDate,
    required this.adult,
    required this.chatChannelId,
    required this.categoryType,
    required this.liveCategory,
    required this.liveCategoryValue,
    required this.chatActive,
    required this.chatAvailableGroup,
    required this.paidPromotion,
    required this.chatAvailableCondition,
    required this.minFollowerMinute,
    required this.livePlaybackJson,
    required this.channel,
    required this.livePollingStatusJson,
    this.userAdultStatus,
  });

  factory ChzzkLiveDetail.fromJson(Map<String, dynamic> data) {
    return ChzzkLiveDetail(
        liveId: data['liveId'],
        liveTitle: data['liveTitle'],
        status: data['status'],
        liveImageUrl: data['liveImageUrl'],
        defaultThumbnailImageUrl: data['defaultThumbnailImageUrl'],
        concurrentUserCount: data['concurrentUserCount'],
        accumulateCount: data['accumulateCount'],
        openDate: data['openDate'],
        closeDate: data['closeDate'],
        adult: data['adult'],
        chatChannelId: data['chatChannelId'],
        categoryType: data['categoryType'],
        liveCategory: data['liveCategory'],
        liveCategoryValue: data['liveCategoryValue'],
        chatActive: data['chatActive'],
        chatAvailableGroup: data['chatAvailableGroup'],
        paidPromotion: data['paidPromotion'],
        chatAvailableCondition: data['chatAvailableCondition'],
        minFollowerMinute: data['minFollowerMinute'],
        livePlaybackJson: data['livePlaybackJson'],
        channel: ChzzkChannelInfo.fromJson(data['channel']),
        livePollingStatusJson: data['livePollingStatusJson'],
        userAdultStatus: data['userAdultStatus']);
  }
}

class ChzzkChannelInfo {
  final String channelId;
  final String channelName;
  final String channelImageUrl;
  final bool verifiedMark;

  const ChzzkChannelInfo({
    required this.channelId,
    required this.channelName,
    required this.channelImageUrl,
    required this.verifiedMark,
  });

  factory ChzzkChannelInfo.fromJson(Map<String, dynamic> data) {
    return ChzzkChannelInfo(
        channelId: data['channelId'],
        channelName: data['channelName'],
        channelImageUrl: data['channelImageUrl'],
        verifiedMark: data['verifiedMark']);
  }
}

class ChzzkAccessToken {
  final String accessToken;
  final ChzzkTemporaryRestrict temporaryRestrict;
  final bool realNameAuth;
  final String extraToken;

  ChzzkAccessToken(
      {required this.accessToken,
      required this.temporaryRestrict,
      required this.realNameAuth,
      required this.extraToken});

  factory ChzzkAccessToken.fromJson(Map<String, dynamic> data) {
    return ChzzkAccessToken(
        accessToken: data['accessToken'],
        temporaryRestrict:
            ChzzkTemporaryRestrict.fromJson(data['temporaryRestrict']),
        extraToken: data['extraToken'],
        realNameAuth: data['realNameAuth']);
  }
}

class ChzzkTemporaryRestrict {
  final bool temporaryRestrict;
  final int times;
  final dynamic duration;
  final dynamic createdTime;

  ChzzkTemporaryRestrict({
    required this.temporaryRestrict,
    required this.times,
    this.duration,
    this.createdTime,
  });

  factory ChzzkTemporaryRestrict.fromJson(Map<String, dynamic> data) {
    return ChzzkTemporaryRestrict(
        temporaryRestrict: data['temporaryRestrict'],
        times: data['times'],
        createdTime: data['createdTime'],
        duration: data['duration']);
  }
}
