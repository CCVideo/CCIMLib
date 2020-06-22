# 交互说明

1. 在使用 IM 服务前，调用“开通房间”接口，将您的房间与消息通道的房间进行绑定。绑定后，接口响应中会返回分配给此房间的 token，服务端需要记录此 token，并在之后与 IM 建连时携带此 token。

2. 调用SDK接口，与消息通道建立连接。建连时需要携带 token、用户 Id 和课程 Id。建连后，会返回历史消息（历史消息此版本尚未实现）。

3. 调用 SDK 接口，发消息。

![WX20200604-182349@2x](/Users/howardchen/Documents/IM 技术文档 - 蓝天.assets/WX20200604-182349@2x.png)

# 服务端文档

## 接口

域名：cust-actionsky.csslcloud.net

### 开通房间

POST /v1/room-binding

消息体格式：

```javascript
{
  "roomId": ""
}
```

参数说明：

| 参数名 | 说明    | 取值范围 | 备注 |
| ------ | ------- | -------- | ---- |
| roomId | 房间 Id | 字符串   |      |

响应状态码为 200 时表示请求成功，其他状态码表示请求失败

请求成功时，消息体格式：

```javascript
{
  "roomId": "",
  "token": ""
}
```

字段说明：

| 字段名 | 说明    | 取值范围 | 备注                         |
| ------ | ------- | -------- | ---------------------------- |
| roomId | 房间 Id | 字符串   | 与请求消息体内的 roomId 相同 |
| token  | token   | 字符串   | 建立连接时需要携带此token    |

请求样例：

```shell
curl -H "Content-Type: application/json" -X POST -d '{"roomId":"666"}' "https://cust-actionsky.csslcloud.net/v1/room-binding"
```

# 客户端文档 - Web

## 1. 安装使用

安装

```plain
npm install cc-im-manager -S
```
引入
```plain
import CCIMManager from 'cc-im-manager'
```
## 2. 初始化

new CCIMManager后，只是创建im对象，并没有立即建立连接。

```plain
const im = new CCIMManager({
  token: 'xxx',
  userId: 'xxx'
})
```
| key | 备注 | 类型 | 是否必填   |
|:----|:----|:----|:----|
| token   | 绑定房间时分配的token   | string   | 是   |
| userId   | 客户端唯一标识   | string   | 是   |
| classId   | 课程Id   | string | 否 \| 直播开启后进入房间需要，用于获取历史消息   |

## 3. 建立连接

调用initCCIM方法，向服务端发起建立连接申请。该方法若被二次调用，将被认为是重新发起建立连接申请，原来的连接将被关闭，并重新建立连接

```plain
im.initCCIM()
```
## 4. 连接状态

若im对象上有对应的回调函数，在连接状态发生变化时，该回调将被执行

```plain
// 示例
im.connect = function () {
  // 连接成功时回调
}
im.connect_error = function (data) {
  // 连接错误时回调
}
im.connect = function (data) {
  // 断开连接时回调
}
im.reconnecting = function (data) {
  // 正在重连时回调
}
im.reconnect = function (data) {
  // 重连成功时回调
}
```
## 5. 广播消息

在建立连接成功后，调用 sendRoomMsg 可以发送广播数据，所有人都会收到且不记录

```plain
im.sendRoomMsg(content, function (data) {
  // 发送成功时回调
})
```
| key | 备注 | 类型   | 是否必填 |
|:----:|:----:|:----|:----:|
| content | 要发送的内容 | object \| string   | 是 |
| callback   | 发送成功的回调   | function   | 否   |
|    |    |    |    |

## 6. 单播/组播

在建立连接成功后，调用 sendCustomCommand 可以给指定用户发送数据

```plain
im.sendCustomCommand(content, users, function (data) {
  // 发送成功时回调
})
```
| key | 备注 | 类型 | 是否必填 |
|:----:|:----:|:----:|:----:|
| content | 要发送的内容 | string \| object | 是 |
| users   | 接收端的id   | string \| array   | 是   |
| callback | 发送成功的回调 | function | 否 |

## 7. 广播并存储

在建立连接成功后，调用 sendReliableMessage 可以发送广播数据，并且数据将会被服务端记录

```plain
im.sendReliableMessage(content, users, function (data) {
  // 发送成功时回调
})
```
| key | 备注 | 类型 | 是否必填 |
|:----:|:----:|:----:|:----|
| content | 要发送的内容 | string \| object | 是   |
| users   | 接收端的id   | string \| array   | 否   |
| callback | 发送成功的回调 | function | 否 |

