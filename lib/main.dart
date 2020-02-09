import 'dart:math';

import 'package:ciocio_team_generator/icon_assets.dart';
import 'package:ciocio_team_generator/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(title: 'cIoCiO tEaM gEnErAtOr'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double deviceWith;
  double deviceHeight;

  int stableNum = 4;

  final TextEditingController _numOfPlayersController =
      new TextEditingController(text: "4");

  static final formKey = GlobalKey<FormState>();

  //called after init state because context in init state throws error
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    deviceWith = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    List<Player> players = _generatePlayers();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: deviceWith,
          height: deviceHeight,
          color: Color(0xff21295C),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _teamColumn(players[0], players[1], isOnLeftSide: true),
                  SvgPicture.asset(
                    "assets/ciocioBoard.svg",
                    width: deviceWith / 3,
                    height: deviceHeight / 3,
                  ),
                  _teamColumn(players[2], players[3], isOnLeftSide: false)
                ],
              ),
              _inputFormRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputFormRow() {
    return Form(
      key: formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: deviceWith / 3,
            child: TextFormField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: _numOfPlayersController,
              style: TextStyle(color: Colors.yellow),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(24.0),
                  ),
                ),
                errorMaxLines: 10,
                hintText: "Players",
                hintStyle: TextStyle(color: Colors.yellow),
                filled: true,
                fillColor: Colors.deepPurple,
              ),
              validator: (value) => _validateInput(value),
            ),
          ),
          SizedBox(
            width: deviceWith / 3,
            height: 60,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(24.0),
              ),
              color: Colors.deepPurple,
              child: Text(
                "Generate Team",
                style: TextStyle(
                    color: Colors.yellow, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                if (formKey.currentState.validate()) {
                  setState(() {});
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _teamColumn(Player player1, Player player2,
      {bool isOnLeftSide = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _playerWidget(player1.id, player1.icon, isOnLeftSide: isOnLeftSide),
        _playerWidget(player2.id, player2.icon, isOnLeftSide: isOnLeftSide),
      ],
    );
  }

  Widget _playerWidget(int id, String iconPath, {bool isOnLeftSide = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.identity()..rotateY(isOnLeftSide ? 0 : pi),
          child: SvgPicture.asset(
            iconPath,
            width: deviceWith / 6,
            height: deviceHeight / 6,
          ),
        ),
        Text(
          "#$id",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  String _validateInput(String value) {
    if (value.isEmpty) {
      return 'Please enter number of players';
    } else if (value.contains(RegExp(r'[A-Za-z]'))) {
      return 'Wow you managed to put some non numeric values, amazing hacking skills';
    } else if (!RegExp(r'\S').hasMatch(value)) {
      return "Still empty just like your life";
    } else if (!_isDouble(value)) {
      return "How about an actual number";
    } else if (_isDouble(value) && !_isInt(value)) {
      return "Did you chop someone into bits and pieces?";
    }

    int players = int.parse(value);
    if (players < 1) {
      return "Nice number just like your IQ";
    } else if (players == 1) {
      return "This game is not for friendless virgins such as yourself";
    } else if (players == 2) {
      return "This is a 4 player game go play tic tac toe";
    } else if (players == 3) {
      return "Guess who the third wheel is";
    } else if (players > 49) {
      return "Sorry only 49 players supported for now";
    }

    return null;
  }

  List<Player> _generatePlayers() {
    if (_validateInput(_numOfPlayersController.text) == null) {
      stableNum = int.parse(_numOfPlayersController.text);
    }

    List<String> assets = IconAssets.assets;
    assets.shuffle(Random.secure());

    List<Player> playerList = List<Player>.generate(
        stableNum,
        (int index) =>
            Player(id: index + 1, icon: assets[index + 1], name: ""));
    playerList.shuffle(Random.secure());
    return playerList;
  }

  bool _isInt(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) == null ? false : true;
  }

  bool _isDouble(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) == null ? false : true;
  }

  @override
  void dispose() {
    _numOfPlayersController.dispose();
    super.dispose();
  }
}
