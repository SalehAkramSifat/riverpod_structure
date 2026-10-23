import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';
import 'package:riverpod_structure/features/movie_detail/data/models/cast.dart';
import 'package:riverpod_structure/features/movie_detail/data/models/casts_response.dart';
import 'package:riverpod_structure/features/movie_detail/domain/use_cases/get_casts_use_case.dart';
import 'package:riverpod_structure/features/movie_detail/presentation/provider/movie_detail_providers.dart';
import 'package:riverpod_structure/features/movie_detail/presentation/provider/state/casts_state.dart';

final castsNotifierProvider =
    NotifierProvider<CastsNotifier, CastsState>(CastsNotifier.new);

class CastsNotifier extends Notifier<CastsState> {
  GetCastsUseCase get _getCastsUseCase => ref.read(getCastsUseCaseProvider);

  @override
  CastsState build() {
    return const CastsState.initial();
  }

  bool get isFetching => state.state != CastConcreteState.loading;

  Future<void> getCasts({required int id}) async {
    if (isFetching) {
      state = state.copyWith(state: CastConcreteState.loading, isLoading: true);
      final response = await _getCastsUseCase.execute(movieId: id);
      updateStateFromGetCastsResponse(response);
    }
  }

  void updateStateFromGetCastsResponse(
    Either<AppException, CastsResponse<dynamic>> response,
  ) {
    response.fold(
      (failure) {
        state = state.copyWith(
          state: CastConcreteState.failure,
          message: failure.message,
          hasData: false,
          isLoading: false,
        );
      },
      (results) {
        final casts = results.casts.map((e) => Cast.fromJson(e)).toList();
        state = state.copyWith(
          state: CastConcreteState.loaded,
          casts: casts,
          hasData: false,
          message: casts.isEmpty ? 'no casts found' : '',
          isLoading: false,
        );
      },
    );
  }
}
