import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_one/utils/app_colors.dart';
import 'package:flutter_one/data_layer/data_base.dart';
import 'package:flutter_one/presentation_layer/main.dart';
import 'package:flutter_one/data_layer/session.dart';
import 'package:flutter_one/utils/util.dart';
import 'package:flutter_one/presentation_layer/custom_alert_dialog.dart';
import '../domain_layer/user.dart';
import '../domain_layer/user_role.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  String email = '';
  String password = '';

  void addUser(String email, String password) async{
    if (email.isEmpty || password.isEmpty) {
      showCustomSnackBar(context, 'Введите данные');
    } else {
      if (await DataBase().hasUser(email)) {
        showCustomSnackBar(context, 'Пользователь с такой почтой уже существует');
      } else {
        signUp(email, password);
        Flushbar(
          duration: Duration(seconds: 3),
          title:  "Вы зарегистрировались!",
          message: "Удачных покупок",
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: AppColors.light_color,
        )..show(context);
        showCustomSnackBar(context, 'Вы зарегистрировались!');
      }
    }
  }

  void signUp(String email, String password) async {
    User user = User(
        email: email,
        password: password,
        role: Util.getStringByUserRole(Util.defaultRole),
    );
    await DataBase().insertUser(user);
    Session.getInstance().login(user, Util.defaultRole);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  void logIn(String email, String password) async {
    User? user = await DataBase().getUserByEmail(email);
    // int? roleId = await DataBase().getRoleIdByUserId(user!.getId!);
    UserRole? role = Util.getUserRoleByString((await DataBase().getRoleByEmail(email))!);
    Session.getInstance().login(user!, role!);
  }

  Future<String?> checkPassword(String email) async{
    String? storedPassword = await DataBase().getPasswordByEmail(email);
    return storedPassword;
  }

  void forgetPassword() async {
    if (!Session.getInstance().isAuthenticated()) {
      if (email.isEmpty) {
        showCustomSnackBar(context, 'Введите почту');
      } else if (!(await DataBase().hasUser(email))) {
        showCustomSnackBar(
            context, 'Пользователя с такой почтой не существует');
      }
      else {
        String? userPassword = await DataBase().getPasswordByEmail(email);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomAlertDialog(messageTitle: 'Ваш пароль', messageContent: userPassword!, showSecondButton: false);
          },
        );
      }
    }else {
      String userEmail = Session.getInstance().getUser()!.getEmail!;
      String? userPassword = await DataBase().getPasswordByEmail(userEmail);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(messageTitle: 'Ваш пароль', messageContent: userPassword!, showSecondButton: false);
        },
      );
    }
  }

  void signUser (String email, String password) async{
    if (email.isEmpty || password.isEmpty) {
      showCustomSnackBar(context, 'Введите данные');
    } else {
      if (!(await DataBase().hasUser(email))) {
        showCustomSnackBar(context, 'Пользователя с такой почтой не существует');
      } else {
        if (await checkPassword(email) == password) {
          logIn(email, password);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
          Flushbar(
            duration: Duration(seconds: 3),
            title: "Вы вошли!",
            message: "Удачных покупок",
            backgroundColor: AppColors.light_color,
            flushbarPosition: FlushbarPosition.TOP,
          )..show(context);
          showCustomSnackBar(context, 'Вы вошли!');
        } else {
          showCustomSnackBar(context, 'Неверный пароль');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Регистрация'),
        backgroundColor: AppColors.background,
        centerTitle: true,
      ),
        body: GestureDetector (
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Padding (
            padding: EdgeInsets.all(5),
            child: Center(
              child: Container(
                width: double.infinity,
                height: 450,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.items_back,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadows,
                      blurRadius: 4,
                      offset: Offset(4, 8),
                    ),
                  ],
                ),
                child: Padding (
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                  child: Session.getInstance().isAuthenticated() ?
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.all(5),
                            child: Text(
                              'Вы вошли под именем',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.main_font_color,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(2),
                            child: Text(
                              '${Session.getInstance().getUser()!.getEmail}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.main_font_color,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 10), child:
                          SizedBox(
                            width: 100,
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {
                                Session.getInstance().logout();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Выйти',
                                style: TextStyle(
                                    color: AppColors.main_font_color,
                                    fontSize: 15),
                              ),
                              style: ElevatedButton.styleFrom(
                                shadowColor: AppColors.main_font_color,
                                elevation: 15,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(25),
                                ),
                                backgroundColor:
                                AppColors.light_color,
                                minimumSize: Size(20, 20),
                              ),
                            ),
                          ),),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                                height: 40,
                                child: InkWell(
                                  child: Text(
                                    'Забыли пароль?',
                                    style: TextStyle(
                                      color: AppColors.main_font_color,
                                      fontSize: 20,
                                      decoration: TextDecoration.underline
                                    ),
                                  ),
                                  onTap: () {
                                    forgetPassword();
                                  },
                                )
                            ),
                          ),
                        ],
                      ),
                    )
                  :
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:
                    [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Container(
                          height: 35,
                          child: Text(
                            'Войти или зарегистрироваться',
                            style: TextStyle(
                              color: AppColors.main_font_color,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 5, left: 5, bottom: 5),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Почта',
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 2, color: AppColors.light_color),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(borderSide:
                            BorderSide(width: 2, color: AppColors.light_color),
                              borderRadius: BorderRadius.circular(50.0),),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Пароль',
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 2, color: AppColors.light_color),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(borderSide:
                            BorderSide(width: 2, color: AppColors.light_color),
                              borderRadius: BorderRadius.circular(50.0),),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            signUser(email, password);
                          },
                          child: Text(
                            'Войти',
                            style: TextStyle(
                                color: AppColors.main_font_color,
                                fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            shadowColor: AppColors.main_font_color,
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(25),
                            ),
                            backgroundColor:
                            AppColors.light_color,
                            minimumSize: Size(50, 50),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Container(
                          height: 20,
                          child: Text(
                            'ИЛИ',
                            style: TextStyle(
                              color: AppColors.main_font_color,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            addUser(email, password);
                          },
                          child: Text(
                            'Зарегистрироваться',
                            style: TextStyle(
                                color: AppColors.main_font_color,
                                fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            shadowColor: AppColors.main_font_color,
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(25),
                            ),
                            backgroundColor:
                            AppColors.light_color,
                            minimumSize: Size(50, 50),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: Container(
                            height: 35,
                            child: InkWell(
                              child: Text(
                                'Забыли пароль?',
                                style: TextStyle(
                                  color: AppColors.main_font_color,
                                  fontSize: 20,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              onTap: () {
                                forgetPassword();
                              },
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: bottomNavigationBar(context),
    );
  }

  Container bottomNavigationBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.light_color.withOpacity(0.25),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              enableFeedback: false,
              onPressed: () {},
              icon: const Icon(
                Icons.account_circle,
                color: AppColors.light_color,
                size: 35,
              )
          ),
          IconButton(
              enableFeedback: false,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              icon: const Icon(
                Icons.store,
                color: AppColors.light_color,
                size: 35,
              )
          ),
        ],
      ),
    );
  }

  void showCustomSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message, style: TextStyle(color: AppColors.white)),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 145,
              left: 10,
              right: 10,
            ),
            backgroundColor: AppColors.light_color,
          ),
        ));
  }
}


