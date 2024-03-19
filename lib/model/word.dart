class Word {
  int? id;
  String english;
  String korean;
  String level;
  int correctStreak;
  int incorrectStreak;

  Word.withoutID({
    this.english = "",
    this.korean = "",
    this.level = "",
    this.correctStreak = 0,
    this.incorrectStreak = 0,
  });

  Word({
    this.id,
    this.english = "",
    this.korean = "",
    this.level = "",
    this.correctStreak = 0,
    this.incorrectStreak = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'english': english,
      'korean': korean,
      'level': level,
      'correctStreak': correctStreak,
      'incorrectStreak': incorrectStreak,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) => Word(
        id: map['id'],
        english: map['english'],
        korean: map['korean'],
        level: map['level'],
        correctStreak: map['correctStreak'],
        incorrectStreak: map['incorrectStreak'],
      );
}
