import 'dart:convert';

class ChatResponseModel {
  /// 93101 :메세지
  ///
  final int cmd;
  final String ver; // '1'

  ChatResponseModel(this.cmd, this.ver);

  factory ChatResponseModel.fromJson(Map<String, dynamic> data) {
    return ChatResponseModel(data['cmd'], data['ver'] ?? '2');
  }
}

class ChatMessageResponseModel<T> extends ChatResponseModel {
  final String svcid; // 'game'
  final String cid;
  final String? tid;
  final T bdy;

  ChatMessageResponseModel({
    required this.svcid,
    required this.cid,
    required this.tid,
    required this.bdy,
    required cmd,
    required ver,
  }) : super(cmd, ver);

  factory ChatMessageResponseModel.fromJson(
      Map<String, dynamic> data, T Function(dynamic) toObject) {
    return ChatMessageResponseModel(
        ver: data['ver'],
        cid: data['cid'],
        cmd: data['cmd'],
        svcid: data['svcid'],
        tid: data['tid'],
        bdy: toObject(data['bdy']));
  }
}

class ChatMessageDataModel {
  final String svcid; // 'game'
  final String cid;
  final int mbrCnt;
  final String uid;
  final ChatMessageProfileModel? profile;
  final String msg;
  final int msgTypeCode; // 1 채팅, 10 채팅 후원
  final String msgStatusType;
  final ChatMessageExtraModel? extras;
  final int ctime;
  final int utime;
  final bool session;
  final int msgTid;
  final int msgTime;

  ChatMessageDataModel({
    required this.svcid,
    required this.cid,
    required this.mbrCnt,
    required this.uid,
    required this.profile,
    required this.msg,
    required this.msgTypeCode,
    required this.msgStatusType,
    required this.ctime,
    required this.extras,
    this.msgTid = -1,
    this.session = false,
    required this.msgTime,
    required this.utime,
  });

  factory ChatMessageDataModel.fromJson(Map<String, dynamic> data) {
    return ChatMessageDataModel(
        cid: data['cid'],
        ctime: data['ctime'],
        extras: data['extras'] != null
            ? ChatMessageExtraModel.fromJson(
                json.decode(data['extras'])) // jsonString 이기 때문에 변환 필요
            : null,
        mbrCnt: data['mbrCnt'],
        msg: data['msg'],
        msgStatusType: data['msgStatusType'],
        msgTime: data['msgTime'],
        msgTypeCode: data['msgTypeCode'],
        profile: data['profile'] != null
            ? ChatMessageProfileModel.fromJson(
                json.decode(data['profile'])) // jsonString 이기 때문에 변환 필요
            : null,
        svcid: data['svcid'],
        uid: data['uid'],
        utime: data['utime'],
        msgTid: data['msgTid'] ?? -1,
        session: data['session'] ?? false);
  }
}

class ChatMessageExtraModel {
  final String chatType; // STRAMING
  final bool isAnonymouse;
  final String streamingChannelId;
  final List<ChatMessageWeeklyRankModel> weeklyRankList;
  final String extraToken;

  final Map<String, dynamic>? emojis;
  final String? osType;
  final String? payType;
  final int? payAmount;
  final String? nickname;
  final String? donationType;

  ChatMessageExtraModel({
    required this.emojis,
    required this.donationType,
    required this.nickname,
    required this.osType,
    required this.payAmount,
    required this.payType,
    required this.streamingChannelId,
    required this.weeklyRankList,
    required this.chatType,
    required this.isAnonymouse,
    required this.extraToken,
  });

  factory ChatMessageExtraModel.fromJson(Map<String, dynamic> data) {
    return ChatMessageExtraModel(
        donationType: data['donationType'],
        emojis: data['emojis'] != null ? json.decode(data['emojis']) : null,
        nickname: data['nickname'],
        osType: data['osType'],
        payAmount: data['payAmount'],
        payType: data['payType'],
        streamingChannelId: data['streamingChannelId'] ?? '',
        weeklyRankList: data['weeklyRankList'] != null
            ? List.from(data['weeklyRankList'])
                .map((e) => ChatMessageWeeklyRankModel.fromJson(e))
                .toList()
            : [],
        chatType: data['chatType'] ?? 'STRAMING',
        isAnonymouse: data['isAnonymouse'] ?? false,
        extraToken: data['extraToken'] ?? '');
  }
}

