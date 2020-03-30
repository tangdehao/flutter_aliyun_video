package com.sm9i.aliyun_video.aliyun.activity

import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.fragment.app.FragmentActivity
import com.bumptech.glide.Glide
import com.sm9i.aliyun_video.R
import com.sm9i.aliyun_video.aliyun.common.utils.ToastUtils
import kotlinx.android.synthetic.main.activity_pre_view.*
import kotlinx.android.synthetic.main.alivc_editor_include_action_bar_profile.*
import java.io.File
import java.io.FileInputStream
import java.lang.Exception

class PreViewActivity : FragmentActivity() {

    companion object{
         const val resultCode = 1002
    }

    private lateinit var imageUrl: String
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_pre_view)
        if (intent.hasExtra("imagePath")) {
            imageUrl = intent.getStringExtra("imagePath")
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
        Log.i("文件路径", "$imageUrl")
        try {
            val fileInput = FileInputStream(imageUrl)
            val imageBtiMap = BitmapFactory.decodeStream(fileInput)
            iv_pre_image.setImageBitmap(imageBtiMap)
        } catch (e: Exception) {
            Log.e("文件获取失败", "$e")
            ToastUtils.show(this, "文件获取失败请重试")
        }


    }
}
