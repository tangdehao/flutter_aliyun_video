package com.sm9i.aliyun_video.aliyun.activity;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.aliyun.common.utils.ToastUtil;
import com.aliyun.jasonparse.JSONSupportImpl;
import com.aliyun.querrorcode.AliyunErrorCode;
import com.aliyun.svideo.sdk.external.struct.common.VideoDisplayMode;
import com.aliyun.svideo.sdk.external.struct.common.VideoQuality;
import com.aliyun.svideo.sdk.external.struct.encoder.VideoCodecs;
import com.aliyun.svideo.sdk.external.struct.snap.AliyunSnapVideoParam;
import com.duanqu.transcode.NativeParser;

import java.lang.ref.WeakReference;

import com.sm9i.aliyun_video.R;
import com.sm9i.aliyun_video.aliyun.base.utils.FastClickUtil;
import com.sm9i.aliyun_video.aliyun.base.widget.ProgressDialog;
import com.sm9i.aliyun_video.aliyun.bean.AlivcRecordInputParam;
import com.sm9i.aliyun_video.aliyun.common.utils.ToastUtils;
import com.sm9i.aliyun_video.aliyun.media.GalleryDirChooser;
import com.sm9i.aliyun_video.aliyun.media.GalleryMediaChooser;
import com.sm9i.aliyun_video.aliyun.media.MediaDir;
import com.sm9i.aliyun_video.aliyun.media.MediaImageLoader;
import com.sm9i.aliyun_video.aliyun.media.MediaInfo;
import com.sm9i.aliyun_video.aliyun.media.MediaStorage;
import com.sm9i.aliyun_video.aliyun.media.SelectedMediaAdapter;
import com.sm9i.aliyun_video.aliyun.media.ThumbnailGenerator;
import com.sm9i.aliyun_video.aliyun.util.FixedToastUtils;
import com.sm9i.aliyun_video.aliyun.util.MixVideoTranscoder;

import static com.sm9i.aliyun_video.aliyun.util.MixVideoTranscoder.HEIGHT;
import static com.sm9i.aliyun_video.aliyun.util.MixVideoTranscoder.WIDTH;


/**
 * 合拍选择视频界面，目前只能选择30秒以下的视频
 */
public class AlivcMixMediaActivity extends AppCompatActivity implements View.OnClickListener {

    public static final int REQUEST_CODE = 1990;
    public static final int RESPONSE_CODE = 1991;
    private final String TAG = getClass().getSimpleName();

    /**
     * 目前支持 2秒-30秒之内的视频
     */
    private static final int MIN_VIDEO_DURATION = 2000;
    private static final int MAX_VIDEO_DURATION = 6 * 10000;
    private static final int IMAGE_DURATION = 3000;//图片代表的时长
    private VideoDisplayMode cropMode = VideoDisplayMode.FILL;
    private MediaStorage mStorage;
    private GalleryMediaChooser mGalleryMediaChooser;
    private ProgressDialog mProgressDialog;
    private TextView mTitle;
    private ImageButton mBtnBack;
    private TextView mTvTotalDuration;

    private ThumbnailGenerator mThumbnailGenerator;
    private SelectedMediaAdapter mSelectedVideoAdapter;
    private Button mBtnNextStep;

    private static final String BUNDLE_KEY_SAVE_MEDIAS = "bundle_key_save_transcoder";


    private AliyunSnapVideoParam mAliyunSnapVideoParam;

    private MixVideoTranscoder mMixVideoTranscoder;

    public AlivcMixMediaActivity() {
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        setContentView(R.layout.alivc_recorder_activity_mix_media);

        getData();
        initMixVideoTranscoder();
        initView();
    }

