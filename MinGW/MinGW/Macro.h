//
//  Macro.h
//  BDDProject
//
//  Created by songxin on 2019/6/19.
//  Copyright © 2019 songheng. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

extern void file(char *sourceFile,char *functionName,int lineNumber,NSString *format, ...);
extern NSString *unionID(void);

// ==================  宏定义  ==================== 
// iPhoneX 屏幕适配
#define TARGET_IPHONE_X           ([UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom > 0)

#define STATUS_BAR_HEIGHT         (TARGET_IPHONE_X ? 44 : 20)
#define NAV_BAR_HEIGHT            (STATUS_BAR_HEIGHT + 44)
#define STATUS_BAR_TOP_MARGIN     (TARGET_IPHONE_X ? 24 : 0)
#define TOP_ESTIMATED_MARGIN      (TARGET_IPHONE_X ? 30 : 0)
#define STATUS_BAR_HEIGHT_ONLY_X  (TARGET_IPHONE_X ? 44 : 0)

#define TAB_BAR_HEIGHT            (TARGET_IPHONE_X ? 83 : 49)
#define TAB_BAR_BOTTOM_MARGIN     (TARGET_IPHONE_X ? 34 : 0)

/**
 *   屏幕 宽高
 */
#define SCREEN_SIZE         [UIScreen mainScreen].bounds.size
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define STT_OnePointHeight  (1/[UIScreen mainScreen].scale)
#define SCREEN_SIZE_MIN     MIN(SCREEN_HEIGHT,SCREEN_WIDTH)
#define SCREEN_SIZE_MAX     MAX(SCREEN_HEIGHT,SCREEN_WIDTH)

/**
 *  color - ios10使用sRGB
 */

#define RGBA(r,g,b,a)           [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define ColorWithHex(str)       [UIColor colorWithRed:((float)((str & 0xFF0000) >> 16))/255.0 green:((float)((str & 0xFF00) >> 8))/255.0 blue:((float)(str & 0xFF))/255.0 alpha:1.0]

#define RandomColor           RGBA((arc4random()%256), (arc4random()%256), (arc4random()%256), 1)
#define ColorWithHexA(str,a)  [ColorWithHex(str) colorWithAlphaComponent:a]

#define APPConfig(kIdentifier)  [[[NSBundle mainBundle] infoDictionary] objectForKey:kIdentifier]

// 主题色
#define COLOR_MAIN ColorWithHex(0x402761)

// 外挂字体
#define FONT_Digit(a) [UIFont fontWithName:@"Bahnschrift" size:a]
#define FONT_System(a) [UIFont systemFontOfSize:a]


#define DEGREES_TO_RADOANS(x) (M_PI * (x) / 180.0)
#define suitWidth(width) width * SCREEN_WIDTH/375
#define suitHeight(height) height * SCREEN_HEIGHT/667

/**
 *  weakSelf/strongSelf
 */
#define WEAK_Self   __weak typeof(self)weakSelf = self;
#define STRONG_Self   __strong typeof(weakSelf)strongSelf = weakSelf;

#define STRONG_Self_AutoReturn   __strong typeof(weakSelf)strongSelf = weakSelf;\
if (!strongSelf) { return ;}

#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kUserDefault ([NSUserDefaults standardUserDefaults])

#if BDDDEBUG == 0
#define STTLog(s, ...) file(__FILE__,(char *)__FUNCTION__,__LINE__,(s),##__VA_ARGS__)
#else
#define STTLog(s, ...)
#endif

/**
 *  BLOCK _ _EXEC
 */
#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


#define SCREENWitdh_LessOrEquel320 ([UIScreen mainScreen].bounds.size.width <= 320)
#define SCREENWitdh_Equel375 ([UIScreen mainScreen].bounds.size.width == 375)

#define FontSizeOnMarkTipsItem        (SCREENWitdh_LessOrEquel320 ?11:(SCREENWitdh_Equel375 ?12:13))
#define FontSizeDefault    (SCREENWitdh_LessOrEquel320 ?16:(SCREENWitdh_Equel375 ?17:18))

#define FontSizeSmall      (SCREENWitdh_LessOrEquel320 ?15:(SCREENWitdh_Equel375 ?16:17))
#define FontSizeNormal     (SCREENWitdh_LessOrEquel320 ?18:(SCREENWitdh_Equel375 ?19:20))
#define FontSizeBig        (SCREENWitdh_LessOrEquel320 ?19:(SCREENWitdh_Equel375 ?20:21))
#define FontSizeVeryBig    (SCREENWitdh_LessOrEquel320 ?21:(SCREENWitdh_Equel375 ?22:23))
#define FontSizeOnShortVideoCell      (SCREENWitdh_LessOrEquel320 ?12:(SCREENWitdh_Equel375 ?13:14))

//是否为iPhone5系列机型
#ifndef iPhone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

// UI设计图尺寸 变换用
#define STTRATIO(a)   ceilf(a / 375.0 * SCREEN_SIZE_MIN)
#define ImageWitdhToHeightRatio (3/2.0)
#define VideoImageWidthToHeightRatio (16/9.0)
#define ImageWitdhToScreenWitdhRatio (112/375.0)
//布局适配
#define LayoutWidth(value)  STTRATIO(value)
//使用可视高度
#define LayoutHeight(value) roundf(value / 667.0 * (SCREEN_SIZE_MAX-TAB_BAR_BOTTOM_MARGIN-STATUS_BAR_HEIGHT_ONLY_X))
#define LayoutHorizontalMargin(value)  STTRATIO(value)
#define LayoutVerticalMargin(value) roundf(value / 667.0 * (SCREEN_SIZE_MAX-TAB_BAR_BOTTOM_MARGIN-STATUS_BAR_HEIGHT_ONLY_X))

#define ScaleHeight(X) (X*SCREEN_WIDTH/375.0)

#define RATIO_Height(x) (x*SCREEN_HEIGHT/812)
#define StringFormat(format, ...) [NSString stringWithFormat:format, ##__VA_ARGS__]
#define ImageName(p) [UIImage imageNamed:p]


/**
 *  statueBarNetWork state
 */
#define NETWORK_Active_YES  [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
#define NETWORK_Active_NO   [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

#define kNSUserDefaults [NSUserDefaults standardUserDefaults]

#define Qid       [XMInfoUtil nomalQID]
#define app_Qid   [XMInfoUtil appQID]
#define app_Type  @"100001"
#define app_Name  @"100001"
#define app_Ver   XMInfo.os_version()
#define app_TypeId @"100001"

#define HeightRatio(x) (x*SCREEN_HEIGHT/667.0)
#define WidthRatio(x) (x*SCREEN_WIDTH/667.0)
//屏幕宽度等比例计算实际高度
#define SacleRatioHeight(ratio) (ratio*SCREEN_WIDTH)   //ratio  真实（Height/Width）
///中间按钮的间距
#define SpecialSpace 30
// 标记暂时不请求、展示插屏
#endif /* Macro_h */
