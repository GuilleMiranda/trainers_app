class Gender {
  final int genderId;
  final String
  text;

  const Gender(this.genderId, this.text);

  Gender.fromJson(Map<String, dynamic> json)
      : genderId = json['id'],
        text = json['descripcion'];

  Map<String, dynamic> toJson() {
    return {'id': genderId, 'descripcion': text};
  }
}
