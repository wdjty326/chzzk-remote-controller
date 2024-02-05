import 'dart:convert';

import 'package:flutter/material.dart';

class ChatResponseModel {
  final int cmd;
  final String ver;

  ChatResponseModel(this.cmd, this.ver);

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(json['cmd'], json['ver'] ?? '2');
  }
}

class ChatMessageResponseModel<T> extends ChatResponseModel {
  final String svcid;
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
  final String svcid;
  final String cid;
  final int mbrCnt;
  final String uid;
  final ChatMessageProfileModel? profile;
  final String msg;
  final int msgTypeCode;
  final String msgStatusType;
  final ChatMessageExtraModel? extras;
  final int ctime;
  final int utime;
  final int? msgTid;
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
    this.msgTid,
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
        msgTid: json['msgTid']);
  }
}

class ChatMessageExtraModel {
  final dynamic emojis;
  final String chatType;
  final bool isAnonymouse;
  final String? streamingChannelId;
  final List<ChatMessageWeeklyRankModel> weeklyRankList;

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
    this.isAnonymouse = false,
  });

  factory ChatMessageExtraModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageExtraModel(
        donationType: json['donationType'],
        emojis: json['emojis'],
        nickname: json['nickname'],
        osType: json['osType'],
        payAmount: json['payAmount'],
        payType: json['payType'],
        streamingChannelId: json['streamingChannelId'],
        weeklyRankList: json['weeklyRankList'] != null
            ? List.from(json['weeklyRankList'])
                .map((e) => ChatMessageWeeklyRankModel.fromJson(e))
                .toList()
            : [],
        chatType: json['chatType'],
        isAnonymouse: json['isAnonymouse'] ?? false);
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

  /// streamingProperty

  ChatMessageProfileModel({
    required this.activityBadges,
    required this.badge,
    required this.nickname,
    required this.profileImageUrl,
    required this.title,
    required this.userIdHash,
    required this.userRoleCode,
    required this.verifiedMark,
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
        verifiedMark: json['verifiedMark']);
  }
}

class ChatMessageBadgesModel {
  final int badgeNo;
  final String badgeId;
  final String imageUrl;
  final String title;
  final String description;
  final bool activated;

  ChatMessageBadgesModel(
      {required this.activated,
      required this.badgeId,
      required this.badgeNo,
      required this.description,
      required this.imageUrl,
      required this.title});

  factory ChatMessageBadgesModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageBadgesModel(
        activated: json['activated'],
        badgeId: json['badgeId'],
        badgeNo: json['badgeNo'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        title: json['title']);
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
