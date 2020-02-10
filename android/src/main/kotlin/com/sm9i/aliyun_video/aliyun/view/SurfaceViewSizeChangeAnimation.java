package com.sm9i.aliyun_video.aliyun.view;
import android.view.SurfaceView;
import android.view.animation.Animation;
import android.view.animation.Transformation;
import android.widget.FrameLayout;


/**
 *  SurfaceView更改高度时的动画
 */
public class SurfaceViewSizeChangeAnimation extends Animation {
    int initialHeight;
    int targetHeight;
    int initialWidth;
    int targetWidth;
    SurfaceView view;
    FrameLayout.LayoutParams layoutParams;



    public SurfaceViewSizeChangeAnimation(SurfaceView view, FrameLayout.LayoutParams layoutParams) {
        this.view = view;
        this.layoutParams = layoutParams;
        this.targetHeight = layoutParams.height;
        this.targetWidth = layoutParams.width;
    }

    @Override
    protected void applyTransformation(float interpolatedTime, Transformation t) {
        layoutParams.height = initialHeight + (int) ((targetHeight - initialHeight) * interpolatedTime);
        view.setLayoutParams(layoutParams);


    }

    /**
     * 需待执行动画的对象（一般是View）和其父元素的宽高，来初始化动画
     * @param width
     * @param height
     * @param parentWidth
     * @param parentHeight
     */
    @Override
    public void initialize(int width, int height, int parentWidth, int parentHeight) {
        this.initialHeight = height;
        this.initialWidth = width;
        super.initialize(width, height, parentWidth, parentHeight);
    }

    @Override
    public boolean willChangeBounds() {
        return false;
    }
}

