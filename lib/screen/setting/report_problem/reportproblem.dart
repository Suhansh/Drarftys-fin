import '/screen/setting/report_problem/report_problem_provider.dart';
import 'package:provider/provider.dart';
import '/custom/loader_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/util/constants.dart';
import '/widget/app_lable_widget.dart';
import '/widget/card_textfield.dart';
import '/widget/rounded_corner_app_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ReportProblemScreen extends StatefulWidget {
  final int? userId;
  const ReportProblemScreen({Key? key, this.userId}) : super(key: key);

  @override
  _ReportProblemScreen createState() => _ReportProblemScreen();
}

class _ReportProblemScreen extends State<ReportProblemScreen> {
  final _formKey = GlobalKey<FormState>();
  late ReportProblemProvider reportProblemProvider;

  @override
  Widget build(BuildContext context) {
    reportProblemProvider = Provider.of<ReportProblemProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Color(Constants.bgblack),
            appBar: AppBar(
              title: Container(
                  margin: const EdgeInsets.only(left: 0), child: const Text("Report a Problem")),
              centerTitle: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              automaticallyImplyLeading: true,
            ),
            body: ModalProgressHUD(
              inAsyncCall: reportProblemProvider.showSpinner,
              opacity: 1.0,
              color: Colors.transparent.withOpacity(0.2),
              progressIndicator: const CustomLoader(),
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 0, right: 20, top: 10),
                            child: const AppLableWidget(
                              title: 'Reason of Report',
                            ),
                          ),
                          CardTextFieldWidget(
                            focus: (v) {
                              FocusScope.of(context).nextFocus();
                            },
                            textInputAction: TextInputAction.next,
                            hintText: 'Enter Reason of Report',
                            textInputType: TextInputType.name,
                            textEditingController: reportProblemProvider.textReason,
                            validator: Constants.kvalidateReason,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 0, right: 20, top: 10),
                            child: const AppLableWidget(
                              title: 'Tell Us Your Problem',
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 20, top: 20),
                            child: Text(
                              "Add Your Issue",
                              style: TextStyle(
                                  color: Color(Constants.whitetext),
                                  fontFamily: Constants.appFont,
                                  fontSize: 16),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: Constants.kvalidateIssue,
                              keyboardType: TextInputType.name,
                              controller: reportProblemProvider.textIssue,
                              maxLines: 8,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16, fontFamily: Constants.appFont),
                              decoration: Constants.kTextFieldInputDecoration
                                  .copyWith(hintText: "Enter Issue"),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 0, right: 20, top: 10),
                            child: const AppLableWidget(
                              title: 'Email Address',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20),
                            child: TextFormField(
                              controller: reportProblemProvider.textEmail,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 16,
                                  fontFamily: Constants.appFontBold),
                              readOnly: true,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 0, right: 20, top: 10),
                            child: const AppLableWidget(
                              title: 'Add Screenshots',
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 0, right: 20, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    reportProblemProvider.chooseProfileImage(context);
                                  },
                                  child: reportProblemProvider.proImage != null
                                      ? Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(Radius.circular(10.0)),
                                            child: Image.file(
                                              reportProblemProvider.proImage!,
                                              width: ScreenUtil().setWidth(65),
                                              height: ScreenUtil().setHeight(65),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          child: SvgPicture.asset(
                                            "images/add_reason.svg",
                                            width: ScreenUtil().setWidth(65),
                                            height: ScreenUtil().setHeight(65),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 30, bottom: 30, left: 30, right: 30),
                            child: RoundedCornerAppButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  if (reportProblemProvider.proImage != null) {
                                    reportProblemProvider.callApiForReportProblem(widget.userId,context);
                                  } else {
                                    Constants.toastMessage("Please provide an image");
                                  }
                                }
                              },
                              btnLabel: 'Submit Report',
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return true;
  }
}
