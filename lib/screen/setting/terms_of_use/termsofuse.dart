import '/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../util/preference_utils.dart';

class TermsOfUseScreen extends StatefulWidget {
  const TermsOfUseScreen({Key? key}) : super(key: key);

  @override
  _TermsOfUseScreen createState() => _TermsOfUseScreen();
}

class _TermsOfUseScreen extends State<TermsOfUseScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Container(
                margin: const EdgeInsets.only(left: 0), child: const Text("Terms of Use")),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: true,
          ),
          backgroundColor: Color(Constants.bgblack),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Html(
                data: PreferenceUtils.getString(Constants.termsOfUse),
              ),
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
