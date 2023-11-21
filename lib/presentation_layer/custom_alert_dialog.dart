import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_one/utils/app_colors.dart';
import 'package:flutter_one/presentation_layer/registration_page.dart';

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
      backgroundColor: AppColors.items_back,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))
      ),
      actions: <Widget>[
        Center(
          child: ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              showSecondButton ?
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrationPage(),
                        ),
                      );
                    },
                    child: Text('Войти или зарегистрироваться', style: TextStyle(color: AppColors.main_font_color, fontSize: 11,)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Закрыть', style: TextStyle(color: AppColors.main_font_color, fontSize: 11),),
                  )
                ],
              ) :
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Закрыть', style: TextStyle(color: AppColors.main_font_color),),
              ),
            ],
          ),
        ),
      ],
    );
  }

}