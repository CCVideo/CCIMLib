//
//  CCIMManager.h
//  CCImDemo
//
//  Created by 刘强强 on 2020/6/3.
//  Copyright © 2020 刘强强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CCRequestCallback)(BOOL result, NSError * _Nullable error);
typedef void(^CCRequestCallbackWithData)(BOOL result, id _Nullable data, NSError * _Nullable error);

@protocol CCIMManagerDelegate <NSObject>

@optional

/// 收到房间内消息
/// @param event 事件名
/// @param object 消息体
- (void)onImSocketReceive:(NSString *_Nonnull)event value:(id _Nullable )object;
///socket连接失败
- (void)onFailed;
///socket连接成功
- (void)onSocketConnected;
///socket关闭
- (void)onsocketClosed;
///socket连接关闭
- (void)onconnectionClosed;
///scoket重连中
- (void)onsocketReconnectiong;
///scoket重连成功
- (void)onSocketReconnected;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CCIMManager : NSObject
///单例化
+ (instancetype)sharedIMManager;

/// 初始化房间信息并连接socket
/// @param token token
/// @param userId 用户id
/// @param classId 课程id
/// @param userName 用户名 option
/// @param callBack 回调函数
- (void)initCCIM:(NSString *)token userId:(NSString *)userId classId:(NSString *)classId userName:(NSString *)userName callBack:(CCRequestCallbackWithData)callBack;

///发布了需要存储消息时使用
- (void)setClassId:(NSString *)classId;


/// 发送房间内广播
/// @param data 消息体
/// @param callBack 发送是否成功的回调
- (void)sendRoomMsg:(NSString *)data callBack:(CCRequestCallback)callBack;

/// 给指定用户组发送广播
/// @param userIds 要发送的用户id数组(为空则是房间内广播)
/// @param data 自定义消息体
/// @param callBack 发送是否成功的回调
- (void)sendCustomCommand:(NSArray *)userIds data:(NSString *)data callBack:(CCRequestCallback)callBack;

/// 给指定用户组发送广播并存储
/// @param userIds 要发送的用户id数组(为空则是房间内广播)
/// @param data 自定义消息体
/// @param callBack 发送是否成功的回调
- (void)sendReliableMessage:(NSArray *)userIds data:(NSString *)data callBack:(CCRequestCallback)callBack;

/// 添加observer
/// @param observer 代理对象
- (void)setOnIMListener:(id<CCIMManagerDelegate>)observer;

/// 添加observer
/// @param observer 代理对象
- (void)removeOnIMListener:(id<CCIMManagerDelegate>)observer;

/// 获取历史消息
/// @param classId 课程id
/// @param types 可传半角逗号隔开的多个值，不传则返回所有 type
/// @param callBack 回调函数
- (void)getHistoryMessage:(NSString *)classId types:(NSString *)types callBack:(CCRequestCallbackWithData)callBack;

@end

NS_ASSUME_NONNULL_END
