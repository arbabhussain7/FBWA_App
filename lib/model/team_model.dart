class Team {
  int? sNo;
  String tName;
  String? tLeagues;
  String? tImg;

  Team({
    this.sNo,
    required this.tName,
    this.tLeagues,
    this.tImg,
  });

  Map<String, dynamic> toMap() {
    return {
      's_no': sNo,
      't_name': tName,
      't_leagues': tLeagues,
      't_img': tImg,
    };
  }

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      sNo: map['s_no'],
      tName: map['t_name'] ?? '',
      tLeagues: map['t_leagues'],
      tImg: map['t_img'],
    );
  }

  @override
  String toString() {
    return 'Team{sNo: $sNo, tName: $tName, tLeagues: $tLeagues, tImg: $tImg}';
  }
}