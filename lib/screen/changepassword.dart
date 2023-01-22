import 'package:flutter/foundation.dart';
import '/apiservice/Api_Header.dart';
import '/apiservice/Apiservice.dart';
import '/custom/loader_custom_widget.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '/util/constants.dart';
import '/widget/app_lable_widget.dart';
import '/widget/card_password_textfield.dart';
import '/widget/rounded_corner_app_button.dart';
import '/widget/app_toolbar.dart';
import '/widget/transitions.dart';
import '/screen/login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  final userId;

  const ChangePasswordScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  _ChangePasswordScreen createState() => _ChangePasswordScreen();
}

class _ChangePasswordScreen extends State<ChangePasswordScreen> {
  bool isRememberMe = false;

  final textNewPassword = TextEditingController();
  final textConfirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  String deviceToken = "";
  bool passwordVisible = true;
  bool confirmPasswordVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
  }

  String? validateConfPassword(String? value) {
    Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
    RegExp regex = RegExp(pattern as String);
    if (value!.isEmpty) {
      return "Password is Required";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters";
    } else if (textNewPassword.text != textConfirmPassword.text) {
      return 'Password and Confirm Password does not match.';
    } else if (!regex.hasMatch(value)) {
      return 'Password required';
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          appBar: ApplicationToolbar(appbarTitle: 'Set New Password'),
          backgroundColor: Color(Constants.bgblack),
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: const CustomLoader(),
            child: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: viewportConstraints.maxHeight),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AppLableWidget(
                                title: 'New Password',
                              ),
                              CardPasswordTextFieldWidget(
                                  textEditingController: textNewPassword,
                                  validator: Constants.kvalidatePassword,
                                  hintText: 'New Password',
                                  isPasswordVisible: passwordVisible),
                              AppLableWidget(
                                title: 'Confirm Password',
                              ),
                              CardPasswordTextFieldWidget(
                                  textEditingController: textConfirmPassword,
                                  validator: validateConfPassword,
                                  hintText: 'Confirm Password',
                                  isPasswordVisible: confirmPasswordVisible),
                              const SizedBox(height: 20.0),
                              const SizedBox(height: 10.0),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: RoundedCornerAppButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                callApiForChangePassword();
                              }
                            },
                            btnLabel: 'Change Password',
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void callApiForChangePassword() {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData())
        .changePassword(widget.userId.toString(), textNewPassword.text,
            textConfirmPassword.text)
        .then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }
      if (success == true) {
        setState(() {
          showSpinner = false;
        });
        textNewPassword.clear();
        textConfirmPassword.clear();
        var msg = body['msg'];
        Constants.toastMessage(msg);
        Navigator.of(context).push(Transitions(
            transitionType: TransitionType.slideRight,
            curve: Curves.bounceInOut,
            reverseCurve: Curves.fastLinearToSlowEaseIn,
            widget: const LoginScreen()));
      } else if (success == false) {
        setState(() {
          showSpinner = false;
        });
        var msg = body['msg'];
        if (kDebugMode) {
          print(msg);
        }
        Constants.toastMessage(msg);
      }
    }).catchError((Object obj) {
      if (kDebugMode) {
        print(obj.toString());
      }
      Constants.toastMessage(obj.toString());
      if (mounted) {
        setState(() {
          showSpinner = false;
        });
      }
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          var msg = res.statusMessage;
          var responseCode = res.statusCode;
          if (responseCode == 401) {
            Constants.toastMessage('$responseCode');
            if (kDebugMode) {
              print(responseCode);
              print(res.statusMessage);
            }
          } else if (responseCode == 422) {
            if (kDebugMode) {
              print("code:$responseCode");
              print("msg:$msg");
            }
            Constants.toastMessage('$responseCode');
          } else if (responseCode == 500) {
            if (kDebugMode) {
              print("code:$responseCode");
              print("msg:$msg");
            }
            Constants.toastMessage('InternalServerError');
          }
          break;
        default:
      }
    });
  }

  Future<bool> _onWillPop() async {
    return true;
  }
}
