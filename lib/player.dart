class Player {
  final int id;
  final String name;
  final String icon;
  bool isPlaying;

  Player({this.id, this.name, this.icon, this.isPlaying = false});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String,
      isPlaying: json['isPlaying'] as bool,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'icon': icon,
        'isPlaying': isPlaying,
      };
}
