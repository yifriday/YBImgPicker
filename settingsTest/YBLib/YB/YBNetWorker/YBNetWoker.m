//
//  NetWoker.m
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/11.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//

#import "YBNetWoker.h"
#import "AFHTTPRequestOperationManager.h"
#import "SessionData.h"
#import "HashData.h"
#import "AFMsgPackRequestSerializer.h"
#import "AFMsgPackResponseSerializer.h"
static AFHTTPRequestOperationManager *manager;
@implementation YBNetWoker
+ (void) upload:(NSString *) path parameters:(NSDictionary *) parameters fileContent:(NSData *)fileData fileName:(NSString *)filename isContainSession:(BOOL)isContainSession complete:(void (^)(id responseObject)) completeCallback error:(BOOL (^)()) errorCallback{
    AFHTTPRequestOperationManager * manager = [self manager];
    NSMutableDictionary * newParam = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    if (isContainSession) {
        if([newParam objectForKey:@"token"] == nil){
            NSString * _t = [[SessionData getSession] objectForKey:@"token"];
            if(_t){
                [newParam setValue:_t forKey:@"token"];
            }else{
                [newParam setValue:@"" forKey:@"token"];
            }
        }
    }
    
    
    [manager POST:[NSString stringWithFormat:@"%s%@", API_HTTP_HOST, path] parameters:newParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        [formData appendPartWithFileData:fileData name:@"image" fileName:filename mimeType:@"application/object"];
    }success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * res = (NSDictionary *) responseObject;
        NSString * flag = [[res objectForKey:@"flag"] stringValue];
        if([flag compare:@"0"] == NSOrderedSame){
            if(completeCallback != nil){
                completeCallback([responseObject objectForKey:@"data"]);
            }
        }else{
            if((errorCallback == nil) || errorCallback()){
                [YBAlertView alertWithOneBtn:[res objectForKey:@"msg"] message:nil sureBtnTitle:@"确定" sureBtnClick:nil];

                
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if((errorCallback == nil) || errorCallback()){
            [YBAlertView alertWithOneBtn:@"网络连接失败" message:nil sureBtnTitle:@"确定" sureBtnClick:nil];
        }
    }];
}
+ (AFHTTPRequestOperation *)request:(NSString *) path parameters:(NSMutableDictionary *) parameters isMsgPack:(BOOL)isMsgPack isContainSession:(BOOL)isContainSession complete:(void (^)(id responseObject)) completeCallback error:(BOOL (^)()) errorCallback{
    AFHTTPRequestOperationManager * manager = [self manager];
    NSMutableDictionary * newParam = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    if (isContainSession) {
        if([newParam objectForKey:@"token"] == nil){
            NSString * _t = [[SessionData getSession] objectForKey:@"token"];
            if(_t){
                [newParam setValue:_t forKey:@"token"];
            }else{
                [newParam setValue:@"" forKey:@"token"];
            }
        }
    }
    if([newParam objectForKey:@"hash"] == nil){
        NSString * hash = [HashData getHash:path];
        if(hash){
            [newParam setValue:hash forKey:@"hash"];
        }else{
        }
    }
    
    if (isMsgPack) {
        
        //申明返回的结果是msgPack类型
        manager.responseSerializer = [AFMsgPackResponseSerializer serializer];
        //申明请求的数据是msgPack类型
        manager.requestSerializer=[AFMsgPackRequestSerializer serializer];
        
        path = [path stringByAppendingString:@"?_s=1"];
        
        return [manager PUT:[NSString stringWithFormat:@"%s%@", API_HTTP_HOST, path] parameters:newParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary * res = (NSDictionary *) responseObject;
            if ([YBPreHelper modelIsEmpty:res]) {
                [YBException newYBException:@"NetWorkError" reason:@"the data is empty" userInfo:nil];
                if((errorCallback == nil) || errorCallback()){
                    
                }
                
            }else {
                NSString * flag = [[res objectForKey:@"flag"] stringValue];
                if([flag compare:@"0"] == NSOrderedSame){
                    if(completeCallback != nil){
                        NSDictionary * data = [responseObject objectForKey:@"data"];
                        if ([data isKindOfClass:[NSDictionary class]] && data.count) {
                            [HashData setHash:[responseObject objectForKey:@"hash"] prefix:path];
                            completeCallback(data);
                        }
                        
                    }
                }else{
                    if((errorCallback == nil) || errorCallback()){
                        
                        [YBAlertView alertWithOneBtn:[res objectForKey:@"msg"] message:nil sureBtnTitle:@"确定" sureBtnClick:nil];

                    }
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            if((errorCallback == nil) || errorCallback()){
                [YBAlertView alertWithOneBtn:@"网络连接失败" message:nil sureBtnTitle:@"确定" sureBtnClick:nil];
            }
        }];
    }else {
        path = [path stringByAppendingString:@"?_s=0"];
        //申明返回的结果是json类型
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //申明请求的数据是json类型
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        
        return [manager PUT:[NSString stringWithFormat:@"%s%@", API_HTTP_HOST, path] parameters:newParam success:^(AFHTTPRequestOperation * operation, id responseObject) {
            
            
            NSDictionary * res = (NSDictionary *) responseObject;
            if ([YBPreHelper modelIsEmpty:res]) {
                [YBException newYBException:@"NetWorkError" reason:@"the data is empty" userInfo:nil];
                if((errorCallback == nil) || errorCallback()){
                    
                }
                
            }else {
                NSString * flag = [[res objectForKey:@"flag"] stringValue];
                if([flag compare:@"0"] == NSOrderedSame){
                    if(completeCallback != nil){
                        NSDictionary * data = [responseObject objectForKey:@"data"];
                        if ([data isKindOfClass:[NSDictionary class]] && data.count) {
                            [HashData setHash:[responseObject objectForKey:@"hash"] prefix:path];
                            completeCallback(data);
                        }
                        
                    }
                }else{
                    if((errorCallback == nil) || errorCallback()){
                        
                        
                        [YBAlertView alertWithOneBtn:[res objectForKey:@"msg"] message:nil sureBtnTitle:@"确定" sureBtnClick:nil];

                    }
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if((errorCallback == nil) || errorCallback()){
                
                [YBAlertView alertWithOneBtn:@"网络连接失败" message:nil sureBtnTitle:@"确定" sureBtnClick:nil];

            }
        }];
    }
    
    
}
+ (AFHTTPRequestOperationManager *) manager{
    if(!manager){
        manager = [AFHTTPRequestOperationManager manager];
        manager.operationQueue.maxConcurrentOperationCount = 8;
        [manager.requestSerializer setTimeoutInterval:10.0];
    }
    return manager;
}

+ (void)upload{
}
@end
