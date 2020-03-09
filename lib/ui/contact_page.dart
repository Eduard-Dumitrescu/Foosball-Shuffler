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
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact us"),
        centerTitle: true,
      ),
      body: Container(
        width: Utils.deviceWidth(context),
        height: Utils.deviceHeightWithoutAppBar(context),
        color: Color(0xff21295C),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: AnimatedZooWidget(),
            ),
            Flexible(
              flex: 1,
              child: Container(),
            ),
            Flexible(
              flex: 1,
              child: Text(
                "Icons made by Freepik from www.flaticon.com \n Icons made by xnimrodx from www.flaticon.com \n Icons made by Icongeek26 from www.flaticon.com",
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

class AnimatedZooWidget extends StatefulWidget {
  @override
  _AnimatedZooWidgetState createState() => _AnimatedZooWidgetState();
}

class _AnimatedZooWidgetState extends State<AnimatedZooWidget>
    with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _translateController;

  final List<String> icons = IconAssets.assets;
  Animation<double> walkAnimation;

  List<Animation<Offset>> _characterTranslationAnimation;
  List<AnimationController> _characterAnimationController;

  double charWidth = 100;
  double charHeight = 100;

  @override
  void initState() {
    icons.shuffle(Random.secure());

    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _controller.forward();

    _translateController =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    _translateController.forward();

    walkAnimation = Tween<double>(begin: 0, end: 0).animate(_controller);

    _characterTranslationAnimation = List<Animation<Offset>>.generate(
        4,
        (index) => Tween<Offset>(
                begin: const Offset(0.0, 0.0), end: const Offset(0.0, 0.0))
            .animate(_controller));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Size zooSize = (context.findRenderObject() as RenderBox).size;

      charWidth = zooSize.height / 3;
      charHeight = zooSize.height / 3;

      final double characterHeight = charWidth;
      final double characterWidth = charHeight;

      final double heightLimit = zooSize.height - characterHeight;
      final double widthLimit = zooSize.width - characterWidth;

      _characterAnimationController = List<AnimationController>.generate(
          4,
          (index) => AnimationController(
              duration: const Duration(seconds: 4), vsync: this));
      _characterTranslationAnimation = List<Animation<Offset>>.generate(
          4,
          (index) => TweenSequence(
                [
                  TweenSequenceItem(
                      tween: Tween<Offset>(
                          begin: Offset(0, 0), end: Offset(widthLimit, 0)),
                      weight: 1),
                  TweenSequenceItem(
                      tween: Tween<Offset>(
                          begin: Offset(widthLimit, 0),
                          end: Offset(widthLimit, heightLimit)),
                      weight: 1),
                  TweenSequenceItem(
                      tween: Tween<Offset>(
                          begin: Offset(widthLimit, heightLimit),
                          end: Offset(0, heightLimit)),
                      weight: 1),
                  TweenSequenceItem(
                      tween: Tween<Offset>(
                          begin: Offset(0, heightLimit), end: Offset(0, 0)),
                      weight: 1),
                ],
              ).animate(_characterAnimationController[index])
                ..addStatusListener((status) {
                  //repeat animation
                  if (status == AnimationStatus.completed)
                    _characterAnimationController[index].repeat();
                }));

      walkAnimation = TweenSequence(
        [
          TweenSequenceItem(
              tween: Tween<double>(begin: 0.0, end: -pi / 8), weight: 1),
          TweenSequenceItem(
              tween: Tween<double>(begin: -pi / 8, end: 0.0), weight: 1),
          TweenSequenceItem(
              tween: Tween<double>(begin: 0, end: pi / 8), weight: 1),
          TweenSequenceItem(
              tween: Tween<double>(begin: pi / 8, end: 0.0), weight: 1),
        ],
      ).animate(_controller)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) _controller.repeat();
        });

      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _translateController?.dispose();
    _characterAnimationController?.forEach((ac) => ac?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue,
      width: Utils.deviceWidth(context),
      child: _zooStack(),
    );
  }

  Widget _zooStack() {
    List<Widget> characters = List<Widget>();
    for (int i = 0; i < 4; i++) {
      characters.add(_character(icons[i], i));
    }
    return Stack(
      children: characters
        ..add(
          Positioned(
            left: (Utils.deviceWidth(context) - charWidth) / 2,
            top: charHeight,
            child: SvgPicture.asset(
              icons[4],
              width: charWidth,
              height: charHeight,
            ),
          ),
        ),
    );
  }

  Widget _character(String icon, index) {
    return FutureBuilder(
        future:
            Future.delayed(Duration(milliseconds: 1000 * index), () => true),
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || !snapshot.data) {
            return Container();
          }

          _characterAnimationController[index].forward();

          return AnimatedBuilder(
            animation: _characterTranslationAnimation[index],
            builder: (context, child) => Transform.translate(
              offset: _characterTranslationAnimation[index].value,
              child: AnimatedBuilder(
                animation: walkAnimation,
                builder: (BuildContext context, Widget child) {
                  return Transform.rotate(
                    alignment: FractionalOffset.center,
                    angle: walkAnimation.value,
                    child: SvgPicture.asset(
                      icon,
                      width: charWidth,
                      height: charHeight,
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}
