//
//  NetDataEngine.h
//  HACursor
//
//  Created by qianfeng on 15/9/22.
//  Copyright © 2015年 haha. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlockType)(id responsData);
typedef void(^FailedBlockType)(NSError *error);

@interface NetDataEngine : NSObject

+ (instancetype)sharedInstance;

- (void)requestNewsFrom:(NSString *)url success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;

- (void)requestWeatherFrom:(NSString *)url success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
@end
