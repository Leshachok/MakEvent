import 'package:flutter_test/flutter_test.dart';
import 'package:meeting_app/view/login_screen.dart';

void main(){
  group('LoginScreenState',(){
    test('should fail auth with wrong email', () async{
      final loginScreenState = LoginScreenState();

      String message = await loginScreenState.onLogin("jfdhsgdfgmail.com", "jfgfgdasdasda");

      expect(message, "Введена пошта недійсна!");
    });

    test('should fail auth with short password', () async{
      final loginScreenState = LoginScreenState();

      String message = await loginScreenState.onLogin("jfdhsgdf@gmail.com", "asdasda");

      expect(message, "Пароль має бути більше 7 символів!");
    });

    test('should fail register with wrong email', () async{
      final loginScreenState = LoginScreenState();

      String message = await loginScreenState.onLogin("jfdhsgdfgmail.com", "jfgfgdasdasda");

      expect(message, "Введена пошта недійсна!");
    });

    test('should fail register with short password', () async{
      final loginScreenState = LoginScreenState();

      String message = await loginScreenState.onLogin("jfdhsgdf@gmail.com", "asdasda");

      expect(message, "Пароль має бути більше 7 символів!");
    });
  });
}

