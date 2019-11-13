//
//  LPK130M.h
//  LPK130M
//
//  Created by Marc Zhao on 16/7/09.
//  Copyright © 2016年 Marc Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LPK130M : NSObject

/**
 * 打印文本
 * @param str 要打印的字符串
 * @return 向打印机发送数据
 */

-(NSData *)printContent:(NSString *) str;

/**
 * 蜂鸣器响一声
 *
 * @return 向打印机发送数据
 */
-(NSData *)NFCP_printerBeep;

/**
 * 唤醒打印机 每次打印之前都要调用该函数，防止由于打印机进入低功耗模式而丢失数据
 *
 * @return 向打印机发送的数据
 */
-(NSData *)NFCP_printerWake;

/**
 * 打印字符串 将字符串数据放入打印缓冲区，当数据满一字符行，或接收到回车符时打印
 *
 * @param str 要打印的字符串
 * @return 向打印机发送的数据
 */
-(NSData *)NFCP_printStr:(NSString *) str;

/**
 * 打印字符串并换行 字符串数据发送后自动加回车，立即打印
 *
 * @param str 要打印的字符串
 * @return 向打印机发送的数据
 */
-(NSData *)NFCP_printStrLine:(NSString *) str;

/**
 * 把打印纸向前推进一行。
 *
 * @return 向打印机发送的数据
 */
-(NSData *)NFCP_printLF;

/**
 * 打印并回车
 *
 * @return 向打印机发送的数据
 */
-(NSData *)NFCP_printCR;

/**
 * 选择/取消双重打印模式
 *
 * @param op 0：取消 ；1:设置
 * @return 向打印机发送的数据
 */
-(NSData *)NFCP_setFontDouble:(int32_t) op;

/**
 * 选择/取消加粗模式
 *
 * @param op 0：取消；1：设置
 * @return 向打印机发送的数据
 */
-(NSData *)NFCP_setFontBold:(int32_t) op;

/**
 * 走纸到下页(黑标) 打印并换页，打印缓冲区中的数据全部打印出来并走纸到下一页
 * 该指令表明走纸到下一页，如果打印机定位方式设置为黑标模式，则该命令定位到黑标， 如果设置为缝隙模式，则该命令会定位到标签缝隙。
 * 如果打印纸张没有黑标，该命令执 行后，达到最大走纸距离即停止。
 *
 * @return 向打印机发送的数据
 */
-(NSData *) NFCP_feedToBlack;

/**
 * 设置下划线打印以及下划线的类型
 *
 * @param op 0：取消下划线；1：选择1点宽下划线；2：选择2点宽下划线
 * @return 向打印机发送的byte数组
 */
-(NSData *) NFCP_setUnderLine:(int32_t) op;

/**
 * 打印并走纸n点
 *
 * @param n 走纸长度n个打印点
 * @return 向打印机发送的数据
 */
-(NSData *) NFCP_feed:(int32_t) n;

/**
 * 设置行距
 *
 * @param distance 行距参数为distance个打印点
 * @return 向打印机发送的数据
 */
-(NSData *) NFCP_setLineSpace:(int32_t) distance;

/**
 * 设置绝对打印位置
 *
 * @param abspos 绝对位置参数，为目标位置距离本行起始位置的打印点个数
 * @return 向打印机发送的数据
 */
-(NSData *) NFCP_setAbsPosition:(int32_t) abspos;

/**
 * 设置横向相对打印位置
 *
 * @param relpos 相对位置参数
 * @return 向打印机发送的数据
 */
-(NSData *) NFCP_setRelPosition:(int32_t) relpos;

/**
 * 设置对齐打印方式
 *
 * @param snapMode 0：左对齐；1：居中； 2：右对齐
 * @return 向打印机发送的数据
 */
-(NSData *) NFCP_setSnapMode:(int32_t) snapMode;

/**
 * 选择/取消顺时针旋转
 *
 * @param op 0：取消旋转；1：顺时针90°旋转；2：顺时针180°旋转 ；3：顺时针270°旋转
 * @return 向打印机发送的byte数组
 */
-(NSData *) NFCP_setRotation:(int32_t) op;

/**
 * 设置左边距
 *
 * @param dot 左边距为dot个打印点
 * @return 向打印机发送的byte数组
 */
-(NSData *) NFCP_setLeftMargin:(int32_t) dot;

/**
 * 设置字符右间距
 *
 * @param dot 字符右间距为dot个打印点
 * @return 向打印机发送的数据
 */
