//
//  NetDataEngine.m
//  HACursor
//
//  Created by qianfeng on 15/9/22.
//  Copyright © 2015年 haha. All rights reserved.
//

#import "NetDataEngine.h"
#import "AFNetworking.h"

@interface NetDataEngine ()
@property (nonatomic) AFHTTPRequestOperationManager *manager;
@end
@implementation NetDataEngine

+ (instancetype)sharedInstance{
    static NetDataEngine *s_netEngine = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_netEngine = [[NetDataEngine alloc]init];
    });
    return s_netEngine;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [[AFHTTPRequestOperationManager alloc]init];
        NSSet *currentAcceptSet = self.manager.responseSerializer.acceptableContentTypes;
        NSMutableSet *mset = [NSMutableSet setWithSet:currentAcceptSet];
        [mset addObject:@"text/html"];
        self.manager.responseSerializer.acceptableContentTypes = mset;
    }
    return self;
}

- (void)GET:(NSString *)url success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock{
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

#pragma mark - 下载接口
- (void)requestNewsFrom:(NSString *)url success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock{
    [self GET:url success:successBlock
       failed:failedBlock];
}

- (void)requestWeatherFrom:(NSString *)url success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock{
    [self GET:url success:successBlock
       failed:failedBlock];
}

@end