    private void initMixVideoTranscoder() {
        mMixVideoTranscoder = new MixVideoTranscoder();
        mMixVideoTranscoder.init(this);
        mMixVideoTranscoder.setTranscodeListener(new MixVideoTranscoder.TranscoderListener() {
            @Override
            public void onError(Throwable e, final int errorCode) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (mProgressDialog != null) {
                            mProgressDialog.dismiss();
                        }
                        switch (errorCode) {
                            case AliyunErrorCode.ALIVC_SVIDEO_ERROR_MEDIA_NOT_SUPPORTED_AUDIO:
                                ToastUtil.showToast(AlivcMixMediaActivity.this, R.string.alivc_record_not_supported_audio);
                                break;
                            case AliyunErrorCode.ALIVC_SVIDEO_ERROR_MEDIA_NOT_SUPPORTED_VIDEO:
                                ToastUtil.showToast(AlivcMixMediaActivity.this, R.string.alivc_record_video_crop_failed);
                                break;
                            case AliyunErrorCode.ALIVC_COMMON_UNKNOWN_ERROR_CODE:
                            default:
                                ToastUtil.showToast(AlivcMixMediaActivity.this, R.string.alivc_record_video_crop_failed);
                        }
                    }
                });

            }

            @Override
            public void onProgress(int progress) {
                if (mProgressDialog != null) {
                    mProgressDialog.setProgress(progress);
                }
            }


            @Override
            public void onComplete(MediaInfo resultVideos) {
                Log.d("TRANCODE", "ONCOMPLETED, dialog : " + (mProgressDialog == null));
                if (mProgressDialog != null) {
                    mProgressDialog.dismiss();
                }
                //跳转AlivcSvideoRecordActivity
                startMixRecord(resultVideos.filePath);
            }

            @Override
            public void onCancelComplete() {
                //取消完成
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        mBtnNextStep.setEnabled(true);
                    }
                });
            }
        });
    }

    void startMixRecord(String path) {
        AlivcSvideoMixRecordActivity.startMixRecord(AlivcMixMediaActivity.this, mAliyunSnapVideoParam, path);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (requestCode == REQUEST_CODE && resultCode == RESPONSE_CODE) {
            setResult(RESPONSE_CODE, data);
            Log.i("地址onActivityResult", data.getStringExtra("param"));
            finish();
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    private void getData() {
        /**
         * 录制参数
         */
        int mResolutionMode = getIntent().getIntExtra(AlivcRecordInputParam.INTENT_KEY_RESOLUTION_MODE, AliyunSnapVideoParam.RESOLUTION_540P);
        int mRatioMode = getIntent().getIntExtra(AlivcRecordInputParam.INTENT_KEY_RATION_MODE, AliyunSnapVideoParam.RATIO_MODE_3_4);
        int mGop = getIntent().getIntExtra(AlivcRecordInputParam.INTENT_KEY_GOP, 250);
        VideoQuality mVideoQuality = (VideoQuality) getIntent().getSerializableExtra(AlivcRecordInputParam.INTENT_KEY_QUALITY);
        if (mVideoQuality == null) {
            mVideoQuality = VideoQuality.HD;
        }
        VideoCodecs mVideoCodec = (VideoCodecs) getIntent().getSerializableExtra(AlivcRecordInputParam.INTENT_KEY_CODEC);
        if (mVideoCodec == null) {
            mVideoCodec = VideoCodecs.H264_HARDWARE;
        }
        /**
         * 帧率裁剪参数,默认30
         */
        int frame = getIntent().getIntExtra(AlivcRecordInputParam.INTENT_KEY_FRAME, 30);

        mAliyunSnapVideoParam = new AliyunSnapVideoParam.Builder()
                .setResulutionMode(mResolutionMode)
                .setRatioMode(mRatioMode)
                .setGop(mGop)
                .setVideoCodec(mVideoCodec)
                .setFrameRate(frame)
                .setCropMode(cropMode)
                .setVideoQuality(mVideoQuality)
                .build();
    }

    private void initView() {

        mBtnNextStep = findViewById(R.id.btn_next_step);
        RecyclerView galleryView = (RecyclerView) findViewById(R.id.gallery_media);
        mTitle = (TextView) findViewById(R.id.gallery_title);
        mTitle.setText(R.string.alivc_media_gallery_all_media);
        mBtnBack = (ImageButton) findViewById(R.id.gallery_closeBtn);
        mBtnBack.setOnClickListener(this);
        mStorage = new MediaStorage(this, new JSONSupportImpl());
        mThumbnailGenerator = new ThumbnailGenerator(this);
        GalleryDirChooser galleryDirChooser = new GalleryDirChooser(this, findViewById(R.id.topPanel),
                mThumbnailGenerator, mStorage);
        mGalleryMediaChooser = new GalleryMediaChooser(galleryView, galleryDirChooser, mStorage, mThumbnailGenerator, this);
        mStorage.setVideoDurationRange(MIN_VIDEO_DURATION, MAX_VIDEO_DURATION);

        int sortMode = MediaStorage.SORT_MODE_VIDEO;
        mStorage.setSortMode(sortMode);
        try {
            mStorage.startFetchmedias();
        } catch (SecurityException e) {
            FixedToastUtils.show(AlivcMixMediaActivity.this, getString(R.string.alivc_record_request_no_permission_content_text));
        }
        mStorage.setOnMediaDirChangeListener(new MediaStorage.OnMediaDirChange() {
            @Override
            public void onMediaDirChanged() {
                MediaDir dir = mStorage.getCurrentDir();
                if (dir.id == -1) {
                    mTitle.setText(getString(R.string.alivc_media_gallery_all_media));
                } else {
                    mTitle.setText(dir.dirName);
                }
                mGalleryMediaChooser.changeMediaDir(dir);
            }
        });
        mStorage.setOnCompletionListener(new MediaStorage.OnCompletion() {
            @Override
            public void onCompletion() {
                MediaDir dir = mStorage.getCurrentDir();
                if (dir != null && dir.id != -1) {
                    //选择了媒体目录时，在加载完成的时候需要刷新一次
                    mTitle.setText(dir.dirName);
                    mGalleryMediaChooser.changeMediaDir(dir);
                }
            }
        });
        mStorage.setOnCurrentMediaInfoChangeListener(new MediaStorage.OnCurrentMediaInfoChange() {
            @Override
            public void onCurrentMediaInfoChanged(MediaInfo info) {

                Log.i(TAG, "log_editor_video_path : " + info.filePath);
                MediaInfo infoCopy = new MediaInfo();
                infoCopy.addTime = info.addTime;
                infoCopy.mimeType = info.mimeType;
                String outputPath = null;
                if (info.mimeType.startsWith("image")) {
                    if (info.filePath.endsWith("gif") || info.filePath.endsWith("GIF")) {
                        NativeParser parser = new NativeParser();
                        parser.init(info.filePath);
                        int frameCount = 0;
                        try {
                            frameCount = Integer.parseInt(parser.getValue(NativeParser.VIDEO_FRAME_COUNT));
                        } catch (Exception e) {
                            ToastUtils.show(AlivcMixMediaActivity.this, R.string.alivc_record_error_tip_play_video_error);
                            return;
                        }
                        //当gif动图为一帧的时候当作图片处理，否则当作视频处理
                        if (frameCount > 1) {
                            infoCopy.mimeType = "video";
                            infoCopy.duration = Integer.parseInt(parser.getValue(NativeParser
                                    .VIDEO_DURATION)) / 1000;
                        } else {
                            infoCopy.duration = IMAGE_DURATION;
                        }

                    } else {
                        infoCopy.duration = IMAGE_DURATION;
                    }

                } else {
                    infoCopy.duration = info.duration;
                }
                if (outputPath != null) {
                    infoCopy.filePath = outputPath;//info.filePath;
                } else {
                    infoCopy.filePath = info.filePath;
                }
                infoCopy.id = info.id;
                infoCopy.isSquare = info.isSquare;
                infoCopy.thumbnailPath = info.thumbnailPath;
                infoCopy.title = info.title;
                infoCopy.type = info.type;
                mTvTotalDuration.setText(convertDuration2Text(info.duration));
                //mMediaInfoList.add(infoCopy);
                /*目前合拍是单选*/
                mSelectedVideoAdapter.addOnlyFirstMedia(infoCopy);
                mMixVideoTranscoder.addMedia(infoCopy);
            }
        });
        RecyclerView rvSelectedVideo = (RecyclerView) findViewById(R.id.rv_selected_video);
        mTvTotalDuration = (TextView) findViewById(R.id.tv_duration_value);
        mSelectedVideoAdapter = new SelectedMediaAdapter(new MediaImageLoader(this), 30 * 1000);
        rvSelectedVideo.setAdapter(mSelectedVideoAdapter);
        rvSelectedVideo.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));
        mTvTotalDuration.setText(convertDuration2Text(0));
        mTvTotalDuration.setActivated(false);

    }

    private String convertDuration2Text(long duration) {
        int sec = Math.round(((float) duration) / 1000);
        int hour = sec / 3600;
        int min = (sec % 3600) / 60;
        sec = (sec % 60);
        return String.format(getString(R.string.alivc_media_video_duration), hour, min, sec);
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        mStorage.saveCurrentDirToCache();
        mStorage.cancelTask();
        mThumbnailGenerator.cancelAllTask();
        mMixVideoTranscoder.release();
    }

    /**
     * 选择合拍视频界面入口
     *
     * @param context Context
     * @param param   AliyunSnapVideoParam
     */
    /**
     * 开启录制
     *
     * @param activity         上下文
     * @param recordInputParam 录制输入参数
     */
    public static void startRecord(Activity activity, AlivcRecordInputParam recordInputParam) {
        Intent intent = new Intent(activity, AlivcMixMediaActivity.class);
        intent.putExtra(AlivcRecordInputParam.INTENT_KEY_RESOLUTION_MODE, recordInputParam.getResolutionMode());
        intent.putExtra(AlivcRecordInputParam.INTENT_KEY_MAX_DURATION, recordInputParam.getMaxDuration());
        intent.putExtra(AlivcRecordInputParam.INTENT_KEY_MIN_DURATION, recordInputParam.getMinDuration());
        intent.putExtra(AlivcRecordInputParam.INTENT_KEY_RATION_MODE, recordInputParam.getRatioMode());
        intent.putExtra(AlivcRecordInputParam.INTENT_KEY_GOP, recordInputParam.getGop());
        intent.putExtra(AlivcRecordInputParam.INTENT_KEY_FRAME, recordInputParam.getFrame());
        intent.putExtra(AlivcRecordInputParam.INTENT_KEY_QUALITY, recordInputParam.getVideoQuality());
        intent.putExtra(AlivcRecordInputParam.INTENT_KEY_CODEC, recordInputParam.getVideoCodec());
        intent.putExtra(AlivcRecordInputParam.INTENT_KEY_VIDEO_OUTPUT_PATH, recordInputParam.getVideoOutputPath());
        activity.startActivityForResult(intent, REQUEST_CODE);
    }

    /**
     * progressDialog cancel listener
     */
    private static class OnCancelListener implements DialogInterface.OnCancelListener {

        private WeakReference<AlivcMixMediaActivity> weakReference;

        public OnCancelListener(AlivcMixMediaActivity mediaActivity) {
            weakReference = new WeakReference<>(mediaActivity);
        }

        @Override
        public void onCancel(DialogInterface dialog) {
            AlivcMixMediaActivity mediaActivity = weakReference.get();
            if (mediaActivity != null) {
                //为了防止未取消成功的情况下就开始下一次转码，这里在取消转码成功前会禁用下一步按钮
                mediaActivity.mMixVideoTranscoder.cancel();
            }
        }
    }

    @Override
    public void onClick(View v) {
        if (v == mBtnBack) {
            finish();
        } else if (v.getId() == R.id.btn_next_step) {//点击下一步
            if (FastClickUtil.isFastClickActivity(AlivcMixMediaActivity.class.getSimpleName())) {
                return;
            }
            MediaInfo mediaInfo = mSelectedVideoAdapter.getOnlyOneMedia();
            if (null == mediaInfo) {
                ToastUtils.show(AlivcMixMediaActivity.this, getResources().getString(R.string.alivc_media_please_select_video));
            } else if (isMixTranscoder()) {
                if (mProgressDialog == null || !mProgressDialog.isShowing()) {
                    mProgressDialog = ProgressDialog.show(this, null, getResources().getString(R.string.alivc_media_wait));
                    mProgressDialog.setCancelable(true);
                    mProgressDialog.setCanceledOnTouchOutside(false);
                    mProgressDialog.setOnCancelListener(new OnCancelListener(this));
                    mMixVideoTranscoder.start();
                }
            } else {
                startMixRecord(mediaInfo.filePath);
            }
        }
    }


    /**
     * 如果大于360p需要转码
     */
    private boolean isMixTranscoder() {
        int frameWidth = 0;
        int frameHeight = 0;
        if (mSelectedVideoAdapter != null && mSelectedVideoAdapter.getItemCount() > 0) {
            MediaInfo mediaInfo = mSelectedVideoAdapter.getOnlyOneMedia();
            try {
                NativeParser nativeParser = new NativeParser();
                nativeParser.init(mediaInfo.filePath);
                try {
                    frameWidth = Integer.parseInt(nativeParser.getValue(NativeParser.VIDEO_WIDTH));
                    frameHeight = Integer.parseInt(nativeParser.getValue(NativeParser.VIDEO_HEIGHT));
                } catch (Exception e) {
                    Log.e(TAG, "parse rotation failed");
                }
                nativeParser.release();
                nativeParser.dispose();
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            ToastUtil.showToast(this, R.string.alivc_media_please_select_video);

        }
        return frameWidth * frameHeight > WIDTH * HEIGHT;
    }
}
