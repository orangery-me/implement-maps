import 'package:flutter_template/common/constants/endpoints.dart';
import 'package:flutter_template/common/helpers/dio_helper.dart';
import 'package:flutter_template/data/dtos/auth/login_by_email_request_dto.dart';
import 'package:flutter_template/data/dtos/auth/login_by_google_response_dto.dart';
import 'package:flutter_template/data/dtos/auth/login_response_dto.dart';
import 'package:flutter_template/data/models/user_model.dart';
import 'package:flutter_template/flavors.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UserRemoteDataSource {
  UserRemoteDataSource({required DioHelper dioHelper}) : _dioHelper = dioHelper;

  final DioHelper _dioHelper;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
    clientId: AppFlavor.clientId,
  );

  Future<String?> handleSignIn() async {
    final googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount == null) {
      return null;
    }
    final GoogleSignInAuthentication googleAuthentication =
        await googleSignInAccount.authentication;

    return googleAuthentication.idToken;
  }

  Future<void> handleSignOut() async => _googleSignIn.signOut();

  Future<LoginResponseDTO> loginByEmail(LoginByEmailRequestDTO params) async {
    final HttpRequestResponse response = await _dioHelper.post(
      Endpoints.login,
      data: params.toJson(),
    );

    return LoginResponseDTO(
      user: UserModel.fromJson(response.data['data']['user']),
      refreshToken: response.data['data']['token']['refreshToken'],
      accessToken: response.data['data']['token']['accessToken'],
      expiresIn: response.data['data']['token']['expiresIn'],
    );
  }

  Future<LoginByGoogleResponseDTO> loginByGoogle(String idToken) async {
    final response = await _dioHelper.post(
      Endpoints.googleLogin,
      data: {'idToken': idToken},
    );

    if (response.statusCode != 200) {
      throw Exception(response.data['message']);
    }

    return LoginByGoogleResponseDTO(
      email: response.data['email'],
      accessToken: response.data['accessToken'],
    );
  }
}
