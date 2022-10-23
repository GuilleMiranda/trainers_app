class Cliente {
  late bool activo;
  late String nombres;
  late String apellidos;
  late String nombreMostrado;
  late String genero;

  late DateTime fechaNacimiento;
  late String email;
  late String contrasena;

  Cliente(this.activo, this.nombres, this.apellidos, this.nombreMostrado,
      this.genero, this.fechaNacimiento, this.email, this.contrasena);

  Cliente.onRegister(this.email, this.contrasena);

  Cliente.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        contrasena = json['contrasena'],
        nombres = json['nombres'],
        apellidos = json['apellidos'],
        genero = json['genero'],
        nombreMostrado = json['nombreMostrado'],
        fechaNacimiento = json['fechaNacimiento'];

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'contrasena': contrasena,
      'nombres': nombres,
      'apellidos': apellidos,
      'genero': genero,
      'nombreMostrado': nombreMostrado,
      'fechaNacimiento': fechaNacimiento
    };
  }
}
