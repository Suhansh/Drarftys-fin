import '/custom/customview.dart';
import '/custom/loader_custom_widget.dart';
import '/screen/search/searchcreator.dart';
import '/util/constants.dart';
import '/util/preference_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'search_history_provider.dart';

class SearchHistoryScreen extends StatefulWidget {
  const SearchHistoryScreen({Key? key}) : super(key: key);

  @override
  _SearchHistoryScreen createState() => _SearchHistoryScreen();
}

class _SearchHistoryScreen extends State<SearchHistoryScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late SearchHistoryProvider searchHistoryProvider;
  @override
  Widget build(BuildContext context) {
    searchHistoryProvider = Provider.of<SearchHistoryProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Color(Constants.bgblack),
            resizeToAvoidBottomInset: true,
            key: _scaffoldKey,
            body: ModalProgressHUD(
              inAsyncCall: searchHistoryProvider.showSpinner,
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
                          margin: const EdgeInsets.only(bottom: 70),
                          color: Colors.transparent,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                height: ScreenUtil().setHeight(50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: Color(Constants.conbg)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        margin: const EdgeInsets.only(left: 10),
                                        child: SvgPicture.asset(
                                            "images/greay_search.svg"),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                        color: Colors.transparent,
                                        child: TextFormField(
                                          autofocus: true,
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[0-9a-zA-Z]")),
                                          ],
                                          style: TextStyle(
                                              color: Color(Constants.whitetext),
                                              fontSize: 14,
                                              fontFamily: Constants.appFont),
                                          decoration: InputDecoration.collapsed(
                                            hintText:
                                                "Search Hashtags, Profile",
                                            hintStyle: TextStyle(
                                                color:
                                                    Color(Constants.hinttext),
                                                fontSize: 14,
                                                fontFamily: Constants.appFont),
                                            border: InputBorder.none,
                                          ),
                                          maxLines: 1,
                                          onFieldSubmitted: (String value) {
                                            setState(() {
                                              if (value.isNotEmpty) {
                                                for (int i = 0;
                                                    i < searchHistoryProvider.recentData.length;
                                                    i++) {
                                                  searchHistoryProvider.addDataToLocal
                                                      .add(searchHistoryProvider.recentData[i]);
                                                }
                                                searchHistoryProvider.addDataToLocal.add(value);
                                                searchHistoryProvider.putStringList(
                                                    Constants.recentSearch,
                                                    searchHistoryProvider.addDataToLocal);
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SearchCreatorScreen(
                                                      searched: value,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                Constants.toastMessage(
                                                    "Please enter any character");
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              /// recent search list
                              Visibility(
                                visible: searchHistoryProvider.recentData.isNotEmpty,
                                child: ListView.builder(
                                  itemCount: 6 <= searchHistoryProvider.recentData.length
                                      ? 6
                                      : searchHistoryProvider.recentData.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(
                                          top: 15,
                                          right: 20,
                                          bottom: 0,
                                          left: 20),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchCreatorScreen(
                                                searched: searchHistoryProvider.recentData[index],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.only(left: 10),
                                                alignment: Alignment.centerLeft,
                                                child: SvgPicture.asset(
                                                    "images/white_search.svg"),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: Text(
                                                searchHistoryProvider.recentData[index],
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Color(Constants
                                                        .whitetext),
                                                    fontFamily:
                                                        Constants.appFont,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    searchHistoryProvider.addDataToLocal.clear();
                                                    searchHistoryProvider.recentData.removeAt(index);
                                                    for (int i = 0;
                                                        i < searchHistoryProvider.recentData.length;
                                                        i++) {
                                                      searchHistoryProvider.addDataToLocal
                                                          .add(searchHistoryProvider.recentData[i]);
                                                    }
                                                    searchHistoryProvider.putStringList(
                                                        Constants.recentSearch,
                                                        searchHistoryProvider.addDataToLocal);
                                                  });
                                                  searchHistoryProvider.tempRecentData.clear();
                                                  searchHistoryProvider.recentData.clear();
                                                  if (searchHistoryProvider.getStringList(Constants
                                                          .recentSearch) != null) {
                                                    searchHistoryProvider.tempRecentData =
                                                        searchHistoryProvider.getStringList(Constants
                                                            .recentSearch);
                                                  } else {
                                                    searchHistoryProvider.tempRecentData = [];
                                                  }
                                                  searchHistoryProvider.recentData = searchHistoryProvider.tempRecentData.toList();
                                                },
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.only(right: 5),
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: SvgPicture.asset(
                                                      "images/close.svg"),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              /// clear search history
                              Visibility(
                                visible: searchHistoryProvider.recentData.isNotEmpty,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      PreferenceUtils.setStringList(
                                          Constants.recentSearch, <String>[]);
                                      searchHistoryProvider.recentData =
                                          searchHistoryProvider.getStringList(Constants.recentSearch);
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    margin: const EdgeInsets.only(
                                        left: 25, right: 20, top: 25),
                                    child: Text(
                                      "Clear Search History",
                                      style: TextStyle(
                                          color:
                                              Color(Constants.lightbluecolor),
                                          fontSize: 16,
                                          fontFamily: Constants.appFont),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(bottom: 10), child: const Body()),
                    ],
                  );
                },
              ),
            )),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return true;
  }
}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: CustomView(1),
    );
  }
}
