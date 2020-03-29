package com.sm9i.aliyun_video.aliyun.effects.sound;

import com.sm9i.aliyun_video.aliyun.view.effects.filter.EffectInfo;
import com.sm9i.aliyun_video.aliyun.view.effects.filter.UIEditorPage;

public class SoundEffectInfo extends EffectInfo {
    public int soundNameId;
    public int imgIcon;

    public SoundEffectInfo() {
        type = UIEditorPage.SOUND;
    }
}
