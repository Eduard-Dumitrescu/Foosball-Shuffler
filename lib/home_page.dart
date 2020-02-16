import 'dart:math';

import 'package:ciocio_team_generator/icon_assets.dart';
import 'package:ciocio_team_generator/player.dart';
import 'package:ciocio_team_generator/player_service.dart';
import 'package:ciocio_team_generator/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

enum TeamType { Numbers, Names }

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _numOfPlayersController =
      new TextEditingController(text: "4");

  static final formKey = GlobalKey<FormState>();

  final ValueNotifier<TeamType> _teamType =
      ValueNotifier<TeamType>(TeamType.Numbers);

  final ValueNotifier<List<Player>> _players =
      ValueNotifier<List<Player>>(List<Player>());

  final ValueNotifier<String> _playersError = ValueNotifier<String>("");
  final ValueNotifier<bool> _shrink = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _generateNumberedPlayers();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) async => _shrink.value = visible,
    );
  }

  void _selectChoice(String value) {
    switch (value) {
      case "Players Page":
        {
          Navigator.pushNamed(context, '/players');
        }
        break;
    }
  }

  static List<String> _choices = ["Players Page", "Contact"];

  _showPlayersDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: PlayerCheck(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _mainBody(),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text(widget.title),
      centerTitle: true,
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: _selectChoice,
          itemBuilder: (BuildContext context) {
            return _choices.map((choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Row(
                  children: <Widget>[
                    Text(choice),
                  ],
                ),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  Widget _mainBody() {
    return GestureDetector(
        onPanUpdate: (details) {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (details.delta.dy > 0) {
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          }
        },
        child: Container(
          width: Utils.deviceWidth(context),
          height: Utils.deviceHeight(context),
          color: Color(0xff21295C),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: _playZone(),
              ),
              ValueListenableBuilder<String>(
                  valueListenable: _playersError,
                  builder: (context, errorString, _) {
                    return errorString.isEmpty
                        ? Container()
                        : Flexible(
                            //flex: 1,
                            child: Center(
                              child: Text(
                                errorString,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                  }),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _inputFormRow(),
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: Utils.deviceWidth(context),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      color: Colors.deepPurple,
                      child: Text(
                        "Generate Team",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        if (_teamType.value == TeamType.Names) {
                          _getNamedPlayers();
                        } else {
                          _playersError.value = "";
                          if (formKey.currentState.validate()) {
                            _generateNumberedPlayers();
                            if (!_isKeyboardHidden()) {
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                            }
                          }
                        }
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _playZone() {
    return ValueListenableBuilder<bool>(
        valueListenable: _shrink,
        builder: (context, shrink, _) {
          final double width = shrink
              ? Utils.deviceWidth(context) / 2
              : Utils.deviceWidth(context);
          final double height = shrink
              ? Utils.deviceHeight(context) / 6
              : Utils.deviceHeight(context) / 3;

          return ValueListenableBuilder<List<Player>>(
              valueListenable: _players,
              builder: (context, players, _) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: width,
                  height: height,
                  curve: Curves.linear,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: _teamColumn(players[0], players[1],
                            isOnLeftSide: true),
                      ),
                      Expanded(
                        flex: 2,
                        child: SvgPicture.asset(
                          "assets/ciocioBoard.svg",
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: _teamColumn(players[2], players[3],
                            isOnLeftSide: false),
                      )
                    ],
                  ),
                );
              });
        });
  }

  // TODO fix page redraw when input is focused / unfocused
  Widget _inputFormRow() {
    return ValueListenableBuilder<TeamType>(
        valueListenable: _teamType,
        builder: (context, teamType, _) {
          _playersError.value = "";

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: ListTile(
                  title: Form(
                    key: formKey,
                    child: SizedBox(
                      height: 40,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: _numOfPlayersController,
                        style: TextStyle(color: Colors.yellow, fontSize: 16),
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
                  ),
                  leading: Radio(
                    value: TeamType.Numbers,
                    groupValue: _teamType.value,
                    onChanged: (TeamType value) async =>
                        _teamType.value = value,
                  ),
                ),
              ),
              Flexible(
                child: ListTile(
                  title: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(24.0),
                    ),
                    color: Colors.deepPurple,
                    child: Text(
                      "Select Players",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async => _showPlayersDialog(),
                  ),
                  leading: Radio(
                    value: TeamType.Names,
                    groupValue: _teamType.value,
                    onChanged: (TeamType value) async =>
                        _teamType.value = value,
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget _teamColumn(Player player1, Player player2,
      {bool isOnLeftSide = true}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
            child: _playerWidget(player1.id, player1.icon,
                name: player1.name, isOnLeftSide: isOnLeftSide)),
        Flexible(
            child: _playerWidget(player2.id, player2.icon,
                name: player2.name, isOnLeftSide: isOnLeftSide)),
      ],
    );
  }

  Widget _playerWidget(int id, String iconPath,
      {bool isOnLeftSide = true, String name = ""}) {
    return _teamType.value == TeamType.Numbers
        ? _playerWithNumberWidget(id, iconPath, isOnLeftSide: isOnLeftSide)
        : _playerWithNameWidget(id, iconPath,
            isOnLeftSide: isOnLeftSide, name: name);
  }

  Widget _playerWithNumberWidget(int id, String iconPath,
      {bool isOnLeftSide = true}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.identity()..rotateY(isOnLeftSide ? 0 : pi),
              child: AspectRatio(
                aspectRatio: 3.0 / 4.0,
                child: SvgPicture.asset(
                  iconPath,
                ),
              ),
            ),
          ),
          Flexible(
            child: Text(
              "#$id",
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _playerWithNameWidget(int id, String iconPath,
      {bool isOnLeftSide = true, String name = ""}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Flexible(
                child: Text(
                  "#$id",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Flexible(
                child: Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.identity()..rotateY(isOnLeftSide ? 0 : pi),
                  child: AspectRatio(
                    aspectRatio: 3.0 / 4.0,
                    child: SvgPicture.asset(
                      iconPath,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "$name",
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
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

  void _getNamedPlayers() async {
    List<Player> savedPlayers = await PlayerService.getSelectedPlayers();
    if (savedPlayers.length < 4) {
      _playersError.value = "Please select at least 4 players";
    } else {
      _playersError.value = "";
      savedPlayers.shuffle(Random.secure());
      _players.value = savedPlayers.take(4).toList();
    }
  }

  void _generateNumberedPlayers() {
    List<String> assets = IconAssets.assets;
    assets.shuffle(Random.secure());

    List<Player> playerList = List<Player>.generate(
        int.parse(_numOfPlayersController.text),
        (int index) =>
            Player(id: index + 1, icon: assets[index + 1], name: ""));
    playerList.shuffle(Random.secure());

    _players.value = playerList.take(4).toList();
  }

  bool _isKeyboardHidden() {
    return MediaQuery.of(context).viewInsets.bottom == 0;
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
    super.dispose();
    _numOfPlayersController.dispose();
    _players.dispose();
    _playersError.dispose();
    _teamType.dispose();
    _shrink.dispose();
  }
}

class PlayerCheck extends StatefulWidget {
  const PlayerCheck();

  @override
  _PlayerCheckState createState() => _PlayerCheckState();
}

class _PlayerCheckState extends State<PlayerCheck> {
  final ValueNotifier<List<Player>> _playerList =
      ValueNotifier<List<Player>>(List<Player>());

  @override
  void initState() {
    super.initState();
    PlayerService.getPlayerList()
        .then((players) => _playerList.value = players);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Utils.deviceWidth(context),
      height: Utils.deviceHeight(context) / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 8,
            child: ValueListenableBuilder<List<Player>>(
                valueListenable: _playerList,
                builder: (context, playerList, _) {
                  if (playerList.length == 0)
                    return Center(
                      child: Text(
                        "No players found. Maybe add some?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                      ),
                    );

                  return Container(
                    color: Color(0xff21295C),
                    child: ListView.builder(
                      itemCount: playerList.length,
                      itemBuilder: (context, position) {
                        return CheckboxListTile(
                          checkColor: Colors.indigo,
                          title: Text(
                            playerList[position].name,
                            textAlign: TextAlign.center,
                          ),
                          value: playerList[position].isPlaying,
                          onChanged: (bool value) async {
                            playerList[position].isPlaying = value;
                            var auxPlayerList = List<Player>();
                            auxPlayerList.addAll(playerList);
                            _playerList.value = auxPlayerList;
                          },
                          secondary: AspectRatio(
                            aspectRatio: 3.0 / 4.0,
                            child: SvgPicture.asset(
                              playerList[position].icon,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
          ),
          Flexible(
            flex: 2,
            child: Container(
              color: Color(0xff21295C),
              padding: const EdgeInsets.all(16.0),
              child: SizedBox.expand(
                child: RaisedButton(
                    child: ValueListenableBuilder<List<Player>>(
                        valueListenable: _playerList,
                        builder: (context, playerList, _) {
                          return Text(
                              playerList.length == 0 ? 'Add players' : 'Save');
                        }),
                    onPressed: () async {
                      if (_playerList.value.length == 0) {
                        Navigator.pushNamed(context, '/players').then((value) =>
                            PlayerService.getPlayerList().then((players) {
                              setState(() {
                                _playerList.value = players;
                              });
                            }));
                      } else {
                        PlayerService.savePlayers(_playerList.value);
                        Navigator.pop(context);
                      }
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _playerList.dispose();
  }
}