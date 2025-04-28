import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/common/extensions/context_extension.dart';
import 'package:flutter_template/common/extensions/string_extension.dart';
import 'package:flutter_template/common/theme/app_size.dart';
import 'package:flutter_template/common/utils/toast_util.dart';
import 'package:flutter_template/data/repositories/user_repository.dart';
import 'package:flutter_template/di/di.dart';
import 'package:flutter_template/generated/locale_keys.g.dart';
import 'package:flutter_template/presentation/auth/bloc/auth/auth_bloc.dart';
import 'package:flutter_template/presentation/auth/bloc/google_login/google_login_bloc.dart';
import 'package:flutter_template/presentation/auth/bloc/login/login_bloc.dart';
import 'package:flutter_template/presentation/auth/widgets/login_form.dart';
import 'package:flutter_template/presentation/widgets/common_rounded_button.dart';
import 'package:flutter_template/router/app_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LoginBloc(
            authBloc: context.read<AuthBloc>(),
            userRepository: getIt.get<UserRepository>(),
          ),
        ),
        BlocProvider(
          create: (_) => GoogleLoginBloc(
            userRepository: getIt.get<UserRepository>(),
            authBloc: context.read<AuthBloc>(),
          ),
        ),
      ],
      child: BlocListener<LoginBloc, LoginState>(
        listener: _listenLoginStateChanged,
        child: _LoginView(),
      ),
    );
  }

  void _listenLoginStateChanged(BuildContext context, LoginState state) {
    if (state is LoginNotSuccess && state.error.isNullOrEmpty) {
      ToastUtil.showError(
        context,
      );
    }
  }
}

class _LoginView extends StatelessWidget {
  _LoginView();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailEditController = TextEditingController();
  final TextEditingController _passwordEditController = TextEditingController();

  void _submitLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
            LoginSubmit(
              email: _emailEditController.text,
              password: _passwordEditController.text,
            ),
          );
    }
  }

  void _listenGoogleLoginStateChanged(
    BuildContext context,
    GoogleLoginState state,
  ) {
    if (state is GoogleLoginFailure) {
      ToastUtil.showError(
        context,
        text: LocaleKeys.texts_error_occur.tr(),
      );
    }
    if (state is GoogleLoginSuccess) {
      Navigator.of(context).pushReplacementNamed(AppRouter.maps);
    }
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return CommonRoundedButton(
          onPressed: () => _submitLogin(context),
          isLoading: state is LoginLoading,
          content: LocaleKeys.auth_sign_in.tr(),
          width: double.infinity,
          backgroundColor: context.themeConfig.abcColor,
          textStyle: TextStyle(
            color: context.themeConfig.buttonTextColor,
          ),
        );
      },
    );
  }

  Widget _buildGoogleLoginButton(BuildContext context) {
    return BlocConsumer<GoogleLoginBloc, GoogleLoginState>(
      builder: ((context, state) {
        return CommonRoundedButton(
          onPressed: () =>
              context.read<GoogleLoginBloc>().add(GoogleLoginSubmit()),
          isLoading: state is GoogleLoginLoading,
          content: LocaleKeys.auth_sign_in_with_google.tr(),
          width: double.infinity,
          textStyle: TextStyle(
            color: context.themeConfig.textColor,
          ),
          backgroundColor: context.themeConfig.lightButtonBackgroundColor,
          borderSide: const BorderSide(),
        );
      }),
      listener: _listenGoogleLoginStateChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSize.horizontalSpacing,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.auth_welcome_back.tr(),
                    style: context.titleLarge,
                  ),
                  LoginForm(
                    formKey: _formKey,
                    emailEditController: _emailEditController,
                    passwordEditController: _passwordEditController,
                  ),
                  _buildLoginButton(context),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text('or'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildGoogleLoginButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
