/*
 * Copyright (C) 2010-2017 Alibaba Group Holding Limited.
 */

package com.sm9i.aliyun_video.aliyun;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.aliyun.svideo.sdk.external.struct.form.PreviewPasterForm;
import com.sm9i.aliyun_video.R;
import com.sm9i.aliyun_video.aliyun.base.widget.CircularImageView;
import com.sm9i.aliyun_video.aliyun.common.image.ImageLoaderImpl;
import com.sm9i.aliyun_video.aliyun.common.utils.image.AbstractImageLoaderTarget;

import java.util.List;


public class PasterAdapter extends RecyclerView.Adapter<PasterAdapter.AssetInfoViewHolder> {
    private Context context;
    private List<PreviewPasterForm> data;
    private int itemWidth;
    private OnItemClickListener listener;

    public interface OnItemClickListener {
        void onItemClick(View view, int position);
    }

    public PasterAdapter(Context context, List<PreviewPasterForm> data, int itemWidth) {
        this.context = context;
        this.data = data;
        this.itemWidth = itemWidth;
    }

    public void setOnItemClickListener(OnItemClickListener l) {
        this.listener = l;
    }

    @Override
    public AssetInfoViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View item = LayoutInflater.from(context).inflate(R.layout.alivc_recorder_item_paster, parent, false);
        item.setLayoutParams(new FrameLayout.LayoutParams(itemWidth, itemWidth));
        AssetInfoViewHolder holder = new AssetInfoViewHolder(item, listener);
        return holder;
    }

    @Override
    public void onBindViewHolder(final AssetInfoViewHolder holder, int position) {
        if (data.get(position).getIcon() == null || data.get(position).getIcon().isEmpty()) {
            holder.itemView.setVisibility(View.GONE);
            holder.itemView.setTag(null);
        } else {
            holder.itemView.setVisibility(View.VISIBLE);

            new ImageLoaderImpl().loadImage(context.getApplicationContext(), data.get(position).getIcon())
                    .into(holder.imageView, new AbstractImageLoaderTarget<Drawable>() {
                        @Override
                        public void onResourceReady(@NonNull Drawable resource) {
                            holder.imageView.setImageDrawable(resource);
                        }
                    });

            holder.itemView.setTag(data.get(position));
        }
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    public class AssetInfoViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        public CircularImageView imageView;
        public OnItemClickListener listener;

        public AssetInfoViewHolder(View itemView, OnItemClickListener l) {
            super(itemView);
            this.listener = l;
            imageView = (CircularImageView) itemView.findViewById(R.id.aliyun_icon);
            itemView.setOnClickListener(this);
        }

        @Override
        public void onClick(View v) {
            if (listener != null) {
                listener.onItemClick(v, getAdapterPosition());
            }
        }
    }
}