class ChatMessageWeeklyRankModel {
  final String userIdHash;
  final String nickName;
  final bool verifiedMark;
  final int donationAmount;
  final int ranking;

  ChatMessageWeeklyRankModel({
    required this.userIdHash,
    required this.nickName,
    required this.verifiedMark,
    required this.donationAmount,
    required this.ranking,
  });

  factory ChatMessageWeeklyRankModel.fromJson(Map<String, dynamic> data) {
    return ChatMessageWeeklyRankModel(
        userIdHash: data['userIdHash'],
        donationAmount: data['donationAmount'],
        nickName: data['nickName'],
        ranking: data['ranking'],
        verifiedMark: data['verifiedMark']);
  }
}

class ChatMessageProfileModel {
  final String userIdHash;
  final String nickname;
  final String? profileImageUrl;
  final String userRoleCode;
  final dynamic badge;
  final dynamic title;
  final bool verifiedMark;
  final List<ChatMessageBadgesModel> activityBadges;

  final ChatStreamingProperty? streamingProperty;

  ChatMessageProfileModel({
    required this.activityBadges,
    required this.badge,
    required this.nickname,
    required this.profileImageUrl,
    required this.title,
    required this.userIdHash,
    required this.userRoleCode,
    required this.verifiedMark,
    this.streamingProperty,
  });

  factory ChatMessageProfileModel.fromJson(Map<String, dynamic> data) {
    return ChatMessageProfileModel(
        activityBadges: List.from(data['activityBadges'])
            .map((e) => ChatMessageBadgesModel.fromJson(e))
            .toList(),
        badge: data['badge'],
        nickname: data['nickname'],
        profileImageUrl: data['profileImageUrl'],
        title: data['title'],
        userIdHash: data['userIdHash'],
        userRoleCode: data['userRoleCode'],
        verifiedMark: data['verifiedMark'],
        streamingProperty: data['streamingProperty'] != null
            ? ChatStreamingProperty.fromJson(data['streamingProperty'])
            : null);
  }
}

class ChatMessageBadgesModel {
  final int badgeNo;
  final String badgeId;
  final String imageUrl;
  // final String title;
  // final String description;
  final bool activated;

  ChatMessageBadgesModel({
    required this.activated,
    required this.badgeId,
    required this.badgeNo,
    // required this.title,
    // required this.description,
    required this.imageUrl,
  });

  factory ChatMessageBadgesModel.fromJson(Map<String, dynamic> data) {
    return ChatMessageBadgesModel(
      activated: data['activated'],
      badgeId: data['badgeId'],
      badgeNo: data['badgeNo'],
      // description: data['description'],
      // title: data['title'],
      imageUrl: data['imageUrl'],
    );
  }
}

class ChatStreamingProperty {
  final ChatStreamingPropertySubscription? subscription;

  ChatStreamingProperty({
    this.subscription,
  });

  factory ChatStreamingProperty.fromJson(Map<String, dynamic> data) {
    return ChatStreamingProperty(
        subscription: data['subscription'] != null
            ? ChatStreamingPropertySubscription.fromJson(
                Map.from(data['subscription']))
            : null);
  }
}

class ChatStreamingPropertyBadge {
  final String imageUrl;
  ChatStreamingPropertyBadge(this.imageUrl);
  factory ChatStreamingPropertyBadge.fromJson(Map<String, dynamic> data) {
    return ChatStreamingPropertyBadge(data['imageUrl']);
  }
}

class ChatStreamingPropertySubscription {
  final int accumulativeMonth;

  final ChatStreamingPropertyBadge badge;

  final int tier;

  ChatStreamingPropertySubscription(
      this.accumulativeMonth, this.badge, this.tier);

  factory ChatStreamingPropertySubscription.fromJson(
      Map<String, dynamic> data) {
    return ChatStreamingPropertySubscription(
        data['accumulativeMonth'],
        ChatStreamingPropertyBadge.fromJson(Map.from(data['badge'])),
        data['tier']);
  }
}

const chzzkChatProxyServerList = [
  "kr-ss1.chat.naver.com",
  "kr-ss2.chat.naver.com",
  "kr-ss3.chat.naver.com",
  "kr-ss4.chat.naver.com",
  "kr-ss5.chat.naver.com"
];

const chzzkChatSessionServerList = [
  "kr-ss1.chat.naver.com",
  "kr-ss2.chat.naver.com",
  "kr-ss3.chat.naver.com",
  "kr-ss4.chat.naver.com",
  "kr-ss5.chat.naver.com"
];
