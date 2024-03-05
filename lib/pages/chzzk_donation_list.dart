import 'package:chzzk_remote_controller/arguments/chzzk_donation_list_arguments.dart';
import 'package:chzzk_remote_controller/bloc/chzzk/chzzk_bloc.dart';
import 'package:chzzk_remote_controller/bloc/chzzk/chzzk_event.dart';
import 'package:chzzk_remote_controller/bloc/chzzk/chzzk_state.dart';
import 'package:chzzk_remote_controller/models/chzzk_chat_model.dart';
import 'package:chzzk_remote_controller/repository/chzzk_repository.dart';
import 'package:chzzk_remote_controller/widgets/window_titlebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChzzkDonationList extends StatelessWidget {
  static const route = '/donation_list';
  const ChzzkDonationList({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as ChzzkDonationListArguments?;
    return Scaffold(
      appBar: const WindowTitlebar(),

      /// TODO::추후 ws연결은 전역처리가 필요할 수 있음
      body: BlocProvider<ChzzkBloc>(
        create: (context) => ChzzkBloc(ChzzkRepository()),
        child: _ChzzkDonationListProvider(args?.userIdHash ?? ''),
      ),
    );
  }
}

class _ChzzkDonationListProvider extends StatefulWidget {
  final String userIdHash;

  const _ChzzkDonationListProvider(this.userIdHash, [Key? key])
      : super(key: key);

  @override
  State<_ChzzkDonationListProvider> createState() =>
      _ChzzkDonationListProviderState();
}

class _ChzzkDonationListProviderState
    extends State<_ChzzkDonationListProvider> {
  TextEditingController inputController = TextEditingController();
  ScrollController chatListScrollController = ScrollController();
  ScrollController donationListScrollController = ScrollController();

  List<ChatMessageDataModel> chatList = [];
  List<ChatMessageDataModel> donationList = [];

  bool ready = false;

  @override
  void initState() {
    super.initState();
    if (widget.userIdHash.isNotEmpty) {
      BlocProvider.of<ChzzkBloc>(context)
          .add(ChzzkAccessTokenEvent(widget.userIdHash));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChzzkBloc, ChzzkState>(
        listener: (context, state) {
          if (state is ChzzkAccessTokenState) {
            BlocProvider.of<ChzzkBloc>(context).add(
                ChzzkChatConnectEvent(state.accessToken, state.chatChannelId));
          }

          if (state is ChzzkChatConnectState) {
            setState(() {
              ready = true;
            });
          }

          if (state is ChzzkChatDisconnectState) {
            setState(() {
              ready = false;
            });
          }

          if (state is ChzzkChatMessageState) {
            setState(() {
              for (var element in state.list) {
                if (element.extras?.payAmount != null) {
                  donationList.insert(0, element);
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    donationListScrollController.animateTo(0,
                        duration: const Duration(milliseconds: 1),
                        curve: Curves.linear);
                  });
                } else {
                  chatList.add(element);
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    chatListScrollController.animateTo(
                        chatListScrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 1),
                        curve: Curves.linear);
                  });
                }
              }
            });
          }
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SvgPicture.asset(
                        'assets/images/logo.svg',
                        width: 91,
                        height: 30,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),

                  /// TODO::로그인으로 대체될 처리입니다
                  SizedBox(
                    width: 180,
                    height: 35,
                    child: TextField(
                      controller: inputController,
                      style: Theme.of(context).textTheme.displayMedium,
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(
                        labelText: 'Channel URI',
                        hintText: 'Enter your Channel',
                        hintStyle: Theme.of(context).textTheme.displayMedium,
                        labelStyle: TextStyle(color: Colors.redAccent),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.redAccent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.redAccent),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (ready) {
                          BlocProvider.of<ChzzkBloc>(context)
                              .add(ChzzkChatDisconnectEvent());
                          return;
                        }
                        BlocProvider.of<ChzzkBloc>(context)
                            .add(ChzzkAccessTokenEvent(inputController.text));
                      },
                      icon: Icon(
                        Icons.settings_input_composite_rounded,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  Text(ready ? 'Disconnect' : 'Connect'),
                ],
              ),
            ),
            body: Row(
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width / 2,
                  child: ListView.builder(
                      controller: donationListScrollController,
                      itemCount: donationList.length,
                      itemBuilder: (ctx, index) {
                        var donationData = donationList[index];
                        return Container(
                          color: Theme.of(context).colorScheme.secondary,
                          padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
                          child: Column(
                            children: [
                              Text(donationData.profile?.nickname ?? '익명의 후원자'),
                              Text(donationData.msg),
                              Text(donationData.extras!.payAmount.toString())
                            ],
                          ),
                        );
                      }),
                ),
                SizedBox(
                    width: MediaQuery.sizeOf(context).width / 2,
                    child: ListView.builder(
                        controller: chatListScrollController,
                        itemCount: chatList.length,
                        // itemExtent: 25,
                        itemBuilder: (ctx, index) {
                          var chatData = chatList[index];
                          var activityBadgeIndex = chatData
                              .profile!.activityBadges
                              .indexWhere((element) => element.activated);

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              activityBadgeIndex != -1
                                  ? Image.network(
                                      chatData
                                          .profile!
                                          .activityBadges[activityBadgeIndex]
                                          .imageUrl,
                                      width: 18,
                                      height: 18,
                                      fit: BoxFit.cover,
                                    )
                                  : const SizedBox(),
                              const SizedBox(width: 4),
                              Text(chatData.profile!.nickname),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: Text(
                                chatData.msg,
                                maxLines: null,
                                softWrap: true,
                              ))
                            ],
                          );
                        }))
              ],
            )));
  }

  @override
  void dispose() {
    if (ready) {
      BlocProvider.of<ChzzkBloc>(context).add(ChzzkChatDisconnectEvent());
    }
    chatListScrollController.dispose();
    donationListScrollController.dispose();
    inputController.dispose();
    super.dispose();
  }
}
