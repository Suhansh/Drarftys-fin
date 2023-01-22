import '/screen/edit_profile/edit_profile_provider.dart';
import 'package:provider/provider.dart';
import '/custom/loader_custom_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/util/constants.dart';
import '/widget/app_lable_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreen createState() => _EditProfileScreen();
}

class _EditProfileScreen extends State<EditProfileScreen> {
  late EditProfileProvider editProfileProvider;

  @override
  void initState() {
    Provider.of<EditProfileProvider>(context,listen: false).callApiForMyProfileInfo();
    super.initState();
  }


  @override
  void dispose() {
    editProfileProvider.proImage = null;
    editProfileProvider.showSpinner = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    editProfileProvider = Provider.of<EditProfileProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(Constants.bgblack),
          appBar:   AppBar(
            title: Container(
                margin: const EdgeInsets.only(left: 0), child: const Text("Edit Profile")),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: true,
            actions: <Widget>[
              editProfileProvider.showSpinner ? const SizedBox(height: 1,width: 1,) : InkWell(
                onTap: () {
                  editProfileProvider.callApiForEditProfile(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 5, right: 20),
                  child: SvgPicture.asset("images/right.svg"),
                ),
              ),
            ],
          ),
          body: editProfileProvider.showSpinner ? const CustomLoader() : ModalProgressHUD(
            inAsyncCall: editProfileProvider.showSpinner,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            progressIndicator: const CustomLoader(),
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //profile pic
                      Container(
                        margin: const EdgeInsets.only(bottom: 5, left: 20),
                        alignment: Alignment.centerLeft,
                        child: editProfileProvider.proImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  editProfileProvider.proImage!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : CachedNetworkImage(
                                alignment: Alignment.centerLeft,
                                imageUrl: editProfileProvider.image,
                                imageBuilder: (context, imageProvider) => CircleAvatar(
                                  radius: 50,
                                  // backgroundColor: const Color(0xFF36446b),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: imageProvider,
                                  ),
                                ),
                                placeholder: (context, url) => const CustomLoader(),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(radius: 50,child: Image.asset("images/no_image.png")),
                              ),
                      ),
                      InkWell(
                        onTap: () {
                          editProfileProvider.chooseProfileImage(context);
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(
                            left: 20,
                          ),
                          child: Text(
                            "Change Profile Picture",
                            style: TextStyle(
                                color: Color(Constants.lightbluecolor),
                                fontSize: 16,
                                fontFamily: Constants.appFont),
                          ),
                        ),
                      ),
                      //username
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 0, right: 20, top: 10),
                        child: AppLableWidget(
                          title: 'Username',
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, top: 0, right: 20),
                        child: TextFormField(
                          controller: editProfileProvider.userNameLoad,
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          validator: Constants.kvalidateUserName,
                          keyboardType: TextInputType.name,
                          style: TextStyle(
                              color: Colors.white, fontSize: 16, fontFamily: Constants.appFontBold),
                          decoration: Constants.kTextFieldInputDecoration
                              .copyWith(hintText: "Enter Your UserName"),
                        ),
                      ),
                      //name
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 0, right: 20, top: 10),
                        child: AppLableWidget(
                          title: 'Name',
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, top: 0, right: 20),
                        child: TextFormField(
                          controller: editProfileProvider.nameLoad,
                          textInputAction: TextInputAction.next,
                          validator: Constants.kvalidateName,
                          keyboardType: TextInputType.name,
                          style: TextStyle(
                              color: Colors.white, fontSize: 16, fontFamily: Constants.appFontBold),
                          decoration: Constants.kTextFieldInputDecoration
                              .copyWith(hintText: "Enter Your Name"),
                        ),
                      ),
                      //bio
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Text(
                          "Bio",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Color(Constants.greytext),
                              fontFamily: Constants.appFont),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, top: 0, right: 20),
                        child: TextFormField(
                          controller: editProfileProvider.bioLoad,
                          textInputAction: TextInputAction.next,

                          validator: Constants.kvalidatedata,
                          keyboardType: TextInputType.multiline,

                          // controller: _text_Email,

                          maxLines: null,

                          maxLength: 250,
                          buildCounter: (
                            BuildContext context, {
                            required int currentLength,
                            int? maxLength = 250,
                            bool? isFocused,
                          }) {
                            return Text(
                              "${maxLength! - currentLength}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Color(Constants.greytext),
                                  fontFamily: Constants.appFont),
                            );
                          },

                          style: TextStyle(
                              color: Colors.white, fontSize: 16, fontFamily: Constants.appFontBold),
                          decoration: Constants.kTextFieldInputDecoration
                              .copyWith(hintText: "Enter Your Bio"),
                        ),
                      ),
                      //contact number
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Text(
                          "Contact Number",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Color(Constants.greytext),
                              fontFamily: Constants.appFont),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, top: 0, right: 20),
                        child: TextFormField(
                          controller: editProfileProvider.phoneLoad,
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          validator: Constants.kvalidateCotactNum,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              color: Colors.white, fontSize: 16, fontFamily: Constants.appFontBold),
                          decoration: Constants.kTextFieldInputDecoration
                              .copyWith(hintText: "Enter Your Contact Number "),
                        ),
                      ),
                      // email
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: Text(
                            "Email Address",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Color(Constants.greytext),
                                fontFamily: Constants.appFont),
                          ),
                        ),
                        Visibility(
                          visible: editProfileProvider.emailVerified,
                          child: RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor: 1,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    margin: const EdgeInsets.only(left: 20, right: 0, top: 20),
                                    child: Text(
                                      "Verify Email Address",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0,
                                          color: Color(Constants.redtext),
                                          fontFamily: Constants.appFont),
                                    ),
                                  ),
                                ),
                                WidgetSpan(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    margin: const EdgeInsets.only(left: 5, right: 20, top: 20),
                                    child: SvgPicture.asset("images/email_verify.svg"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                      Container(
                        margin: const EdgeInsets.only(left: 20, top: 0, right: 20),
                        child: TextFormField(
                          controller: editProfileProvider.emailLoad,
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          validator: Constants.kvalidateEmail,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              color: Colors.white, fontSize: 16, fontFamily: Constants.appFontBold),
                          decoration: Constants.kTextFieldInputDecoration
                              .copyWith(hintText: "Enter Your Email Address"),
                        ),
                      ),
                      //bDate
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Text(
                          "Birth Date",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Color(Constants.greytext),
                              fontFamily: Constants.appFont),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, top: 0, right: 0, bottom: 20),
                        child: TextFormField(
                          controller: editProfileProvider.birthdate,
                          textInputAction: TextInputAction.next,
                          readOnly: true,
                          onTap: () {
                            editProfileProvider.selectDate(context);
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: Colors.white, fontSize: 16, fontFamily: Constants.appFontBold),
                          decoration: Constants.kTextFieldInputDecoration
                              .copyWith(hintText: "Enter Your Birthdate"),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: Text(
                          "Gender",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Color(Constants.greytext),
                              fontFamily: Constants.appFont),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 20, left: 20, bottom: 50),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Color(Constants.bgblack1),
                          ),
                          child: DropdownButton<String>(
                            value: editProfileProvider.dropdownValue,
                            isExpanded: true,
                            icon: Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: SvgPicture.asset("images/profile_down.svg"),
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Color(Constants.whitetext)),
                            underline: Container(
                              height: 1,
                              color: Color(Constants.whitetext),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                editProfileProvider.dropdownValue = newValue;
                              });
                            },
                            items: <String>[
                              'Select Gender',
                              'Male',
                              'Female',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value.toString(),
                                  style: TextStyle(
                                      color: Color(Constants.whitetext),
                                      fontSize: 16,
                                      fontFamily: Constants.appFont),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
