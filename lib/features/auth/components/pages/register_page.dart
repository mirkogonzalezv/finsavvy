import 'package:finsavvy/core/consts/theme_consts.dart';
import 'package:finsavvy/features/auth/components/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:finsavvy/infra/injector_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/consts/route_config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  late final AuthBloc _authBloc; // Cambiamos a variable de instancia

  @override
  void initState() {
    // TODO: implement initState

    _authBloc = getIt<AuthBloc>(); // Obtenemos la instancia una sola vez
  }

  void _onRegisterPressed() {
    if (_registerFormKey.currentState?.validate() ?? false) {
      final email = _emailController.text.toLowerCase().trim();
      final password = _passwordController.text.trim();
      final repeatPassword = _repeatPasswordController.text.trim();

      // Validar que las contraseñas coincidan
      if (password != repeatPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Las contraseñas no coinciden')),
        );
        return;
      }

      _authBloc.add(AuthRegisterRequested(email: email, password: password));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    // NO dispose del BLoC aquí porque es un singleton gestionado por GetIt
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        if (state is AuthLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) =>
                const Center(child: CircularProgressIndicator.adaptive()),
          );
        } else {
          context.goNamed(AppRouter.homeNamePath);
        }

        if (state is AuthErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is AuthSuccessState) {
          // Navegar al home después de registro exitoso
          context.go(AppRouter.homePath);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ThemeConstsApp.backgroundColor, Colors.deepPurpleAccent],
              stops: [0.18, 0.99],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'FinSavvy',
                    style: TextStyle(
                      color: ThemeConstsApp.textColorPrimary,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '¿Listo para crear una nueva cuenta?',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(maxWidth: 400),
                    decoration: BoxDecoration(
                      color: Color(0xff11101c).withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(24),
                    child: Form(
                      key: _registerFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Correo eletrónico',
                              labelStyle: TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Color(
                                0xFF1A1A2E,
                              ).withValues(alpha: 0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.white70,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu correo';
                              } else if (!emailRegex.hasMatch(value)) {
                                return 'Correo inválido';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              labelStyle: TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Color(
                                0xFF1A1A2E,
                              ).withValues(alpha: 0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.white70,
                              ),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu contraseña';
                              } else if (value.length < 12) {
                                return 'La contraseña debe tener al menos 12 caracteres';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _repeatPasswordController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Repetir Contraseña',
                              labelStyle: TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Color(
                                0xFF1A1A2E,
                              ).withValues(alpha: 0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.white70,
                              ),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu contraseña';
                              } else if (value.length < 12) {
                                return 'La contraseña debe tener al menos 12 caracteres';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _onRegisterPressed,
                              child: Text(
                                'Registrar nueva cuenta',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
