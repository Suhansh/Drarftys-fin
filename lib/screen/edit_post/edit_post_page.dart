import '/screen/edit_post/edit_post_provider.dart';
import 'package:provider/provider.dart';
import '/custom/loader_custom_widget.dart';
import '/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EditPost extends StatefulWidget {
  final int? videoId;

  const EditPost({Key? key, required this.videoId}) : super(key: key);

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  late EditPostProvider editPostProvider;

  @override
  void initState() {
    super.initState();
    Provider.of<EditPostProvider>(context, listen: false)
        .callApiForGetEditDataVideo(widget.videoId);
  }

  @override
  Widget build(BuildContext context) {
    editPostProvider = Provider.of<EditPostProvider>(context);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Container(
                margin: const EdgeInsets.only(left: 0),
                child: const Text("Edit Video")),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: true,
            actions: <Widget>[
              InkWell(
                onTap: () {
                  Constants.checkNetwork().whenComplete(() => editPostProvider
                      .callApiForEditPost(widget.videoId, context));
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 20, top: 5),
                  child: SvgPicture.asset("images/right.svg"),
                ),
              )
            ],
          ),
          backgroundColor: Color(Constants.bgblack),
          resizeToAvoidBottomInset: true,
          body: ModalProgressHUD(
            inAsyncCall: editPostProvider.showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: const CustomLoader(),
            child: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 0, right: 10),
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Edit Status",
                                  style: TextStyle(
                                      color: Color(Constants.greytext),
                                      fontSize: 14,
                                      fontFamily: Constants.appFont),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: TextField(
                                  controller: editPostProvider.statusController,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Edit Status Here",
                                    hintStyle: TextStyle(
                                        color: Color(Constants.whitetext),
                                        fontSize: 16,
                                        fontFamily: Constants.appFont),
                                  ),
                                  style: TextStyle(
                                      color: Color(Constants.whitetext),
                                      fontSize: 16,
                                      fontFamily: Constants.appFont),
                                ),
                              ),
                              Divider(
                                color: Color(Constants.greytext),
                                thickness: 1,
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(55),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      editPostProvider.isAdvanceOpen =
                                          !editPostProvider.isAdvanceOpen;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Advance Settings",
                                        style: TextStyle(
                                            color: Color(Constants.greytext),
                                            fontSize: 14,
                                            fontFamily: Constants.appFont),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 0, top: 2),
                                        child: editPostProvider.isAdvanceOpen ==
                                                false
                                            ? SvgPicture.asset(
                                                "images/advanced_status-down.svg")
                                            : SvgPicture.asset(
                                                "images/advanced_status.svg"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: editPostProvider.isAdvanceOpen,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Like & Comments",
                                    style: TextStyle(
                                        color: Color(Constants.whitetext),
                                        fontSize: 16,
                                        fontFamily: Constants.appFont),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: editPostProvider.isAdvanceOpen,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        editPostProvider.isComment =
                                            !editPostProvider.isComment;
                                        if (editPostProvider.isComment ==
                                            true) {
                                          editPostProvider.showComment = 1;
                                        } else {
                                          editPostProvider.showComment = 0;
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Comments",
                                            style: TextStyle(
                                                color:
                                                    Color(Constants.whitetext),
                                                fontSize: 16,
                                                fontFamily: Constants.appFont),
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: Transform.scale(
                                              scale: 1.1,
                                              child: FlutterSwitch(
                                                height: 25,
                                                width: 45,
                                                borderRadius: 30,
                                                padding: 5.5,
                                                duration: const Duration(
                                                    milliseconds: 400),
                                                activeColor: Color(
                                                    Constants.lightbluecolor),
                                                activeToggleColor:
                                                    Color(Constants.bgblack),
                                                inactiveToggleColor:
                                                    Color(Constants.bgblack),
                                                inactiveColor:
                                                    Color(Constants.greytext),
                                                toggleSize: 15,
                                                value:
                                                    editPostProvider.isComment,
                                                onToggle: (val) {
                                                  setState(() {
                                                    editPostProvider.isComment =
                                                        val;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                color: Color(Constants.greytext),
                                thickness: 1,
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Who can see your profile",
                                  style: TextStyle(
                                      color: Color(Constants.whitetext),
                                      fontSize: 16,
                                      fontFamily: Constants.appFont),
                                ),
                              ),
                              Theme(
                                data: ThemeData(
                                  unselectedWidgetColor:
                                      Color(Constants.whitetext),
                                ),
                                child: RadioListTile(
                                  contentPadding: EdgeInsets.zero,
                                  value: 0,
                                  groupValue: editPostProvider.radioValue,
                                  onChanged:
                                      editPostProvider.handleRadioValueChange,
                                  title: Text(
                                    "Everyone",
                                    style: TextStyle(
                                        color: Color(Constants.whitetext),
                                        fontFamily: Constants.appFont,
                                        fontSize: 16),
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  activeColor: Color(Constants.whitetext),
                                ),
                              ),
                              Theme(
                                data: ThemeData(
                                  unselectedWidgetColor:
                                      Color(Constants.whitetext),
                                ),
                                child: RadioListTile(
                                  contentPadding: EdgeInsets.zero,
                                  activeColor: Color(Constants.whitetext),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  value: 1,
                                  groupValue: editPostProvider.radioValue,
                                  onChanged:
                                      editPostProvider.handleRadioValueChange,
                                  title: Text(
                                    "Only People Who Follow You",
                                    style: TextStyle(
                                        color: Color(Constants.whitetext),
                                        fontFamily: Constants.appFont,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                              Theme(
                                data: ThemeData(
                                  unselectedWidgetColor:
                                      Color(Constants.whitetext),
                                ),
                                child: RadioListTile(
                                  contentPadding: EdgeInsets.zero,
                                  activeColor: Color(Constants.whitetext),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  value: 2,
                                  groupValue: editPostProvider.radioValue,
                                  onChanged:
                                      editPostProvider.handleRadioValueChange,
                                  title: Text(
                                    "Only Me",
                                    style: TextStyle(
                                        color: Color(Constants.whitetext),
                                        fontFamily: Constants.appFont,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                              Divider(
                                color: Color(Constants.greytext),
                                thickness: 1,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Language",
                                  style: TextStyle(
                                      color: Color(Constants.whitetext),
                                      fontSize: 16,
                                      fontFamily: Constants.appFont),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(55),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(left: 0),
                                      child: Text(
                                        "English",
                                        style: TextStyle(
                                            color: Color(Constants.greytext),
                                            fontSize: 14,
                                            fontFamily: Constants.appFont),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 0, top: 2),
                                      // child: SvgPicture.asset(
                                      //     "images/language_down.svg"),
                                    ),
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
          )),
    );
  }
}
