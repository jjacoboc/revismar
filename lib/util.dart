class Util {

  static String parseDocumentType(String type) {
    String code;
    switch(type) {
      case "DNI": {code = "1"; break;}
      case "CDI": {code = "2"; break;}
    }
    return code;
  }
}
