import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/generated/locale_keys.g.dart';
import 'package:flutter_template/presentation/auth/bloc/auth/auth_bloc.dart';
import 'package:flutter_template/presentation/auth/views/login_view.dart';

class MapsDrawer extends StatelessWidget {
  const MapsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Drawer(
          child: state.status == AuthenticationStatus.authenticated
              ? ListView(
                  children: [
                    DrawerHeader(
                      child: Text('Welcome ${state.user!.email}'),
                    ),
                    ListTile(
                      title: Text(LocaleKeys.auth_sign_out.tr()),
                      onTap: () {
                        context.read<AuthBloc>().add(
                              const AuthUserInfoSet(currentUser: null),
                            );
                      },
                    ),
                  ],
                )
              : ListView(
                  children: [
                    const DrawerHeader(
                      child: Text('Welcome to MapSorter App!'),
                    ),
                    ListTile(
                      title: Text(LocaleKeys.auth_sign_in.tr()),
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (_) => const LoginPage(),
                        );
                      },
                    ),
                  ],
                ),
        );
      },
    );
  }
}
