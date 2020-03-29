package com.sm9i.aliyun_video.aliyun.effects.control;

import com.sm9i.aliyun_video.aliyun.view.effects.filter.EffectInfo;

public interface OnItemTouchListener {
    int EVENT_DOWN = 1;
    int EVENT_UP = 2;
    int EVENT_MOVE = 3;
    void onTouchEvent(int motionEvent, int index, EffectInfo info);
}
