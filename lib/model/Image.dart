class Image {
  late int? userId;
  late String? userType;
  late String imageType;
  late String base64;

  Image(this.userId, this.userType, this.imageType, this.base64);

  Image.newImage();

  Image.fromJson(Map<String, dynamic> json)
      : userId = json['idPersona'],
        imageType = json['tipoImagen'],
        base64 = json['base64'];

  Map<String, dynamic> toJson() {
    return {
      'idPersona': userId,
      'tipoPersona': userType,
      'tipoImagen': imageType,
      'base64': base64
    };
  }
}
