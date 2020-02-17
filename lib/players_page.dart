import 'package:ciocio_team_generator/player.dart';
import 'package:ciocio_team_generator/player_service.dart';
import 'package:ciocio_team_generator/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

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
          title: Text("Go Bananas"),
          centerTitle: true,
        ),
        body: Container(
          width: Utils.deviceWidth(context),
          height: Utils.deviceHeight(context),
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
                            return ListTile(
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
                        hintStyle: TextStyle(color: Colors.yellow),
                        filled: true,
                        fillColor: Colors.deepPurple,
                      ),
                      validator: (value) {
                        if (value.isEmpty) return "Please enter a player name";
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
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(24.0),
          ),
          color: Colors.deepPurple,
          child: Text(
            "Add guy",
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
            await PlayerService.deleteAllPlayers();
            _loadPlayers();
          },
        ),
      )
    ];
  }

  void _loadPlayers() {
    PlayerService.getPlayerList()
        .then((players) => _playerList.value = players);
  }

  @override
  void dispose() {
    super.dispose();
    _playerList.dispose();
    _playerName.dispose();
  }
}
