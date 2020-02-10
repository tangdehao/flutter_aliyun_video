package com.sm9i.aliyun_video.aliyun.view;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.hardware.Camera;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Environment;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.util.Log;
import android.view.GestureDetector;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.SurfaceView;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.RadioGroup;
import android.widget.Toast;

import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;

import com.aliyun.common.global.AliyunTag;
import com.aliyun.common.utils.CommonUtil;
import com.aliyun.common.utils.StorageUtils;
import com.aliyun.mix.AliyunMixMediaInfoParam;
import com.aliyun.mix.AliyunMixRecorderDisplayParam;
import com.aliyun.mix.AliyunMixTrackLayoutParam;
import com.aliyun.querrorcode.AliyunErrorCode;
import com.aliyun.recorder.supply.AliyunIClipManager;
import com.aliyun.recorder.supply.RecordCallback;
import com.aliyun.svideo.sdk.external.struct.common.VideoDisplayMode;
import com.aliyun.svideo.sdk.external.struct.common.VideoQuality;
import com.aliyun.svideo.sdk.external.struct.effect.EffectBean;
import com.aliyun.svideo.sdk.external.struct.effect.EffectFilter;
import com.aliyun.svideo.sdk.external.struct.effect.EffectPaster;
import com.aliyun.svideo.sdk.external.struct.encoder.VideoCodecs;
import com.aliyun.svideo.sdk.external.struct.form.PreviewPasterForm;
import com.aliyun.svideo.sdk.external.struct.recorder.CameraParam;
import com.aliyun.svideo.sdk.external.struct.recorder.MediaInfo;
import com.aliyun.svideo.sdk.external.struct.snap.AliyunSnapVideoParam;
//import com.google.gson.Gson;
import com.google.gson.Gson;
import com.qu.preview.callback.OnFrameCallBack;
import com.qu.preview.callback.OnTextureIdCallBack;
import com.sm9i.aliyun_video.R;
import com.sm9i.aliyun_video.aliyun.activity.AlivcSvideoRecordActivity;
import com.sm9i.aliyun_video.aliyun.base.Constants;
import com.sm9i.aliyun_video.aliyun.base.widget.RecordTimelineView;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.BeautyConstants;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.BeautyDetailSettingView;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.BeautyParams;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.enums.BeautyLevel;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.enums.BeautyMode;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.listener.OnBeautyDetailClickListener;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.listener.OnBeautyFaceItemSeletedListener;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.listener.OnBeautyModeChangeListener;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.listener.OnBeautyParamsChangeListener;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.listener.OnBeautySkinItemSeletedListener;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.listener.OnViewClickListener;
import com.sm9i.aliyun_video.aliyun.bean.RememberBeautyBean;
import com.sm9i.aliyun_video.aliyun.common.utils.DensityUtils;
import com.sm9i.aliyun_video.aliyun.common.utils.ThreadUtils;
import com.sm9i.aliyun_video.aliyun.common.utils.ToastUtils;
import com.sm9i.aliyun_video.aliyun.download.zipprocessor.DownloadFileUtils;
import com.sm9i.aliyun_video.aliyun.faceunity.FaceUnityManager;
import com.sm9i.aliyun_video.aliyun.mixrecorder.AlivcIMixRecorderInterface;
import com.sm9i.aliyun_video.aliyun.music.MusicFileBean;
import com.sm9i.aliyun_video.aliyun.util.Common;
import com.sm9i.aliyun_video.aliyun.util.FixedToastUtils;
import com.sm9i.aliyun_video.aliyun.util.OrientationDetector;
import com.sm9i.aliyun_video.aliyun.util.SharedPreferenceUtils;
import com.sm9i.aliyun_video.aliyun.util.TimeFormatterUtils;
import com.sm9i.aliyun_video.aliyun.utils.PermissionUtils;
import com.sm9i.aliyun_video.aliyun.view.control.CameraType;
import com.sm9i.aliyun_video.aliyun.view.control.ControlView;
import com.sm9i.aliyun_video.aliyun.view.control.ControlViewListener;
import com.sm9i.aliyun_video.aliyun.view.control.FlashType;
import com.sm9i.aliyun_video.aliyun.view.control.RecordMode;
import com.sm9i.aliyun_video.aliyun.view.control.RecordState;
import com.sm9i.aliyun_video.aliyun.view.countdown.AlivcCountDownView;
import com.sm9i.aliyun_video.aliyun.view.dialog.BeautyEffectChooser;
import com.sm9i.aliyun_video.aliyun.view.dialog.DialogVisibleListener;
import com.sm9i.aliyun_video.aliyun.view.dialog.FilterEffectChooser;
//import com.sm9i.aliyun_video.aliyun.view.dialog.GIfEffectChooser;
import com.sm9i.aliyun_video.aliyun.view.effects.face.BeautyFaceDetailChooser;
import com.sm9i.aliyun_video.aliyun.view.effects.face.BeautyService;
import com.sm9i.aliyun_video.aliyun.view.effects.filter.EffectInfo;
import com.sm9i.aliyun_video.aliyun.view.effects.filter.interfaces.OnFilterItemClickListener;
import com.sm9i.aliyun_video.aliyun.view.effects.paster.PasterSelectListener;
import com.sm9i.aliyun_video.aliyun.view.effects.skin.BeautySkinDetailChooser;
import com.sm9i.aliyun_video.aliyun.view.focus.FocusView;
//import com.sm9i.aliyun_video.aliyun.view.music.MusicChooser;
import com.sm9i.aliyun_video.aliyun.view.music.MusicSelectListener;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.ref.WeakReference;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 新版本(> 3.6.5之后)录制模块的具体业务实现类
 */
