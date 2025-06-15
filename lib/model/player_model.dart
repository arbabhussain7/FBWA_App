class Player {
  int? sNo;
  String pName;
  int jNumber;
  String pPosition;
  String? pImg;

  Player({
    this.sNo,
    required this.pName,
    required this.jNumber,
    required this.pPosition,
    this.pImg,
  });

  Map<String, dynamic> toMap() {
    return {
      's_no': sNo,
      'p_name': pName,
      'j_number': jNumber,
      'p_position': pPosition,
      'p_img': pImg,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      sNo: map['s_no'],
      pName: map['p_name'],
      jNumber: map['j_number'],
      pPosition: map['p_position'],
      pImg: map['p_img'],
    );
  }

  @override
  String toString() {
    return 'Player{sNo: $sNo, pName: $pName, jNumber: $jNumber, pPosition: $pPosition, pImg: $pImg}';
  }
}
