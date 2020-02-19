class Player {
  final int id;
  String name;
  String icon;
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Player &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          icon == other.icon &&
          name == other.name &&
          isPlaying == other.isPlaying;

  @override
  int get hashCode =>
      id.hashCode ^ icon.hashCode ^ name.hashCode ^ isPlaying.hashCode;
}
