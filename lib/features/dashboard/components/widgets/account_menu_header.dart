import 'package:finsavvy/core/consts/route_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/components/blocs/auth_bloc/bloc/auth_bloc.dart';

class AccountMenuHeader extends StatelessWidget {
  const AccountMenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccessState) {
          return UserAccountsDrawerHeader(
            accountName: Text(state.user.displayName!),
            accountEmail: Text(state.user.email!),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: state.user.photoURL != null
                  ? ClipOval(
                      child: Image.network(
                        state.user.photoURL!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Text(
                      state.user.email?.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(fontSize: 24),
                    ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.deepPurpleAccent],
              ),
            ),
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
