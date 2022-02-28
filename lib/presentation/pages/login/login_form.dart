import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:wordle/bloc/app/app_bloc.dart';
import 'package:wordle/bloc/login/login_cubit.dart';
import 'package:wordle/presentation/pages/sign_up/sign_up_page.dart';
import 'package:wordle/presentation/pages/statistic/statistic_page.dart';
import 'package:wordle/resources/r.dart';
import 'package:wordle/utils/responsive.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    required this.authRepository,
    Key? key,
  }) : super(key: key);

  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? R.stringsOf(context).auth_fail_message,
                ),
              ),
            );
        }
      },
      child: Center(
        child: Responsive(
          mobile: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Align(
              alignment: const Alignment(0, -1 / 3),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      _EmailInput(),
                      const SizedBox(height: 8),
                      _PasswordInput(),
                      const SizedBox(height: 8),
                      _LoginButton(),
                      const SizedBox(height: 4),
                      _SignUpButton(
                        authRepository: authRepository,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          cursorColor: Theme.of(context).colorScheme.secondary,
          decoration: InputDecoration(
            labelText: 'email',
            helperText: '',
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.secondary),
            ),
            errorText: state.email.invalid
                ? R.stringsOf(context).invalid_email_message
                : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          cursorColor: Theme.of(context).colorScheme.secondary,
          decoration: InputDecoration(
            labelText: 'password',
            helperText: '',
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.secondary),
            ),
            errorText: state.password.invalid
                ? R.stringsOf(context).invalid_password_message
                : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  primary: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: state.status.isValidated
                    ? () {
                        context.read<LoginCubit>().logInWithCredentials();
                        if (state.status.isSubmissionSuccess) {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => const StatisticView(),
                            ),
                          );
                        }
                      }
                    : null,
                child: Text(R.stringsOf(context).login.toUpperCase()),
              );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({
    required this.authRepository,
    Key? key,
  }) : super(key: key);

  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      key: const Key('loginForm_createAccount_flatButton'),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RepositoryProvider.value(
            value: authRepository,
            child: BlocProvider(
              child: const SignUpPage(),
              create: (context) => AppBloc(authRepository: authRepository),
            ),
          ),
        ),
      ),
      child: Text(
        R.stringsOf(context).create_account.toUpperCase(),
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}
