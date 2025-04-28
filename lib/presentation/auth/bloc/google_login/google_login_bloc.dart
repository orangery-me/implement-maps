import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_template/data/models/user_model.dart';
import 'package:flutter_template/data/repositories/user_repository.dart';
import 'package:flutter_template/generated/locale_keys.g.dart';
import 'package:flutter_template/presentation/auth/bloc/auth/auth_bloc.dart';

part 'google_login_event.dart';
part 'google_login_state.dart';

class GoogleLoginBloc extends Bloc<GoogleLoginEvent, GoogleLoginState> {
  final UserRepository _userRepository;
  final AuthBloc _authBloc;
  GoogleLoginBloc({
    required UserRepository userRepository,
    required AuthBloc authBloc,
  })  : _userRepository = userRepository,
        _authBloc = authBloc,
        super(GoogleLoginInitial()) {
    on<GoogleLoginSubmit>(_handleSignin);
  }

  Future<void> _handleSignin(
    GoogleLoginSubmit event,
    Emitter<GoogleLoginState> emit,
  ) async {
    emit(GoogleLoginLoading());

    try {
      final String? idToken = await _userRepository.handleSignIn();
      if (idToken == null) {
        emit(GoogleLoginFailure(error: LocaleKeys.texts_error_occur.tr()));
        return;
      }

      final UserModel user = await _userRepository.loginByGoogle(idToken);
      emit(GoogleLoginSuccess(user: user));
      _authBloc.add(AuthUserInfoSet(currentUser: user));
    } catch (error) {
      emit(GoogleLoginFailure(error: error.toString()));
    }
  }
}
