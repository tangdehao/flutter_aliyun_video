package com.sm9i.aliyun_video.aliyun.bean;

import com.sm9i.aliyun_video.aliyun.base.widget.beauty.BeautyParams;

import java.util.List;

/**
 * 记录美颜参数json的bean
 */
public class RememberBeautyBean {
    private List<BeautyParams> beautyList;

    public List<BeautyParams> getBeautyList() {
        return beautyList;
    }

    public void setBeautyList(List<BeautyParams> beautyList) {
        this.beautyList = beautyList;
    }
}
