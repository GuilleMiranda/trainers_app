class Gender {
  final int genderId;
  final String text;
  final String questionText;

  const Gender(this.genderId, this.text, this.questionText);

  Gender.fromJson(Map<String, dynamic> json)
      : genderId = json['id'],
        text = json['descripcion'],
        questionText = json['textoPregunta'];

  Map<String, dynamic> toJson() {
    return {'id': genderId, 'descripcion': text, 'textoPregunta': questionText};
  }
}
