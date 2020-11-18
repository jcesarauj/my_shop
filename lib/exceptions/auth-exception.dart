class AuthException implements Exception {
  static const Map<String, String> errors = {
    "EMAIL_EXISTS": "E-mail já cadastrado",
    "OPERATION_NOT_ALLOWED": "Operação não permitida",
    "TOO_MANY_ATTEMPS_TRY_LATER": "Tente mais tarde",
    "EMAIL_NOT_FOUND": "Email não encontrado",
    "INVALID_PASSWORD": "Email ou senha inválido",
    "USER_DISABLED": "Usuário desabilitado",
    "INVALID_EMAIL": "Email inválido"
  };

  final String key;

  const AuthException(this.key);

  @override
  String toString() {
    if (errors.containsKey(key)) {
      return errors[key];
    } else {
      return 'Ocorreu um erro na autenticação';
    }
  }
}
