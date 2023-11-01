import 'package:flutter/material.dart';
import '../../services/authService.dart';
import '../../shared/loading.dart';

class UserRegister extends StatefulWidget {

  final AuthService auth;

  const UserRegister({super.key, required this.auth});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _securePasswordController = TextEditingController();
  late String _errorText = '';
  bool _isLoading = false; // Add this line

  Future<void> _register() async {
    if (_formKey.currentState!.validate() == true) {
      setState(() {
        _isLoading = true;
      });
      String registration = await widget.auth.registerWithEmailAndPass(
        emailAddress: _emailController.text,
        password: _passwordController.text,
      );
      if (registration == 'Success') {
        Navigator.pop(context);
      } else {
        setState(() {
          _errorText = registration;
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Text(_emailController.text),
            Text(_passwordController.text),
            Text(_securePasswordController.text)
          ],
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Registro de usuario',
          ),
          backgroundColor: Colors.green[700],
        ),
        backgroundColor: Colors.white,
        body: _isLoading
            ? const Loading() // Add this line
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 3,
                      child: const FlutterLogo(),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Email',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.black,
                                  ),
                                  child: TextFormField(
                                    controller: _emailController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.white,
                                      ),
                                      hintText: 'Email',
                                      hintStyle: TextStyle(color: Colors.white),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor introduzca su correo electrónico.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  'Contraseña',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.black,
                                  ),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                                      hintText: 'Contraseña',
                                      hintStyle: TextStyle(color: Colors.white),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, introduzca su contraseña.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  'Reingresar Contraseña',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.black,
                                  ),
                                  child: TextFormField(
                                    controller: _securePasswordController,
                                    obscureText: true,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                                      hintText: 'Reingresar Contraseña',
                                      hintStyle: TextStyle(color: Colors.white),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, introduzca otra vez su contraseña.';
                                      } else if (value !=
                                          _passwordController.text) {
                                        return 'Las contraseñas no coinciden.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 35),
                                GestureDetector(
                                  onTap: _register,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.black,
                                    ),
                                    child: const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'Crear Cuenta',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  _errorText,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
