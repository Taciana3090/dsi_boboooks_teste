import 'package:flutter/material.dart';
import 'package:dsi_bobooks/service/auth.dart';

class ForgotPassword extends StatefulWidget {
  final String docId;
  ForgotPassword({this.docId});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  AuthMethods authMethods = new AuthMethods();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      // color: Colors.,
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Por favor digite o seu email',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.purple[900],
                // decoration: TextDecoration.underline,
              ),
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                  autofocus: true,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.emailAddress,
                  controller: myController,
                  textAlign: TextAlign.center,
                  validator: (input) {
                    return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(input)
                        ? null
                        : 'Digite um endereço de email válido';
                  }),
            ),
            TextButton(
              child: Text(
                'Enviar link de redefinição',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

                  try {
                    authMethods.resetPassword(myController.text);
                  } catch (e) {
                    print(e.toString());
                  }

                  Navigator.pop(context, true);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