-(NSData *) NFCP_setCharSpace:(int32_t) dot;

/**
 * 选择字体
 *
 * @param op 0：中文24*24点阵；1：中文16*16点阵；48：英文24*12点阵；49：英文16*8点阵
 * @return 向打印机发送的数据
 */
-(NSData *) NFCP_chooseFont:(int32_t) op;

/**
 * 设置字符大小
 *
 * @param height 纵向（高度）放大倍数 1 ：正常；2:2倍高
 * @param width  横向（宽度）放大倍数 1：正常；2:2倍宽
 * @return 向打印机发送的数据
 */
-(NSData *) NFCP_fontSizeHeight:(int32_t) height andWidth:(int32_t) width;

/**
 * 打印并向前走纸row字符行
 *
 * @param row 走纸row字符行
 * @return 向打印机发送的byte数组
 */
-(NSData *) NFCP_feedRow:(int32_t) row;

/**
 * 打印FLASH预存位图
 *
 * @param index 预存图片索引号，最大取值范围为1-5
 * @param mode  打印模式 0：正常直接打印；1：倍宽直接打印；2：倍高直接打印； 3：倍宽倍高直接打印；4：正常叠加打印
 * @return 向打印机发送的byte数组
 */
-(NSData *) NFCP_printPicInflashIndex:(int32_t) index andMode:(int32_t) mode;
/**
 * 一般模式下打印一维码
 *
 * @param str          要打印的内容
 * @param barType      一维码类型
 * @param heightDot    条码高度
 * @param HRI_location 条码的HRI字符打印位置 0：不打印；1：条码上方打印；2：条码下方打印；3：条码上、下方都打印
 */
-(NSData *) NFCP_drawBarCode:(NSString *) str andBarType:(int32_t)barType andHeightDot:(int32_t)heightDot
             andHRI_location:(int32_t)HRI_location;

/**
 * ESC/POS模式下打印二维码Qrcode
 *
 * @param Ver   DQCODE版本号
 * @param Level 纠错等级 0：纠错等级为L 1：纠错等级为M 2：纠错等级为Q 3：纠错等级为H
 * @param str   要打印的字符串
 */
-(NSData *)NFCP_printQRcode:(int32_t) Ver andLevel:(int32_t)Level andStr:(NSString *) str;

/**
 * 打印光栅位图
 *
 * @param bitmap 位图
 * @param mode   0：正常打印；1：倍宽打印；2：倍高打印； 3：倍宽倍高打印
 *横向取模 GS v 0 m xL xH yL yH d1...dk 打印光栅位图
 */
-(NSData *) NFCP_printBitmap:(NSString *)bmpName Mode:(int32_t) mode;

/**
 * 页模式下创建页面
 *
 * @param x 页面宽度
 * @param y 页面高度
 * @return 向打印机发送的byte数组
 */
-(NSData *) NFCP_createPageX:(int32_t) x andY:(int32_t) y;

/**
 * 页模式下打印页面
 *
 * @param horizontal 0:正常打印，不旋转；1：顺时针旋转90°后打印
 * @param skip       0：打印技术后不定位，直接停止；1：打印结束后定位到标签分割线，如果无缝隙，最大进纸30mm后停止
 * @return 向打印机发送的byte数组
 */
-(NSData *) NFCP_printPageHorizontal:(int32_t)horizontal andSkip:(int32_t) skip;

/**
 * 页模式下绘制线段
 *
 * @param w  线段宽度
 * @param sx 起始点横坐标
 * @param sy 起始点纵坐标
 * @param ex 结束点横坐标
 * @param ey 结束点纵坐标
 * @return 向打印机发送的byte数组
 */
-(NSData *) NFCP_Page_drawLineW:(int32_t) w andSx:(int32_t)sx andSy:(int32_t) sy anEx:(int) ex andEy:(int32_t) ey;

/**
 * 页模式下添加文本框
 *
 * @param x         起始横坐标
 * @param y         起始纵坐标
 * @param width     文本框宽度
 * @param height    文本框高度
 * @param str       字符串
 * @param fontsize  字体大小 1：16点阵；2：24点阵；3：32点阵；4：24点阵放大一倍；5：32点阵放大一倍
 *                  6：24点阵放大两倍；7：32点阵放大两倍；其他：24点阵
 * @param rotate    旋转角度 0：不旋转；1：90度；2：180°；3:270°
 * @param bold      是否粗体 0：取消；1：设置
 * @param underline 是有有下划线 false:没有；true：有
 * @param reverse   是否反白 false：不反白；true：反白
 * @return 向打印机发送的byte数组
 */
