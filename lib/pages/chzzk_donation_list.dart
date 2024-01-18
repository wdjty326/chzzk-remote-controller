import 'package:chzzk_remote_controller/bloc/chzzk/chzzk_bloc.dart';
import 'package:chzzk_remote_controller/bloc/chzzk/chzzk_event.dart';
import 'package:chzzk_remote_controller/bloc/chzzk/chzzk_state.dart';
import 'package:chzzk_remote_controller/models/chzzk_chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChzzkDonationList extends StatefulWidget {
  const ChzzkDonationList({super.key});

  @override
  State<ChzzkDonationList> createState() => _ChzzkDonationListState();
}

class _ChzzkDonationListState extends State<ChzzkDonationList> {
  TextEditingController inputController = TextEditingController();
  ScrollController chatListScrollController = ScrollController();
  ScrollController donationListScrollController = ScrollController();

  List<ChatMessageDataModel> chatList = [];
  List<ChatMessageDataModel> donationList = [];

  bool ready = false;

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
                  donationList.add(element);
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
                children: [
                  SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: 91,
                    height: 30,
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(
                    width: 180,
                    height: 35,
                    child: TextField(
                      controller: inputController,
                      style: Theme.of(context).textTheme.displayMedium,
                      decoration: const InputDecoration(
                        labelText: 'Channel URI',
                        hintText: 'Enter your Channel',
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
                  ElevatedButton(
                    onPressed: () {
                      if (ready) {
                        BlocProvider.of<ChzzkBloc>(context)
                            .add(ChzzkChatDisconnectEvent());
                        return;
                      }
                      BlocProvider.of<ChzzkBloc>(context)
                          .add(ChzzkAccessTokenEvent(inputController.text));
                    },
                    child: Text(ready ? 'Disconnect' : 'Connect'),
                  ),
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
                      reverse: true,
                      itemBuilder: (ctx, index) {
                        var donationData = donationList[index];
                        return Container(
                          color: Theme.of(context).colorScheme.secondary,
                          padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
                          child: Column(
                            children: [
                              Text(donationData.profile.nickname),
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
                        itemExtent: 25,
                        itemBuilder: (ctx, index) {
                          var chatData = chatList[index];
                          var activityBadgeIndex = chatData
                              .profile.activityBadges
                              .indexWhere((element) => element.activated);

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              activityBadgeIndex != -1
                                  ? Image.network(
                                      chatData
                                          .profile
                                          .activityBadges[activityBadgeIndex]
                                          .imageUrl,
                                      width: 18,
                                      height: 18,
                                      fit: BoxFit.cover,
                                    )
                                  : const SizedBox(),
                              const SizedBox(width: 4),
                              Text(chatData.profile.nickname),
                              const SizedBox(width: 12),
                              Text(chatData.msg)
                            ],
                          );
                        }))
              ],
            )));
  }

  @override
  void dispose() {
    chatListScrollController.dispose();
    donationListScrollController.dispose();
    inputController.dispose();
    super.dispose();
  }
}
