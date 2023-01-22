import '/custom/loader_custom_widget.dart';
import 'package:flutter/foundation.dart';
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
import '/screen/login_screen.dart';
import '/apiservice/Apiservice.dart';
import '/apiservice/Api_Header.dart';
import '/util/preference_utils.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  _OtpScreen createState() => _OtpScreen();
}

class _OtpScreen extends State<OtpScreen> {
  final _textOtp = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
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
          appBar: ApplicationToolbar(appbarTitle: 'Set OTP'),
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
                          autovalidateMode: AutovalidateMode.always,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AppLableWidget(
                                title: 'One Time Password',
                              ),
                              CardTextFieldWidget(
                                focus: (v) {
                                  FocusScope.of(context).nextFocus();
                                },
                                textInputAction: TextInputAction.next,
                                hintText: 'Set Your OTP Here',
                                textInputType: TextInputType.number,
                                textEditingController: _textOtp,
                                validator: Constants.kvalidateotp,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10, top: 20, right: 10),
                                child: AppLableWidget(
                                  title:
                                      'Set your OTP(One Time Password) here which one mention on your mail.',
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              const SizedBox(height: 10.0),
                              const SizedBox(height: 50),
                              Container(
                                margin: const EdgeInsets.only(top: 10, bottom: 20),
                                alignment: Alignment.center,
                                child: InkWell(
                                    onTap: () {
                                      Constants.checkNetwork()
                                          .whenComplete(() => callApiForResendOtp(context));
                                    },
                                    child: Text(
                                      "Resend OTP!!!",
                                      style: TextStyle(
                                          color: Color(Constants.whitetext),
                                          fontSize: 18,
                                          fontFamily: Constants.appFontBold),
                                    )),
                              )
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
                              // if (_formKey.currentState!.validate()) {
                              //   _formKey.currentState!.save();
                              // } else {
                              //   setState(() {
                              //     _autoValidate = true;
                              //   });
                              // }
                              String otp = _textOtp.text.toString();
                              Constants.checkNetwork()
                                  .whenComplete(() => callApiForCheckOtp(otp, context));
                            },
                            btnLabel: 'Continue',
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

  Future<bool> _onWillPop() async {
    return true;
  }

  Future<void> callApiForCheckOtp(String otp, BuildContext context) async {
    String userid = PreferenceUtils.getString(Constants.serverUserId);
    if (kDebugMode) {
      print("userid:$userid");
    }
    setState(() {
      showSpinner = true;
    });
    await RestClient(ApiHeader().dioData()).checkOtp(otp, userid).then((response) {
      if (kDebugMode) {
        print(response.toString());
      }
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }
      if (success == true) {
        setState(() {
          showSpinner = false;
        });
        var token = body['data']['token'];
        Constants.toastMessage("OTP Match");
        PreferenceUtils.setString(Constants.headerToken, token);
        if (kDebugMode) {
          print(token);
        }
        PreferenceUtils.setString(Constants.serverUserId, body['data']['id'].toString());
        PreferenceUtils.setString(Constants.name, body['data']['name']);
        PreferenceUtils.setString(Constants.userId, body['data']['user_id']);
        PreferenceUtils.setBool(Constants.isverified, true);
        Navigator.of(this.context).push(Transitions(
            transitionType: TransitionType.slideUp,
            curve: Curves.bounceInOut,
            reverseCurve: Curves.fastLinearToSlowEaseIn,
            widget: const LoginScreen()));
      } else if (success == false) {
        setState(() {
          showSpinner = false;
        });
        var msg = body['msg'];
        Constants.toastMessage(body['msg'].toString());
        if (kDebugMode) {
          print(msg);
        }
        // Constants.createSnackBar(msg, context, Color(Constants.redtext));
      }
    }).catchError((Object obj) {
      setState(() {
        showSpinner = false;
      });

      if (kDebugMode) {
        print("error:$obj.");
        print(obj.runtimeType);
      }

      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          if (kDebugMode) {
            print(res);
          }

          var responseCode = res.statusCode;

          if (responseCode == 401) {
            if (kDebugMode) {
              print("Got error : ${res.statusCode} -> ${res.statusMessage}");
            }
            setState(() {
              showSpinner = false;
            });
          } else if (responseCode == 422) {
            if (kDebugMode) {
              print("Invalid Data");
            }
            setState(() {
              showSpinner = false;
            });
          }

          break;
        default:
          setState(() {
            showSpinner = false;
          });
      }
    });
  }

  Future<void> callApiForResendOtp(BuildContext context) async {
    String userEmail = PreferenceUtils.getString(Constants.email);
    if (kDebugMode) {
      print("userid:$userEmail");
    }

    setState(() {
      showSpinner = true;
    });
    await RestClient(ApiHeader().dioData()).sendotp(userEmail).then((response) {
      if (kDebugMode) {
        print(response.toString());
      }
      final body = json.decode(response!);
      bool? success = body['success'];
      if (kDebugMode) {
        print(success);
      }

      if (success == true) {
        setState(() {
          showSpinner = false;
        });

        Constants.toastMessage("OTP sended");
        Constants.createSnackBar("OTP sended", context, Color(Constants.lightbluecolor));
      } else if (success == false) {
        setState(() {
          showSpinner = false;
        });
        var msg = body['msg'];
        if (kDebugMode) {
          print(msg);
        }
        Constants.createSnackBar(msg, context, Color(Constants.redtext));
      }
    }).catchError((Object obj) {
      setState(() {
        showSpinner = false;
      });

      if (kDebugMode) {
        print("error:$obj.");
        print(obj.runtimeType);
      }

      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;
          if (kDebugMode) {
            print(res);
          }

          var responseCode = res.statusCode;

          if (responseCode == 401) {
            if (kDebugMode) {
              print("Got error : ${res.statusCode} -> ${res.statusMessage}");
            }
            setState(() {
              showSpinner = false;
            });
          } else if (responseCode == 422) {
            if (kDebugMode) {
              print("Invalid Data");
            }
            setState(() {
              showSpinner = false;
            });
          }

          break;
        default:
          setState(() {
            showSpinner = false;
          });
      }
    });
  }
}
