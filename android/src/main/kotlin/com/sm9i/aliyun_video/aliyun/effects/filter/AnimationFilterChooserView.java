package com.sm9i.aliyun_video.aliyun.effects.filter;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.sm9i.aliyun_video.R;
import com.sm9i.aliyun_video.aliyun.base.utils.EditorCommon;
import com.sm9i.aliyun_video.aliyun.base.utils.FastClickUtil;
import com.sm9i.aliyun_video.aliyun.common.utils.DensityUtils;
import com.sm9i.aliyun_video.aliyun.editor.control.OnItemClickListener;
import com.sm9i.aliyun_video.aliyun.effects.BaseChooser;
import com.sm9i.aliyun_video.aliyun.effects.control.OnItemTouchListener;
import com.sm9i.aliyun_video.aliyun.msg.ClearAnimationFilter;
import com.sm9i.aliyun_video.aliyun.msg.ConfirmAnimationFilter;
import com.sm9i.aliyun_video.aliyun.msg.DeleteLastAnimationFilter;
import com.sm9i.aliyun_video.aliyun.msg.Dispatcher;
import com.sm9i.aliyun_video.aliyun.msg.FilterTabClick;
import com.sm9i.aliyun_video.aliyun.msg.LongClickAnimationFilter;
import com.sm9i.aliyun_video.aliyun.msg.LongClickUpAnimationFilter;
import com.sm9i.aliyun_video.aliyun.view.effects.filter.EffectInfo;
import com.sm9i.aliyun_video.aliyun.view.effects.filter.SpaceItemDecoration;
import com.sm9i.aliyun_video.aliyun.view.effects.filter.UIEditorPage;

public class AnimationFilterChooserView extends BaseChooser
    implements OnItemClickListener, OnItemTouchListener, View.OnClickListener {
    private RecyclerView mListView;
    private FrameLayout mFlThumblinebar;
    private EffectAdapter mFilterAdapter;
    private ImageView mCancel;
    private TextView mTvEffectTitle;
    private ImageView mIvEffectIcon;
    private ImageView mComplete;
    private boolean isFirstShow;
    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        Dispatcher.getInstance().postMsg(new FilterTabClick(FilterTabClick.POSITION_ANIMATION_FILTER));

        if (isFirstShow) {
            View contentView = LayoutInflater.from(getContext()).inflate(R.layout.alivc_editor_view_tip_first_show, null, false);
            PopupWindow window = new PopupWindow( contentView, ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT, true);
            window.setContentView(contentView);
            window.setOutsideTouchable(true);
            // 设置PopupWindow的背景
            window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
            int yoff = 0 - getContext().getResources().getDimensionPixelSize(R.dimen.alivc_editor_size_effect_list_view) - DensityUtils
                       .dip2px(getContext(), 25 );
            int xoff = DensityUtils.dip2px(getContext(), 5);
            window.showAsDropDown(mListView, xoff, yoff);
            isFirstShow = false;
        }
    }


    public AnimationFilterChooserView(@NonNull Context context) {
        this(context, null);
    }

    public AnimationFilterChooserView(@NonNull Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public AnimationFilterChooserView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    public boolean onItemClick(EffectInfo effectInfo, int index) {
        if (index == 0) {
            //删除最后一次添加效果
            Dispatcher.getInstance().postMsg(new DeleteLastAnimationFilter());

        }
        return false;
    }
    @Override
    public void onTouchEvent(int motionEvent, int index, EffectInfo info) {
        switch (motionEvent) {
        case OnItemTouchListener.EVENT_UP:
            //先判断缩略图是否在被拖动状态，如果在被拖动状态则不能添加特效
            if (mThumbLineBar != null && !mThumbLineBar.isTouching()) {
                //添加特效结束时，恢复缩略图滑动事件
                //setThumbScrollEnable(true);
                setClickable(true);
                Dispatcher.getInstance().postMsg(new LongClickUpAnimationFilter.Builder()
                                                 .effectInfo(info)
                                                 .index(index)
                                                 .build());
            }
            break;
        case OnItemTouchListener.EVENT_DOWN:
            if (index > 0) {
                //先判断缩略图是否在被拖动状态，如果在被拖动状态则不能添加特效
                if (mThumbLineBar != null && !mThumbLineBar.isTouching()) {
                    //添加特效开始时，关闭特效界面点击
                    //setThumbScrollEnable(false);
                    setClickable(false);
                    info.streamStartTime = mPlayerListener.getCurrDuration();
                    Dispatcher.getInstance().postMsg(new LongClickAnimationFilter.Builder()
                                                     .effectInfo(info)
                                                     .index(index)
                                                     .build());
                }


            }
            break;
        default:
            break;
        }


    }

    @Override
    public void onClick(View v) {
        if (FastClickUtil.isFastClick()) {
            return;
        }

        if (v == mComplete) {
            Dispatcher.getInstance().postMsg(new ConfirmAnimationFilter());
            if (mOnEffectActionLister != null) {
                mOnEffectActionLister.onComplete();
            }
        } else if (v == mCancel) {
            onBackPressed();
        }

    }
    @Override
    protected void init() {
        LayoutInflater.from(getContext()).inflate(R.layout.alivc_editor_view_chooser_animation_filter, this);
        mListView = (RecyclerView) findViewById(R.id.effect_list_filter);
        LinearLayoutManager layoutManager = new LinearLayoutManager(getContext(), LinearLayoutManager.HORIZONTAL, false);
        mListView.setLayoutManager(layoutManager);
        mFlThumblinebar = findViewById(R.id.fl_thumblinebar);
        mFilterAdapter = new EffectAdapter(getContext());
        mFilterAdapter.setOnItemClickListener(this);
        mFilterAdapter.setOnItemTouchListener(this);
        mFilterAdapter.setDataList(EditorCommon.getAnimationFilterList());
        //        mFilterAdapter.setSelectedPos(mEditorService.getEffectIndex(UIEditorPage.FILTER_EFFECT));
        mListView.setAdapter(mFilterAdapter);
        mListView.addItemDecoration(new SpaceItemDecoration(getContext().getResources().getDimensionPixelSize(R.dimen.list_item_space)));
        //        mListView.scrollToPosition(mEditorService.getEffectIndex(UIEditorPage.FILTER_EFFECT));
        mCancel = (ImageView) findViewById(R.id.cancel);
        mTvEffectTitle = (TextView) findViewById(R.id.tv_effect_title);
        mIvEffectIcon = (ImageView) findViewById(R.id.iv_effect_icon);
        mComplete = (ImageView) findViewById(R.id.complete);
        mIvEffectIcon.setImageResource(R.mipmap.alivc_svideo_effect);
        mTvEffectTitle.setText(R.string.alivc_editor_dialog_animate_tittle);
        mComplete.setOnClickListener(this);
        mCancel.setOnClickListener(this);
    }

    @Override
    protected UIEditorPage getUIEditorPage() {
        return UIEditorPage.FILTER_EFFECT;
    }

    @Override
    public void onBackPressed() {
        Dispatcher.getInstance().postMsg(new ClearAnimationFilter());
        if (mOnEffectActionLister != null) {
            mOnEffectActionLister.onCancel();
        }
    }

    public void setFirstShow(boolean firstShow) {
        isFirstShow = firstShow;
    }

    @Override
    public boolean isPlayerNeedZoom() {
        return true;
    }
    @Override
    protected FrameLayout getThumbContainer() {
        return mFlThumblinebar;
    }
}
