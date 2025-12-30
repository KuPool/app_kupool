import 'package:flutter/material.dart';

/// 一个用于管理页面加载状态的`Mixin`。
///
/// 通过混入到 `State` 类中，可以轻松地为异步操作添加加载状态管理，
/// 避免了重复编写 `isLoading` 标志位和 `setState` 的模板代码。
mixin LoadingStateMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;

  /// 当前是否处于加载状态。
  bool get isLoading => _isLoading;

  /// 安全地执行一个异步操作，并自动管理加载状态。
  ///
  /// 在执行[action]之前，它会设置`isLoading`为`true`并更新UI。
  /// 操作完成后（无论成功或失败），它都会将`isLoading`设置回`false`。
  ///
  /// 如果当前已处于加载状态，则此方法不会重复执行。
  Future<void> runWithLoading(Future<void> Function() action) async {
    if (_isLoading) {
      return;
    }

    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      await action();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
