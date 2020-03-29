package com.sm9i.aliyun_video.aliyun.msg;

public interface MessageHandler {
    <T> int onHandleMessage(T message);
}
