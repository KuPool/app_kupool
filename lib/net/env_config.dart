/// 环境
enum Environment {
  // dev,
  test,
  prod,
}

/// 环境配置
class EnvConfig {
  // 当前环境
  static late Environment _currentEnvironment;

  // 不同环境对应的-baseUrl
  static final Map<Environment, String> _baseUrls = {
    // dev是本地ip
    // Environment.dev: 'https://dev.api.com',
    Environment.test: 'https://www.ku-pool.com',
    Environment.prod: 'https://www.kupool.com',
  };

  /// 设置当前环境
  static void setEnvironment(Environment env) {
    _currentEnvironment = env;
  }

  /// 获取当前环境的baseUrl
  static String get baseUrl {
    return _baseUrls[_currentEnvironment]!;
  }
}