public class AliyunSVideoRecordView extends FrameLayout
        implements DialogVisibleListener, ScaleGestureDetector.OnScaleGestureListener {
    private static final String TAG = AliyunSVideoRecordView.class.getSimpleName();
    private static final String TAG_GIF_CHOOSER = "gif";
    private static final String TAG_BEAUTY_CHOOSER = "beauty";
    private static final String TAG_MUSIC_CHOOSER = "music";
    private static final String TAG_FILTER_CHOOSER = "filter";
    private static final String TAG_BEAUTY_DETAIL_FACE_CHOOSER = "beautyFace";
    private static final String TAG_BEAUTY_DETAIL_SKIN_CHOOSER = "beautySkin";
    //最小录制时长
    private static final int MIN_RECORD_TIME = 0;
    //最大录制时长
    private static final int MAX_RECORD_TIME = Integer.MAX_VALUE;

    private static int TEST_VIDEO_WIDTH = 540;
    private static int TEST_VIDEO_HEIGHT = 960;
    /**
     * v3.7.8改动, GlsurfaceView --> SurfaceView
     * AliyunIRecorder.setDisplayView(GLSurfaceView surfaceView) =====>> AliyunIRecorder.setDisplayView(SurfaceView surfaceView)
     */
    private SurfaceView mRecorderSurfaceView;
    private SurfaceView mPlayerSurfaceView;

    private ControlView mControlView;
    private RecordTimelineView mRecordTimeView;
    private AlivcCountDownView mCountDownView;
    // private AliyunIRecorder recorder;

    private AlivcIMixRecorderInterface recorder;

    private AliyunIClipManager clipManager;
    private com.aliyun.svideo.sdk.external.struct.recorder.CameraType cameraType
            = com.aliyun.svideo.sdk.external.struct.recorder.CameraType.FRONT;
    private FragmentActivity mActivity;
    private boolean isOpenFailed = false;
    //正在准备录制视频,readyview显示期间为true，其他为false
    private boolean isLoadingReady = false;
    //录制视频是否达到最大值
    private boolean isMaxDuration = false;
    //录制时长
    private int recordTime = 0;

    //最小录制时长
    private int minRecordTime = 2000;
    //最大录制时长
    private int maxRecordTime = 15 * 1000;
    //关键帧间隔
    private int mGop = 5;
    //视频质量
    private VideoQuality mVideoQuality = VideoQuality.HD;
    //视频比例
    private int mRatioMode = AliyunSnapVideoParam.RATIO_MODE_3_4;
    //编码方式
    private VideoCodecs mVideoCodec = VideoCodecs.H264_HARDWARE;

    //视频输出参数
    private MediaInfo mOutputInfo;

    //合拍输入视频参数
    private AliyunMixMediaInfoParam mMixInputInfo;

    //用来合拍的视频路径
    private String mMixVideoPath;

//    private GIfEffectChooser gifEffectChooser;
    /**
     * 滤镜选择弹窗
     */
    private FilterEffectChooser filterEffectChooser;
    //视频分辨率
    private int mResolutionMode = AliyunSnapVideoParam.RESOLUTION_540P;

    private BeautyEffectChooser beautyEffectChooser;
    //选中的贴图效果
    private EffectPaster effectPaster;
    private OrientationDetector orientationDetector;
    private int rotation;
//    private MusicChooser musicChooseView;
    /**
     * 第三方高级美颜支持库faceUnity管理类
     */
    private FaceUnityManager faceUnityManager;
    /**
     * 相机的原始NV21数据
     */
    private byte[] frameBytes;
    private byte[] mFuImgNV21Bytes;
    /**
     * 原始数据宽
     */
    private int frameWidth;
    /**
     * 原始数据高
     */
    private int frameHeight;
    /**
     * faceUnity相关
     */
    private int mFrameId = 0;
    private BeautyParams beautyParams;
    private BeautyFaceDetailChooser beautyFaceDetailChooser;
    private BeautySkinDetailChooser beautySkinDetailChooser;
    /**
     * 美肌美颜微调dialog是否正在显示
     */
    private boolean isbeautyDetailShowing;

    /**
     * 美颜默认档位
     */
    private BeautyLevel defaultBeautyLevel = BeautyLevel.BEAUTY_LEVEL_THREE;

    /**
     * 当前美颜模式
     */
    private BeautyMode currentBeautyFaceMode = BeautyMode.Advanced;
    public static final int TYPE_FILTER = 1;
    public static final int TYPE_MUSIC = 3;
    private LinkedHashMap<Integer, Object> mConflictEffects = new LinkedHashMap<>();
    private EffectBean effectMusic;
    private AsyncTask<Void, Integer, Integer> finishRecodingTask;
    private AsyncTask<Void, Void, Void> faceTrackPathTask;

    /**
     * 记录filter选中的item索引
     */
    private int currentFilterPosition;
    /**
     * 记录美颜选中的索引, 默认为3
     */
    private int currentBeautyFacePosition = 3;

    /**
     * 记录美颜选中的索引, 默认为3
     */
    private int currentBeautyFaceNormalPosition = 3;

    /**
     * 当前美肌选择的item下标, 默认为3
     */
    private int currentBeautySkinPosition = 3;
    /**
     * 控制mv的添加, 开始录制后,不允许切换mv
     */
    private boolean isAllowChangeMv = true;
    private AsyncTask<Void, Void, Void> mFaceUnityTask;
    private List<BeautyParams> rememberParamList;
    private RememberBeautyBean rememberBeautyBean;
    private ProgressDialog progressBar;

    /**
     * 用于判断当前音乐界面是否可见, 如果可见, 从后台回到前台时, restoreConflictEffect()不恢复mv的播放, 否则会和音乐重复播放
     * <p>
     * true: 可见 false: 不可见
     */
    private boolean isMusicViewShowing;

    /**
     * faceUnity的初始化结果 true: 初始化成功 false: 初始化失败
     */
    private static boolean faceInitResult;
    /**
     * 是否处于后台
     */
    private boolean mIsBackground;
    private BeautyService beautyService;

    private boolean isHasMusic = false;
    private FocusView mFocusView;

    public boolean isHasMusic() {
        return isHasMusic;
    }

    /**
     * 音乐选择监听，通知到外部
     */
    private MusicSelectListener mOutMusicSelectListener;

    /**
     * 恢复冲突的特效，这些特效都是会彼此冲突的，比如滤镜和MV，因为MV中也有滤镜效果，所以MV和滤镜的添加顺序 会影响最终产生视频的效果，在恢复时必须严格按照用户的操作顺序来恢复，
     * 这样就需要维护一个添加过的特效类的列表，然后按照列表顺序 去恢复
     */
    private void restoreConflictEffect() {
        if (!mConflictEffects.isEmpty() && recorder != null) {
            for (Map.Entry<Integer, Object> entry : mConflictEffects.entrySet()) {
                switch (entry.getKey()) {
                    case TYPE_FILTER:
                        recorder.applyFilter((EffectFilter) entry.getValue());
                        break;
                    case TYPE_MUSIC:
                        EffectBean music = (EffectBean) entry.getValue();

                        if (music != null) {
                            recorder.setMusic(music.getPath(), music.getStartTime(), music.getDuration());
                            // 根据音乐路径判断是否添加了背景音乐,
                            // 在编辑界面, 如果录制添加了背景音乐, 则不能使用音效特效
                            isHasMusic = !TextUtils.isEmpty(music.getPath());
                        }
                        break;
                    default:
                        break;
                }
            }
        }
    }

    /**
     * 底层在onPause时会回收资源, 此处选择的滤镜的资源路径, 用于恢复状态
     */
    private String filterSourcePath;

    /**
     * 美颜美肌点击了back按钮
     */
    private boolean isbeautyDetailBack;

    /**
     * 用于防止sdk的oncomplete回调之前, 再次调用startRecord
     */
    private boolean tempIsComplete = true;

    public AliyunSVideoRecordView(Context context) {
        super(context);
        // initVideoView();
    }

    public AliyunSVideoRecordView(Context context, AttributeSet attrs) {
        super(context, attrs);
        // initVideoView();
    }

    public AliyunSVideoRecordView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        // initVideoView();
    }

    private void initVideoView() {
        //初始化surfaceView

        initControlView();
        initCountDownView();
        initBeautyParam();
        initRecordTimeView();
        initFocusView();
        initFaceUnity(getContext());
        setFaceTrackModePath();

    }

    /**
     * 焦点focus
     */
    private void initFocusView() {
        mFocusView = new FocusView(getContext());
        mFocusView.setPadding(10, 10, 10, 10);
        addSubView(mFocusView);
    }

    private void initBeautyParam() {
        beautyParamCopy();
        //进来前应该获取上一次记住的美颜模式
        currentBeautyFaceMode = SharedPreferenceUtils.getBeautyMode(getContext());

        currentBeautySkinPosition = SharedPreferenceUtils.getBeautySkinLevel(getContext());
        currentBeautyFacePosition = SharedPreferenceUtils.getBeautyFaceLevel(getContext());
        currentBeautyFaceNormalPosition = SharedPreferenceUtils.getBeautyNormalFaceLevel(getContext());
    }

    private void beautyParamCopy() {

        rememberBeautyBean = new RememberBeautyBean();

        rememberParamList = new ArrayList<>();

        int size = BeautyConstants.BEAUTY_MAP.size();
        // 需求要记录之前修改的美颜参数, 所以每次先读取json中的数据,如果json无数据, 就从常量中拿
        String jsonBeautyParam = SharedPreferenceUtils.getBeautyParams(getContext());
        if (TextUtils.isEmpty(jsonBeautyParam)) {
            for (int i = 0; i < size; i++) {
                BeautyParams beautyParams = BeautyConstants.BEAUTY_MAP.get(i);
                BeautyParams rememberParam = beautyParams.clone();
                rememberParamList.add(rememberParam);
            }
        } else {
            for (int i = 0; i < size; i++) {
                BeautyParams beautyParams = getBeautyParams(i);
                rememberParamList.add(beautyParams);
            }
        }
        rememberBeautyBean.setBeautyList(rememberParamList);
    }

    public void onPause() {
        mIsBackground = true;
    }

    public void onResume() {
        mIsBackground = false;
    }

    public void onStop() {
        if (mFocusView != null) {
            mFocusView.activityStop();
        }
    }

    private void initFaceUnity(Context context) {
        if (!faceInitResult) {
            mFaceUnityTask = new FaceUnityTask(this).executeOnExecutor(
                    AsyncTask.THREAD_POOL_EXECUTOR);
        }
    }

    private static class FaceUnityTask extends AsyncTask<Void, Void, Void> {

        private WeakReference<AliyunSVideoRecordView> weakReference;
        private Context mContext;

        FaceUnityTask(AliyunSVideoRecordView recordView) {
            weakReference = new WeakReference<>(recordView);
        }

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            AliyunSVideoRecordView recordView = weakReference.get();
            if (recordView != null) {
                mContext = recordView.getContext();
            }
        }

        @Override
        protected Void doInBackground(Void... voids) {
            AliyunSVideoRecordView recordView = weakReference.get();
            if (recordView != null && mContext != null) {
                recordView.faceUnityManager = FaceUnityManager.getInstance();
                faceInitResult = recordView.faceUnityManager.createBeautyItem(mContext);
            }
            return null;
        }

        @Override
        protected void onPostExecute(Void aVoid) {
            super.onPostExecute(aVoid);
            AliyunSVideoRecordView recordView = weakReference.get();
            if (recordView != null) {
                recordView.faceunityDefaultParam();
            }
        }
    }

    /**
     * 初始化倒计时view
     */
    private void initCountDownView() {
        if (mCountDownView == null) {
            mCountDownView = new AlivcCountDownView(getContext());
            FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT,
                    FrameLayout.LayoutParams.MATCH_PARENT);
            params.gravity = Gravity.CENTER;
            addView(mCountDownView, params);
        }
    }

    private void initRecordTimeView() {
        mRecordTimeView = new RecordTimelineView(getContext());
        LayoutParams params = new LayoutParams(LayoutParams.MATCH_PARENT, DensityUtils.dip2px(getContext(), 6));

        params.setMargins(DensityUtils.dip2px(getContext(), 12),
                DensityUtils.dip2px(getContext(), 6),
                DensityUtils.dip2px(getContext(), 12),
                0);
        mRecordTimeView.setColor(R.color.alivc_record_bg_timeview_duraton, R.color.alivc_record_bg_timeview_selected, R.color.alivc_common_white,
                R.color.alivc_record_bg_timeview);
        mRecordTimeView.setMaxDuration(clipManager.getMaxDuration());
        mRecordTimeView.setMinDuration(clipManager.getMinDuration());
        addView(mRecordTimeView, params);

        mRecordTimeView.setMaxDuration(getMaxRecordTime());
        mRecordTimeView.setMinDuration(minRecordTime);
        //设置可见性
        mRecordTimeView.setVisibility(ControlView.recordMode == RecordMode.VIDEO ? VISIBLE : GONE);
    }

    /**
     * 初始化RecordersurfaceView
     */
    @SuppressLint("ClickableViewAccessibility")
    private void initRecorderSurfaceView() {
        mRecorderSurfaceView = new SurfaceView(getContext());
        final ScaleGestureDetector scaleGestureDetector = new ScaleGestureDetector(getContext(), this);
        final GestureDetector gestureDetector = new GestureDetector(getContext(),
                new GestureDetector.SimpleOnGestureListener() {
                    @Override
                    public boolean onSingleTapUp(MotionEvent e) {
                        if (recorder == null) {
                            return true;
                        }
                        float x = e.getX() / mRecorderSurfaceView.getWidth();
                        float y = e.getY() / mRecorderSurfaceView.getHeight();
                        recorder.setFocus(x, y);

                        mFocusView.showView();
                        mFocusView.setLocation(e.getRawX(), e.getRawY());
                        return true;
                    }
                });
        mRecorderSurfaceView.setOnTouchListener(new OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if (event.getPointerCount() >= 2) {
                    scaleGestureDetector.onTouchEvent(event);
                } else if (event.getPointerCount() == 1) {
                    gestureDetector.onTouchEvent(event);
                }
                return true;
            }
        });
        //添加录制surFaceView
        recorder.setDisplayView(mRecorderSurfaceView, mPlayerSurfaceView);

        addSubView(mRecorderSurfaceView);
        mRecorderSurfaceView.setLayoutParams(recorder.getLayoutParams());

    }

    /**
     * 初始化PlayerSurfaceView
     */
    @SuppressLint("ClickableViewAccessibility")
    private void initPlayerSurfaceView() {
        mPlayerSurfaceView = new SurfaceView(getContext());
        addSubView(mPlayerSurfaceView);
    }


    /**
     * 初始化控制栏view
     */
    private void initControlView() {
        mControlView = new ControlView(getContext());
        //设置进度条的可见

        mControlView.setControlViewListener(new ControlViewListener() {
            @Override
            public void onBackClick() {
                if (mBackClickListener != null) {
                    mBackClickListener.onClick();
                }
            }

            @Override
            public void takePhoto(boolean needBitmap) {
                if (mBackClickListener != null) {
                    recorder.takePicture(needBitmap);
                }
            }

            @Override
            public void changeType(boolean isVideo) {
                mRecordTimeView.setVisibility(isVideo ? VISIBLE : GONE);
            }

            @Override
            public void onNextClick() {
                // 完成录制
                if (!isStopToCompleteDuration) {
                    finishRecording();
                }
            }

            @Override
            public void onBeautyFaceClick() {
                showBeautyFaceView();
            }

            @Override
            public void onMusicClick() {
                //   showMusicSelView();
            }

            @Override
            public void onCameraSwitch() {
                if (recorder != null) {
                    int cameraId = recorder.switchCamera();
                    for (com.aliyun.svideo.sdk.external.struct.recorder.CameraType type : com.aliyun.svideo.sdk
                            .external.struct.recorder.CameraType
                            .values()) {
                        if (type.getType() == cameraId) {
                            cameraType = type;
                        }
                    }
                    if (mControlView != null) {
                        for (CameraType type : CameraType.values()) {
                            if (type.getType() == cameraId) {
                                mControlView.setCameraType(type);
                            }
                        }

                        if (mControlView.getFlashType() == FlashType.ON
                                && mControlView.getCameraType() == CameraType.BACK) {
                            recorder.setLight(com.aliyun.svideo.sdk.external.struct.recorder.FlashType.TORCH);
                        }
                    }
                }
            }


            @Override
            public void onLightSwitch(FlashType flashType) {
                if (recorder != null) {
                    for (com.aliyun.svideo.sdk.external.struct.recorder.FlashType type : com.aliyun.svideo.sdk
                            .external.struct.recorder.FlashType
                            .values()) {
                        if (flashType.toString().equals(type.toString())) {
                            recorder.setLight(type);
                        }
                    }

                }
                if (mControlView.getFlashType() == FlashType.ON
                        && mControlView.getCameraType() == CameraType.BACK) {
                    recorder.setLight(com.aliyun.svideo.sdk.external.struct.recorder.FlashType.TORCH);
                }
            }

            @Override
            public void onRateSelect(float rate) {
                if (recorder != null) {
                    recorder.setRate(rate);
                }
            }

            @Override
            public void onGifEffectClick() {
                showGifEffectView();
            }

            @Override
            public void onReadyRecordClick(boolean isCancel) {
                if (isStopToCompleteDuration) {
                    /*TODO  这里是因为如果 SDK 还没有回调onComplete,倒计时录制，会crash */
                    return;
                }
                if (isCancel) {
                    cancelReadyRecord();
                } else {
                    showReadyRecordView();
                }

            }

            @Override
            public void onStartRecordClick() {
                if (!tempIsComplete) {
                    // 连续点击开始录制，停止录制，要保证在onComplete回调回来再允许点击开始录制,
                    // 否则SDK会出现ANR问题, v3.7.8修复会影响较大, 工具包暂时处理
                    return;
                }
                startRecord();
            }

            @Override
            public void onStopRecordClick() {
                if (!tempIsComplete) {
                    // 连续点击开始录制，停止录制，要保证在onComplete回调回来再允许点击开始录制,
                    // 否则SDK会出现ANR问题, v3.7.8修复会影响较大, 工具包暂时处理
                    return;
                }
                stopRecord();
            }

            @Override
            public void onDeleteClick() {
                if (isStopToCompleteDuration) {
                    // 这里是因为如果 SDK 还没有回调onComplete,点击回删会出现删除的不是最后一段的问题
                    return;
                }
                mRecordTimeView.deleteLast();
                // clipManager.deletePart();
                recorder.deleteLastPart();
                isMaxDuration = false;
                if (mControlView != null) {
                    if (clipManager.getDuration() < clipManager.getMinDuration()) {
                        mControlView.setCompleteEnable(false);
                    }

                    mControlView.updataCutDownView(true);
                }

                if (clipManager.getDuration() == 0) {
                    //音乐可以选择
                    recorder.restartMv();
                    mControlView.setHasRecordPiece(false);
                    isAllowChangeMv = true;
                }
                mControlView.setRecordTime(TimeFormatterUtils.formatTime(clipManager.getDuration()));
            }

            @Override
            public void onFilterEffectClick() {
                // 滤镜选择弹窗弹出
                showFilterEffectView();
            }

            @Override
            public void onChangeAspectRatioClick(int ratio) {
                //重新绘制界面
                setReSizeRatioMode(ratio);
            }

        });
        mControlView.setRecordType(recorder.isMixRecorder());
        addSubView(mControlView);
        mControlView.setAspectRatio(mRatioMode);
    }

    /**
     * 权限申请
     */
    String[] permission = {
            Manifest.permission.CAMERA,
            Manifest.permission.RECORD_AUDIO,
            Manifest.permission.READ_EXTERNAL_STORAGE,
            Manifest.permission.WRITE_EXTERNAL_STORAGE
    };

    /**
     * 开始录制
     */
    private void startRecord() {
        boolean checkResult = PermissionUtils.checkPermissionsGroup(getContext(), permission);
        if (!checkResult && mActivity != null) {
            PermissionUtils.requestPermissions(mActivity, permission,
                    AlivcSvideoRecordActivity.PERMISSION_REQUEST_CODE);
            return;
        }

        if (CommonUtil.SDFreeSize() < 50 * 1000 * 1000) {
            FixedToastUtils.show(getContext(), getResources().getString(R.string.alivc_music_no_free_memory));
            return;
        }
        if (isMaxDuration) {
            mControlView.setRecordState(RecordState.STOP);
            return;
        }

        if (recorder != null && !mIsBackground) {
            // 快速显示回删字样, 将音乐按钮置灰,假设此时已经有片段, 在录制失败时, 需要改回false
            mControlView.setHasRecordPiece(true);
            mControlView.setRecordState(RecordState.RECORDING);
            mControlView.setRecording(true);
            String videoPath = Constants.SDCardConstants.OUTPUT_PATH_DIR + File.separator + System.currentTimeMillis() + "-record.mp4";
            recorder.setOutputPath(videoPath);
            recorder.startRecording();

            Log.d(TAG, "startRecording    isStopToCompleteDuration:" + isStopToCompleteDuration);
        }

    }

    /**
     * 视频是是否正正在已经调用stopRecord到onComplete回调过程中这段时间，这段时间不可再次调用stopRecord
     * true: 正在调用stop~onComplete, false反之
     */
    private boolean isStopToCompleteDuration;

    /**
     * 停止录制
     */
    private void stopRecord() {
        Log.d(TAG, "stopRecord    isStopToCompleteDuration:" + isStopToCompleteDuration);
        if (recorder != null && !isStopToCompleteDuration && mControlView.isRecording()) {//
            isStopToCompleteDuration = true;

            //此处添加判断，progressBar弹出，也即当视频片段合成的时候，不调用stopRecording,
            //否则在finishRecording的时候调用stopRecording，会导致finishRecording阻塞
            //暂时规避，等待sdk解决该问题，取消该判断
            if ((progressBar == null || !progressBar.isShowing())) {
                recorder.stopRecording();

            }

        }

    }

    /**
     * 取消拍摄倒计时
     */
    private void cancelReadyRecord() {
        if (mCountDownView != null) {
            mCountDownView.cancle();
        }
    }

    /**
     * 显示准备拍摄倒计时view
     */
    private void showReadyRecordView() {
        if (mCountDownView != null) {
            mCountDownView.start();
        }
    }

