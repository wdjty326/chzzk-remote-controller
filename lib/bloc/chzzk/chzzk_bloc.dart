import 'package:chzzk_remote_controller/bloc/chzzk/chzzk_event.dart';
import 'package:chzzk_remote_controller/bloc/chzzk/chzzk_state.dart';
import 'package:chzzk_remote_controller/models/chzzk_model.dart';
import 'package:chzzk_remote_controller/repository/chzzk_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChzzkBloc extends Bloc<ChzzkEvent, ChzzkState> {
  final ChzzkRepository chzzkRepository;

  ChzzkBloc(this.chzzkRepository) : super(ChzzkInitialized()) {
    on(getChzzkAccessToken);
  }

  void getChzzkAccessToken(ChzzkAccessTokenEvent event, Emitter emit) async {
    emit(ChzzkLoading());

    ChzzkAPICommonModel<ChzzkLiveDetail?> resp0 =
        await chzzkRepository.getLiveDetail(event.channelId);
    if (resp0.content == null) {
      emit(ChzzkFailure(resp0.code, resp0.message));
      return;
    }

    ChzzkAPICommonModel<ChzzkAccessToken?> resp1 =
        await chzzkRepository.getChatAccessToken(
            event.channelId, resp0.content!.chatChannelId, 'STREAMING');
    if (resp1.content == null) {
      emit(ChzzkFailure(resp1.code, resp1.message));
      return;
    }

    emit(ChzzkAccessTokenState(
        resp1.content!.accessToken, resp0.content!.chatChannelId));
  }
}
