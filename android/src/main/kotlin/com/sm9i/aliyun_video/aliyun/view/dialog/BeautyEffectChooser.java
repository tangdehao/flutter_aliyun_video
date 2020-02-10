package com.sm9i.aliyun_video.aliyun.view.dialog;

import android.content.DialogInterface;
import android.os.Bundle;
import android.widget.RadioGroup;

import androidx.annotation.Nullable;
import androidx.fragment.app.DialogFragment;
import androidx.fragment.app.Fragment;

import com.sm9i.aliyun_video.R;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.BeautyParams;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.enums.BeautyLevel;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.listener.OnBeautyDetailClickListener;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.listener.OnBeautyFaceItemSeletedListener;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.listener.OnBeautyModeChangeListener;
import com.sm9i.aliyun_video.aliyun.base.widget.beauty.listener.OnBeautySkinItemSeletedListener;
import com.sm9i.aliyun_video.aliyun.view.effects.face.AlivcBeautyFaceFragment;
import com.sm9i.aliyun_video.aliyun.view.effects.skin.AlivcBeautySkinFragment;

import java.util.ArrayList;
import java.util.List;

/**
 * 美颜模块整体dialog, 包含滤镜, 美颜, 美肌
 * @author xlx
 */
public class BeautyEffectChooser extends BasePageChooser {

    /**
     * 美颜参数
     */
    private BeautyParams beautyParams;

    /**
     * 美颜fragment
     */
    private AlivcBeautyFaceFragment beautyFaceFragment;
    /**
     * 美肌fragment
     */
    private AlivcBeautySkinFragment beautySkinFragment;

    /**
     * 美颜微调点击listener
     */
    private OnBeautyDetailClickListener onBeautyFaceDetailClickListener;
    /**
     * 美肌微调点击listener
     */
    private OnBeautyDetailClickListener onBeautySkinDetailClickListener;

    /**
     * 美颜item选中listener
     */
    private OnBeautyFaceItemSeletedListener onItemSeletedListener;
    /**
     * 美肌item选中listener
     */
    private OnBeautySkinItemSeletedListener onBeautySkinItemSeletedListener;
    /**
     * 美颜模式切换listener (普通or高级)
     */
    private OnBeautyModeChangeListener onBeautyModeChangeListener;

    /**
     * 当前viewpager的选中下标
     */
    public int currentTabPosition;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //适配有底部导航栏的手机，在full的style下会盖住部分视图的bug
        setStyle(DialogFragment.STYLE_NO_FRAME, R.style.QUDemoFullStyle);
    }

    @Override
    public List<Fragment> createPagerFragmentList() {
        List<Fragment> fragments = new ArrayList<>();

        beautyFaceFragment = new AlivcBeautyFaceFragment();
        beautySkinFragment = new AlivcBeautySkinFragment();

        beautyFaceFragment.setTabTitle(getResources().getString(R.string.alivc_base_beauty));
        //美肌
        beautySkinFragment.setTabTitle(getResources().getString(R.string.alivc_base_beauty_face));
        fragments.add(beautyFaceFragment);
      //  fragments.add(beautySkinFragment);


        initBeautyFace();
        initBeautySkin();
        // dialog的tab切换监听
        setOnUpdatePageSelectedListener(new OnUpdatePageSelectedListener() {
            @Override
            public void onPageSelected(int position) {
                currentTabPosition = position;
                beautyFaceFragment.updatePageIndex(position);
                beautySkinFragment.updatePageIndex(position);
            }
        });
        return fragments;
    }

    private void initBeautySkin() {
        beautySkinFragment.setBeautyParams(beautyParams);

        beautySkinFragment.setOnBeautySkinItemSelectedlistener(new OnBeautySkinItemSeletedListener() {
            @Override
            public void onItemSelected(int postion) {
                if (onBeautySkinItemSeletedListener != null) {
                    onBeautySkinItemSeletedListener.onItemSelected(postion);
                }
            }
        });

        // 详情
        beautySkinFragment.setOnBeautyDetailClickListener(new OnBeautyDetailClickListener() {
            @Override
            public void onDetailClick() {
                if (onBeautySkinDetailClickListener != null) {
                    onBeautySkinDetailClickListener.onDetailClick();
                }
            }
        });
    }

    private void initBeautyFace() {
        beautyFaceFragment.setBeautyParams(beautyParams);

        // 档位选择
        beautyFaceFragment.setOnBeautyFaceItemSeletedListener(new OnBeautyFaceItemSeletedListener() {
            @Override
            public void onNormalSelected(int postion, BeautyLevel beautyLevel) {
                if (onItemSeletedListener != null) {
                    onItemSeletedListener.onNormalSelected(postion, beautyLevel);
                }
            }

            @Override
            public void onAdvancedSelected(int postion, BeautyLevel beautyLevel) {
                if (onItemSeletedListener != null) {
                    onItemSeletedListener.onAdvancedSelected(postion, beautyLevel);
                }
            }
        });

        // 高级or普通模式切换
        beautyFaceFragment.setOnBeautyModeChangeListener(new OnBeautyModeChangeListener() {
            @Override
            public void onModeChange(RadioGroup group, int checkedId) {
                if (onBeautyModeChangeListener != null) {
                    onBeautyModeChangeListener.onModeChange(group, checkedId);
                }
            }
        });

        // 高级详情
        beautyFaceFragment.setOnBeautyDetailClickListener(new OnBeautyDetailClickListener() {
            @Override
            public void onDetailClick() {
                if (onBeautyFaceDetailClickListener != null) {
                    onBeautyFaceDetailClickListener.onDetailClick();
                }
            }
        });
    }



    /**
     * 设置美颜美肌参数
     * @param beautyParams 美颜美肌参数
     */
    public void setBeautyParams(BeautyParams beautyParams) {
        this.beautyParams = beautyParams;
    }

    /**
     * 美颜微调按钮点击listener
     * @param listener OnBeautyDetailClickListener
     */
    public void setOnBeautyFaceDetailClickListener(
        OnBeautyDetailClickListener listener) {
        this.onBeautyFaceDetailClickListener = listener;
    }

    /**
     * 美肌微调按钮点击listener
     * @param listener OnBeautyDetailClickListener
     */
    public void setOnBeautySkinDetailClickListener(
        OnBeautyDetailClickListener listener) {
        this.onBeautySkinDetailClickListener = listener;
    }

    /**
     * 设置美颜item点击listener
     * @param listener OnBeautyFaceItemSeletedListener
     */
    public void setOnBeautyFaceItemSeletedListener(OnBeautyFaceItemSeletedListener listener) {
        this.onItemSeletedListener = listener;
    }


    /**
     * 设置美肌item点击listener
     * @param listener OnBeautySkinItemSeletedListener
     */
    public void setOnBeautySkinSelectedListener(OnBeautySkinItemSeletedListener listener) {
        this.onBeautySkinItemSeletedListener = listener;
    }

    /**
     * 美颜模式切换listener
     * @param listener OnBeautyModeChangeListener
     */
    public void setOnBeautyModeChangeListener(
        OnBeautyModeChangeListener listener) {
        this.onBeautyModeChangeListener = listener;
    }


    public int getCurrentTabIndex() {
        return currentTabPosition;
    }

    @Override
    public void onPause() {
        super.onPause();
    }

    @Override
    public void onDismiss(DialogInterface dialog) {
        super.onDismiss(dialog);
    }

}
