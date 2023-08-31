import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_one/data_base.dart';
import 'package:flutter_one/main.dart';
import 'package:flutter_one/session.dart';
import 'package:flutter_one/user.dart';
import 'package:flutter_one/util.dart';
import 'package:flutter_one/user_role.dart';
import 'package:flutter_one/custom_alert_dialog.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  String email = '';
  String password = '';

  void addUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Введите данные",
        "Проверьте ввод почты и пароля",
        snackPosition:
        SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } else {
      if (await DataBase().hasUser(email)) {
        Get.snackbar(
          "Пользователь с такой почтой уже существует",
          "Попробуйте войти, введя пароль",
          snackPosition:
          SnackPosition.TOP,
          duration: const Duration(seconds: 5),
        );
      } else {
        User user = User(
            email: email,
            password: password
        );
        await DataBase().insertUser(user);
        user = (await DataBase().getUserByEmail(user.email!))!;
        int? userRoleId = await DataBase().getIdByUserRole(Util.defaultRole);
        await DataBase().insertUserRole(user.getId!, userRoleId!);
        Session.getInstance().login(user, Util.defaultRole);
        Get.snackbar(
          "Вы успешно зарегистрировались в приложении",
          "Продолжайте покупки",
          snackPosition:
          SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    }
  }

  void forgetPassword() async {
    if (email.isEmpty) {
      Get.snackbar(
        "Введите почту",
        "Проверьте ввод почты",
        snackPosition:
        SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } else if (!(await DataBase().hasUser(email))) {
      Get.snackbar(
        "Пользователя с такой почтой не существует",
        "Проверьте правильность введения почты",
        snackPosition:
        SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    } else {
      String? userPassword = await DataBase().getPasswordByEmail(email);
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
      Get.snackbar(
        "Введите данные",
        "Проверьте ввод почты и пароля",
        snackPosition:
        SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } else {
      if (!(await DataBase().hasUser(email))) {
        Get.snackbar(
          "Пользователя с такой почтой не существует",
          "Проверьте правильность введения почты",
          snackPosition:
          SnackPosition.TOP,
          duration: const Duration(seconds: 5),
        );
      } else {
        String? storedPassword = await DataBase().getPasswordByEmail(email);
        if (storedPassword == password) {
          User? user = await DataBase().getUserByEmail(email);
          int? roleId = await DataBase().getRoleIdByUserId(user!.getId!);
          UserRole? role = await DataBase().getUserRoleById(roleId!);
          Session.getInstance().login(user, role!);
          Get.snackbar(
            "Вы вошли!",
            "Начинайте закупаться энергетиками!",
            snackPosition:
            SnackPosition.TOP,
            duration: const Duration(seconds: 5),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        } else {
          Get.snackbar(
            "Неверный пароль",
            "Проверьте правильность введения пароля или сбросьте его",
            snackPosition:
            SnackPosition.TOP,
            duration: const Duration(seconds: 5),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF6e7582),
      ),
      home: Scaffold (
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Регистрация'),
          backgroundColor: Color(0xFF6e7582),
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
                  color: Color(0xFFf39189),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFbb8082),
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
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(2),
                            child: Text(
                              '${Session.getInstance().getUser()!.getEmail}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
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
                                    color: Colors.black,
                                    fontSize: 15),
                              ),
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.black,
                                elevation: 15,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(25),
                                ),
                                backgroundColor:
                                Color(0xFF7D9295),
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
                                      color: Colors.black,
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
                              color: Colors.black,
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
                              BorderSide(width: 2, color: Color(0xFF6e7582)),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(borderSide:
                            BorderSide(width: 2, color: Color(0xFF6e7582)),
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
                              BorderSide(width: 2, color: Color(0xFF6e7582)),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(borderSide:
                            BorderSide(width: 2, color: Color(0xFF6e7582)),
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
                                color: Colors.black,
                                fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.black,
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(25),
                            ),
                            backgroundColor:
                            Color(0xFF7D9295),
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
                              color: Colors.black,
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
                                color: Colors.black,
                                fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.black,
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(25),
                            ),
                            backgroundColor:
                            Color(0xFF7D9295),
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
                                  color: Colors.black,
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
      ),
    );
  }
}


