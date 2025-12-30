/// 环境
enum Environment {
  dev,
  test,
  prod,
}

/// 环境配置
class EnvConfig {
  // 当前环境
  static late Environment _currentEnvironment;

  // 不同环境对应的-baseUrl
  static final Map<Environment, String> _baseUrls = {
    Environment.dev: 'https://dev.api.com',
    Environment.test: 'https://test.api.com',
    // 我们暂时用旧的地址作为生产环境地址
    Environment.prod: 'https://jsonplaceholder.typicode.com',
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
