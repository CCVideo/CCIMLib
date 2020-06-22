//
//  ViewController.m
//  CCImDemo
//
//  Created by 刘强强 on 2020/6/2.
//  Copyright © 2020 刘强强. All rights reserved.
//

#import "ViewController.h"
//#import "CCIMManager.h"
#import <CCIMLib/CCIMLib.h>

@interface ViewController ()<CCIMManagerDelegate>

@property(nonatomic, strong)UIButton *socketBtn;

@property(nonatomic, strong)UIButton *sendMessage;

@property(nonatomic, strong)UIButton *sendCustomMessage;

@property(nonatomic, strong)UIButton *sendStoreMessage;

@property(nonatomic, strong)UIButton *getHistoryMessage;

@property(nonatomic, strong)UITextView *textView;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubview];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)setupSubview {
    self.socketBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 35)];
    [self.socketBtn setTitle:@"连接socket" forState:UIControlStateNormal];
    self.socketBtn.backgroundColor = [UIColor cyanColor];
    [self.socketBtn addTarget:self action:@selector(socketBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.socketBtn];
    
    self.sendMessage = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 100, 35)];
    [self.sendMessage setTitle:@"sendMessage" forState:UIControlStateNormal];
    self.sendMessage.backgroundColor = [UIColor cyanColor];
    [self.sendMessage addTarget:self action:@selector(sendMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendMessage];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 300)];
    
    [self.view addSubview:self.textView];
    
    
    self.sendCustomMessage = [[UIButton alloc] initWithFrame:CGRectMake(110, 200, 100, 35)];
    [self.sendCustomMessage setTitle:@"自定义消息" forState:UIControlStateNormal];
    self.sendCustomMessage.backgroundColor = [UIColor cyanColor];
    [self.sendCustomMessage addTarget:self action:@selector(sendCustomMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendCustomMessage];
    
    self.sendStoreMessage = [[UIButton alloc] initWithFrame:CGRectMake(110, 100, 100, 35)];
    [self.sendStoreMessage setTitle:@"存储消息" forState:UIControlStateNormal];
    self.sendStoreMessage.backgroundColor = [UIColor cyanColor];
    [self.sendStoreMessage addTarget:self action:@selector(sendStoreMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendStoreMessage];
    
    self.getHistoryMessage = [[UIButton alloc] initWithFrame:CGRectMake(220, 100, 100, 35)];
    [self.getHistoryMessage setTitle:@"历史消息" forState:UIControlStateNormal];
    self.getHistoryMessage.backgroundColor = [UIColor cyanColor];
    [self.getHistoryMessage addTarget:self action:@selector(getHistoryMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.getHistoryMessage];
    
    [[CCIMManager sharedIMManager] setOnIMListener:self];
    
}

- (void)socketBtnAction {
    [[CCIMManager sharedIMManager] initCCIM:@"eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3d3dy5ib2tlY2MuY29tLyIsInN1YiI6ImFjdGlvbnNreSIsImV4cCI6MTU5Mjg4MTkwMiwiY3VzdE5hbWUiOiJhY3Rpb25za3kiLCJjdXN0SWQiOiI1OTM4RjA0N0U1RjU2MkYwIiwicm9vbUlkIjoiNjY2NyJ9.svsvEI0w1PRUTe_5pgHY2ad9aW25zATuexcNKpigEBw" userId:@"lqq" classId:@"ccc" userName:@""  callBack:^(BOOL result, id  _Nullable data, NSError * _Nullable error) {
        
        NSLog(@"===initCCIM==%@  %@", error, data);
        self.textView.text = [NSString stringWithFormat:@"%@%@", data, error];
    }];
    
}

- (void)sendMessageAction {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"mes"] = @"1\\123";
    dic[@"type"] = @"type_lqq";
    [[CCIMManager sharedIMManager] sendRoomMsg:[self objcetToJsonStr:dic] callBack:^(BOOL result, NSError * _Nonnull error) {
        NSLog(@"==sendMessageAction===");
    }];
}

- (void)sendCustomMessageAction {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"mes"] = @"sendCustomMessageAction123";
    dic[@"type"] = @"type_lqq_cus";
    [[CCIMManager sharedIMManager] sendCustomCommand:@[@"hou", @"lqq"] data:[self objcetToJsonStr:dic] callBack:^(BOOL result, NSError * _Nonnull error) {
        NSLog(@"==sendCustomMessageAction===");
    }];
}

- (void)sendStoreMessageAction {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"mes"] = @"这是存储消息";
    dic[@"type"] = @"type_lqq_store";
    [[CCIMManager sharedIMManager] sendReliableMessage:@[] data:[self objcetToJsonStr:dic] callBack:^(BOOL result, NSError * _Nonnull error) {
        
        NSLog(@"==sendStoreMessageAction===");
    }];
}

- (void)getHistoryMessageAction {
    
    [[CCIMManager sharedIMManager] getHistoryMessage:@"ccc" types:@"type,type_lqq_store" callBack:^(BOOL result, id  _Nullable data, NSError * _Nullable error) {
            
        self.textView.text = [NSString stringWithFormat:@"getHistoryMessage=%@",data];
    }];
}

- (void)onFailed {
    self.textView.text = @"连接失败";
}

- (void)onSocketConnected {
    self.textView.text = @"连接成功";
    [self getHistoryMessageAction];
}

- (void)onImSocketReceive:(NSString *_Nonnull)event value:(id _Nullable )object {
    self.textView.text = [NSString stringWithFormat:@"====%@",object];
}

- (NSString *)objcetToJsonStr:(id)object
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

@end
