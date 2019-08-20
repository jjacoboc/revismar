class Util {

  static String parseDocumentType(String type) {
    String code;
    switch(type) {
      case "DNI": {code = "1"; break;}
      case "CDI": {code = "2"; break;}
    }
    return code;
  }

  static String obscureEmail(String email) {
    List<String> list = email.split('@');
    String user = list[0];
    String domain = list[1];
    String obscureEmail = '';
    obscureEmail = user.substring(0, 3);
    for(int i = 0; i < user.length - 3; i++) {
      obscureEmail = obscureEmail + '*';
    }
    obscureEmail = obscureEmail + '@';
    obscureEmail = obscureEmail + domain.substring(0,1);
    for(int i = 0; i < domain.length - 1; i++) {
      obscureEmail = obscureEmail + '*';
    }
    return obscureEmail;
  }
}
