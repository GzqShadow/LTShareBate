//
//  NSObject+LTShare.m
//  dsbridge
//
//  Created by 乐天 on 2017/1/7.
//  Copyright © 2017年 乐天. All rights reserved.
//

#import "NSObject+LTShare.h"
#import <UShareUI/UShareUI.h>
#import "SDWebImageManager.h"

@implementation NSObject (LTShare)

- (void)shareWithObj:(id)obj
{
    
    if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSURL class]]) {
      UIImage *img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:obj];
        
        if (img) {
            [self initShare:img];
        } else {
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:obj
                                  options:0
                                 progress:nil
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    if (image) {
                                        // do something with image
                                        [self initShare:img];
                                    }
                                }];
        }
        
        
    } else if ([obj isKindOfClass:[UIImage class]]) {
        [self initShare:obj];
    }
    
    
}

- (void)initShare:(UIImage *)img
{
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        [self shareImageAndTextToPlatformType:platformType andImg:img];
    }];
    
    
    
}

//分享图片和文字
- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType andImg:(UIImage *)img
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //设置文本
    messageObject.text = @"众返科技";
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //    shareObject.thumbImage = _imgs[0];
    [shareObject setShareImage:img];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
               UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"分享" message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [view show];
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        
    }];
}

@end
