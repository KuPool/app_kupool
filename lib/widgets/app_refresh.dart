import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

/// A unified classic header for the application.
class AppRefreshHeader extends ClassicHeader {
  const AppRefreshHeader({
    super.key,
    super.dragText = '下拉刷新',
    super.triggerOffset = 50,
    super.armedText = '释放刷新',
    super.readyText = '刷新中...',
    super.processingText = '刷新中...',
    super.processedText = '刷新成功',
    super.failedText = '刷新失败',
    super.messageText = '上次更新 %T',
  });
}

/// A unified classic footer for the application.
class AppRefreshFooter extends ClassicFooter {
  const AppRefreshFooter({
    super.key,
    super.dragText = '上拉加载',
    super.armedText = '释放加载',
    super.readyText = '加载中...',
    super.processingText = '加载中...',
    super.processedText = '加载成功',
    super.failedText = '加载失败',
    super.noMoreText = '没有更多数据了',
    super.showMessage = false,
  });
}
