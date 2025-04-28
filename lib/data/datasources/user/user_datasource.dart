import 'package:flutter_template/data/datasources/user/local/user_datasource.dart';
import 'package:flutter_template/data/datasources/user/remote/user_datasource.dart';
import 'package:flutter_template/data/dtos/auth/login_by_email_request_dto.dart';
import 'package:flutter_template/data/dtos/auth/login_by_google_response_dto.dart';
import 'package:flutter_template/data/dtos/auth/login_response_dto.dart';
import 'package:flutter_template/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UserDataSource {
  UserDataSource({
    required UserRemoteDataSource remoteDataSource,
    required UserLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;

  Future<UserModel> loginByEmail(LoginByEmailRequestDTO params) async {
    final LoginResponseDTO loginResponse =
        await _remoteDataSource.loginByEmail(params);

    await _localDataSource.setUserAuth(loginResponse);

    return loginResponse.user;
  }

  UserModel? getUserInfo() {
    return _localDataSource.getUserInfo();
  }

  Future<UserModel> loginByGoogle(String idToken) async {
    final LoginByGoogleResponseDTO loginReponse =
        await _remoteDataSource.loginByGoogle(idToken);
    await _localDataSource.setUserGoogleAuth(loginReponse);

    return UserModel(email: loginReponse.email);
  }

  Future<String?> handleSignIn() async => _remoteDataSource.handleSignIn();

  Future<void> handleSignOut() async => _remoteDataSource.handleSignOut();
}
