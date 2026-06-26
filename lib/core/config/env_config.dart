class EnvConfig {
  EnvConfig._();

  static const String environment = String.fromEnvironment('ENV_NAME', defaultValue: 'DEV');
  static const String baseUrl = String.fromEnvironment('BASE_URL', defaultValue: 'https://newsapi.org/v2/'); 
  
  // Menambahkan penampung API Key (Akan kita isi dari launch.json atau Termux nanti)
  static const String apiKey = String.fromEnvironment('API_KEY', defaultValue: '0b9635b7b683424c98ec63c501640896');

  static bool get isProduction => environment == 'PROD';
}
