class EnvConfig {
  EnvConfig._();

  static const String environment = String.fromEnvironment('ENV_NAME', defaultValue: 'DEV');
  
  // Karena mengambil tema Portal Berita, kita siapkan default Base URL mengarah ke NewsAPI
  static const String baseUrl = String.fromEnvironment('BASE_URL', defaultValue: 'https://newsapi.org/v2/'); 

  static bool get isProduction => environment == 'PROD';
}
