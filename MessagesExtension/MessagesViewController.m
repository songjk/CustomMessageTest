//
//  MessagesViewController.m
//  MessagesExtension
//
//  Created by mac on 16/10/9.
//  Copyright © 2016年 boyaa. All rights reserved.
//

#import "MessagesViewController.h"
#import "YLGIFImage.h"
#import "YLImageView.h"
#import "CollectionViewCell.h"
#define kGroup @"group.com.boyaa.texas-cn.sticker"
@interface MessagesViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *listView;
@property (nonatomic, strong) NSMutableArray * arryData;
@property (nonatomic, assign) NSInteger index;
@end
static NSString *const gifName = @"fish%d.gif";
static NSString *const nameWithOutGif = @"fish%ld";
@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self showGifImageWithYLImageView];
    self.arryData = [NSMutableArray array];
    for (int i = 1; i< 11; i++) {
        NSString * name = [NSString stringWithFormat:gifName, i];
        [self.arryData addObject:name];
    }
    self.listView.delegate = self;
    self.listView.dataSource = self;
    [self.listView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:cellId];
}
#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arryData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell * cell = [CollectionViewCell cellWithData:self.arryData[indexPath.row] collectView:collectionView indexPath:indexPath];
    return cell;
}
#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){90 ,90};
}

#pragma mark ---- UICollectionViewDelegate

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self createMesage:indexPath.row];
}
-(void)showGifImageWithWebView{
    //读取gif图片数据
    NSData *gifData = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"fish1" ofType:@"gif"]];
    //UIWebView生成
    UIWebView *imageWebView = [[UIWebView alloc] initWithFrame:CGRectMake(1, 1, 200, 200)];
    //用户不可交互
    imageWebView.userInteractionEnabled = YES;
    imageWebView.scrollView.scrollEnabled = NO;
    imageWebView.scalesPageToFit = YES;
    //加载gif数据
    [imageWebView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = imageWebView.bounds;
    [btn addTarget:self action:@selector(createMesage:) forControlEvents:UIControlEventTouchUpInside];
    [imageWebView addSubview:btn];
    //视图添加此gif控件
    [self.view addSubview:imageWebView];
}
-(void)showGifImageWithYLImageView{
    YLImageView* imageView = [[YLImageView alloc] initWithFrame:CGRectMake(1, 1, 150, 150)];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    imageView.image = [YLGIFImage imageNamed:@"fish1.gif"];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = imageView.bounds;
    [btn addTarget:self action:@selector(createMesage:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:btn];
}
- (void)createMesage:(NSInteger)index {
    NSString * name = [NSString stringWithFormat:nameWithOutGif, (index + 1)];
    NSString * path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
    NSURL * url = [NSURL fileURLWithPath:path];
    MSSticker * sticker = [[MSSticker alloc] initWithContentsOfFileURL:url localizedDescription:@"" error:nil];
    [self.activeConversation insertSticker:sticker completionHandler:^(NSError * _Nullable error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Conversation Handling

-(void)didBecomeActiveWithConversation:(MSConversation *)conversation {
    // Called when the extension is about to move from the inactive to active state.
    // This will happen when the extension is about to present UI.
    
    // Use this method to configure the extension and restore previously stored state.
}

-(void)willResignActiveWithConversation:(MSConversation *)conversation {
    // Called when the extension is about to move from the active to inactive state.
    // This will happen when the user dissmises the extension, changes to a different
    // conversation or quits Messages.
    
    // Use this method to release shared resources, save user data, invalidate timers,
    // and store enough state information to restore your extension to its current state
    // in case it is terminated later.
}

-(void)didReceiveMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when a message arrives that was generated by another instance of this
    // extension on a remote device.
    
    // Use this method to trigger UI updates in response to the message.
}
-(void)didSelectMessage:(MSMessage *)message conversation:(MSConversation *)conversation
{
    NSLog(@"didSelectMessage %@", self.activeConversation.selectedMessage.URL);
}
-(void)didStartSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when the user taps the send button.
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:kGroup];
    NSArray * arrData = [userDefaults objectForKey:@"sticker"];
    NSMutableArray *marray = nil;
    if(arrData)
    {
        marray = [[NSMutableArray alloc] initWithArray:arrData];
    }
    else
    {
        marray = [NSMutableArray array];
    }
    
    [marray addObject:[NSString stringWithFormat:@"EVENT_%zi",(self.index + 1)]];
    [userDefaults setObject:marray forKey:@"sticker"];
    [userDefaults synchronize];
}

-(void)didCancelSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when the user deletes the message without sending it.
    
    // Use this to clean up state related to the deleted message.
}

-(void)willTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    // Called before the extension transitions to a new presentation style.
    
    // Use this method to prepare for the change in presentation style.
}

-(void)didTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    // Called after the extension transitions to a new presentation style.
    
    // Use this method to finalize any behaviors associated with the change in presentation style.
}

@end
