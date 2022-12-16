class PreferenciasCliente {
  late int? deporte; // Id de la actividad deportiva que quiere realizar
  late int?
      expecienciaEnDisciplina; // Id de la respuesta sobre experencia en el deporte que quiere hacer
  late int? modalidad; // Id que representa: Presencial - Virtual - Mixto
  late int?
      localizacionEntrenamiento; // Id lugar en el que quiere entrenar (gym, en casa, al aire libre, etc)
  //late List<int> objetivos; // Id de lo que quiere lograr con el entrenamiento
  late int? tipoPlan; // Id del plazo del servicio: mensual, por día
  late double?
      precioTope; // Monto máximo que quiere pagar para el plazo que eligió
  late int?
      condicionSalud; // Tiene alguna condición especial? Sí o No para no entrar en su vida personal

  PreferenciasCliente(      ){
    deporte = -1;
    expecienciaEnDisciplina = -1;
    modalidad = -1;
    localizacionEntrenamiento = -1;
    // objetivos = null;
    tipoPlan = -1;
    precioTope = -1.0;
    condicionSalud = -1;


  }

  PreferenciasCliente.allArgs(
      this.deporte,
      this.expecienciaEnDisciplina,
      this.modalidad,
      this.localizacionEntrenamiento,
      //this.objetivos,
      this.tipoPlan,
      this.precioTope,
      this.condicionSalud);

  PreferenciasCliente.fromJson(Map<String, dynamic> preferencias) {
    deporte = preferencias['deporte'];
    expecienciaEnDisciplina = preferencias['experienciaEnDisciplina'];
    modalidad = preferencias['modalidad'];
    localizacionEntrenamiento = preferencias['localizacionEntrenamiento'];
    //objetivos = preferencias['objetivos'];
    tipoPlan = preferencias['tipoPlan'];
    precioTope = preferencias['precioTope'];
    condicionSalud = preferencias['condicionSalud'];
  }

  Map<String, dynamic> toJson() {
    return {
      'deporte': deporte,
      'expecienciaEnDisciplina': expecienciaEnDisciplina,
      'modalidad': modalidad,
      'localizacionEntrenamiento': localizacionEntrenamiento,
      //'objetivos': objetivos,
      'tipoPlan': tipoPlan,
      'precioTope': precioTope,
      'condicionSalud': condicionSalud
    };
  }

  dynamic getFromQuestion(String question) {
    switch (question) {
      case 'DEPORTE':
        {
          return deporte;
        }
      case 'EXPERIENCIA_DISCIPLINA':
        {
          return expecienciaEnDisciplina;
        }
      case 'MODALIDAD':
        {
          return modalidad;
        }
      case 'LOCALIZACION':
        {
          return localizacionEntrenamiento;
        }
      case 'TIPO_PLAN':
        {
          return tipoPlan;
        }
      case 'PRECIO':
        {
          return precioTope;
        }
      case 'CONDICION_SALUD':
        {
          return condicionSalud;
        }
    }
  }

  void setFromQuestion(String question, dynamic response) {
    switch (question) {
      case 'DEPORTE':
        {
          deporte = response;
        }
        break;
      case 'EXPERIENCIA_DISCIPLINA':
        {
          expecienciaEnDisciplina = response;
        }
        break;
      case 'MODALIDAD':
        {
          modalidad = response;
        }
        break;
      case 'LOCALIZACION':
        {
          localizacionEntrenamiento = response;
        }
        break;
      case 'TIPO_PLAN':
        {
          tipoPlan = response;
        }
        break;
      case 'PRECIO':
        {
          precioTope = response;
        }
        break;
      case 'CONDICION_SALUD':
        {
          condicionSalud = response;
        }
        break;
    }
  }
}
