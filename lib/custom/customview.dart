import '/screen/initialize_screen.dart';
import '/util/constants.dart';
import '/util/preference_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import 'loader_custom_widget.dart';


class CustomView extends StatefulWidget {
  int index;

  CustomView(this.index, {Key? key}) : super(key: key);

  @override
  _CustomView createState() => _CustomView();
}

class _CustomView extends State<CustomView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Color(Constants.bgblack),
          alignment: FractionalOffset.center,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (widget.index != 0){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => InitializeScreen(0)));
                    }
                  },
                  child: SvgPicture.asset("images/tab_home.svg",
                      color: widget.index == 0
                          ? Color(Constants.lightbluecolor)
                          : Color(Constants.whitetext)),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.index != 1){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => InitializeScreen(1)));
                    }
                  },
                  child: SvgPicture.asset("images/tab_search.svg",
                      color: widget.index == 1
                          ? Color(Constants.lightbluecolor)
                          : Color(Constants.whitetext)),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.index != 2) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => InitializeScreen(2)));
                    }
                  },
                  child: SvgPicture.asset(
                    "images/tab_add_new.svg",
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.index != 3){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => InitializeScreen(3)));
                    }
                  },
                  child: SvgPicture.asset("images/tab_notification.svg",
                      color: widget.index == 3
                          ? Color(Constants.lightbluecolor)
                          : Color(Constants.whitetext)),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.index != 4){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => InitializeScreen(4)));
                    }
                  },
                  child: Container(
                    child: PreferenceUtils.getString(Constants.image).isEmpty
                        ? CircleAvatar(
                            radius: 17,
                            child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30.0)),
                                child:
                                    Image.asset("images/profilepicDemo.jpg")))
                        : CachedNetworkImage(
                            alignment: Alignment.center,
                            imageUrl:
                                PreferenceUtils.getString(Constants.image),
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 17,
                              backgroundColor: const Color(0xFF36446b),
                              child: CircleAvatar(
                                radius: 17,
                                backgroundImage: imageProvider,
                              ),
                            ),
                            placeholder: (context, url) => const CustomLoader(),
                            errorWidget: (context, url, error) =>
                                Image.asset("images/no_image.png"),
                          ),
                  ),
                ),
            ],
          ),
        ));
  }
}
