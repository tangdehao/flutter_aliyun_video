package com.sm9i.aliyun_video.aliyun;

import android.content.Context;
import android.graphics.drawable.Drawable;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.aliyun.svideo.sdk.external.struct.form.IMVForm;
import com.sm9i.aliyun_video.R;
import com.sm9i.aliyun_video.aliyun.base.widget.CircularImageView;
import com.sm9i.aliyun_video.aliyun.common.image.ImageLoaderImpl;
import com.sm9i.aliyun_video.aliyun.common.utils.image.AbstractImageLoaderTarget;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by aa on 2018/1/11.
 */

public class MvAdapter  extends RecyclerView.Adapter<RecyclerView.ViewHolder> implements View.OnClickListener {


    interface OnItemClickListener {
        boolean onItemClick(MvForm effectInfo, int index);
    }

    private Context mContext;
    private OnItemClickListener mItemClick;
    private int mSelectedPos;
    private IMVViewHolder mSelectedHolder;

    List<IMVForm> mDataList = new ArrayList<>();

    private static final int EFFECT_NONE = 0;
    private static final int EFFECT_RESOURCE = 1;

    public MvAdapter(Context context) {
        this.mContext = context;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.alivc_recorder_item_mv, parent, false);
        IMVViewHolder iMVViewHolder = new IMVViewHolder(view);
        iMVViewHolder.frameLayout = (FrameLayout) view.findViewById(R.id.resource_image);
        return iMVViewHolder;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        final IMVViewHolder iMVViewHolder = (IMVViewHolder) holder;
        int viewType = getItemViewType(position);
        iMVViewHolder.itemView.setOnClickListener(this);
        if (viewType == EFFECT_NONE) {

            new ImageLoaderImpl().loadImage(mContext, R.mipmap.aliyun_video_icon_raw_effect)
            .into(iMVViewHolder.mImage, new AbstractImageLoaderTarget<Drawable>() {
                @Override
                public void onResourceReady(@NonNull Drawable resource) {
                    iMVViewHolder.mImage.setImageDrawable(resource);
                }
            });
        } else {
            IMVForm imvForm = mDataList.get(position);

            new ImageLoaderImpl().loadImage(mContext, imvForm.getIcon())
            .into(iMVViewHolder.mImage, new AbstractImageLoaderTarget<Drawable>() {
                @Override
                public void onResourceReady(@NonNull Drawable resource) {
                    iMVViewHolder.mImage.setImageDrawable(resource);
                }
            });

        }
        if (mSelectedPos == position) {
            iMVViewHolder.mImage.setSelected(true);
            mSelectedHolder = iMVViewHolder;
        } else {
            iMVViewHolder.mImage.setSelected(false);
        }
        iMVViewHolder.itemView.setTag(holder);

    }

    @Override
    public int getItemCount() {
        return mDataList.size();
    }

    public static class IMVViewHolder extends RecyclerView.ViewHolder {
        FrameLayout frameLayout;
        CircularImageView mImage;
//        TextView mName;
        public IMVViewHolder(View itemView) {
            super(itemView);
            mImage = (CircularImageView) itemView.findViewById(R.id.resource_image_view);
//            mName = (TextView) itemView.findViewById(R.id.resource_name);
        }
    }

    public void setOnItemClickListener(OnItemClickListener listener) {
        mItemClick = listener;
    }

    @Override
    public void onClick(View view) {
        if (mItemClick != null) {
            IMVViewHolder viewHolder = (IMVViewHolder) view.getTag();
            int position = viewHolder.getAdapterPosition();
            if (mSelectedPos != position) {
                setEffectInfo(viewHolder, position);
            }
        }
    }

    @Override
    public int getItemViewType(int position) {
        int type = EFFECT_RESOURCE;
        if (position == 0) {
            type = EFFECT_NONE;
        }
        return type;
    }

    public void setData(List<IMVForm> data) {
        if (data == null) {
            return;
        }
        mDataList = data;
        notifyDataSetChanged();
    }

    public void setEffectInfo(IMVViewHolder holder, int index) {
        if (holder != null) {
            if (mSelectedHolder != null) {
                mSelectedHolder.mImage.setSelected(false);
                holder.mImage.setSelected(true);
            }

            mSelectedPos = index;
            mSelectedHolder = holder;
            setEffecteffective(index);
        }
    }

    public void setEffecteffective(int index) {
        MvForm effectInfo = new MvForm();
        effectInfo.list = mDataList.get(index).getAspectList();
        effectInfo.id = mDataList.get(index).getId();
        mItemClick.onItemClick(effectInfo, effectInfo.id);
    }

    public int getSelectedEffectIndex() {
        return mSelectedPos;
    }

    public void setSelectedEffectIndex(int index) {
        mSelectedPos = index;
    }

}
