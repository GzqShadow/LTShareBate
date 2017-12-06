//
//  NSObject+LTShare.h
//  dsbridge
//
//  Created by 乐天 on 2017/1/7.
//  Copyright © 2017年 乐天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LTShare)


/**
 分享

 @param obj obj 可为本地图片(UIImage类型),网络图片,(NSString类型,因为只能上传https的图片，所以内部使用SDWebImageManager，SDWebImage第三方库的一个类，使用这类进行图片下载处理)
 */
- (void)shareWithObj:(id)obj;

@end
