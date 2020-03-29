package com.sm9i.aliyun_video

import android.app.Activity
import android.content.Intent
import android.util.Log
import com.aliyun.svideo.sdk.external.struct.common.VideoQuality
import com.aliyun.svideo.sdk.external.struct.encoder.VideoCodecs
import com.sm9i.aliyun_video.aliyun.activity.AlivcMixMediaActivity
import com.sm9i.aliyun_video.aliyun.activity.AlivcSvideoRecordActivity
import com.sm9i.aliyun_video.aliyun.bean.AlivcRecordInputParam
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MethodCallHandlerImpl(private var activity: Activity, messenger: BinaryMessenger) :
        MethodChannel.MethodCallHandler, PluginRegistry.ActivityResultListener {

    private var methodChannel: MethodChannel = MethodChannel(messenger, "aliyun_video")
    private val resultMap: HashMap<String, MethodChannel.Result> = HashMap()

    init {
        methodChannel.setMethodCallHandler(this)
    }

    fun stopListening() {
        methodChannel.setMethodCallHandler(null)
    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "startVideo" -> startVideo(call, result)
            "startCooperationVideo" -> startCooperationVideo(call, result)
            else -> result.notImplemented()
        }
    }


    private fun startCooperationVideo(call: MethodCall, result: MethodChannel.Result) {
//        //AlivcSvideoMixRecordActivity.startMixRecord()
//        val recordInputParam = AlivcRecordInputParam.Builder()
//                .setResolutionMode(LittleVideoParamConfig.Recorder.RESOLUTION_MODE)
//                .setRatioMode(LittleVideoParamConfig.Recorder.RATIO_MODE)
//                .setMaxDuration(LittleVideoParamConfig.Recorder.MAX_DURATION)
//                .setMinDuration(LittleVideoParamConfig.Recorder.MIN_DURATION)
//                .setVideoQuality(LittleVideoParamConfig.Recorder.VIDEO_QUALITY)
//                .setGop(LittleVideoParamConfig.Recorder.GOP)
//                .setVideoCodec(LittleVideoParamConfig.Recorder.VIDEO_CODEC)
//                .build()
        val param = AlivcRecordInputParam()
        call.argument<Int>(AlivcRecordInputParam.INTENT_KEY_RESOLUTION_MODE)?.let {
            param.resolutionMode = it
        }
        call.argument<Int>(AlivcRecordInputParam.INTENT_KEY_MAX_DURATION)?.let {
            param.maxDuration = it
        }
        call.argument<Int>(AlivcRecordInputParam.INTENT_KEY_MIN_DURATION)?.let {
            param.minDuration = it
        }
        call.argument<Int>(AlivcRecordInputParam.INTENT_KEY_RATION_MODE)?.let {
            param.ratioMode = it
        }
        call.argument<Int>(AlivcRecordInputParam.INTENT_KEY_GOP)?.let {
            param.gop = it
        }
        call.argument<Int>(AlivcRecordInputParam.INTENT_KEY_FRAME)?.let {
            param.frame = it
        }
        call.argument<String>(AlivcRecordInputParam.INTENT_KEY_QUALITY)?.let {
            param.videoQuality = VideoQuality.valueOf(it)
        }
        call.argument<String>(AlivcRecordInputParam.INTENT_KEY_CODEC)?.let {
            param.videoCodec = VideoCodecs.valueOf(it)
        }
        AlivcMixMediaActivity.startRecord(activity, param)
        resultMap[AlivcMixMediaActivity.REQUEST_CODE.toString()] = result
    }


    private fun startVideo(call: MethodCall, result: MethodChannel.Result) {
        val param = AlivcRecordInputParam()
        call.argument<Int>(AlivcRecordInputParam.INTENT_KEY_RESOLUTION_MODE)?.let {
            param.resolutionMode = it
        }
        call.argument<Int>(AlivcRecordInputParam.INTENT_KEY_MAX_DURATION)?.let {
            param.maxDuration = it
        }
        call.argument<Int>(AlivcRecordInputParam.INTENT_KEY_MIN_DURATION)?.let {
            param.minDuration = it
        }
        call.argument<Int>(AlivcRecordInputParam.INTENT_KEY_RATION_MODE)?.let {
            param.ratioMode = it
        }
        call.argument<Int>(AlivcRecordInputParam.INTENT_KEY_GOP)?.let {
            param.gop = it
        }
        call.argument<Int>(AlivcRecordInputParam.INTENT_KEY_FRAME)?.let {
            param.frame = it
        }
        call.argument<String>(AlivcRecordInputParam.INTENT_KEY_QUALITY)?.let {
            param.videoQuality = VideoQuality.valueOf(it)
        }
        call.argument<String>(AlivcRecordInputParam.INTENT_KEY_CODEC)?.let {
            param.videoCodec = VideoCodecs.valueOf(it)
        }
        call.argument<Int>(AlivcRecordInputParam.INTENT_KEY_CREATE_TYPE)?.let {
            param.createType = it
            print("createType  $it")
        }
        AlivcSvideoRecordActivity.startRecord(activity, param)
        resultMap[AlivcSvideoRecordActivity.REQUEST_CODE.toString()] = result
    }


    override fun onActivityResult(reqCode: Int, resultCode: Int, intent: Intent?): Boolean {
        if (reqCode == AlivcSvideoRecordActivity.REQUEST_CODE) {
            //filePath
            //  0  是video  1 是photo
            // 如果fileTye =-1 则失败
            val map = HashMap<String, String>()
            if (intent == null) {
                map["fileType"] = "-1"
                resultMap[AlivcSvideoRecordActivity.REQUEST_CODE.toString()]?.success(map)
                return false
            }
            if (intent.hasExtra("param")) {
                map["filePath"] = intent.getStringExtra("param")
            }
            when (resultCode) {
                AlivcSvideoRecordActivity.RESPONSE_VIDEO_CODE -> {
                    map["fileType"] = "0"
                }
                AlivcSvideoRecordActivity.RESPONSE_PHOTO_CODE -> {
                    map["fileType"] = "1"
                }
            }
            if (!map.containsKey("filePath")) {
                map["fileType"] = "-1"
            }
            resultMap[AlivcSvideoRecordActivity.REQUEST_CODE.toString()]?.success(map)

        } else if (reqCode == AlivcMixMediaActivity.REQUEST_CODE && resultCode == AlivcMixMediaActivity.RESPONSE_CODE) {
            val map = HashMap<String, String>()
            if (intent == null) {
                map["fileType"] = "-1"
                resultMap[AlivcSvideoRecordActivity.REQUEST_CODE.toString()]?.success(map)
                return false
            }
            if (intent.hasExtra("param")) {
                map["filePath"] = intent.getStringExtra("param")
                map["fileType"] = "0"
                Log.i("intent hasExtra", intent.getStringExtra("param"))
            }
            if (!map.containsKey("filePath")) {
                map["fileType"] = "-1"
            }
            resultMap[AlivcMixMediaActivity.REQUEST_CODE.toString()]?.success(map)

        }
        return false

    }
}