package com.sm9i.aliyun_video.aliyun.activity

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.util.Log
import android.view.View
import androidx.annotation.RequiresApi
import androidx.fragment.app.FragmentActivity
import com.sm9i.aliyun_video.R
import com.sm9i.aliyun_video.aliyun.common.utils.ToastUtils
import kotlinx.android.synthetic.main.activity_pre_video.*
import kotlinx.android.synthetic.main.activity_pre_view.bar_linear
import kotlinx.android.synthetic.main.alivc_editor_include_action_bar_profile.*
import java.io.File


class PreVideoActivity : FragmentActivity() {
    companion object {
        const val resultCode = 1003
    }


    private val handler = Handler()
    private val runnable: Runnable = object : Runnable {
        override fun run() {
            if (video_view.isPlaying) {
                val current: Int = video_view.currentPosition
                runOnUiThread {
                    tv_time.text = "${(current / 1000).toInt()}:00:${(video_view.duration / 1000).toInt()}:00"
                }
            }
            handler.postDelayed(this, 1000)
        }
    }

    private lateinit var videoPath: String
    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_pre_video)
        if (intent.hasExtra("videoPath")) {
            videoPath = intent.getStringExtra("videoPath")
        }
        bar_linear.bringToFront()
        iv_left.setImageResource(R.mipmap.aliyun_svideo_back)
        iv_left.visibility = View.VISIBLE
        iv_left.setOnClickListener {
            val i = Intent()
            i.putExtra("res", false)
            setResult(resultCode, i)
            finish()
        }
        tv_right.visibility = View.VISIBLE
        tv_right.setOnClickListener {
            val i = Intent()
            i.putExtra("res", true)
            setResult(resultCode, i)
            finish()
        }
        Log.i("文件路径", "$videoPath")

        try {
            val file = File(videoPath)
            video_view.setVideoPath(file.absolutePath)
            video_view.setOnPreparedListener {
                video_view.start()
            }
            video_view.setOnCompletionListener {
                video_view.start()
            }
            runnable.run()


            play_button.setText(R.string.alivc_editor_edit_play_pause)
//            play_button.setBackgroundResource()
            iv_play.setImageResource(R.mipmap.aliyun_svideo_pause)
            ll_button.setOnClickListener {

                if (video_view.isPlaying) {
                    video_view.pause()
                    play_button.setText(R.string.alivc_editor_edit_play_start)
//                    play_button.setBackgroundResource(R.mipmap.aliyun_svideo_play)
                    iv_play.setImageResource(R.mipmap.aliyun_svideo_play)
                } else {
                    video_view.start()
                    play_button.setText(R.string.alivc_editor_edit_play_pause)
//                    play_button.setBackgroundResource(R.mipmap.aliyun_svideo_pause)
                    iv_play.setImageResource(R.mipmap.aliyun_svideo_pause)
                }


            }

            video_view.setOnInfoListener { _, position, total ->
                Log.i("video", "$position")
                Log.i("video", "$total")
                return@setOnInfoListener true
            }
        } catch (e: Exception) {
            Log.e("文件获取失败", "$e")
            ToastUtils.show(this, "文件获取失败请重试")
        }
    }

    override fun onDestroy() {
        handler.removeCallbacks(runnable)
        video_view.stopPlayback()
        super.onDestroy()
    }
}