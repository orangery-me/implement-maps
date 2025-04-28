part of 'google_login_bloc.dart';

sealed class GoogleLoginEvent extends Equatable {
  const GoogleLoginEvent();

  @override
  List<Object> get props => [];
}

class GoogleLoginSubmit extends GoogleLoginEvent {}
