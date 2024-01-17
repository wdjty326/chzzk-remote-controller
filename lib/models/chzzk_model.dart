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
      Map<String, dynamic> json, T Function(dynamic) toObject) {
    return ChzzkAPICommonModel(
        code: json['code'],
        message: json['message'],
        content: toObject(json['content']));
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

  factory ChzzkLiveDetail.fromJson(Map<String, dynamic> json) {
    return ChzzkLiveDetail(
        liveId: json['liveId'],
        liveTitle: json['liveTitle'],
        status: json['status'],
        liveImageUrl: json['liveImageUrl'],
        defaultThumbnailImageUrl: json['defaultThumbnailImageUrl'],
        concurrentUserCount: json['concurrentUserCount'],
        accumulateCount: json['accumulateCount'],
        openDate: json['openDate'],
        closeDate: json['closeDate'],
        adult: json['adult'],
        chatChannelId: json['chatChannelId'],
        categoryType: json['categoryType'],
        liveCategory: json['liveCategory'],
        liveCategoryValue: json['liveCategoryValue'],
        chatActive: json['chatActive'],
        chatAvailableGroup: json['chatAvailableGroup'],
        paidPromotion: json['paidPromotion'],
        chatAvailableCondition: json['chatAvailableCondition'],
        minFollowerMinute: json['minFollowerMinute'],
        livePlaybackJson: json['livePlaybackJson'],
        channel: ChzzkChannelInfo.fromJson(json['channel']),
        livePollingStatusJson: json['livePollingStatusJson'],
        userAdultStatus: json['userAdultStatus']);
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

  factory ChzzkChannelInfo.fromJson(Map<String, dynamic> json) {
    return ChzzkChannelInfo(
        channelId: json['channelId'],
        channelName: json['channelName'],
        channelImageUrl: json['channelImageUrl'],
        verifiedMark: json['verifiedMark']);
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

  factory ChzzkAccessToken.fromJson(Map<String, dynamic> json) {
    return ChzzkAccessToken(
        accessToken: json['accessToken'],
        temporaryRestrict:
            ChzzkTemporaryRestrict.fromJson(json['temporaryRestrict']),
        extraToken: json['extraToken'],
        realNameAuth: json['realNameAuth']);
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

  factory ChzzkTemporaryRestrict.fromJson(Map<String, dynamic> json) {
    return ChzzkTemporaryRestrict(
        temporaryRestrict: json['temporaryRestrict'],
        times: json['times'],
        createdTime: json['createdTime'],
        duration: json['duration']);
  }
}