-(NSData *)NFCP_Page_setTextBox:(int32_t)x andY:(int32_t)y Width:(int32_t)width Height:(int32_t)height andStr:(NSString *)str Fontsize:(int32_t)fontsize Rotate:(int32_t)rotate Bold:(int32_t)bold Underline:(Boolean)underline Reverse:(int32_t)reverse;

/**
 * 页模式下文本框反显
 *
 * @param startx  起始横坐标
 * @param starty  起始纵坐标
 * @param endx    结束横坐标
 * @param endy    结束纵坐标
 * @param reverse 是否反白 false：不反白；true：反白
 * @return 向打印机发送的byte数组
 */
-(NSData *) NFCP_Page_Area_Reverse:(int32_t)startx startY:(int32_t)starty endX:(int32_t)endx endY:(int32_t)endy Reverse:(Boolean)reverse;


/**
 * 页模式下添加文字
 *
 * @param x         打印文字起始点横坐标
 * @param y         打印文字起始点纵坐标
 * @param str       打印的文字
 * @param fontsize  字体大小 1：16点阵；2：24点阵；3：32点阵；4：24点阵放大一倍；5：32点阵放大一倍
 *                  6：24点阵放大两倍；7：32点阵放大两倍；其他：24点阵
 * @param rotate    旋转角度 0：不旋转；1：90度；2：180°；3:270°
 * @param bold      是否粗体 0：取消；1：设置
 * @param underline 是有有下划线 false:没有；true：有
 * @param reverse   是否反白 false：不反白；true：反白
 * @return 向打印机发送的byte数组
 */
-(NSData *)NFCP_Page_setTextX:(int32_t)x andY:(int32_t)y andStr:(NSString *)str Fontsize:(int32_t)fontsize Rotate:(int32_t)rotate Bold:(int32_t)bold Underline:(Boolean)underline Reverse:(Boolean)reverse;

/**
 * 页模式下绘制宽度为2个打印点的线段
 *
 * @param sx 起始点横坐标
 * @param sy 起始点纵坐标
 * @param ex 结束点横坐标
 * @param ey 结束点纵坐标
 * @return 向打印机发送的byte数组
 */
-(NSData *) NFCP_Page_drawLineSx:(int32_t)sx andSy:(int32_t) sy andEx:(int32_t) ex andEy:(int32_t) ey;

/**
 * 页模式下绘制一维条码
 *
 * @param x           打印的起始横坐标
 * @param y           打印的起始纵坐标
 * @param str         字符串
 * @param barcodetype 条码类型
 *                    0：CODE39；1：CODE128；2：CODE93；3：CODEBAR；4：EAN8；5：EAN13；6：UPCA
 *                    ;7:UPC-E;8:ITF
 * @param rotate      旋转角度 0：不旋转；1：90度；2：180°；3:270°
 * @param barWidth    条码宽度
 * @param barHeight   条码高度
 */
-(NSData *)NFCP_Page_drawBarX:(int32_t)x andY:(int32_t)y andStr:(NSString *)str BarcodeType:(int32_t)barcodetype Rotate:(int32_t)rotate BarWidth:(int32_t)barWidth BarHeight:(int32_t)barHeight;

/**
 * 页模式下打印QRCode的函数
 *
 * @param x      打印的起始横坐标
 * @param y      打印的起始纵坐标
 * @param rotate 旋转角度 0：不旋转；1：90度；2：180°；3:270°
 * @param Ver    DQCODE版本号
 * @param lel    纠错等级 0：纠错等级为L 1：纠错等级为M 2：纠错等级为Q 3：纠错等级为H
 * @param Text   要打印的字符串
 */
-(NSData *)NFCP_Page_printQrCodeX:(int32_t)x andY:(int32_t)y Rotate:(int32_t) rotate andVer:(int32_t)Ver Lel:(int32_t)lel andStr:(NSString *)Text;

/**
 * 页模式下打印位图
 *
 * @param x      起始横坐标
 * @param y      起始纵坐标
 * @param bitmap 位图
 */
-(NSData *) NFCP_Page_printBitmapX:(int32_t)x andY:(int32_t)y Bitmap:(NSString *)bmpName;

-(Boolean) isnum:(Byte) ch;
-(Byte) seta2cA:(Byte)a andB:(Byte) b;


@end

