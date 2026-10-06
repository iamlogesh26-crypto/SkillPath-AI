class ApiConstants {
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'AQ.Ab8RN6KB8_tXvAcajh8YBjriNxJFEEfQI13pJNFSKbgflJl-uA',
  );

  static const String geminiPrimaryModel = 'gemini-3.5-flash';
  static const String geminiFallbackModel = 'gemini-3.5-flash-lite';
}
