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
import '/screen/changepassword.dart';

class ForgotOtpScreen extends StatefulWidget {
  final userId;

  const ForgotOtpScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ForgotOtpScreen createState() => _ForgotOtpScreen();
}

class _ForgotOtpScreen extends State<ForgotOtpScreen> {
  bool isRememberMe = false;

  final textOtp = TextEditingController();
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
          appBar: ApplicationToolbar(appbarTitle: 'Enter OTP'),
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
                                title: 'One Time Password',
                              ),
                              CardTextFieldWidget(
                                focus: (v) {
                                  FocusScope.of(context).nextFocus();
                                },
                                textInputAction: TextInputAction.next,
                                hintText: 'Enter Your OTP Here',
                                textInputType: TextInputType.number,
                                textEditingController: textOtp,
                                validator: Constants.kvalidateotp,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10, top: 20, right: 10),
                                child: AppLableWidget(
                                  title:
                                      'Enter your OTP(One Time Password) here which one mention on your mail.',
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
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
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                Constants.checkNetwork().then((value) => callApiForCheckOtp());
                              }
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

  void callApiForCheckOtp() {
    setState(() {
      showSpinner = true;
    });
    RestClient(ApiHeader().dioData())
        .checkOtp(textOtp.text, widget.userId.toString())
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
        textOtp.clear();
        var msg = body['msg'];
        Constants.toastMessage(msg);
        Navigator.of(context).push(Transitions(
            transitionType: TransitionType.slideLeft,
            curve: Curves.bounceInOut,
            reverseCurve: Curves.fastLinearToSlowEaseIn,
            widget: ChangePasswordScreen(
              userId: widget.userId,
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
