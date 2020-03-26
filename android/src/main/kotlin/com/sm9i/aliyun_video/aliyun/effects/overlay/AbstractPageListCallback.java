/*
 * Copyright (C) 2010-2017 Alibaba Group Holding Limited.
 */

package com.sm9i.aliyun_video.aliyun.effects.overlay;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.sm9i.aliyun_video.R;
import com.sm9i.aliyun_video.aliyun.base.PasterForm;
import com.sm9i.aliyun_video.aliyun.base.ResourceForm;
import com.sm9i.aliyun_video.aliyun.base.widget.CircularImageView;
import com.sm9i.aliyun_video.aliyun.base.widget.pagerecyclerview.PageRecyclerView;
import com.sm9i.aliyun_video.aliyun.common.image.ImageLoaderImpl;
import com.sm9i.aliyun_video.aliyun.common.utils.image.AbstractImageLoaderTarget;

import java.util.ArrayList;

public abstract class AbstractPageListCallback implements PageRecyclerView.CallBack<PageViewHolder> {
    private static final int NO_SELECTED = -1;
    private ArrayList<PasterForm> mListData = new ArrayList<>();
    private int mCurrSelectedPos = NO_SELECTED;
    private Context mContext;
    private StringBuilder mIconBuilder;

    public AbstractPageListCallback(Context context) {
        this.mContext = context;
        mIconBuilder = new StringBuilder();
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater inflater = LayoutInflater.from(parent.getContext());
        View view = inflater.inflate(R.layout.alivc_editor_item_paster, parent, false);
        PageViewHolder holder = new PageViewHolder(view);
        holder.mImageView =  view.findViewById(R.id.resource_image_view);
        return holder;
    }

    @Override
    public void onBindViewHolder(final PageViewHolder holder, int position) {
        if (mListData != null
                && position < mListData.size()
                && position >= 0) {
            PasterForm model = mListData.get(position);
            if (mIconBuilder.length() >  0) {
                mIconBuilder.delete(0, mIconBuilder.length());
            }
            mIconBuilder.append(model.getPath())
            .append("/icon.png");

            new ImageLoaderImpl().loadImage(mContext, mIconBuilder.toString())
            .into(holder.mImageView, new AbstractImageLoaderTarget<Drawable>() {
                @Override
                public void onResourceReady(@NonNull Drawable resource) {
                    holder.mImageView.setImageDrawable(resource);
                }
            });
        }
    }

    @Override
    public void onItemClickListener(View view, int position) {
        int prePos = -1;
        /*if (mCurrSelectedPos == position) {//当前已经选中，不需要再操作
            return;
        }*/
        if (mCurrSelectedPos == NO_SELECTED) {//从来没选过
            mCurrSelectedPos = position;
        } else {//当前选中的不是同一个
            prePos = mCurrSelectedPos;
            mCurrSelectedPos = position;
        }
        notifySelected(mCurrSelectedPos, prePos);
    }

    public abstract void notifySelected(int selectedPos, int prePos);


    public PasterForm getSelectedItem() {
        if (mCurrSelectedPos == NO_SELECTED) {
            return null;
        } else {
            if (mCurrSelectedPos >= 0 && mCurrSelectedPos < mListData.size()) {
                return mListData.get(mCurrSelectedPos);
            }
            return null;
        }
    }

    @Override
    public void onItemLongClickListener(View view, int position) {

    }

    public void resetSelected() {
        mCurrSelectedPos = NO_SELECTED;
    }

    public void setData(ResourceForm data) {
        if (data == null || data.getPasterList() == null) {
            return;
        }
        this.mListData = (ArrayList<PasterForm>) data.getPasterList();
    }

}


class PageViewHolder extends RecyclerView.ViewHolder {
    CircularImageView mImageView;

    public PageViewHolder(View itemView) {
        super(itemView);
    }
}

