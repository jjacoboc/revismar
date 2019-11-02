class Constants {
  static const String url_bucket = "https://mgp-reader.s3.us-east-2.amazonaws.com/";
  static const String url_login = "http://52.15.119.234:8080/ereader-service-0.0.1-SNAPSHOT/login/";
  static const String url_books = "http://52.15.119.234:8080/ereader-service-0.0.1-SNAPSHOT/book/";
  static const String url_booksByYear = "http://52.15.119.234:8080/ereader-service-0.0.1-SNAPSHOT/books/";
  static const String url_years = "http://52.15.119.234:8080/ereader-service-0.0.1-SNAPSHOT/years/";
  static const String url_image = "http://52.15.119.234:8080/ereader-service-0.0.1-SNAPSHOT/image/";
  static const String url_document = "http://52.15.119.234:8080/ereader-service-0.0.1-SNAPSHOT/document/";
  static const String url_sections = "http://52.15.119.234:8080/ereader-service-0.0.1-SNAPSHOT/sections/";
  static const String url_articles = "http://52.15.119.234:8080/ereader-service-0.0.1-SNAPSHOT/articles/";
  static const String url_audio = "http://52.15.119.234:8080/ereader-service-0.0.1-SNAPSHOT/audio/";
  static const String url_user = "http://52.15.119.234:8080/ereader-service-0.0.1-SNAPSHOT/user/";
  static const String url_createUser = "http://52.15.119.234:8080/ereader-service-0.0.1-SNAPSHOT/create/suser/";
  static const String url_userByEmail = "http://52.15.119.234:8080/ereader-service-0.0.1-SNAPSHOT/user/email/";
  static const String url_resetPassword = "http://52.15.119.234:8080/ereader-service-0.0.1-SNAPSHOT/reset/password/";

  static const String separator = "/";
  static const String jpg_ext = ".jpg";
  static const String mp3_ext = ".mp3";
  static const String pdf = "pdf";
  static const String mp3 = "mp3";
  static const String frontPage = "caratula";
  static const String defaultCover = "images/defaultCover.jpg";
  static const String splash_title = "Marina de Guerra\n del Perú";
  static const String splash_footer = "Revista de Marina";

  static const String DNI_Code = "1";

  static const String Audio_Book = "1";
  static const String No_Audio_Book = "0";

  static const String alert_success_title = "Éxito!";
  static const String alert_error_title = "Error!";

  static const String resetPass_title = "Olvidó su Contraseña?";
  static const String resetPass_text = "Por favor, ingrese el número de documento registrado en la aplicación para resetear su contraseña.";
  static const String resetPass_btn = "Restaurar Contraseña";
  static const String resetPass_hintText_DNI = "DNI";
  static const String resetPass_error_docNumberRequired = "Debe ingresar su número de documento.";
  static const String resetPass_error_docNumberNotFound = "El número de documento no se encuentra registrado.";

  static const String changePass_title = "Cambio de Contraseña";
  static const String changePass_hintText_OldPass = "Contraseña Actual";
  static const String changePass_hintText_NewPass = "Contraseña Nueva";
  static const String changePass_hintText_ConfirmPass = "Confirmar Contraseña";
  static const String changePass_btn = "Guardar Contraseña";
  static const String changePass_validation1 = "Al menos 8 caracteres";
  static const String changePass_validation2 = "Al menos 1 letra minúscula (a..z)";
  static const String changePass_validation3 = "Al menos 1 letra mayúscula (A..Z)";
  static const String changePass_validation4 = "Al menos 1 número (0..9)";
  static const String changePass_success_description = "Su nueva contraseña ha sido registrada!";
  static const String changePass_error_passRequired = "Debe ingresar su contraseña actual.";
  static const String changePass_error_newPassRequired = "Debe ingresar su nueva contraseña.";
  static const String changePass_error_confirmPassRequired = "Debe ingresar la confirmación de su nueva contraseña.";
  static const String changePass_error_confirmPassEquals = "La confirmación de la contraseña no coincide con la nueva contraseña ingresada.";
  static const String changePass_error_unexpected = "Ocurrió un error inesperado!\nPor favor, comuníquese con el proveedor del servicio.";
}