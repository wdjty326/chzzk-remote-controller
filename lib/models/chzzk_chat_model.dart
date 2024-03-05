import 'dart:convert';

import 'package:flutter/material.dart';

class ChatResponseModel {
  /// 93101 :메세지
  ///
  final int cmd;
  final String ver; // '1'

  ChatResponseModel(this.cmd, this.ver);

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(json['cmd'], json['ver'] ?? '2');
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
      Map<String, dynamic> json, T Function(dynamic) toObject) {
    return ChatMessageResponseModel(
        ver: json['ver'],
        cid: json['cid'],
        cmd: json['cmd'],
        svcid: json['svcid'],
        tid: json['tid'],
        bdy: toObject(json['bdy']));
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

  factory ChatMessageDataModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageDataModel(
        cid: json['cid'],
        ctime: json['ctime'],
        extras: json['extras'] != null
            ? ChatMessageExtraModel.fromJson(jsonDecode(json['extras']))
            : null,
        mbrCnt: json['mbrCnt'],
        msg: json['msg'],
        msgStatusType: json['msgStatusType'],
        msgTime: json['msgTime'],
        msgTypeCode: json['msgTypeCode'],
        profile: json['profile'] != null
            ? ChatMessageProfileModel.fromJson(jsonDecode(json['profile']))
            : null,
        svcid: json['svcid'],
        uid: json['uid'],
        utime: json['utime'],
        msgTid: json['msgTid'] ?? -1,
        session: json['session'] ?? false);
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

  factory ChatMessageExtraModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageExtraModel(
        donationType: json['donationType'],
        emojis: json['emojis'] != null ? Map.from(json['emojis']) : null,
        nickname: json['nickname'],
        osType: json['osType'],
        payAmount: json['payAmount'],
        payType: json['payType'],
        streamingChannelId: json['streamingChannelId'] ?? '',
        weeklyRankList: json['weeklyRankList'] != null
            ? List.from(json['weeklyRankList'])
                .map((e) => ChatMessageWeeklyRankModel.fromJson(e))
                .toList()
            : [],
        chatType: json['chatType'] ?? 'STRAMING',
        isAnonymouse: json['isAnonymouse'] ?? false,
        extraToken: json['extraToken'] ?? '');
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

  factory ChatMessageWeeklyRankModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageWeeklyRankModel(
        userIdHash: json['userIdHash'],
        donationAmount: json['donationAmount'],
        nickName: json['nickName'],
        ranking: json['ranking'],
        verifiedMark: json['verifiedMark']);
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

  factory ChatMessageProfileModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageProfileModel(
        activityBadges: List.from(json['activityBadges'])
            .map((e) => ChatMessageBadgesModel.fromJson(e))
            .toList(),
        badge: json['badge'],
        nickname: json['nickname'],
        profileImageUrl: json['profileImageUrl'],
        title: json['title'],
        userIdHash: json['userIdHash'],
        userRoleCode: json['userRoleCode'],
        verifiedMark: json['verifiedMark'],
        streamingProperty: json['streamingProperty'] != null
            ? ChatStreamingProperty.fromJson(json['streamingProperty'])
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

  factory ChatMessageBadgesModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageBadgesModel(
      activated: json['activated'],
      badgeId: json['badgeId'],
      badgeNo: json['badgeNo'],
      // description: json['description'],
      // title: json['title'],
      imageUrl: json['imageUrl'],
    );
  }
}

class ChatStreamingProperty {
  final ChatStreamingPropertySubscription? subscription;

  ChatStreamingProperty({
    this.subscription,
  });

  factory ChatStreamingProperty.fromJson(Map<String, dynamic> json) {
    return ChatStreamingProperty(
        subscription: json['subscription'] != null
            ? ChatStreamingPropertySubscription.fromJson(
                Map.from(json['subscription']))
            : null);
  }
}

class ChatStreamingPropertyBadge {
  final String imageUrl;
  ChatStreamingPropertyBadge(this.imageUrl);
  factory ChatStreamingPropertyBadge.fromJson(Map<String, dynamic> json) {
    return ChatStreamingPropertyBadge(json['imageUrl']);
  }
}

class ChatStreamingPropertySubscription {
  final int accumulativeMonth;

  final ChatStreamingPropertyBadge badge;

  final int tier;

  ChatStreamingPropertySubscription(
      this.accumulativeMonth, this.badge, this.tier);

  factory ChatStreamingPropertySubscription.fromJson(
      Map<String, dynamic> json) {
    return ChatStreamingPropertySubscription(
        json['accumulativeMonth'],
        ChatStreamingPropertyBadge.fromJson(Map.from(json['badge'])),
        json['tier']);
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
