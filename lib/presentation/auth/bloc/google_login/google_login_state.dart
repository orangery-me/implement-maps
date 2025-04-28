part of 'google_login_bloc.dart';

sealed class GoogleLoginState extends Equatable {
  const GoogleLoginState();

  @override
  List<Object> get props => [];
}

final class GoogleLoginInitial extends GoogleLoginState {}

final class GoogleLoginLoading extends GoogleLoginState {}

final class GoogleLoginSuccess extends GoogleLoginState {
  final UserModel user;

  const GoogleLoginSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

final class GoogleLoginFailure extends GoogleLoginState {
  final String error;

  const GoogleLoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}
