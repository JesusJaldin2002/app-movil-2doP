import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:segundo_parcial_movil/src/screens/login/login_controller.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4F8),
        body: Stack(
          children: [
            _backgroundCover(context),
            _boxForm(context),
            Column(
              children: [_imageCover()],
            ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 120,
          child: _textDontHaveAccount(),
        ),
      ),
    );
  }

  Widget _backgroundCover(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.37,
      color: const Color(0xFF004D40),
    );
  }

  Widget _boxForm(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.34,
            left: 33,
            right: 33),
        height: MediaQuery.of(context).size.height * 0.49,
        decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 15,
                  offset: Offset(0, 0.75))
            ],
            border: Border.all(
              color: const Color(0xFFBDBDBD),
              width: 3,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              _textYourInfo(),
              _textFieldEmail(),
              _textFieldPassword(),
              const SizedBox(height: 20),
              _buttonLogin()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonLogin() {
    return Container(
      margin: const EdgeInsets.only(top: 30, left: 30, right: 30),
      child: ElevatedButton(
        onPressed: () {
          controller.login();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00695C),
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: const Text(
          'Iniciar sesión',
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF)),
        ),
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: const EdgeInsets.only(top: 30, left: 30, right: 30),
      child: TextField(
        controller: controller.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          hintText: 'Correo electrónico',
          icon: Icon(Icons.email, color: Color(0xFF616161)),
          labelText: 'Correo electrónico',
          labelStyle: TextStyle(color: Color(0xFF000000)),
          hintStyle: TextStyle(color: Color(0xFF000000)),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF000000))),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF000000))),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF000000))),
        ),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
      child: TextField(
        controller: controller.passwordController,
        obscureText: true,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          hintText: 'Contraseña',
          icon: Icon(Icons.lock, color: Color(0xFF616161)),
          labelText: 'Contraseña',
          labelStyle: TextStyle(color: Color(0xFF000000)),
          hintStyle: TextStyle(color: Color(0xFF000000)),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF000000))),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF000000))),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF000000))),
        ),
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: const Text(
        'Ingresa tus datos',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF000000)),
      ),
    );
  }

  Widget _imageCover() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 15),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/logo-white.png',
          width: 250,
          height: 220,
        ),
      ),
    );
  }

  Widget _textDontHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('¿No tienes una cuenta?',
            style: TextStyle(color: Colors.black, fontSize: 17)),
        const SizedBox(width: 7),
        GestureDetector(
          onTap: () {
            controller.goToRegisterPage();
          },
          child: const Text(
            'Regístrate aquí',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E88E5),
                fontSize: 17),
          ),
        ),
      ],
    );
  }
}
