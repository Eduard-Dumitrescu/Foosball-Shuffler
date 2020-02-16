import 'dart:convert';

import 'package:ciocio_team_generator/icon_assets.dart';
import 'package:ciocio_team_generator/player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerService {
  static const String PLAYER_LIST = "PlayerList";

  static Future<List<Player>> getPlayerList() async {
    final String playerList = await Repo.getString(PLAYER_LIST);

    return playerList == null
        ? List<Player>()
        : (jsonDecode(playerList) as Iterable)
            .map((el) => Player.fromJson(el))
            .toList();
  }

  static Future<List<Player>> getSelectedPlayers() async {
    final String playerList = await Repo.getString(PLAYER_LIST);

    return playerList == null
        ? List<Player>()
        : (jsonDecode(playerList) as Iterable)
            .map((el) => Player.fromJson(el))
            .where((player) => player.isPlaying)
            .toList();
  }

  static Future<String> addPlayer(String name, {String icon}) async {
    final List<Player> playerList = await getPlayerList();

    if (playerList.length == IconAssets.assets.length)
      return "Cannot add anymore players";

    playerList.add(Player(
        id: playerList.length + 1,
        name: name,
        icon: icon ?? IconAssets.assets[playerList.length]));

    await Repo.setString(PLAYER_LIST, jsonEncode(playerList));

    return "Success";
  }

  static Future editPlayer(Player player) async {
    final List<Player> playerList = await getPlayerList();

    final int index = playerList.indexWhere((item) => item.id == player.id);

    playerList.removeAt(index);
    playerList.insert(index, player);

    Repo.setString(PLAYER_LIST, jsonEncode(playerList));
  }

  static Future deletePlayer(int id) async {
    final List<Player> playerList = await getPlayerList();
    playerList.removeWhere((player) => player.id == id);

    Repo.setString(PLAYER_LIST, jsonEncode(playerList));
  }

  static Future deleteAllPlayers() async => Repo.removeString(PLAYER_LIST);

  static Future savePlayers(List<Player> value) async =>
      Repo.setString(PLAYER_LIST, jsonEncode(value));
}

class Repo {
  static Future setString(String key, String value) =>
      SharedPreferences.getInstance()
          .then((prefs) => prefs.setString(key, value));

  static Future getString(String key) =>
      SharedPreferences.getInstance().then((prefs) => prefs.getString(key));

  static Future removeString(String key) =>
      SharedPreferences.getInstance().then((prefs) => prefs.remove(key));
}
