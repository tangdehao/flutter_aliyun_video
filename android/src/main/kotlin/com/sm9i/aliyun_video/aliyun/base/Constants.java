package com.sm9i.aliyun_video.aliyun.base;

import android.content.Context;
import android.os.Build;
import android.os.Environment;

import java.io.File;

/**
 * @author cross_ly DATE 2019/04/23
 * <p>描述:常量值
 */
public class Constants {

    /**
     * 文件存储相关常量
     */
    public static class SDCardConstants {

        /**
         * 裁剪 & 录制 & 转码输出文件的目录
         * "/sdcard/DCIM/Camera/"
         */
        public final static String OUTPUT_PATH_DIR = Environment.getExternalStorageDirectory() + File.separator + "DCIM" + File.separator + "Camera" + File.separator;

        /**
         * 转码文件后缀
         */
        public final static String TRANSCODE_SUFFIX = ".mp4_transcode";

        /**
         * 裁剪文件后缀
         */
        public final static String CROP_SUFFIX = "-crop.mp4";

        /**
         * 合成文件后缀
         */
        public final static String COMPOSE_SUFFIX = "-compose.mp4";

        static {
            //静态代码快创建目录
            File dir = new File(OUTPUT_PATH_DIR);
            if (!dir.exists()) {
                //noinspection ResultOfMethodCallIgnored
                dir.mkdirs();
            }
        }
        /**
         * 获取外部缓存目录 版本默认"/storage/emulated/0/Android/data/包名/file/Cache"
         *
         * @param context Context
         * @return string path
         */
        public static String getCacheDir(Context context) {
            File cacheDir = context.getExternalCacheDir();
            return cacheDir == null ? "" : cacheDir.getPath();
        }


        /**
         * 裁剪 & 录制 & 转码输出文件的目录
         * android Q 版本默认路径
         * /storage/emulated/0/Android/data/包名/files/Media/
         * android Q 以下版本默认"/sdcard/DCIM/Camera/"
         */
        public static String getDir(Context context) {
            String dir;
            if (Build.VERSION.SDK_INT >= 29) {
                dir = context.getExternalFilesDir("") + File.separator + "Media" + File.separator;
            } else {
                dir = Environment.getExternalStorageDirectory() + File.separator + "DCIM"
                        + File.separator + "Camera" + File.separator;
            }
            File file = new File(dir);
            if (!file.exists()) {
                //noinspection ResultOfMethodCallIgnored
                file.mkdirs();
            }
            return dir;
        }

    }
}
