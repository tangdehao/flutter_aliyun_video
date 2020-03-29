/*
 * Copyright (C) 2010-2017 Alibaba Group Holding Limited.
 */

package com.sm9i.aliyun_video.aliyun.view.effects.filter;

import com.aliyun.editor.AudioEffectType;
import com.aliyun.editor.TimeEffectType;
import com.aliyun.svideo.sdk.external.struct.form.AspectForm;

import java.io.Serializable;
import java.util.List;

/**
 * 特效javaBean
 * @author xlx
 */
public class EffectInfo implements Serializable {

    /**
     * 用作取消的批处理
     * 1.转场的取消
     */
    public List<EffectInfo> mutiEffect;

    public UIEditorPage type;

    public TimeEffectType timeEffectType;
    /**
     * 音效类型
     */
    public AudioEffectType audioEffectType;

    /**
     * 音效权重
     */
    public int soundWeight;

    public float timeParam;

    public boolean isMoment;

    public boolean isCategory;

    public boolean isAudioMixBar;

    public boolean isLocalMusic;

    public String fontPath;

    public int id;

    public int mixId;

    public List<AspectForm> list;

    public long startTime = -1;

    public long endTime;

    public long streamStartTime;

    public long streamEndTime;

    String path;

    public int musicWeight;

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public int transitionType;

    public int clipIndex;

}
