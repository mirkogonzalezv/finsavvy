import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/consts/route_config.dart';
import '../../../auth/components/blocs/auth_bloc/bloc/auth_bloc.dart';

class MenuApp extends StatelessWidget {
  const MenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Column(
        children: [
          BlocBuilder<AuthBloc, AuthState>(
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
                            state.user.email?.substring(0, 1).toUpperCase() ??
                                'U',
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
          ),
          Expanded(
            child: ListView(
              children: [
                _buildListTile(
                  icon: Icons.home,
                  title: 'Inicio',
                  onTap: () {
                    context.go(AppRouter.homePath);
                    Navigator.pop(context);
                  },
                ),
                _buildListTile(
                  icon: Icons.person,
                  title: 'Perfil',
                  onTap: () {
                    log("IR A PERFIL");
                    Navigator.pop(context);
                  },
                ),
                _buildListTile(
                  icon: Icons.settings,
                  title: 'Configuración',
                  onTap: () {
                    log("IR A CONFIGURACIÓN");
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                _buildListTile(
                  icon: Icons.logout,
                  title: 'Cerrar Sesión',
                  onTap: () {
                    _showLogoutConfirmation(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildListTile({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: Colors.deepPurple),
    title: Text(title),
    onTap: onTap,
  );
}

void _showLogoutConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: const Text(
        'Cerrar sesión',
        style: TextStyle(color: Colors.black87),
      ),
      content: const Text(
        '¿Estás seguro de que quieres cerrar sesión?',
        style: TextStyle(color: Colors.black87),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            context.read<AuthBloc>().add(CloseSessionAccount());
            context.go(AppRouter.authPath);
          },
          child: const Text('Salir', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
