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
    super.textStyle = const TextStyle(fontSize: 14),
  });
}

/// A unified footer for the application that shows a centered text for "noMore".
/// A unified custom footer for the application.
class AppRefreshFooter extends BuilderFooter {
  AppRefreshFooter({
    super.triggerOffset = 52.0,
    super.infiniteOffset = 60,
    super.clamping = false,

    super.position = IndicatorPosition.behind,
    super.processedDuration = Duration.zero, // 加载成功后立即消失
  }) : super(
    builder: (context, state) {
      Widget widget;
      const textStyle = TextStyle(fontSize: 14, color: Colors.black54);

      // 根据状态返回不同的 Widget
      switch (state.mode) {
        case IndicatorMode.drag:
          widget = const Text('上拉加载', style: textStyle);
          break;
        case IndicatorMode.armed:
          widget = const Text('释放加载', style: textStyle);
          break;
        case IndicatorMode.ready:
        case IndicatorMode.processing:
          widget = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(
              //   width: 20,
              //   height: 20,
              //   child: CircularProgressIndicator(strokeWidth: 2.0, color: iconColor),
              // ),
              // const SizedBox(width: 10),
              const Text('加载中...', style: textStyle),
            ],
          );
          break;
        case IndicatorMode.processed:
          if (state.result == IndicatorResult.fail) {
            widget = const Text('加载失败', style: textStyle);
          } else if (state.result == IndicatorResult.noMore) {
            // 如果加载成功但没有更多数据了，也显示 "没有更多数据了"
            widget =  Text('没有更多数据了', style: textStyle);
          } else {
            // 加载成功，快速消失
            widget = const SizedBox();
          }
          break;
        default:
          if (state.result == IndicatorResult.noMore) {
            // 如果加载成功但没有更多数据了，也显示 "没有更多数据了"
            widget =  Text('没有更多数据了', style: textStyle);
          }else{
            widget = const SizedBox();
          }
          break;
      }

      // 返回一个固定高度、居中的容器来包裹状态 Widget
      return SizedBox(
        height: state.offset,
        child: Align(
          alignment: Alignment.center,
          child: widget,
        ),
      );
    },
  );
}
