import 'dart:async';

import 'package:flutter/services.dart';

class AliyunVideo {
  static const MethodChannel _channel = const MethodChannel('aliyun_video');

  ///
  /// 开始拍摄
  /// [createType]    拍摄类型  0 视频 1 照片
  /// [mResolutionMode]    分辨率
  /// [mMaxDuration] 最长时间
  /// [mMinDuration]  最短时间
  /// [mRatioMode]  比例
  /// [mGop] 录制视频的关键帧间隔
  /// [mFrame]  录制视频的帧率
  /// [mVideoQuality] 录制视频的视频质量
  /// [mVideoCodec]录制视频的编码方式
  /// 参数参见   com.sm9i.aliyun_video.aliyun.activity.AlivcSvideoRecordActivity
  ///
  /// @return [AliyunResult]
  static Future<AliyunResult> startCamera({
    int mCreateType = 0,
    int mResolutionMode = ResolutionMode.DEFAULT_RESOLUTION_720P,
    int mMaxDuration = 15 * 1000,
    int mMinDuration = 2 * 1000,
    int mRatioMode = RatioMode.DEFAULT_RATIO_MODE_9_16,
    int mGop = 250,
    int mFrame = 30,
    String mVideoQuality = QualityMode.DEFAULT_QUALITY_HD,
    String mVideoCodec = CodecsMode.DEFAULT_CODECS_H264_HARDWARE,
  }) async {
    final res = await _channel.invokeMethod('startVideo', {
      "mCreateType": mCreateType,
      "mResolutionMode": mResolutionMode,
      "mMaxDuration": mMaxDuration,
      "mMinDuration": mMinDuration,
      "mRatioMode": mRatioMode,
      "mGop": mGop,
      "mFrame": mFrame,
      "mVideoQuality": mVideoQuality,
      "mVideoCodec": mVideoCodec,
    });
    if (res == null) return null;
    return AliyunResult.fromMap(res);
  }
}

class AliyunResult {
  //文件类型
  // 0 视频
  // 1 照片
  // -1 失败
  int fileType;

  //文件路径
  String filePath;

  AliyunResult.fromMap(map) {
    this.fileType = int.parse(map['fileType']) ?? -1;
    this.filePath = map['filePath'] ?? '';
  }
}

///分辨率
class ResolutionMode {
  static const int DEFAULT_RESOLUTION_360P = 0;
  static const int DEFAULT_RESOLUTION_480P = 1;
  static const int DEFAULT_RESOLUTION_540P = 2;
  static const int DEFAULT_RESOLUTION_720P = 3;
}

///屏幕比例
class RatioMode {
  static const int DEFAULT_RATIO_MODE_3_4 = 0;
  static const int DEFAULT_RATIO_MODE_1_1 = 1;
  static const int DEFAULT_RATIO_MODE_9_16 = 2;
}

///质量
class QualityMode {
  static const String DEFAULT_QUALITY_SSD = 'SSD';
  static const String DEFAULT_QUALITY_HD = 'HD';
  static const String DEFAULT_QUALITY_SD = 'SD';
  static const String DEFAULT_QUALITY_LD = 'LD';
  static const String DEFAULT_QUALITY_PD = 'PD';
  static const String DEFAULT_QUALITY_EPD = 'EPD';
}

///编码
class CodecsMode {
  static const String DEFAULT_CODECS_H264_HARDWARE = 'H264_HARDWARE';
  static const String DEFAULT_CODECS_H264_H264_SOFT_OPENH264 =
      'H264_SOFT_OPENH264';
  static const String DEFAULT_CODECS_H264_H264_SOFT_FFMPEG = 'H264_SOFT_FFMPEG';
}
