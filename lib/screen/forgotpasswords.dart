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
import '/widget/card_textfield.dart';
import '/widget/rounded_corner_app_button.dart';
import '/widget/app_toolbar.dart';
import '/widget/transitions.dart';
import '/screen/forgototp.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreen createState() => _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen> {
  bool isRememberMe = false;

  final textEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  String deviceToken = "";

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
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
          appBar: ApplicationToolbar(appbarTitle: 'Forgot Password'),
          backgroundColor: Color(Constants.bgblack),
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: const CustomLoader(),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints viewportConstraints) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AppLableWidget(
                                title: 'Email Address',
                              ),
                              CardTextFieldWidget(
                                focus: (v) {
                                  FocusScope.of(context).nextFocus();
                                },
                                textInputAction: TextInputAction.next,
                                hintText: 'Email Address',
                                textInputType: TextInputType.emailAddress,
                                textEditingController: textEmail,
                                validator: Constants.kvalidateEmail,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10, top: 20, right: 10),
                                child: AppLableWidget(
                                  title:
                                      'Check your mail ID we will share with you a one OTP password in your email account as you above.',
                                ),
                              ),
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
                          margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: RoundedCornerAppButton(
                            onPressed: () {
                              //set the form field in all tabs
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                Constants.checkNetwork().then((value) => callApiForForgotEmail());
                              }
                            },
                            btnLabel: 'Submit',
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

  void callApiForForgotEmail() {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData()).sendotp(textEmail.text).then((response) {
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }

      if (success == true) {
        setState(() {
          showSpinner = false;
        });
        textEmail.clear();
        var msg = body['msg'];
        Constants.toastMessage(msg);
        var userId = body['data']['id'];
        Navigator.of(context).push(Transitions(
            transitionType: TransitionType.slideLeft,
            curve: Curves.bounceInOut,
            reverseCurve: Curves.fastLinearToSlowEaseIn,
            widget: ForgotOtpScreen(
              userId: userId,
            )));
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
