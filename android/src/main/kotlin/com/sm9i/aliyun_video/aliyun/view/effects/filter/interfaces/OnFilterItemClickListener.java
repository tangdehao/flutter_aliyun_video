/*
 * Copyright (C) 2010-2017 Alibaba Group Holding Limited.
 */

package com.sm9i.aliyun_video.aliyun.view.effects.filter.interfaces;

import com.sm9i.aliyun_video.aliyun.view.effects.filter.EffectInfo;

/**
 * 滤镜item点击事件接口
 * @author xlx
 */
public interface OnFilterItemClickListener {
    /**
     * 滤镜item点击
     * @param effectInfo 特效对象
     * @param index 下标
     * @return
     */
    void onItemClick(EffectInfo effectInfo, int index);
}
