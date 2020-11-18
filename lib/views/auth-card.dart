import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth-exception.dart';
import 'package:shop/providers/auth.dart';

enum AuthMode { SignUp, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _form = GlobalKey();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {'email': '', 'password': ''};
  final _passwordController = TextEditingController();

  AnimationController _animationController;
  Animation<double> _animationOpacity;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 300,
        ));

    _animationOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Ocorreu um erro"),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Fechar"),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();

    Auth auth = Provider.of<Auth>(context, listen: false);

    try {
      if (_authMode == AuthMode.Login) {
        await auth.login(
          _authData["email"],
          _authData["password"],
        );
      } else {
        await auth.signup(
          _authData["email"],
          _authData["password"],
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      print(error.toString());
      _showErrorDialog("Ocorreu um erro inesperado");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
        _animationController.forward();
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        margin: EdgeInsets.only(bottom: 20),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        height: _authMode == AuthMode.Login ? 270 : 320,
        child: Form(
            key: _form,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Informe um e-mail válido';
                    }
                    return null;
                  },
                  onSaved: (value) => _authData['email'] = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Senha'),
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Informe uma senha válida';
                    }
                    return null;
                  },
                  onSaved: (value) => _authData['password'] = value,
                ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                    maxHeight: _authMode == AuthMode.SignUp ? 120 : 0,
                    minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                  ),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.linear,
                  child: FadeTransition(
                    opacity: _animationOpacity,
                    child: TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Confirmar Senha'),
                        obscureText: true,
                        validator: _authMode == AuthMode.SignUp
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Senhas são diferentes';
                                }
                                return null;
                              }
                            : null),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                        _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR'),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                    onPressed: _submit,
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 8.0,
                    ),
                  ),
                FlatButton(
                  onPressed: _switchAuthMode,
                  child:
                      Text(_authMode == AuthMode.Login ? 'REGISTRAR' : 'LOGIN'),
                  textColor: Theme.of(context).primaryColor,
                )
              ],
            )),
      ),
    );
  }
}
