class ChatResponseModel {
  final int cmd;
  final String ver;

  ChatResponseModel(this.cmd, this.ver);

  factory ChatResponseModel.formJson(Map<String, dynamic> json) {
    return ChatResponseModel(json['cmd'], json['ver']);
  }
}

class ChatMessageResponseModel<T> extends ChatResponseModel {
  final String svcid;
  final String cid;
  final String tid;
  final T bdy;

  ChatMessageResponseModel({
    required this.svcid,
    required this.cid,
    required this.tid,
    required this.bdy,
    required cmd,
    required ver,
  }) : super(cmd, ver);

  factory ChatMessageResponseModel.formJson(
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
  final String profile;
  final String msg;
  final int msgTypeCode;
  final String msgStatusType;
  final String extras;
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
        extras: json['extras'],
        mbrCnt: json['mbrCnt'],
        msg: json['msg'],
        msgStatusType: json['msgStatusType'],
        msgTime: json['msgTime'],
        msgTypeCode: json['msgTypeCode'],
        profile: json['profile'],
        svcid: json['svcid'],
        uid: json['uid'],
        utime: json['utime'],
        msgTid: json['msgTid']);
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
