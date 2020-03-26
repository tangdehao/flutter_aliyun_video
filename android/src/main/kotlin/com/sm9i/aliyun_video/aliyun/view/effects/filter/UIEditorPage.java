/*
 * Copyright (C) 2010-2017 Alibaba Group Holding Limited.
 */

package com.sm9i.aliyun_video.aliyun.view.effects.filter;
/**
 * NOTE: item order must match
 * @author xlx
 */
public enum UIEditorPage {
    /**
     * 滤镜
     */
    FILTER,
    /**
     * 音乐
     */
    AUDIO_MIX,
    /**
     * 动图
     */
    OVERLAY,
    /**
     * 字幕
     */
    CAPTION,
    /**
     * MV
     */
    MV,

    /**
     * 音效
     */
    SOUND,
    /**
     * 特效
     */
    FILTER_EFFECT,
    /**
     * 时间特效
     */
    TIME,
    /**
     * 转场
     */
    TRANSITION,
    /**
     * 涂鸦
     */
    PAINT,
    /**
     *封面
     */
    COVER,
    /**
     * 字体
     */
    FONT;


    public static
    UIEditorPage get(int index) {
        return values()[index];
    }

    public int index() {
        return ordinal();
    }
}
