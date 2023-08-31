import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_one/registration_page.dart';

class CustomAlertDialog extends StatelessWidget {
  final String messageTitle;
  final String messageContent;
  final bool showSecondButton;

  CustomAlertDialog({required this.messageTitle, required this.messageContent, required this.showSecondButton});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(messageTitle, textAlign: TextAlign.center,),
      content: Text(messageContent, textAlign: TextAlign.center,),
      backgroundColor: Color(0xFFf39189),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))
      ),
      actions: <Widget>[
        Center(child: Row(
          children: [
            showSecondButton ?
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistrationPage(),
                  ),
                );
              },
              child: Text('Войти или зарегистрироваться', style: TextStyle(color: Color(0xff4c5059)),),
            ) : Container(),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Закрыть', style: TextStyle(color: Color(0xff4c5059)),),
            ),
          ],
        ),
        ),
      ],
    );
  }
}