//    /**
//     * 显示音乐选择的控件
//     */
//    private void showMusicSelView() {
//        if (musicChooseView == null) {
//            musicChooseView = new MusicChooser();
//
//            musicChooseView.setRecordTime(getMaxRecordTime());
//
//            musicChooseView.setMusicSelectListener(new MusicSelectListener() {
//
//                @Override
//                public void onMusicSelect(MusicFileBean musicFileBean, long startTime) {
//                    if (musicFileBean != null) {
//                        if (effectMusic != null) {
//                            mConflictEffects.remove(TYPE_MUSIC);
//                        }
//                        effectMusic = new EffectBean();
//                        effectMusic.setPath(musicFileBean.getPath());
//                        effectMusic.setStartTime(startTime);
//                        effectMusic.setDuration(getMaxRecordTime());
//
//                        mConflictEffects.put(TYPE_MUSIC, effectMusic);
//                        if (mOutMusicSelectListener != null) {
//                            mOutMusicSelectListener.onMusicSelect(musicFileBean, startTime);
//                        }
//                        //如果音乐地址或者图片地址为空则使用默认图标
//                        if (TextUtils.isEmpty(musicFileBean.getImage()) || TextUtils.isEmpty(musicFileBean.getPath())) {
//                            mControlView.setMusicIconId(R.mipmap.aliyun_svideo_music);
//                        } else {
//                            mControlView.setMusicIcon(musicFileBean.getImage());
//                        }
//                    } else {
//                        mControlView.setMusicIconId(R.mipmap.aliyun_svideo_music);
//                    }
//                }
//            });
//
//            musicChooseView.setDismissListener(new DialogVisibleListener() {
//                @Override
//                public void onDialogDismiss() {
//                    mControlView.setMusicSelViewShow(false);
//                    isMusicViewShowing = false;
//                    restoreConflictEffect();
//                }
//
//                @Override
//                public void onDialogShow() {
//                    mControlView.setMusicSelViewShow(true);
//                    recorder.applyMv(new EffectBean());
//                    isMusicViewShowing = true;
//                }
//            });
//        }
//        musicChooseView.show(getFragmentManager(), TAG_MUSIC_CHOOSER);
//    }

    /**
     * 当前所选中的动图路径
     */
    private String currPasterPath;

    /**
     * 显示动图效果调节控件
     */
    private void showGifEffectView() {
//        if (gifEffectChooser == null) {
//            gifEffectChooser = new GIfEffectChooser();
//            gifEffectChooser.setDismissListener(this);
//            gifEffectChooser.setPasterSelectListener(new PasterSelectListener() {
//                @Override
//                public void onPasterSelected(PreviewPasterForm imvForm) {
//                    String path;
//                    if (imvForm.getId() == 150) {
//                        //id=150的动图为自带动图
//                        path = imvForm.getPath();
//                    } else {
//                        path = DownloadFileUtils.getAssetPackageDir(getContext(),
//                                imvForm.getName(), imvForm.getId()).getAbsolutePath();
//                    }
//                    currPasterPath = path;
//                    addEffectToRecord(path);
//
//                }
//
//                @Override
//                public void onSelectPasterDownloadFinish(String path) {
//                    // 所选的paster下载完成后, 记录该paster 的path
//                    currPasterPath = path;
//                }
//            });
//
//            gifEffectChooser.setDismissListener(new DialogVisibleListener() {
//                @Override
//                public void onDialogDismiss() {
//                    mControlView.setEffectSelViewShow(false);
//                }
//
//                @Override
//                public void onDialogShow() {
//                    mControlView.setEffectSelViewShow(true);
//                    if (!TextUtils.isEmpty(currPasterPath)) {
//                        // dialog显示后,如果记录的paster不为空, 使用该paster
//                        addEffectToRecord(currPasterPath);
//                    }
//                }
//            });
//        }
//        gifEffectChooser.show(getFragmentManager(), TAG_GIF_CHOOSER);
    }

    private void addEffectToRecord(String path) {

        if (effectPaster != null) {
            recorder.removePaster(effectPaster);
        }

        effectPaster = new EffectPaster(path);
        recorder.addPaster(effectPaster);

    }

    private FragmentManager getFragmentManager() {
        FragmentManager fm = null;
        if (mActivity != null) {
            fm = mActivity.getSupportFragmentManager();
        } else {
            Context mContext = getContext();
            if (mContext instanceof FragmentActivity) {
                fm = ((FragmentActivity) mContext).getSupportFragmentManager();
            }
        }
        return fm;
    }

    /**
     * 显示滤镜选择的控件
     */
    private void showFilterEffectView() {
        if (filterEffectChooser == null) {
            filterEffectChooser = new FilterEffectChooser();
        }
        if (filterEffectChooser.isAdded()) {
            return;
        }
        // 滤镜改变listener
        filterEffectChooser.setOnFilterItemClickListener(new OnFilterItemClickListener() {
            @Override
            public void onItemClick(EffectInfo effectInfo, int index) {
                if (effectInfo != null) {
                    filterSourcePath = effectInfo.getPath();
                    if (index == 0) {
                        filterSourcePath = null;
                    }
                    EffectFilter filterEffect = new EffectFilter(filterSourcePath);
                    recorder.applyFilter(filterEffect);
                    mConflictEffects.put(TYPE_FILTER, filterEffect);
                }
                currentFilterPosition = index;
            }
        });
        filterEffectChooser.setFilterPosition(currentFilterPosition);
        filterEffectChooser.setDismissListener(new DialogVisibleListener() {
            @Override
            public void onDialogDismiss() {
                mControlView.setEffectSelViewShow(false);
            }

            @Override
            public void onDialogShow() {
                mControlView.setEffectSelViewShow(true);
            }
        });
        filterEffectChooser.show(getFragmentManager(), TAG_FILTER_CHOOSER);
    }

    /**
     * 显示美颜调节的控件
     */
    private void showBeautyFaceView() {
        if (beautyEffectChooser == null) {
            beautyEffectChooser = new BeautyEffectChooser();
        }
        currentBeautySkinPosition = SharedPreferenceUtils.getBeautySkinLevel(getContext());


        // 美颜item选中listener
        beautyEffectChooser.setOnBeautyFaceItemSeletedListener(new OnBeautyFaceItemSeletedListener() {
            @Override
            public void onNormalSelected(int postion, BeautyLevel beautyLevel) {
                defaultBeautyLevel = beautyLevel;
                currentBeautyFaceNormalPosition = postion;
                // 普通美颜
                recorder.setBeautyLevel(beautyLevel.getValue());

                if (beautyService != null) {
                    beautyService.saveSelectParam(getContext(), currentBeautyFaceNormalPosition, currentBeautyFacePosition, currentBeautySkinPosition);
                }
            }

            @Override
            public void onAdvancedSelected(int position, BeautyLevel beautyLevel) {
                currentBeautyFacePosition = position;
                // 高级美颜
                BeautyParams beautyParams = rememberParamList.get(position);
                //// 美白和红润faceUnity的值范围 0~1.0f
                if (beautyService != null) {
                    beautyService.setBeautyParam(beautyParams, BeautyService.BEAUTY_FACE);
                    beautyService.saveSelectParam(getContext(), currentBeautyFaceNormalPosition, currentBeautyFacePosition, currentBeautySkinPosition);
                }
            }
        });

        // 美肌item选中
        beautyEffectChooser.setOnBeautySkinSelectedListener(new OnBeautySkinItemSeletedListener() {
            @Override
            public void onItemSelected(int postion) {
                currentBeautySkinPosition = postion;
                BeautyParams beautyParams = rememberParamList.get(postion);
                if (beautyService != null) {
                    beautyService.setBeautyParam(beautyParams, BeautyService.BEAUTY_SKIN);
                    beautyService.saveSelectParam(getContext(), currentBeautyFaceNormalPosition, currentBeautyFacePosition, currentBeautySkinPosition);
                }
            }
        });

        //  设置 美颜微调dialog
        beautyEffectChooser.setOnBeautyFaceDetailClickListener(new OnBeautyDetailClickListener() {
            @Override
            public void onDetailClick() {
                //英藏
                beautyEffectChooser.dismiss();
                mControlView.setEffectSelViewShow(true);
                showBeautyFaceDetailDialog();

            }
        });

        // 美肌微调dialog
        beautyEffectChooser.setOnBeautySkinDetailClickListener(new OnBeautyDetailClickListener() {
            @Override
            public void onDetailClick() {
                beautyEffectChooser.dismiss();
                mControlView.setEffectSelViewShow(true);
                showBeautySkinDetailDialog();
            }
        });

        // 美颜普通和高级模式切换
        beautyEffectChooser.setOnBeautyModeChangeListener(new OnBeautyModeChangeListener() {
            @Override
            public void onModeChange(RadioGroup group, int checkedId) {

                BeautyParams beautyParams = null;
                if (checkedId == R.id.rb_level_advanced) {
                    currentBeautyFaceMode = BeautyMode.Advanced;
                    recorder.setBeautyStatus(false);
                    beautyParams = rememberParamList.get(currentBeautyFacePosition);
                    if (beautyService != null) {
                        beautyService.setBeautyParam(beautyParams, BeautyService.BEAUTY_FACE);
                    }
                } else if (checkedId == R.id.rb_level_normal) {
                    currentBeautyFaceMode = BeautyMode.Normal;
                    recorder.setBeautyStatus(true);
                    recorder.setBeautyLevel(defaultBeautyLevel.getValue());
                }

                if (beautyService != null) {
                    beautyService.saveBeautyMode(getContext(), currentBeautyFaceMode);
                }
            }
        });

        beautyEffectChooser.setDismissListener(new DialogVisibleListener() {
            @Override
            public void onDialogDismiss() {
                // 如果微调的页面不在显示状态,
                if (!isbeautyDetailShowing) {
                    mControlView.setEffectSelViewShow(false);
                } else {
                    mControlView.setEffectSelViewShow(true);
                }
                isbeautyDetailBack = false;

                if (beautyService != null) {
                    beautyService.saveBeautyMode(getContext(), currentBeautyFaceMode);
                    beautyService.saveSelectParam(getContext(), currentBeautyFaceNormalPosition, currentBeautyFacePosition, currentBeautySkinPosition);
                }
            }

            @Override
            public void onDialogShow() {
                mControlView.setEffectSelViewShow(true);
                beautyEffectChooser.setBeautyParams(AliyunSVideoRecordView.this.beautyParams);

            }
        });

        ///美颜show
        beautyEffectChooser.show(getFragmentManager(), TAG_BEAUTY_CHOOSER);
    }

    /**
     * 显示美颜微调dialog
     */
    private void showBeautyFaceDetailDialog() {
        beautyParams = getBeautyParams(currentBeautyFacePosition);
        if (beautyParams == null) {
            beautyParams = rememberParamList.get(currentBeautyFacePosition);
        }
        beautyFaceDetailChooser = new BeautyFaceDetailChooser();
        beautyFaceDetailChooser.setBeautyLevel(currentBeautyFacePosition);
        beautyFaceDetailChooser.setOnBeautyParamsChangeListener(
                new OnBeautyParamsChangeListener() {
                    @Override
                    public void onBeautyChange(BeautyParams param) {
                        if (beautyParams != null && param != null) {
                            beautyParams.beautyWhite = param.beautyWhite;
                            beautyParams.beautyBuffing = param.beautyBuffing;
                            beautyParams.beautyRuddy = param.beautyRuddy;
                            if (faceUnityManager != null) {
                                // 美白
                                faceUnityManager.setFaceBeautyWhite(param.beautyWhite / 100);
                                // 红润
                                faceUnityManager.setFaceBeautyRuddy(param.beautyRuddy / 100);
                                // 磨皮
                                //将【0-100】转化【0-6】，比率为0。06,
                                faceUnityManager.setFaceBeautyBuffing((float) (param.beautyBuffing * 0.06));
                            }
                        }
                    }
                });
        // 点击back按钮
        beautyFaceDetailChooser.setOnBackClickListener(new OnViewClickListener() {
            @Override
            public void onClick() {
                isbeautyDetailShowing = false;
                isbeautyDetailBack = true;
                beautyFaceDetailChooser.dismiss();
                beautyEffectChooser.show(getFragmentManager(), TAG_BEAUTY_CHOOSER);
            }
        });
        // 空白区域点击
        beautyFaceDetailChooser.setOnBlankClickListener(new BeautyDetailSettingView.OnBlanckViewClickListener() {
            @Override
            public void onBlankClick() {
                isbeautyDetailShowing = false;
            }
        });
        beautyFaceDetailChooser.setDismissListener(new DialogVisibleListener() {
            @Override
            public void onDialogDismiss() {
                // 如果是点击微调界面中的back按钮, controlview的底部view仍要保持隐藏状态
                if (isbeautyDetailBack) {
                    mControlView.setEffectSelViewShow(true);
                } else {
                    mControlView.setEffectSelViewShow(false);
                }
                saveBeautyParams(currentBeautyFacePosition, beautyParams);
                isbeautyDetailBack = false;
            }

            @Override
            public void onDialogShow() {
            }
        });
        beautyFaceDetailChooser.setBeautyParams(beautyParams);
        beautyEffectChooser.dismiss();
        isbeautyDetailShowing = true;
        beautyFaceDetailChooser.show(getFragmentManager(), TAG_BEAUTY_DETAIL_FACE_CHOOSER);
    }


    /**
     * 显示美肌微调dialog
     */
    private void showBeautySkinDetailDialog() {
        beautyParams = getBeautyParams(currentBeautySkinPosition);
        if (beautyParams == null) {
            beautyParams = rememberParamList.get(currentBeautySkinPosition);
        }

        beautySkinDetailChooser = new BeautySkinDetailChooser();
        beautySkinDetailChooser.setBeautyLevel(currentBeautySkinPosition);
        beautySkinDetailChooser.setOnBeautyParamsChangeListener(
                new OnBeautyParamsChangeListener() {
                    @Override
                    public void onBeautyChange(BeautyParams param) {
                        if (beautyParams != null && param != null) {

                            beautyParams.beautyBigEye = param.beautyBigEye;
                            beautyParams.beautySlimFace = param.beautySlimFace;
                            if (faceUnityManager != null) {
                                //大眼
                                faceUnityManager.setFaceBeautyBigEye(param.beautyBigEye / 100);
                                //瘦脸
                                faceUnityManager.setFaceBeautySlimFace(param.beautySlimFace / 100 * 1.5f);
                            }
                            saveBeautyParams(currentBeautySkinPosition, beautyParams);

                        }
                    }
                });

        // 点击back按钮
        beautySkinDetailChooser.setOnBackClickListener(new OnViewClickListener() {
            @Override
            public void onClick() {
                isbeautyDetailShowing = false;
                beautySkinDetailChooser.dismiss();
                isbeautyDetailBack = true;
                beautyEffectChooser.show(getFragmentManager(), TAG_BEAUTY_CHOOSER);
            }
        });

        // 空白区域点击
        beautySkinDetailChooser.setOnBlankClickListener(new BeautyDetailSettingView.OnBlanckViewClickListener() {
            @Override
            public void onBlankClick() {
                isbeautyDetailShowing = false;
            }
        });

        beautySkinDetailChooser.setDismissListener(new DialogVisibleListener() {
            @Override
            public void onDialogDismiss() {
                // 如果是点击微调界面中的back按钮, controlview的底部view仍要保持隐藏状态
                if (isbeautyDetailBack) {
                    mControlView.setEffectSelViewShow(true);
                } else {
                    mControlView.setEffectSelViewShow(false);
                }
                saveBeautyParams(currentBeautySkinPosition, AliyunSVideoRecordView.this.beautyParams);
                isbeautyDetailBack = false;
            }

            @Override
            public void onDialogShow() {

            }
        });
        beautySkinDetailChooser.setBeautyParams(beautyParams);
        beautyEffectChooser.dismiss();
        isbeautyDetailShowing = true;
        beautySkinDetailChooser.show(getFragmentManager(), TAG_BEAUTY_DETAIL_SKIN_CHOOSER);
    }

    /**
     * 设置录制类型
     */
    public void setRecorder(AlivcIMixRecorderInterface recorder) {
        this.recorder = recorder;
        initRecorder();
        initVideoView();

    }

    private void initRecorder() {
        recorder.setGop(mGop);
        recorder.setVideoQuality(mVideoQuality);
        recorder.setRatioMode(mRatioMode);
        recorder.setResolutionMode(mResolutionMode);
        clipManager = recorder.getClipManager();
        clipManager.setMaxDuration(getMaxRecordTime());
        clipManager.setMinDuration(minRecordTime);
        recorder.setFocusMode(CameraParam.FOCUS_MODE_CONTINUE);
        //mediaInfo.setHWAutoSize(true);//硬编时自适应宽高为16的倍数
        cameraType = recorder.getCameraCount() == 1 ? com.aliyun.svideo.sdk.external.struct.recorder.CameraType.BACK : cameraType;
        recorder.setCamera(cameraType);
        recorder.setBeautyStatus(false);

        initOrientationDetector();


        //获取需要的surFaceView数量
        if (recorder.isMixRecorder()) {
            initPlayerSurfaceView();
            initRecorderSurfaceView();
            //设置录制界面位置
            recorder.setMixRecorderRatio(mRecorderSurfaceView);
            //设置播放界面的位置
            recorder.setMixPlayerRatio(mPlayerSurfaceView);
        } else {
            initRecorderSurfaceView();
        }

        //设置视频输入输出参数
        setMediaInfo();

        recorder.setOnFrameCallback(new OnFrameCallBack() {
            @Override
            public void onFrameBack(byte[] bytes, int width, int height, Camera.CameraInfo info) {
                //原始数据回调 NV21,这里获取原始数据主要是为了faceUnity高级美颜使用
                frameBytes = bytes;
                frameWidth = width;
                frameHeight = height;
            }

            @Override
            public Camera.Size onChoosePreviewSize(List<Camera.Size> supportedPreviewSizes,
                                                   Camera.Size preferredPreviewSizeForVideo) {
                return null;
            }

            @Override
            public void openFailed() {
                Log.e(AliyunTag.TAG, "openFailed----------");
                isOpenFailed = true;
            }
        });

        //设置回调
        recorder.setRecordCallback(new RecordCallback() {
            @Override
            public void onComplete(final boolean validClip, final long clipDuration) {
                Log.i(TAG, "onComplete   duration : " + clipDuration +
                        ", clipManager.getDuration() = " + clipManager.getDuration());
                tempIsComplete = true;
                ThreadUtils.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        Log.d(TAG, "onComplete    isStopToCompleteDuration:" + isStopToCompleteDuration);

                        if (recorder.isMixRecorder() && !isMaxDuration) {
                            ToastUtils.show(mActivity, getResources().getString(R.string.alivc_mix_record_continue), Gravity.CENTER, Toast.LENGTH_SHORT);
                        }

                        isStopToCompleteDuration = false;
                        handleStopCallback(validClip, clipDuration);
                        if (isMaxDuration && validClip) {
                            finishRecording();
                        }

                    }
                });

            }

            /**
             * 合成完毕的回调
             * @param outputPath
             */
            @Override
            public void onFinish(final String outputPath) {
                Log.i(TAG, "onFinish:" + outputPath);

                if (progressBar != null && progressBar.isShowing()) {
                    progressBar.dismiss();
                }

                ThreadUtils.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (mCompleteListener != null) {
                            final int duration = clipManager.getDuration();
                            //deleteAllPart();
                            // 选择音乐后, 在录制完合成过程中退后台
                            // 保持在后台情况下, sdk合成完毕后, 会仍然执行跳转代码, 此时会弹起跳转后的页面
                            if (activityStoped) {
                                pendingCompseFinishRunnable = new Runnable() {
                                    @Override
                                    public void run() {
                                        if (!isStopToCompleteDuration) {
                                            mCompleteListener.onComplete(outputPath, duration, mRatioMode);
                                        }
                                    }
                                };
                            } else {
                                if (!isStopToCompleteDuration) {
                                    mCompleteListener.onComplete(outputPath, duration, mRatioMode);
                                }
                            }
                        }
                    }
                });

            }


            @Override
            public void onProgress(final long duration) {
                final int currentDuration = clipManager.getDuration();
                ThreadUtils.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        isAllowChangeMv = false;
                        recordTime = 0;
                        //设置录制进度
                        if (mRecordTimeView != null) {
                            mRecordTimeView.setDuration((int) duration);
                        }

                        recordTime = (int) (currentDuration + duration);

                        Log.d(TAG, "onProgress: " + recordTime + "——————" + currentDuration + "————" + duration);

                        if (recordTime <= clipManager.getMaxDuration() && recordTime >= clipManager.getMinDuration()) {
                            // 2018/7/11 让下一步按钮可点击
                            mControlView.setCompleteEnable(true);
                        } else {
                            mControlView.setCompleteEnable(false);
                        }
                        if (mControlView != null && mControlView.getRecordState().equals(RecordState.STOP)) {
                            return;
                        }
                        if (mControlView != null) {
                            mControlView.setRecordTime(TimeFormatterUtils.formatTime(recordTime));
                        }

                    }
                });

            }

            @Override
            public void onMaxDuration() {
                Log.i(TAG, "onMaxDuration:");
                isMaxDuration = true;
                ThreadUtils.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (mControlView != null) {
                            mControlView.setCompleteEnable(false);
                            mControlView.setRecordState(RecordState.STOP);
                            mControlView.updataCutDownView(false);
                        }
                    }
                });

            }

            @Override
            public void onError(int errorCode) {
                Log.e(TAG, "onError:" + errorCode);
                ThreadUtils.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        tempIsComplete = true;
                        if (progressBar != null && progressBar.isShowing()) {
                            progressBar.dismiss();
                            mControlView.setCompleteEnable(true);
                        } else {
                            handleStopCallback(false, 0);
                        }
                    }
                });
            }

            @Override
            public void onInitReady() {
                Log.i(TAG, "onInitReady");
                ThreadUtils.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        restoreConflictEffect();
                        if (effectPaster != null) {
                            addEffectToRecord(effectPaster.getPath());
                        }

                    }
                });
            }

            @Override
            public void onDrawReady() {

            }

            @Override
            public void onPictureBack(final Bitmap bitmap) {

                mCompleteListener.onTakeComplete(saveImageToGallery(bitmap));
            }

            @Override
            public void onPictureDataBack(final byte[] data) {

            }

        });
        recorder.setOnTextureIdCallback(new OnTextureIdCallBack() {
            @Override
            public int onTextureIdBack(int textureId, int textureWidth, int textureHeight, float[] matrix) {

                //******************************** start ******************************************
                //这块代码会影响到标准版的faceUnity功能 改动的时候要关联app gradle 一起改动
                if (faceInitResult && currentBeautyFaceMode == BeautyMode.Advanced && faceUnityManager != null) {
                    /**
                     * faceInitResult fix bug:反复退出进入会出现黑屏情况,原因是因为release之后还在调用渲染的接口,必须要保证release了之后不能再调用渲染接口
                     */
                    return faceUnityManager.draw(frameBytes, mFuImgNV21Bytes, textureId, frameWidth, frameHeight, mFrameId++, mControlView.getCameraType().getType());
                }
                //******************************** end ********************************************
                return textureId;
            }


            @Override
            public int onScaledIdBack(int scaledId, int textureWidth, int textureHeight, float[] matrix) {
                //if (test == null) {
                //    test = new OpenGLTest();
                //}

                return scaledId;
            }

            @Override
            public void onTextureDestroyed() {
                // sdk3.7.8改动, 自定义渲染（第三方渲染）销毁gl资源，以前GLSurfaceView时可以通过GLSurfaceView.queueEvent来做，
                // 现在增加了一个gl资源销毁的回调，需要统一在这里面做。
                if (faceUnityManager != null && faceInitResult) {
                    faceUnityManager.release();
                    faceInitResult = false;
                }
            }
        });

        recorder.setFaceTrackInternalMaxFaceCount(2);
    }

    /**
     * 美颜默认选中高级, 3档 美白: 0.6 红润: 0.6 磨皮: 6 大眼: 0.6 瘦脸: 0.6 * 1.5 (总范围0~1.5)
     * 使用默认参数前判断是那种美颜
     */
    private void faceunityDefaultParam() {
        beautyService = new BeautyService();
        if (BeautyMode.Advanced == currentBeautyFaceMode) {
            recorder.setBeautyStatus(false);
            beautyService.bindFaceUnity(getContext(), faceUnityManager);

        } else if (BeautyMode.Normal == currentBeautyFaceMode) {
            //普通美颜等级
            int beautyNormalFaceLevel = SharedPreferenceUtils.getBeautyNormalFaceLevel(getContext());
            recorder.setBeautyStatus(true);
            beautyService.bindNormalFaceUnity(faceUnityManager);
            recorder.setBeautyLevel(getNormalBeautyLevel(beautyNormalFaceLevel));
        } else {
            beautyService.bindFaceUnity(getContext(), faceUnityManager);

        }

    }

    /**
     * 获取当前普通美颜的级别对应的数值【0-5】-【0-100】
     */
    private int getNormalBeautyLevel(int beautyNormalFaceLevel) {

        switch (beautyNormalFaceLevel) {
            case 0:
                return BeautyLevel.BEAUTY_LEVEL_ZERO.getValue();
            case 1:
                return BeautyLevel.BEAUTY_LEVEL_ONE.getValue();
            case 2:
                return BeautyLevel.BEAUTY_LEVEL_TWO.getValue();
            case 3:
                return BeautyLevel.BEAUTY_LEVEL_THREE.getValue();
            case 4:
                return BeautyLevel.BEAUTY_LEVEL_FOUR.getValue();
            case 5:
                return BeautyLevel.BEAUTY_LEVEL_FIVE.getValue();
            default:
                return BeautyLevel.BEAUTY_LEVEL_THREE.getValue();

        }

    }

    public void setFaceTrackModePath() {
        ThreadUtils.runOnSubThread(new Runnable() {
            @Override
            public void run() {
                String path = StorageUtils.getCacheDirectory(getContext()).getAbsolutePath() + File.separator + Common.QU_NAME + File.separator;
                if (recorder != null) {
                    recorder.needFaceTrackInternal(true);
                    recorder.setFaceTrackInternalModelPath(path + "/model");
                }
            }
        });

    }

    public void setRecordMute(boolean recordMute) {
        if (recorder != null) {
            recorder.setMute(recordMute);
        }
    }

    private void initOrientationDetector() {
        orientationDetector = new OrientationDetector(getContext().getApplicationContext());
        orientationDetector.setOrientationChangedListener(new OrientationDetector.OrientationChangedListener() {
            @Override
            public void onOrientationChanged() {
                rotation = getCameraRotation();
                recorder.setRotation(rotation);
            }
        });
    }

    private int getCameraRotation() {
        int orientation = orientationDetector.getOrientation();
        int rotation = 90;
        if ((orientation >= 45) && (orientation < 135)) {
            rotation = 180;
        }
        if ((orientation >= 135) && (orientation < 225)) {
            rotation = 270;
        }
        if ((orientation >= 225) && (orientation < 315)) {
            rotation = 0;
        }

        Camera.CameraInfo cameraInfo = new Camera.CameraInfo();
        Camera.getCameraInfo(cameraType.getType(), cameraInfo);
        if (cameraInfo.facing == Camera.CameraInfo.CAMERA_FACING_FRONT) {
            if (rotation != 0) {
                rotation = 360 - rotation;
            }
        }
        return rotation;
    }


    private boolean activityStoped;
    private Runnable pendingCompseFinishRunnable;

    /**
     * 开始预览
     */
    public void startPreview() {
        activityStoped = false;
        if (pendingCompseFinishRunnable != null) {
            pendingCompseFinishRunnable.run();
        }
        pendingCompseFinishRunnable = null;
        if (recorder != null) {
            recorder.startPreview();
            if (isAllowChangeMv) {
                restoreConflictEffect();
            }
            //            recorder.setZoom(scaleFactor);
            if (clipManager.getDuration() >= clipManager.getMinDuration() || isMaxDuration) {
                // 2018/7/11 让下一步按钮可点击
                mControlView.setCompleteEnable(true);
            } else {
                mControlView.setCompleteEnable(false);
            }
        }
        if (orientationDetector != null && orientationDetector.canDetectOrientation()) {
            orientationDetector.enable();
        }

        mCountDownView.setOnCountDownFinishListener(new AlivcCountDownView.OnCountDownFinishListener() {
            @Override
            public void onFinish() {
                FixedToastUtils.show(getContext(), getResources().getString(R.string.alivc_recorder_record_start_recorder));
                startRecord();
            }
        });

    }

    /**
     * 结束预览
     */
    public void stopPreview() {
        activityStoped = true;
        if (mControlView != null && mCountDownView != null && mControlView.getRecordState().equals(RecordState.READY)) {
            mCountDownView.cancle();
            mControlView.setRecordState(RecordState.STOP);
            mControlView.setRecording(false);
        }

        if (mControlView != null && mControlView.getRecordState().equals(RecordState.RECORDING)) {
            recorder.stopRecording();
        }
        recorder.stopPreview();

        if (beautyEffectChooser != null) {
            beautyEffectChooser.dismiss();
        }

        if (mFaceUnityTask != null) {
            mFaceUnityTask.cancel(true);
            mFaceUnityTask = null;
        }
        if (orientationDetector != null) {
            orientationDetector.disable();
        }

        if (mControlView != null && mControlView.getFlashType() == FlashType.ON
                && mControlView.getCameraType() == CameraType.BACK) {
            mControlView.setFlashType(FlashType.OFF);
        }
    }

    /**
     * 销毁录制，在activity或者fragment被销毁时调用此方法
     */
    public void destroyRecorder() {

        //destroy时删除多段录制的片段文件
        deleteSliceFile();
        if (finishRecodingTask != null) {
            finishRecodingTask.cancel(true);
            finishRecodingTask = null;
        }

        if (faceTrackPathTask != null) {
            faceTrackPathTask.cancel(true);
            faceTrackPathTask = null;
        }

        if (recorder != null) {
            recorder.release();
            recorder = null;
            Log.i(TAG, "recorder destroy");
        }

        if (orientationDetector != null) {
            orientationDetector.setOrientationChangedListener(null);
        }

    }

    /**
     * 删除多段录制临时文件
     */
    private void deleteSliceFile() {
        if (recorder != null) {
            recorder.getClipManager().deleteAllPart();
        }
    }

    /**
     * 结束录制，并且将录制片段视频拼接成一个视频 跳转editorActivity在合成完成的回调的方法中，{@link AlivcSvideoRecordActivity#()}
     */
    private void finishRecording() {
        //弹窗提示
        if (progressBar == null) {
            progressBar = new ProgressDialog(getContext());
            progressBar.setMessage(getResources().getString(R.string.alivc_recorder_record_create_video));
            progressBar.setCanceledOnTouchOutside(false);
            progressBar.setCancelable(false);
            progressBar.setProgressStyle(android.app.ProgressDialog.STYLE_SPINNER);
        }
        progressBar.show();
        mControlView.setCompleteEnable(false);
        finishRecodingTask = new FinishRecodingTask(this).executeOnExecutor(
                AsyncTask.THREAD_POOL_EXECUTOR);
    }

    private void setMediaInfo() {
        // mMixInputInfo只对合拍有效，普通录制情况下，该参数将被忽略
        AliyunMixRecorderDisplayParam recorderDisplayParam = new AliyunMixRecorderDisplayParam.Builder()
                .displayMode(VideoDisplayMode.SCALE)
                .layoutParam(
                        new AliyunMixTrackLayoutParam.Builder()
                                .centerX(0.25f)
                                .centerY(0.5f)
                                .widthRatio(0.5f)
                                .heightRatio(1.0f)
                                .build()
                )
                .build();
        AliyunMixRecorderDisplayParam sampleDisplayParam = new AliyunMixRecorderDisplayParam
                .Builder()
                .displayMode(VideoDisplayMode.FILL)
                .layoutParam(new AliyunMixTrackLayoutParam.Builder()
                        .centerX(0.75f)
                        .centerY(0.5f)
                        .widthRatio(0.5f)
                        .heightRatio(1.0f)
                        .build())
                .build();
        mMixInputInfo = new AliyunMixMediaInfoParam
                .Builder()
                .streamStartTimeMills(0L)
                .streamEndTimeMills(0L)
                .mixVideoFilePath(mMixVideoPath)
                .mixDisplayParam(sampleDisplayParam)
                .recordDisplayParam(recorderDisplayParam)
                .build();


        mOutputInfo = new MediaInfo();
        mOutputInfo.setFps(35);
        mOutputInfo.setVideoWidth(recorder.getVideoWidth());
        mOutputInfo.setVideoHeight(recorder.getVideoHeight());
        mOutputInfo.setVideoCodec(mVideoCodec);
        recorder.setMediaInfo(mMixInputInfo, mOutputInfo);
    }

    /**
     * 录制结束的AsyncTask
     */
    public static class FinishRecodingTask extends AsyncTask<Void, Integer, Integer> {
        WeakReference<AliyunSVideoRecordView> weakReference;

        FinishRecodingTask(AliyunSVideoRecordView recordView) {
            weakReference = new WeakReference<>(recordView);
        }

        @Override
        protected Integer doInBackground(Void... voids) {
            if (weakReference == null) {
                return -1;
            }

            AliyunSVideoRecordView recordView = weakReference.get();
            if (recordView != null) {
                Log.i(TAG, "finishRecording");
                return recordView.recorder.finishRecording();

            }
            return -1;
        }

        @Override
        protected void onPostExecute(Integer code) {
            if (weakReference == null) {
                return;
            }
            if (code != AliyunErrorCode.ALIVC_COMMON_RETURN_SUCCESS) {
                Log.e(TAG, "合成失败 错误码 : " + code);
                AliyunSVideoRecordView recordView = weakReference.get();
                if (recordView != null) {
                    ToastUtils.show(recordView.getContext(), R.string.alivc_editor_publish_compose_failed);
                    if (recordView.progressBar != null && recordView.progressBar.isShowing()) {
                        recordView.progressBar.dismiss();
                        recordView.mControlView.setCompleteEnable(true);
                    }
                }
            }
        }
    }

    /**
     * 片段录制完成的回调处理
     *
     * @param isValid
     * @param duration
     */
    private void handleStopCallback(final boolean isValid, final long duration) {


        mControlView.setRecordState(RecordState.STOP);
        if (mControlView != null) {
            mControlView.setRecording(false);
        }

        if (!isValid) {
            if (mRecordTimeView != null) {
                mRecordTimeView.setDuration(0);

                if (mRecordTimeView.getTimelineDuration() == 0) {
                    mControlView.setHasRecordPiece(false);
                }
            }
            return;
        }

        if (mRecordTimeView != null) {
            mRecordTimeView.setDuration((int) duration);
            mRecordTimeView.clipComplete();
            mControlView.setHasRecordPiece(true);
            isAllowChangeMv = false;
        }
    }

    /**
     * addSubView 添加子view到布局中
     *
     * @param view 子view
     */
    private void addSubView(View view) {
        LayoutParams params = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
        addView(view, params);//添加到布局中
    }

    /**
     * 录制界面返回按钮click listener
     */
    private OnBackClickListener mBackClickListener;

    public void setBackClickListener(OnBackClickListener listener) {
        this.mBackClickListener = listener;
    }

    private OnFinishListener mCompleteListener;


    @Override
    public void onDialogDismiss() {
        if (mControlView != null) {
            mControlView.setEffectSelViewShow(false);
        }
    }

    @Override
    public void onDialogShow() {
        if (mControlView != null) {
            mControlView.setEffectSelViewShow(true);
        }
    }

    /**
     * 删除所有录制文件
     */
    public void deleteAllPart() {
        if (clipManager != null) {
            clipManager.deleteAllPart();
            if (clipManager.getDuration() < clipManager.getMinDuration() && mControlView != null) {
                mControlView.setCompleteEnable(false);
            }
            if (clipManager.getDuration() == 0) {
                // 音乐可以选择
                //                    musicBtn.setVisibility(View.VISIBLE);
                //                    magicMusic.setVisibility(View.VISIBLE);
                //recorder.restartMv();
                mRecordTimeView.clear();
                mControlView.setHasRecordPiece(false);
                isAllowChangeMv = true;
            }
        }
    }

    private float lastScaleFactor;
    private float scaleFactor;

    @Override
    public boolean onScale(ScaleGestureDetector detector) {
        float factorOffset = detector.getScaleFactor() - lastScaleFactor;
        scaleFactor += factorOffset;
        lastScaleFactor = detector.getScaleFactor();
        if (scaleFactor < 0) {
            scaleFactor = 0;
        }
        if (scaleFactor > 1) {
            scaleFactor = 1;
        }
        recorder.setZoom(scaleFactor);
        return false;
    }

    @Override
    public boolean onScaleBegin(ScaleGestureDetector detector) {
        lastScaleFactor = detector.getScaleFactor();
        return true;
    }

    @Override
    public void onScaleEnd(ScaleGestureDetector detector) {

    }

    /**
     * 返回按钮事件监听
     */
    public interface OnBackClickListener {
        void onClick();
    }

    /**
     * 录制完成事件监听
     */
    public interface OnFinishListener {
        void onComplete(String path, int duration, int ratioMode);

        void onTakeComplete(String path);
    }

    public void setCompleteListener(OnFinishListener mCompleteListener) {
        this.mCompleteListener = mCompleteListener;
    }

    public void setActivity(FragmentActivity mActivity) {
        this.mActivity = mActivity;
    }

    /**
     * 获取最大录制时长
     *
     * @return
     */
    public int getMaxRecordTime() {
        if (maxRecordTime < MIN_RECORD_TIME) {
            return MIN_RECORD_TIME;
        } else if (maxRecordTime > MAX_RECORD_TIME) {
            return MAX_RECORD_TIME;
        } else {

            return maxRecordTime;
        }

    }

    /**
     * 设置录制时长
     *
     * @param maxRecordTime
     */
    public void setMaxRecordTime(int maxRecordTime) {
        this.maxRecordTime = maxRecordTime;
    }

    /**
     * 设置最小录制时长
     *
     * @param minRecordTime
     */
    public void setMinRecordTime(int minRecordTime) {
        this.minRecordTime = minRecordTime;
    }

    /**
     * 设置Gop
     *
     * @param mGop
     */
    public void setGop(int mGop) {
        this.mGop = mGop;

    }

    /**
     * 设置视频质量
     *
     * @param mVideoQuality
     */
    public void setVideoQuality(VideoQuality mVideoQuality) {
        this.mVideoQuality = mVideoQuality;
    }

    /**
     * 重新绘制SurFaceView的比例
     */
    public void setReSizeRatioMode(int ratioMode) {
        this.mRatioMode = ratioMode;
        recorder.setRatioMode(ratioMode);
        mRecorderSurfaceView.setLayoutParams(recorder.getLayoutParams());
    }

    /**
     * 设置视频比例
     *
     * @param ratioMode
     */
    public void setRatioMode(int ratioMode) {
        this.mRatioMode = ratioMode;
    }

    /**
     * 设置播放视频的路径
     */
    public void setVideoPath(String path) {
        this.mMixVideoPath = path;
    }

    /**
     * 设置视频编码方式
     *
     * @param mVideoCodec
     */
    public void setVideoCodec(VideoCodecs mVideoCodec) {
        this.mVideoCodec = mVideoCodec;
    }

    /**
     * 设置视频码率
     *
     * @param mResolutionMode
     */
    public void setResolutionMode(int mResolutionMode) {
        this.mResolutionMode = mResolutionMode;
    }


    private void saveBeautyParams(int position, BeautyParams beautyParams) {
        if (beautyParams != null) {
            Gson gson = new Gson();

            rememberParamList.set(position, beautyParams);
            rememberBeautyBean.setBeautyList(rememberParamList);
            String jsonString = gson.toJson(rememberBeautyBean);

            if (!TextUtils.isEmpty(jsonString)) {
                SharedPreferenceUtils.setBeautyParams(getContext(), jsonString);
            }
        }
    }

    /**
     * 获取美颜美肌参数
     */
    private BeautyParams getBeautyParams(int position) {
        String jsonString = SharedPreferenceUtils.getBeautyParams(getContext());
        if (TextUtils.isEmpty(jsonString)) {
            return null;
        }
        Gson gson = new Gson();
        RememberBeautyBean rememberBeautyBean = gson.fromJson(jsonString, RememberBeautyBean.class);
        List<BeautyParams> beautyList = rememberBeautyBean.getBeautyList();
        if (beautyList == null) {
            return null;
        }
        return beautyList.get(position);
    }


    public void setOnMusicSelectListener(MusicSelectListener musicSelectListener) {
        this.mOutMusicSelectListener = musicSelectListener;
    }

    //保存文件到本地？
    public String saveImageToGallery(Bitmap bmp) {
        //生成路径
        String root = Environment.getExternalStorageDirectory().getAbsolutePath();
        String dirName = "erweima16";
        File appDir = new File(root, dirName);
        if (!appDir.exists()) {
            appDir.mkdirs();
        }

        //文件名为时间
        long timeStamp = System.currentTimeMillis();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String sd = sdf.format(new Date(timeStamp));
        String fileName = sd + ".jpg";

        //获取文件
        File file = new File(appDir, fileName);
        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(file);
            bmp.compress(Bitmap.CompressFormat.JPEG, 100, fos);
            fos.flush();
            //通知系统相册刷新
            mActivity.sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.parse("file://" + file.getAbsolutePath())));
            return file.getAbsolutePath();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (fos != null) {
                    fos.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return null;
    }
}