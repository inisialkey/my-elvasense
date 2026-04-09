import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/dependencies_injection.dart';
import 'package:myelvasense/features/features.dart';
import 'package:myelvasense/utils/services/hive/hive.dart';

part 'logout_cubit.freezed.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final PostLogout _postLogout;

  LogoutCubit(this._postLogout) : super(const LogoutStateLoading());

  Future<void> postLogout() async {
    emit(const LogoutStateLoading());
    final data = await _postLogout.call(NoParams());
    data.fold(
      (l) {
        if (l is ServerFailure) {
          emit(LogoutStateFailure(l.message ?? ''));
        }
      },
      (r) async {
        await sl<MainBoxMixin>().logoutBox();
        emit(LogoutStateSuccess(r));
      },
    );
  }
}

@freezed
sealed class LogoutState with _$LogoutState {
  const factory LogoutState.loading() = LogoutStateLoading;
  const factory LogoutState.failure(String message) = LogoutStateFailure;
  const factory LogoutState.success(String message) = LogoutStateSuccess;
}
