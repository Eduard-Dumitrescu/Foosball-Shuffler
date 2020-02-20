import 'dart:math';

import 'package:ciocio_team_generator/utils/icon_assets.dart';
import 'package:ciocio_team_generator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactPage extends StatelessWidget {
  final String email = "eduard.dumitrescu94@gmail.com";

  @override
  Widget build(BuildContext context) {
    List<String> icons = IconAssets.assets;
    icons.shuffle(Random.secure());

    return Scaffold(
      appBar: AppBar(
        title: Text("Contact us"),
        centerTitle: true,
      ),
      body: Container(
        width: Utils.deviceWidth(context),
        height: Utils.deviceHeight(context),
        color: Color(0xff21295C),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                  color: Colors.lightBlue,
                  child: GridView.count(
                      padding: const EdgeInsets.all(20),
                      childAspectRatio: 16.0 / 9.0,
                      crossAxisCount: 3,
                      children: icons
                          .take(9)
                          .map((icon) => SvgPicture.asset(icon))
                          .toList())),
            ),
            Flexible(
              flex: 1,
              child: Container(),
            ),
            Flexible(
              flex: 1,
              child: Text(
                "Icons made by Freepik from www.flaticon.com",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(),
            ),
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellowAccent),
                      children: <TextSpan>[
                        TextSpan(text: "For more "),
                        TextSpan(
                          text: "beguiling ",
                          style: GoogleFonts.pacifico(
                            textStyle: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        TextSpan(text: "Flutter Apps send an email to : \n"),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (context) => Material(
                      color: Colors.white.withOpacity(0),
                      child: InkWell(
                        onTap: () async {
                          Clipboard.setData(ClipboardData(text: email));
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Copied to Clipboard"),
                          ));
                        },
                        child: Text(
                          email,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
