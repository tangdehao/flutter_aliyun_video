package com.sm9i.aliyun_video.aliyun.view.effects.skin;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.Nullable;
import androidx.fragment.app.DialogFragment;

import com.sm9i.aliyun_video.R;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.BeautyConstants;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.BeautyDetailSettingView;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.BeautyParams;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.listener.OnBeautyParamsChangeListener;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.listener.OnViewClickListener;
import com.sm9i.aliyun_video.aliyun.view.dialog.BaseChooser;

/**
 * 美肌微调
 * @author xlx
 */
public class BeautySkinDetailChooser extends BaseChooser implements OnBeautyParamsChangeListener, OnViewClickListener,
    BeautyDetailSettingView.OnBlanckViewClickListener {
    /**
     * 美肌tab所在下标: 2
     */
    private static final int TAB_POSITION_BEAUTY_FACE = 2;
    private BeautyParams beautyParams;

    /**
     * 微调返回按钮点击
     */
    private OnViewClickListener onBackClickListener;
    private BeautyDetailSettingView beautyDetailSettingView;
    /**
     * 美肌微调参数改变监听
     */
    private OnBeautyParamsChangeListener onBeautyParamsChangeListener;
    /**
     * 空白区域点击监听
     */
    private BeautyDetailSettingView.OnBlanckViewClickListener onBlankClickListener;
    private int beautyLevel;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStyle(DialogFragment.STYLE_NO_FRAME, R.style.QUDemoFullStyle);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {
        beautyDetailSettingView = new BeautyDetailSettingView(getContext());
        return beautyDetailSettingView;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        beautyDetailSettingView.setParams(beautyParams);
        beautyDetailSettingView.setBeautyParamsChangeListener(this);
        beautyDetailSettingView.setBackClickListener(this);
        beautyDetailSettingView.setOnBlanckViewClickListener(this);
        beautyDetailSettingView.updateDetailLayout(TAB_POSITION_BEAUTY_FACE);
    }

    @Override
    public void onStart() {
        super.onStart();
        beautyDetailSettingView.setBeautyConstants(BeautyConstants.BIG_EYE);
        beautyDetailSettingView.setParams(beautyParams);
        beautyDetailSettingView.setBeautyLevel(beautyLevel);
    }

    @Override
    public void onBeautyChange(BeautyParams param) {
        if (onBeautyParamsChangeListener != null) {
            onBeautyParamsChangeListener.onBeautyChange(param);
        }
    }

    public void setOnBeautyParamsChangeListener(OnBeautyParamsChangeListener listener) {
        this.onBeautyParamsChangeListener = listener;
    }

    public void setBeautyParams(BeautyParams beautyParams) {
        this.beautyParams = beautyParams;

    }

    /**
     * 微调返回按钮点击
     */
    @Override
    public void onClick() {
        if (onBackClickListener != null) {
            onBackClickListener.onClick();
        }
    }

    public void setOnBackClickListener(OnViewClickListener listener) {
        this.onBackClickListener = listener;
    }

    @Override
    public void onBlankClick() {
        if (onBlankClickListener != null) {
            onBlankClickListener.onBlankClick();
        }
        dismiss();
    }

    public void setOnBlankClickListener(BeautyDetailSettingView.OnBlanckViewClickListener listener) {
        this.onBlankClickListener = listener;
    }

    public void setBeautyLevel(int beautyLevel) {
        this.beautyLevel = beautyLevel;
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        if (beautyDetailSettingView != null) {
            beautyDetailSettingView.setBackClickListener(null);
            beautyDetailSettingView.setBeautyParamsChangeListener(null);
            beautyDetailSettingView.setOnBlanckViewClickListener(null);
            beautyDetailSettingView = null;
        }
    }
}
