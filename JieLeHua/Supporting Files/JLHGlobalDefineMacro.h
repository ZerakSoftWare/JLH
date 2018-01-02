//
//  JLHGlobalDefineMacro.h
//  JieLeHua
//
//  Created by kuang on 2017/3/27.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#ifndef JLHGlobalDefineMacro_h
#define JLHGlobalDefineMacro_h

//色值
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]


/** 主题色 */
#define kColor_Main_Color           RGB(13,136,255)

/** 品牌色(亮)(加50%白)*/
#define kColor_Main_Light_Color     RGB(134, 195, 255)

/** 品牌色(暗)(加10%黑)*/
#define kColor_Main_Black_Color     RGB(11, 122, 229)

/** 分割线颜色 */
#define kColor_SeparaterLine_Color  RGB(205,205,205)

/** 模块区域背景颜色 */
#define kColor_ViewBackground_Color RGB(241, 244, 246)

/** 按钮不可点击颜色 */
#define kColor_Disable_Color        RGB(170, 195, 226)

/** 按钮点击颜色 */
#define kColor_Highlighted_Color    RGB(9, 95, 179)

/** 警示/报错 */
#define kColor_Red_Color            RGB(204, 0, 0)

#pragma mark App 字体颜色设置

/** 大标题颜色 */
#define kColor_ImportantColor       RGB(0, 0, 0)

/** 标准颜色 */
#define kColor_TitleColor           RGB(51, 51, 51)

/** 用于次文本颜色 */
#define kColor_NormalColor          RGB(102, 102, 102)

/** 用于次次要文字颜色 */
#define kColor_TipColor             RGB(153, 153, 153)

#pragma mark App 字体设置

/** 用于导航栏标题，主按钮文字，输入框输入后文字 */
#define kFont_ImportantTitle        [UIFont systemFontOfSize:18]

/** 用于navigationItem */
#define kFont_BarButtonItem_Title        [UIFont systemFontOfSize:17]

/** 导航栏次要标题/关闭/返回，分类标题，列表标题 */
#define kFont_Title                 [UIFont systemFontOfSize:15]

/** 列表次要信息，长文本  */
#define kFont_NormalTitle           [UIFont systemFontOfSize:14]

/** 说明性文字，备注 */
#define kFont_TipTitle              [UIFont systemFontOfSize:12]


#endif /* JLHGlobalDefineMacro_h */
