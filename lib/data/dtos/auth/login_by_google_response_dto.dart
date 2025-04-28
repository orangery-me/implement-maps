import 'package:json_annotation/json_annotation.dart';
part 'login_by_google_response_dto.g.dart';

@JsonSerializable(createFactory: false)
class LoginByGoogleResponseDTO {
  LoginByGoogleResponseDTO({
    required this.email,
    required this.accessToken,
  });
  final String email;
  final String accessToken;
}
