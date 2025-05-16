import 'package:flutter/material.dart';
import 'package:instagram_clone/core/utils/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../feed/feed_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  void _login() {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      // Attendre 5sec pour executer la fonction
      Future.delayed(const Duration(seconds: 5), () {
        final username = _usernameController.text.trim();
        final password = _passwordController.text.trim();

        context.read<AuthBloc>().add(LoginSubmitted(username, password));
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool passwordVisible = false;
  bool _showClear = false;
  bool _showEye = false;

  // Fonction pour afficher/cacher le mot de passe
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  // Effacer le username écris
  void clearText() {
    _usernameController.text = "";
    setState(() {
      _showClear = !_showClear;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is AuthSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const FeedScreen()),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Français (France)',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      Icon(Icons.keyboard_arrow_down_outlined)
                    ],
                  ),
                  const SizedBox(height: 40),
                  Image.asset('assets/images/instagram_logo.png', height: 70),
                  const SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            onChanged: (value) {
                              if (value.trim().isNotEmpty) {
                                setState(() {
                                  _showClear = true;
                                });
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Veillez saisir le Nom, e-mail ou numéro de mobile";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText:
                                  'Nom de profil, e-mail ou numéro de mobile',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade200)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade800)),
                              suffixIcon: IconButton(
                                  onPressed: clearText,
                                  icon: Icon(
                                    _showClear ? Icons.close : null,
                                  )),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !passwordVisible,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Veillez saisir le mot de passe svp";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              if (value.trim().isNotEmpty) {
                                setState(() {
                                  _showEye = true;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Mot de passe',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade200)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade800)),
                              suffixIcon: IconButton(
                                  onPressed: togglePassword,
                                  icon: _showEye
                                      ? Icon(
                                          passwordVisible
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                        )
                                      : Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.transparent,
                                        )),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: blueColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'Se connecter',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Mot de passe oublié ?',
                            style: TextStyle(color: Colors.black),
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
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(bottom: 15.0, top: 15),
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: const BorderSide(color: blueColor),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        'Créer un compte',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/meta.png',
                    height: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Meta",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
