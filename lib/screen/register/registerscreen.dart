import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../initialize_screen.dart';
import '../otpscreen.dart';
import '/custom/loader_custom_widget.dart';
import '/screen/login_screen.dart';
import '/util/constants.dart';
import '/widget/app_lable_widget.dart';
import '/widget/app_toolbar.dart';
import '/widget/card_password_textfield.dart';
import '/widget/card_textfield.dart';
import '/widget/rounded_corner_app_button.dart';
import '/widget/transitions.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'register_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  late RegisterProvider registerProvider;

  @override
  Widget build(BuildContext context) {
    registerProvider = Provider.of<RegisterProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          appBar: ApplicationToolbar(appbarTitle: 'Create New Account'),
          backgroundColor: Color(Constants.bgblack),
          body: ModalProgressHUD(
            inAsyncCall: registerProvider.showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: const CustomLoader(),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
                    child: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppLableWidget(
                              title: 'Username',
                            ),
                            CardTextFieldWidget(
                              focus: (v) {
                                FocusScope.of(context).nextFocus();
                              },
                              textInputAction: TextInputAction.next,
                              hintText: 'Username',
                              textInputType: TextInputType.name,
                              textEditingController: registerProvider.textUsername,
                              validator: Constants.kvalidateUserName,
                            ),
                            const AppLableWidget(
                              title: 'Name',
                            ),
                            CardTextFieldWidget(
                              focus: (v) {
                                FocusScope.of(context).nextFocus();
                              },
                              textInputAction: TextInputAction.next,
                              hintText: 'Name',
                              textInputType: TextInputType.name,
                              textEditingController: registerProvider.textName,
                              validator: Constants.kvalidateName,
                            ),
                            const AppLableWidget(
                              title: 'Email Address',
                            ),
                            CardTextFieldWidget(
                              focus: (v) {
                                FocusScope.of(context).nextFocus();
                              },
                              textInputAction: TextInputAction.next,
                              hintText: 'Email Address',
                              textInputType: TextInputType.emailAddress,
                              textEditingController: registerProvider.textEmail,
                              validator: Constants.kvalidateEmail,
                            ),
                            const AppLableWidget(
                              title: 'Contact Number',
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 20.0, right: 20),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: ScreenUtil().setWidth(60),
                                    margin: const EdgeInsets.only(left: 5, right: 5),
                                    child: CountryCodePicker(
                                      onChanged: (c) {
                                        registerProvider.strCountryCode = c.dialCode;
                                        if (kDebugMode) {
                                          print(
                                              "strCountryCode:${registerProvider.strCountryCode}");
                                        }
                                        registerProvider.notify();
                                      },
                                      textStyle: TextStyle(
                                        color: Color(Constants.whitetext),
                                      ),
                                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                      initialSelection: 'IN',
                                      favorite: const ['+91', 'IN'],
                                      // optional. Shows only country name and flag
                                      showCountryOnly: false,
                                      showFlag: false,
                                      // optional. Shows only country name and flag when popup is closed.
                                      showOnlyCountryWhenClosed: false,
                                      // optional. aligns the flag and the Text left
                                      alignLeft: false,
                                    ),
                                  ),
                                  Container(
                                    width: ScreenUtil().setWidth(5),
                                    height: 15,
                                    margin:
                                        const EdgeInsets.only(left: 5, right: 0, top: 0, bottom: 0),
                                    alignment: Alignment.center,
                                    child: VerticalDivider(
                                      color: Color(Constants.whitetext),
                                      width: 1,
                                      thickness: 1,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 9,
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 0, right: 0),
                                      child: CardTextFieldWidget(
                                        focus: (v) {
                                          FocusScope.of(context).nextFocus();
                                        },
                                        textInputAction: TextInputAction.next,
                                        hintText: 'Contact Number',
                                        textInputType: TextInputType.number,
                                        textEditingController: registerProvider.textContact,
                                        validator: Constants.kvalidateCotactNum,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const AppLableWidget(
                              title: 'Password',
                            ),
                            CardPasswordTextFieldWidget(
                                textEditingController: registerProvider.textPassword,
                                validator: Constants.kvalidatePassword,
                                hintText: 'Password',
                                isPasswordVisible: registerProvider.passwordVisible),
                            const AppLableWidget(
                              title: 'Confirm Password',
                            ),
                            CardPasswordTextFieldWidget(
                                textEditingController: registerProvider.textConfPassword,
                                validator: registerProvider.validateConfPassword,
                                hintText: 'Confirm Password',
                                isPasswordVisible: registerProvider.confirmPasswordVisible),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                child: RoundedCornerAppButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState!.save();
                                      String name = registerProvider.textName.text.toString();
                                      String userId = registerProvider.textUsername.text.toString();
                                      String email = registerProvider.textEmail.text.toString();
                                      String phone = registerProvider.textContact.text.toString();
                                      String password =
                                          registerProvider.textPassword.text.toString();
                                      String confirmPassword =
                                          registerProvider.textConfPassword.text.toString();
                                      if (registerProvider.strCountryCode != null ||
                                          registerProvider.strCountryCode!.isNotEmpty) {
                                        String? code = registerProvider.strCountryCode;

                                        // 0 no screen change
                                        // 1 initialize if verify
                                        // 2 otpScreen if not verify
                                        // 3 error
                                        int navigate = await registerProvider.callApiForRegister(
                                            name,
                                            userId.trim(),
                                            email,
                                            code,
                                            phone,
                                            password,
                                            confirmPassword,
                                            context);
                                        if(navigate == 0){

                                        }else if (navigate == 1){
                                          Navigator.push(
                                            this.context,
                                            MaterialPageRoute(builder: (context) => InitializeScreen(0)),
                                          );
                                        }else if(navigate == 2){
                                          Navigator.of(this.context).push(Transitions(
                                              transitionType: TransitionType.slideUp,
                                              curve: Curves.bounceInOut,
                                              reverseCurve: Curves.fastLinearToSlowEaseIn,
                                              widget: const OtpScreen()));
                                        }else if (navigate == 3){

                                        }


                                      }
                                    } else {
                                      registerProvider.autoValidate = true;
                                      registerProvider.notify();
                                    }
                                  },
                                  btnLabel: 'Create Account',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(Transitions(
                                    transitionType: TransitionType.slideDown,
                                    curve: Curves.bounceInOut,
                                    reverseCurve: Curves.fastLinearToSlowEaseIn,
                                    widget: const LoginScreen()));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already an account ? ',
                                    style: TextStyle(
                                        color: Colors.white, fontFamily: Constants.appFont),
                                  ),
                                  Text(
                                    'Login',
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
                          ],
                        ),
                      ),
                    ),
                  ),
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
}
