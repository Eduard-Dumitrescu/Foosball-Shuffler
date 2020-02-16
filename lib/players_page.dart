import 'dart:io';

import 'package:ciocio_team_generator/player.dart';
import 'package:ciocio_team_generator/player_service.dart';
import 'package:flutter/material.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage();

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  final ValueNotifier<List<Player>> _playerList =
      ValueNotifier<List<Player>>(List<Player>());
  final TextEditingController _playerName = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Go Bananas"),
          centerTitle: true,
        ),
        body: Container(
          width: _deviceWidth(),
          height: _deviceHeight(),
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
                      return ListView.builder(
                        itemCount: playerList.length,
                        itemBuilder: (context, position) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                playerList[position].name,
                                style: TextStyle(fontSize: 22.0),
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
              Flexible(
                flex: 1,
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.yellow, fontSize: 16),
                  decoration: InputDecoration(
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
                  onChanged: (data) async {
                    _playerName.value = TextEditingValue(text: data);
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: RaisedButton(
                  child: Text("Add guy"),
                  onPressed: () async {
                    await PlayerService.addPlayer(_playerName.text);
                    _loadPlayers();
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: RaisedButton(
                  child: Text("Delete All Players"),
                  onPressed: () async {
                    await PlayerService.deleteAllPlayers();
                    _loadPlayers();
                  },
                ),
              )
            ],
          ),
        ));
  }

  void _loadPlayers() {
    PlayerService.getPlayerList()
        .then((players) => _playerList.value = players);
  }

  double _deviceWidth() {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Platform.isIOS ? deviceWidth / 2 : deviceWidth;
  }

  double _deviceHeight() {
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Platform.isIOS ? deviceHeight / 2 : deviceHeight;
  }

  @override
  void dispose() {
    super.dispose();
    _playerList.dispose();
    _playerName.dispose();
  }
}
