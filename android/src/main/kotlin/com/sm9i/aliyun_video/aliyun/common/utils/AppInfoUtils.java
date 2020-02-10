package com.sm9i.aliyun_video.aliyun.common.utils;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;

/**
 * data:2019-09-24
 */
public class AppInfoUtils {
    public final static String MD5    = "MD5";
    public final static String SHA1   = "SHA1";
    public final static String SHA256 = "SHA256";


    private AppInfoUtils() {
        /* cannot be instantiated */
        throw new UnsupportedOperationException("cannot be instantiated");

    }

    /**
     * 获取应用程序名称
     *
     * @param context
     * @return
     */
    public static String getAppName(Context context) {
        try {
            PackageManager packageManager = context.getPackageManager();
            PackageInfo packageInfo = packageManager.getPackageInfo(
                context.getPackageName(), 0);
            int labelRes = packageInfo.applicationInfo.labelRes;
            return context.getResources().getString(labelRes);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }
    /**
     * 获取应用程序版本名称信息
     *
     * @param context
     * 当前应用的版本名称
     */
    public static String getVersionName(Context context) {
        try {
            PackageManager packageManager = context.getPackageManager();
            PackageInfo packageInfo = packageManager.getPackageInfo(
                context.getPackageName(), 0);
            return packageInfo.versionName;

        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }
    /**
     * 获取应用程序版本code
     *
     * @param context
     * 当前应用的版本code
     */
    public static int getVersionCode(Context context) {
        try {
            PackageInfo packageInfo = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
            return packageInfo.versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return 1;
    }
    /**
     * 获取application节点下的meta信息
     *
     * @param context
     * @param params
     *            想要获取的参数
     * @return
     */
    public static String getMetaInfo(Context context, String params) {

        String packageName = context.getPackageName();
        // 获取application里面的meta信息
        try {
            ApplicationInfo appInfo = context.getPackageManager()
                .getApplicationInfo(packageName,
                    PackageManager.GET_META_DATA);
            return appInfo.metaData.getString(params);
        } catch (Exception e) {
            System.out.println("获取渠道失败:" + e);
            e.printStackTrace();
        }
        return null;
    }
    /**
     * 返回一个签名的对应类型的字符串
     *
     * @param context
     * @param packageName
     * @param type
     *
     * @return
     */
    public static ArrayList<String> getSingInfo(Context context, String packageName, String type)
    {
        ArrayList<String> result = new ArrayList<String>();
        try
        {
            Signature[] signs = getSignatures(context, packageName);
            for (Signature sig : signs)
            {
                String tmp = "error!";
                if (MD5.equals(type))
                {
                    tmp = getSignatureString(sig, MD5);
                }
                else if (SHA1.equals(type))
                {
                    tmp = getSignatureString(sig, SHA1);
                }
                else if (SHA256.equals(type))
                {
                    tmp = getSignatureString(sig, SHA256);
                }
                result.add(tmp);
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 返回对应包的签名信息
     *
     * @param context
     * @param packageName
     *
     * @return
     */
    public static Signature[] getSignatures(Context context, String packageName) {
        PackageInfo packageInfo = null;
        try {
            packageInfo = context.getPackageManager().getPackageInfo(packageName, PackageManager.GET_SIGNATURES);
            return packageInfo.signatures;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }
    /**
     * 获取相应的类型的字符串（把签名的byte[]信息转换成16进制）
     *
     * @param sig
     * @param type
     *
     * @return
     */
    public static String getSignatureString(Signature sig, String type){
        byte[] hexBytes = sig.toByteArray();
        String fingerprint = "error!";
        try
        {
            MessageDigest digest = MessageDigest.getInstance(type);
            if (digest != null)
            {
                byte[] digestBytes = digest.digest(hexBytes);
                StringBuilder sb = new StringBuilder();
                for (byte digestByte : digestBytes)
                {
                    sb.append((Integer.toHexString((digestByte & 0xFF) | 0x100)).substring(1, 3));
                }
                fingerprint = sb.toString();
            }
        }
        catch (NoSuchAlgorithmException e)
        {
            e.printStackTrace();
        }

        return fingerprint;
    }

}
