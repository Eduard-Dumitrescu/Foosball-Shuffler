import 'package:ciocio_team_generator/models/player.dart';
import 'package:ciocio_team_generator/repo/player_service.dart';
import 'package:ciocio_team_generator/utils/icon_assets.dart';
import 'package:ciocio_team_generator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage();

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  static final formKey = GlobalKey<FormState>();

  final ValueNotifier<List<Player>> _playerList =
      ValueNotifier<List<Player>>(List<Player>());
  final ValueNotifier<bool> _isKeyboardShowing = ValueNotifier<bool>(false);
  final TextEditingController _playerName = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    _loadPlayers();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) async => _isKeyboardShowing.value = visible,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Players Settings"),
          centerTitle: true,
        ),
        body: Container(
          width: Utils.deviceWidth(context),
          height: Utils.deviceHeightWithoutAppBar(context),
          color: Color(0xff21295C),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: ValueListenableBuilder<List<Player>>(
                    valueListenable: _playerList,
                    builder: (context, playerList, _) {
                      return Container(
                        color: Color(0xff21295C),
                        child: ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.orangeAccent,
                            thickness: 2,
                            indent: 24,
                            endIndent: 24,
                          ),
                          itemCount: playerList.length,
                          itemBuilder: (context, position) {
                            return Material(
                              color: Colors.white.withOpacity(0),
                              child: InkWell(
                                child: ListTile(
                                  onTap: () async {
                                    final bool result = await _showPlayerDialog(
                                        _playerList.value[position]);
                                    if (result != null) _loadPlayers();
                                  },
                                  title: Text(
                                    playerList[position].name,
                                    textAlign: TextAlign.center,
                                  ),
                                  leading: AspectRatio(
                                    aspectRatio: 3.0 / 4.0,
                                    child: SvgPicture.asset(
                                      playerList[position].icon,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: _playerName,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.yellow, fontSize: 16),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8.0),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(24.0),
                          ),
                        ),
                        errorMaxLines: 10,
                        hintText: "Player name",
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.deepPurple,
                      ),
                      validator: (value) {
                        if (value.isEmpty) return "Please enter a player name";
                        if (_playerList.value.indexWhere((player) =>
                                player.name.toLowerCase() ==
                                value.toLowerCase()) !=
                            -1) return "Player with given name already exists";
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isKeyboardShowing,
                  builder: (context, isKeyboardShowing, _) {
                    return isKeyboardShowing
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: _crudButtons(),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: _crudButtons(),
                          );
                  },
                ),
              ),
            ],
          ),
        ));
  }

  List<Widget> _crudButtons() {
    return <Widget>[
      Flexible(
        flex: 1,
        child: RaisedButton(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(24.0),
          ),
          color: Colors.deepPurple,
          child: Text(
            "Add Player",
            style: TextStyle(
              fontSize: 16,
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            if (formKey.currentState.validate()) {
              await PlayerService.addPlayer(_playerName.text);
              _playerName.clear();
              _loadPlayers();
              Utils.dismissKeyboard(context);
            }
          },
        ),
      ),
      Flexible(
        flex: 1,
        child: RaisedButton(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(24.0),
          ),
          color: Colors.deepPurple,
          child: Text(
            "Delete All Players",
            style: TextStyle(
              fontSize: 16,
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Color(0xff21295C),
                  title: Text(
                    'Delete all players?',
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.fredokaOne().fontFamily),
                  ),
                  content: Text(
                    "Are you absolutely sure you want to delete everyone?",
                    style: GoogleFonts.fredokaOne(),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('I guess not'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('DID I STUTTER?'),
                      onPressed: () async {
                        await PlayerService.deleteAllPlayers();
                        _loadPlayers();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      )
    ];
  }

  Future<bool> _showPlayerDialog(Player player) async {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: PlayerEditWidget(player),
          );
        });
  }

  void _loadPlayers() {
    PlayerService.getPlayerList().then((players) {
      players.sort((player1, player2) =>
          player1.name.toLowerCase().compareTo(player2.name.toLowerCase()));
      _playerList.value = players;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _playerList.dispose();
    _playerName.dispose();
  }
}

class PlayerEditWidget extends StatefulWidget {
  final Player player;

  PlayerEditWidget(this.player);

  @override
  _PlayerEditWidgetState createState() => _PlayerEditWidgetState();
}

class _PlayerEditWidgetState extends State<PlayerEditWidget> {
  static final formKey = GlobalKey<FormState>();

  final TextEditingController _playerName = TextEditingController(text: "");
  final ValueNotifier<String> _iconPath = ValueNotifier<String>("");

  List<Player> _playerList;
  List<String> _iconList;
  bool isMowgli;

  @override
  void initState() {
    super.initState();
    _iconList = IconAssets.assets;
    _playerName.text = widget.player.name;
    _iconPath.value = widget.player.icon;
    isMowgli = widget.player.name.toLowerCase() == "cezara";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Player>>(
        future: PlayerService.getPlayerList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _playerList = snapshot.data;
            _iconList.removeWhere((iconPath) =>
                _playerList.indexWhere((player) => player.icon == iconPath) !=
                -1);
            _iconList.remove(IconAssets.icon051Monkey);

            return Container(
              color: Color(0xff21295C),
              width: Utils.deviceWidth(context),
              height:
                  Utils.deviceHeightWithoutAppBar(context) / (isMowgli ? 3 : 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: ValueListenableBuilder<String>(
                        valueListenable: _iconPath,
                        builder: (context, iconPath, _) {
                          return AspectRatio(
                            aspectRatio: 16.0 / 9.0,
                            child: SvgPicture.asset(
                              iconPath,
                            ),
                          );
                        }),
                  ),
                  isMowgli ? Container() : _iconListWidget(),
                  isMowgli
                      ? Container()
                      : Flexible(
                          flex: 1,
                          child: Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Form(
                              key: formKey,
                              child: TextFormField(
                                controller: _playerName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.yellow, fontSize: 16),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(8.0),
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(24.0),
                                    ),
                                  ),
                                  errorMaxLines: 10,
                                  hintText: "Player name",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.deepPurple,
                                ),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return "Please enter a player name";
                                  if (value.toLowerCase() ==
                                      _playerName.text.toLowerCase())
                                    return null;
                                  if (value != widget.player.name &&
                                      _playerList.indexWhere((player) =>
                                              player.name.toLowerCase() ==
                                              value.toLowerCase()) !=
                                          -1)
                                    return "Player with given name already exists";
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                  isMowgli
                      ? Container()
                      : Flexible(
                          flex: 1,
                          child: Container(
                            width: Utils.deviceWidth(context) / 2,
                            child: RaisedButton(
                                elevation: 8.0,
                                child: Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    color: Colors.yellowAccent,
                                  ),
                                ),
                                color: Colors.deepPurple,
                                onPressed: () async {
                                  if (formKey.currentState.validate()) {
                                    if (_iconPath.value != widget.player.icon ||
                                        _playerName.text !=
                                            widget.player.name) {
                                      final int index =
                                          _playerList.indexOf(widget.player);
                                      _playerList[index].name =
                                          _playerName.text;
                                      _playerList[index].icon =
                                          _playerName.text.toLowerCase() ==
                                                  "cezara"
                                              ? IconAssets.icon051Monkey
                                              : _iconPath.value;
                                      await PlayerService.savePlayers(
                                          _playerList);
                                    }
                                    Navigator.pop(context, true);
                                  }
                                }),
                          ),
                        ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: Utils.deviceWidth(context) / 2,
                      child: RaisedButton(
                          elevation: 8.0,
                          child: Text(
                            'Delete Player',
                            style: TextStyle(
                              color: Colors.yellowAccent,
                            ),
                          ),
                          color: Colors.deepPurple,
                          onPressed: () async {
                            await PlayerService.deletePlayer(widget.player.id);
                            Navigator.pop(context, true);
                          }),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Widget _iconListWidget() {
    return (IconAssets.assets.length - _playerList.length) < 3
        ? Container()
        : Flexible(
            flex: 1,
            child: ListView.separated(
              separatorBuilder: (context, index) => VerticalDivider(
                color: Colors.orangeAccent,
                thickness: 2,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: _iconList.length,
              itemBuilder: (BuildContext context, int index) {
                return Material(
                  color: Colors.white.withOpacity(0),
                  child: InkWell(
                    onTap: () async => _iconPath.value = _iconList[index],
                    child: AspectRatio(
                      aspectRatio: 16.0 / 9.0,
                      child: SvgPicture.asset(
                        _iconList[index],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
    _playerName.dispose();
    _iconPath.dispose();
  }
}
