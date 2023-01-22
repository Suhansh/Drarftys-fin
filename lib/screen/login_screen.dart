import 'dart:async';
import 'dart:io';
import 'dart:ui';
import '/custom/loader_custom_widget.dart';
import '/screen/forgotpasswords.dart';
import '/screen/initialize_screen.dart';
import 'otpscreen.dart';
import 'register/registerscreen.dart';
import '/util/constants.dart';
import '/util/preference_utils.dart';
import '/widget/app_lable_widget.dart';
import '/widget/card_password_textfield.dart';
import '/widget/card_textfield.dart';
import '/widget/hero_image_app_logo.dart';
import '/widget/rounded_corner_app_button.dart';
import '/widget/transitions.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'chat/provider/auth_provider_firebase.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<ScaffoldState> globalKeyy = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).deviceToken =
        PreferenceUtils.getString(Constants.deviceToken);
    Constants.checkNetwork().whenComplete(() {
      return Provider.of<AuthProvider>(context, listen: false)
          .callApiForSetting();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    authProvider.textEmail.dispose();
    authProvider.textPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    authProvider.globalKey=globalKeyy;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          key: globalKeyy,
          backgroundColor: Color(Constants.bgblack),
          body: ModalProgressHUD(
            inAsyncCall: authProvider.showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: const CustomLoader(),
            child: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                        child: Container(
                          decoration:
                              const BoxDecoration(color: Colors.black45),
                        ),
                      ),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: ExactAssetImage('images/login_bg_image.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: viewportConstraints.maxHeight),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const HeroImage(),
                              const SizedBox(height: 50.0),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    AppLableWidget(
                                      title: 'Email',
                                    ),
                                    CardTextFieldWidget(
                                      focus: (v) {
                                        FocusScope.of(context).nextFocus();
                                      },
                                      textInputAction: TextInputAction.next,
                                      hintText: 'Email',
                                      textInputType: TextInputType.emailAddress,
                                      textEditingController:
                                          authProvider.textEmail,
                                      validator: Constants.kvalidateEmail,
                                    ),
                                    AppLableWidget(
                                      title: 'Password',
                                    ),
                                    CardPasswordTextFieldWidget(
                                        textEditingController:
                                            authProvider.textPassword,
                                        validator: Constants.kvalidatePassword,
                                        hintText: 'Password',
                                        isPasswordVisible:
                                            authProvider.passwordVisible),
                                    Container(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, right: 10.0, top: 10),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              Transitions(
                                                transitionType:
                                                    TransitionType.slideLeft,
                                                curve: Curves.bounceInOut,
                                                reverseCurve: Curves
                                                    .fastLinearToSlowEaseIn,
                                                widget:
                                                    const ForgotPasswordScreen(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Forgot Password?",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                                color:
                                                    Color(Constants.whitetext),
                                                fontFamily: Constants.appFont),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 10, left: 10, right: 10),
                                        child: RoundedCornerAppButton(
                                          onPressed: () async {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            if (_formKey.currentState!.validate()) {
                                              _formKey.currentState!.save();
                                              if (authProvider.deviceToken == "" && authProvider.deviceToken.isEmpty) {
                                                authProvider.getDeviceToken(PreferenceUtils.getString(Constants.appId), context);
                                              } else {
                                                String email = authProvider
                                                    .textEmail.text.toString();
                                                String password = authProvider
                                                    .textPassword.text.toString();
                                                // 0 no screen change
                                                // 1 initialize if verify
                                                // 2 otpScreen if not verify
                                                // 3 error
                                                await authProvider.callApiForLogin(email,
                                                            password, authProvider.deviceToken,);
                                              }
                                            } else {
                                              authProvider.autoValidate = true;
                                              authProvider.notify();
                                            }
                                          },
                                          btnLabel: 'Login',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(Transitions(
                                            transitionType:
                                                TransitionType.slideUp,
                                            curve: Curves.bounceInOut,
                                            reverseCurve:
                                                Curves.fastLinearToSlowEaseIn,
                                            widget: const RegisterScreen()));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Don\'t have an account ? ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: Constants.appFont),
                                          ),
                                          Text(
                                            'Register ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: Constants.appFont),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(Transitions(
                                            transitionType:
                                                TransitionType.slideUp,
                                            curve: Curves.bounceInOut,
                                            reverseCurve:
                                                Curves.fastLinearToSlowEaseIn,
                                            widget: InitializeScreen(0)));
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'skip login',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontFamily: Constants.appFont,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  icon: const Text("NO")),
              const SizedBox(height: 16),
              IconButton(
                  onPressed: () {
                    exit(0);
                  },
                  icon: const Text("YES")),
            ],
          ),
        )) ??
        false as Future<bool>;
  }
}