## 8. 接收消息

在建立连接成功后，当接收端收到消息后，将会执行 onMessage 回调

```plain
im.onMessage = function (data) {
  // data即为接收端接收到的数据
}
```

# 客户端文档 - Android


## 0. 引用方式
```
 implementation 'com.bokecc:CCIMLib:0.1.0'//远程依赖
```

## 1. 实例化单例
```
单例对象：CCIMManager.getInstance()
```
## 2. 初始化建立链接
```
 public void initCCIM(String token, String userId, String classId)
```

## 3. IM链接状态
```
CCIMManager.getInstance().setSocketListener(new CCSocketListener() {
            @Override
            public void onConnect() {
              //链接成功
            }

            @Override
            public void onReconnect() {
             //重新成功
            }

            @Override
            public void onReconnecting() {
              //重新链接
            }

            @Override
            public void onDisconnect() {
             //断开链接
            }
        });
```
* 注意下面的方法要在 onConnect 链接成功后调用

## 4. 发布房间内广播
```
 /**
   * @param data  发送数据
   * @param ccRequestCallback 发送事件回调监听
   */
sendRoomMsg(String data, final CCRequestCallback ccRequestCallback)
```

## 5. 给指定用户组发送广播
```
/**
 * @param userIds   用户id数组
 * @param data      发送数据
 * @param ccRequestCallback 发送事件回调监听
 */
sendCustomCommand(List userIds, String data, final CCRequestCallback ccRequestCallback) 
```

## 6. 给指定用户组发送广播并存储
```
/**
  * @param userIds  用户id数组
  * @param data     发送数据
  * @param ccRequestCallback 发送事件回调监听
  */
sendReliableMessage(List userIds, String data, final CCRequestCallback ccRequestCallback) 

```
## 7. 收到房间内消息
```
/**
  * 监听房间的事件
  * @param ccimCallback
  */
setOnIMListener(final CCIMCallback ccimCallback)
```

## 8. 断开链接
```
release()
```

## 9. 设置课程id
```
setClassId(String classId)
```



# 客户端文档 - iOS

##实例化单例
```
[CCIMManager sharedIMManager];
```
## 初始化
```
/// 初始化房间信息并连接socket
/// @param token token
/// @param userId 客户端id
/// @param classId 课程id
- (void)initCCIM:(NSString *)token userId:(NSString *)userId classId:(NSString *)classId;
```

##设置课程id
```
///发布了需要存储消息时使用
- (void)setClassId:(NSString *)classId;
```

##发布房间内广播
```
/// 发送房间内广播
/// @param data 消息体
/// @param callBack 发送是否成功的回调
- (void)sendRoomMsg:(NSString *)data callBack:(CCRequestCallback)callBack;
```

##给指定用户组发送广播
```
/// 给指定用户组发送广播
/// @param userIds 要发送的用户id数组(为空则是房间内广播)
/// @param data 自定义消息体
/// @param callBack 发送是否成功的回调
- (void)sendCustomCommand:(NSArray *)userIds data:(NSString *)data callBack:(CCRequestCallback)callBack;
```

##给指定用户组发送广播并存储
```
/// 给指定用户组发送广播并存储
/// @param userIds 要发送的用户id数组(为空则是房间内广播)
/// @param data 自定义消息体
/// @param callBack 发送是否成功的回调
- (void)sendReliableMessage:(NSArray *)userIds data:(NSString *)data callBack:(CCRequestCallback)callBack;

```
##添加监听
```
/// 添加observer
/// @param observer 代理对象
- (void)setOnIMListener:(id<CCIMManagerDelegate>)observer;
```

##移除监听
```
/// 添加observer
/// @param observer 代理对象
- (void)removeOnIMListener:(id<CCIMManagerDelegate>)observer;
```

##收到房间内消息
```
/// 收到房间内消息
/// @param event 事件名
/// @param object 消息体
- (void)onImSocketReceive:(NSString *_Nonnull)event value:(id _Nullable )object;
```

## scoket连接失败
```
///socket连接失败
- (void)onFailed;
```

## socket连接成功
```
///socket连接成功
- (void)onSocketConnected;
```

## socket关闭
```
///socket关闭
- (void)onsocketClosed;
```

## socket连接关闭
```
///socket连接关闭
- (void)onconnectionClosed;
```

## scoket重连中
```
///scoket重连中
- (void)onsocketReconnectiong;
```

## scoket重连成功
```
///scoket重连成功
- (void)onSocketReconnected;
```

