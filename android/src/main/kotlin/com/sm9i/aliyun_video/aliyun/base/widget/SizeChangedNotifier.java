/*
 * Copyright (C) 2010-2017 Alibaba Group Holding Limited.
 */

package com.sm9i.aliyun_video.aliyun.base.widget;

import android.view.View;

public interface SizeChangedNotifier {

    public interface Listener {
        void onSizeChanged(View view, int w, int h, int oldw, int oldh);
    }

    void setOnSizeChangedListener(Listener listener);

}
