package com.sm9i.aliyun_video

import android.app.Activity
import android.content.Context
import android.content.Intent
import com.aliyun.common.global.Version
import com.aliyun.svideo.sdk.external.struct.common.VideoQuality
import com.aliyun.svideo.sdk.external.struct.encoder.VideoCodecs
import com.sm9i.aliyun_video.aliyun.activity.AlivcSvideoRecordActivity
import com.sm9i.aliyun_video.aliyun.bean.AlivcRecordInputParam
import com.sm9i.aliyun_video.aliyun.editor.bean.AlivcEditInputParam
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.HashMap

class AliyunVideoPlugin : MethodCallHandler {

    private val context: Context
    private val activity: Activity
    private val resultMap: HashMap<String, Result>

    constructor(registrar: Registrar) {
        this.context = registrar.context()
        this.activity = registrar.activity()
        this.resultMap = HashMap()
        registrar.addActivityResultListener { reqCode, respCode, intent ->
            if (reqCode == AlivcSvideoRecordActivity.REQUEST_CODE) {
                //filePath 
                //  0  是video  1 是photo 
                // 如果fileTye =-1 则失败 

                val map = HashMap<String, String>()

                if (intent == null) {
                    map["fileType"] = "-1"
                    resultMap[AlivcSvideoRecordActivity.REQUEST_CODE.toString()]?.success(map)
                    return@addActivityResultListener false
                }
                if (intent.hasExtra("param")) {
                    map["filePath"] = intent.getStringExtra("param")

                }
                when (respCode) {
                    AlivcSvideoRecordActivity.RESPONSE_VIDEO_CODE -> {
                        map["fileType"] = "0"
                    }
                    AlivcSvideoRecordActivity.RESPONSE_PHOTO_CODE -> {
                        map["fileType"] = "1"
                    }
                }
                if (!map.containsKey("filePath")) {
                    map["fileType"] = "-1"s
                }

                resultMap[AlivcSvideoRecordActivity.REQUEST_CODE.toString()]?.success(map)
            }
            false
        }
    }


    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {

            val channel = MethodChannel(registrar.messenger(), "aliyun_video")
            channel.setMethodCallHandler(AliyunVideoPlugin(registrar))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when {
            call.method == "startVideo" -> startVideo(call, result)
            else -> result.notImplemented()
        }
    }

    private lateinit var result: Result

    private fun startVideo(call: MethodCall, result: Result) {
        this.result = result

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
}
