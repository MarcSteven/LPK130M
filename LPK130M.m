//
//  LPK130M.m
//  LPK130M
//
//  Created by Marc Zhao on 16/7/09.
//  Copyright © 2016年 Marc Zhao. All rights reserved.
//

#import "LPK130M.h"
#import <stdio.h>
/**
 * 该类是针对LPK130系列打印机定义的打印机类。该类包含几乎所有的打印机功能的实现，用户只要在原有的应用基础上声明一个打印机的类
 * 即可利用该类中丰富的方法实现对打印机的控制，快捷方便的打印。
 */

@implementation LPK130M

/**
 * 打印文本
 * @param str 要打印的字符串
 * @return 向打印机发送数据
 */
-(NSData *)printContent:(NSString *) str{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* sendData = [str dataUsingEncoding:encoding];
    return sendData;
}

/**
 * 蜂鸣器响一声
 *
 * @return 向打印机发送数据
 */

-(NSData *) NFCP_printerBeep{
    Byte arrayOfByte[1] = {0x07};
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:1];
    return sendData;
}

/**
 * 唤醒打印机 每次打印之前都要调用该函数，防止由于打印机进入低功耗模式而丢失数据
 *
 * @return 向打印机发送的数据
 */

-(NSData *)NFCP_printerWake{
    Byte arrayOfByte[6] = {0x00,0x00,0x00,0x00,0x00,0x00};
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:6];
    return sendData;
}

/**
 * 打印字符串 将字符串数据放入打印缓冲区，当数据满一字符行，或接收到回车符时打印
 *
 * @param str 要打印的字符串
 * @return 向打印机发送的数据
 */

-(NSData *)NFCP_printStr:(NSString *) str{
    return [self printContent:str];
}

/**
 * 打印字符串并换行 字符串数据发送后自动加回车，立即打印
 *
 * @param str 要打印的字符串
 * @return 向打印机发送的数据
 */

-(NSData *)NFCP_printStrLine:(NSString *) str{
    NSArray *array = [NSArray arrayWithObjects:str,@"\r\n",nil];
    NSString *string = [array componentsJoinedByString:@""];
    return [self printContent:string];
    
}
/**
 * 把打印纸向前推进一行。
 *
 * @return 向打印机发送的数据
 */

-(NSData *)NFCP_printLF{
    Byte arrayOfByte[1] = {0x0A};
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:1];
    return sendData;
}
/**
 * 打印并回车
 *
 * @return 向打印机发送的数据
 */
-(NSData *)NFCP_printCR{
    Byte arrayOfByte[2] = {0x0A, 0x0D};
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:2];
    return sendData;
}

/**
 * 选择/取消双重打印模式
 *
 * @param op 0：取消 ；1:设置
 * @return 向打印机发送的数据
 */

-(NSData *)NFCP_setFontDouble:(int32_t) op{
    Byte arrayOfByte[3] = {0x1B, 0x47, (Byte) op};
    if ((op != 1) && (op != 0))
        arrayOfByte[2] = 0x00;
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:3];
    return sendData;
}

/**
 * 选择/取消加粗模式
 *
 * @param op 0：取消；1：设置
 * @return 向打印机发送的数据
 */

-(NSData *)NFCP_setFontBold:(int32_t) op{
    Byte arrayOfByte[3] = {0x1B, 0x45, (Byte) op};
    if ((op != 1) && (op != 0))
        arrayOfByte[2] = 0x00;
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:3];
    return sendData;
}

/**
 * 设置下划线打印以及下划线的类型
 *
 * @param op 0：取消下划线；1：选择1点宽下划线；2：选择2点宽下划线
 * @return 向打印机发送的byte数组
 */

-(NSData *) NFCP_setUnderLine:(int32_t) op{
    if (op <= 2 && op >= 0) {
        Byte arrayOfByte[3] = {0x1B, 0x2D, (Byte) op};
        NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:3];
        return sendData;
    }
    return nil;
}

/**
 * 走纸到下页(黑标) 打印并换页，打印缓冲区中的数据全部打印出来并走纸到下一页
 * 该指令表明走纸到下一页，如果打印机定位方式设置为黑标模式，则该命令定位到黑标， 如果设置为缝隙模式，则该命令会定位到标签缝隙。
 * 如果打印纸张没有黑标，该命令执 行后，达到最大走纸距离即停止。
 *
 * @return 向打印机发送的数据
 */
-(NSData *) NFCP_feedToBlack{
    Byte arrayOfByte[1]= {0x0C};
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:1];
    return sendData;
}

/**
 * 打印并走纸n点
 *
 * @param n 走纸长度n个打印点
 * @return 向打印机发送的数据
 */

-(NSData *) NFCP_feed:(int32_t) n{
    Byte arrayOfByte[3] = {0x1B, 0x4A, (Byte) n};
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:3];
    return sendData;
}

/**
 * 设置行距
 *
 * @param distance 行距参数为distance个打印点
 * @return 向打印机发送的数据
 */

-(NSData *) NFCP_setLineSpace:(int32_t) distance {
    Byte arrayOfByte[3] = {0x1B, 0x33, (Byte) distance};
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:3];
    return sendData;
}

/**
 * 设置绝对打印位置
 *
 * @param abspos 绝对位置参数，为目标位置距离本行起始位置的打印点个数
 * @return 向打印机发送的数据
 */

-(NSData *) NFCP_setAbsPosition:(int32_t) abspos {
    Byte arrayOfByte[4] = {0x1B, 0x24, (Byte)(abspos % 256),
        (Byte) (abspos / 256)};
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:4];
    return sendData;
}

/**
 * 设置横向相对打印位置
 *
 * @param relpos 相对位置参数
 * @return 向打印机发送的数据
 */

-(NSData *) NFCP_setRelPosition:(int32_t) relpos {
    Byte arrayOfByte[4]= {0x1B, 0x5C, (Byte)(relpos % 256),
        (Byte)(relpos / 256)};
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:4];
    return sendData;}

/**
 * 设置对齐打印方式
 *
 * @param snapMode 0：左对齐；1：居中； 2：右对齐
 * @return 向打印机发送的数据
 */

-(NSData *) NFCP_setSnapMode:(int32_t) snapMode {
    if (snapMode <= 2 && snapMode >= 0) {
        Byte arrayOfByte[3]  = {0x1B, 0x61, (Byte) snapMode};
        NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:3];
        return sendData;    }
    return nil;
}

/**
 * 选择/取消顺时针旋转
 *
 * @param op 0：取消旋转；1：顺时针90°旋转；2：顺时针180°旋转 ；3：顺时针270°旋转
 * @return 向打印机发送的byte数组
 */

-(NSData *) NFCP_setRotation:(int32_t) op {
    Byte arrayOfByte[3] = {0x1B, 0x56, 0};
    if (op < 0 || op > 3) {
        op = 0;
    }
    arrayOfByte[2] = (Byte) op;
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:3];
    return sendData;
}

/**
 * 设置左边距
 *
 * @param dot 左边距为dot个打印点
 * @return 向打印机发送的byte数组
 */

-(NSData *) NFCP_setLeftMargin:(int32_t) dot {
    Byte arrayOfByte[4] = {0x1D, 0x4C, (Byte) (dot % 256 ),
        (Byte) (dot / 256)};
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:4];
    return sendData;
}

/**
 * 设置字符右间距
 *
 * @param dot 字符右间距为dot个打印点
 * @return 向打印机发送的数据
 */

-(NSData *) NFCP_setCharSpace:(int32_t) dot {
    Byte arrayOfByte[3] = {0x1B, 0x20, (Byte) dot};
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:3];
    return sendData;
}

/**
 * 选择字体
 *
 * @param op 0：中文24*24点阵；1：中文16*16点阵；48：英文24*12点阵；49：英文16*8点阵
 * @return 向打印机发送的数据
 */

-(NSData *) NFCP_chooseFont:(int32_t) op {
    if ((op != 1) && (op != 0) && (op != 48) && (op != 49))
        return nil;
    Byte arrayOfByte[3] = {0x1B, 0x4D, (Byte) op};
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:3];
    return sendData;
}

/**
 * 设置字符大小
 *
 * @param height 纵向（高度）放大倍数 1 ：正常；2:2倍高
 * @param width  横向（宽度）放大倍数 1：正常；2:2倍宽
 * @return 向打印机发送的数据
 */

-(NSData *) NFCP_fontSizeHeight:(int32_t) height andWidth:(int32_t) width {
    if ((height > 2) || (width > 2)) {
        return nil;
    }
    Byte arrayOfByte[3] = {0x1D, 0x21,
        (Byte) ((width - 1) * 16 + height - 1)};
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:3];
    return sendData;
    
}

/**
 * 打印并向前走纸row字符行
 *
 * @param row 走纸row字符行
 * @return 向打印机发送的byte数组
 */

-(NSData *) NFCP_feedRow:(int32_t) row {
    Byte arrayOfByte[3] = {0x1B, 0x64, (Byte) row};
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:3];
    return sendData;
}

/**
 * 打印FLASH预存位图
 *
 * @param index 预存图片索引号，最大取值范围为1-5
 * @param mode  打印模式 0：正常直接打印；1：倍宽直接打印；2：倍高直接打印； 3：倍宽倍高直接打印；4：正常叠加打印
 * @return 向打印机发送的byte数组
 */

-(NSData *) NFCP_printPicInflashIndex:(int32_t) index andMode:(int32_t) mode {
    if ((index > 5) || (index < 1)) {
        return nil;
    }
    Byte data_logo[4] = {0x1C, 0x70, (Byte) index, (Byte) mode};
    if (mode < 0 || mode > 4)
        data_logo[3] = (Byte) mode;
    NSData *sendData = [[NSData alloc] initWithBytes:data_logo length:4];
    return sendData;
}

/**
 * 一般模式下打印一维码
 *
 * @param str          要打印的内容
 * @param barType      一维码类型
 * @param heightDot    条码高度
 * @param HRI_location 条码的HRI字符打印位置 0：不打印；1：条码上方打印；2：条码下方打印；3：条码上、下方都打印
 */

-(NSData *) NFCP_drawBarCode:(NSString *) str andBarType:(int32_t)barType andHeightDot:(int32_t)heightDot
             andHRI_location:(int32_t)HRI_location {
    
    NSMutableData *sendData=[[NSMutableData alloc]init];
    
    if (HRI_location > 3 || HRI_location < 0) {
        HRI_location = 2;
    }
    int32_t bType;
    switch (barType) {
        case 0: // code39
            bType = 69;
            break;
        case 1: // code128
            bType = 73;
            break;
        case 2: // code93
            bType = 72;
            break;
        case 3: // codebar
            bType = 71;
            break;
        case 4: // ean8
            bType = 68;
            break;
        case 5: // ean13
            bType = 67;
            break;
        case 6: // UPC-A
            bType = 65;
            break;
        case 7:// UPC-E
            bType = 66;
            break;
        case 8:// ITF
            bType = 70;
            break;
        default:
            bType = 73;
            break;
    }
    Byte barHeightCommand[3] = {0x1d, 0x68, (Byte) heightDot};// 设置条码高度
    Byte barWidthCommand[3] = {0x1d, 0x48, (Byte) HRI_location};// 设置HRI字符打印位置
    Byte barTypeCommand[3] = {0x1d, 0x6B, (Byte) bType};
    
    [sendData appendBytes:barHeightCommand length:3];
    [sendData appendBytes:barWidthCommand length:3];
    [sendData appendBytes:barTypeCommand length:3];
    
    
    
    int32_t i = 0;
    Byte data[512+1] = {0};
    NSData * tempData = [self printContent:str];
    Byte *temp = (Byte *)[tempData bytes];
    //    int strLen = [temp length];
    int strLen = [tempData length];
    
    if (barType == 1)// code128需要转码，其他直接打印
    {
        // 自动适配最优字符集
        Byte budf[256] = {0x00};
        Byte index = 0;
        Byte curset;
        
        if (strLen <= 4) {
            // 四个以内字符，直接使用A集
            curset = 'A';
            budf[index++] = 123;
            budf[index++] = 65;
            
            for (i = 0; i < strLen; i++) {
                budf[index++] = temp[i];
            }
        } else {
            i = 0;
            
            // 判断首四个字节是否都为数字
            if ([self isnum:temp[0]] && [self isnum:temp[1]] && [self isnum:temp[2]]
                && [self isnum:temp[3]]) {
                
                // 首四字节为数字，使用字符集C
                curset = 'C';
                budf[index++] = 123;
                budf[index++] = 67;
                
                // 填充四个首字符
                budf[index++] = [self seta2cA:temp[0] andB:temp[1]];
                budf[index++] = [self seta2cA:temp[2] andB:temp[3]];
                i += 4;
            } else {
                // 使用字符集A
                curset = 'A';
                budf[index++] = 123;
                budf[index++] = 65;
                
                // 第一个字节使用字符集A
                budf[index++] = temp[0];
                i += 1;
            }
            
            // 遍历后续字节
            while (i < strLen) {
                if ((strLen - i) == 1)// 判断剩余字节数
                {
                    // 剩余一个字节，必须使用字符集A
                    if (curset == 'A') {
                        budf[index++] = temp[i];
                        i += 1;
                    } else {
                        curset = 'A';
                        budf[index++] = 123;
                        budf[index++] = 65;
                        budf[index++] = temp[i];
                        i += 1;
                    }
                } else if ((strLen - i) == 2) {
                    // 剩余两个字节，按照当前字符集执行
                    if (curset == 'A') {
                        budf[index++] = temp[i];
                        budf[index++] = temp[i + 1];
                        i += 2;
                    } else {
                        if ([self isnum:temp[i]] && [self isnum:temp[i+1]]) {
                            budf[index++] = [self seta2cA:temp[i] andB:temp[i + 1]];
                            i += 2;
                        } else {
                            curset = 'A';
                            budf[index++] = 123;
                            budf[index++] = 65;
                            
                            budf[index++] = temp[i];
                            budf[index++] = temp[i + 1];
                            i += 2;
                        }
                    }
                } else if ((strLen - i) == 3) {
                    if (curset == 'A') {
                        budf[index++] = temp[i];
                        budf[index++] = temp[i + 1];
                        i += 2;
                    } else {
                        if ([self isnum:temp[i]] && [self isnum:temp[i+1]]) {
                            budf[index++] = [self seta2cA:temp[i] andB:temp[i + 1]];
                            i += 2;
                        } else {
                            curset = 'A';
                            budf[index++] = 123;
                            budf[index++] = 65;
                            
                            budf[index++] = temp[i];
                            i += 1;
                        }
                    }
                } else {
                    // 剩余超过四个
                    if (curset == 'A') {
                        if ([self isnum:temp[i]] && [self isnum:temp[i+1]]
                            && [self isnum:temp[i+2]]
                            && [self isnum:temp[i+3]]) {
                            // 连续四个数字，可以转换字符集C
                            curset = 'C';
                            budf[index++] = 123;
                            budf[index++] = 67;
                            
                            budf[index++] = [self seta2cA:temp[i] andB:temp[i + 1]];
                            budf[index++] = [self seta2cA:temp[i+2] andB:temp[i + 3]];
                            
                            i += 4;
                        } else {
                            budf[index++] = temp[i];
                            
                            i += 1;
                        }
                    } else {
                        if ([self isnum:temp[i]] && [self isnum:temp[i+1]]) {
                            budf[index++] = [self seta2cA:temp[i] andB:temp[i + 1]];
                            
                            i += 2;
                        } else {
                            curset = 'A';
                            budf[index++] = 123;
                            budf[index++] = 65;
                            budf[index++] = temp[i];
                            i += 1;
                        }
                    }
                    
                }
            }
        }
        
        data[0] = index;
        for (i = 0; i < index; i++) {
            data[1 + i] = budf[i];
            
        }
        
        [sendData appendBytes:data length:(index+1)];
        return sendData;
        
    } else {
        
        data[0] = (Byte) strLen;
        for (i = 0; i < strLen; i++) {
            data[1 + i] = temp[i];
        }
        
        [sendData appendBytes:data length:(strLen+1)];
        return sendData;
    }
    
}


-(Boolean) isnum:(Byte) ch{
    if ((ch >= '0') && (ch <= '9')) {
        return YES;
    }
    return NO;
}

-(Byte) seta2cA:(Byte)a andB:(Byte) b{
    return (Byte) ((a - '0') * 10 + (b - '0'));
}

/**
 * ESC/POS模式下打印二维码Qrcode
 *
 * @param Ver   DQCODE版本号
 * @param Level 纠错等级 0：纠错等级为L 1：纠错等级为M 2：纠错等级为Q 3：纠错等级为H
 * @param str   要打印的字符串
 */
-(NSData *)NFCP_printQRcode:(int32_t) Ver andLevel:(int32_t)Level andStr:(NSString *) str{
    if (Ver > 20) {
        return nil;// ER_COMMRANGE;
    }
    if (Level > 3) {
        return nil;// ER_COMMRANGE;
    }
    
    NSMutableData *sendData=[[NSMutableData alloc]init];
    
    
    NSData* tempData = [self printContent:str];
    //    Byte *temp = (Byte *)[tempData bytes];
    //    int32_t len = [temp length];
    int32_t len = [tempData length];
    
    Byte aCmdBuf[6]= {0x1D, 0x6C, (Byte) Ver, (Byte) Level,
        (Byte) (len % 256), (Byte) (len / 256)};
    
    [sendData appendBytes:aCmdBuf length:6];
    [sendData appendData:tempData];
    
    return sendData;
    
}

/**
 * 打印光栅位图
 *
 * @param bitmap 位图
 * @param mode   0：正常打印；1：倍宽打印；2：倍高打印； 3：倍宽倍高打印
 *横向取模 GS v 0 m xL xH yL yH d1...dk 打印光栅位图
 */
-(NSData *) NFCP_printBitmap:(NSString *)bmpName Mode:(int32_t) mode{
    
    UIImage* image=[UIImage imageNamed:bmpName];
    CGImageRef temImg = image.CGImage;
    int32_t width = CGImageGetWidth(temImg);
    int32_t height = CGImageGetHeight(temImg);
    
    int LineByte = (width/8+3)/4*4;
    
    Byte *imageData  = (Byte *)malloc(LineByte*width*sizeof(Byte));
    memset(imageData, 0, LineByte*width);
    
    NSString *itemPath = bmpName;
    NSArray *aArray = [itemPath componentsSeparatedByString:@"."];
    NSString *filename = [aArray objectAtIndex:0];
    NSString *sufix = [aArray objectAtIndex:1];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:filename ofType:sufix];
    FILE *fp = fopen([imagePath cStringUsingEncoding:NSMacOSRomanStringEncoding],"rb");
    fseek(fp,62,0);
    fread(imageData,LineByte*height,1,fp);
    fclose(fp);
    //    for(int i=0;i<LineByte*height;i++)
    //        NSLog(@"%dtestByte = %d\n",i,imageData[i]);
    
    Byte m = (Byte) mode;
    if (m < 0 || m > 3) {
        m = 0;
    }
    
    Byte data[8]= {};
    data[0] = 0x1d;
    data[1] = 0x76;
    data[2] = 0x30;
    data[3] = m;
    data[4] = (Byte) (LineByte % 256);
    data[5] = (Byte) (LineByte / 256);
    data[6] = (Byte) (height % 256);
    data[7] = (Byte) (height / 256);
    
    NSMutableData *sendData = [[NSMutableData alloc] init];
    [sendData appendBytes:data length:8];
    
    Byte temp[1] = {};
    
    // 循环高
    for (int32_t i = height -1; i >= 0; i--) {
        // 循环宽度
        for (int32_t j = 0; j < LineByte; j++) {
            
            temp[0] = 0;
            int32_t pixelByte = imageData[j+ i * LineByte];
            if(j < width/8){
                temp[0] = (Byte)(255 - pixelByte);
            }else if(j == width/8){
                for(int k = 0;k < 8;k++){
                    if(j * 8 + k < width){
                        int tempBit = (pixelByte >> (7-k))&0x01;
                        if(tempBit == 0)
                            temp[0] |= (Byte) (128 >> k);
                    }
                }
            }else{
                temp[0] = (Byte)(pixelByte);
            }
            
            [sendData appendBytes:temp length:1];
            
        }
    }
    return sendData;
}

/**
 * 页模式下创建页面
 *
 * @param x 页面宽度
 * @param y 页面高度
 * @return 向打印机发送的byte数组
 */

-(NSData *) NFCP_createPageX:(int32_t) x andY:(int32_t) y {
    Byte arrayOfByte[8] = {0x1C, 0x4C, 0x70, (Byte) (x % 256),
        (Byte) (x / 256), (Byte) (y % 256), (Byte) (y / 256), 0x00};
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:8];
    return sendData;
}

/**
 * 页模式下打印页面
 *
 * @param horizontal 0:正常打印，不旋转；1：顺时针旋转90°后打印
 * @param skip       0：打印技术后不定位，直接停止；1：打印结束后定位到标签分割线，如果无缝隙，最大进纸30mm后停止
 * @return 向打印机发送的byte数组
 */

-(NSData *) NFCP_printPageHorizontal:(int32_t)horizontal andSkip:(int32_t) skip {
    Byte arrayOfByte[7] = {0x1C, 0x4C, 0x6F, (Byte) horizontal,
        (Byte) skip, 0x00, 0x00};
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:7];
    return sendData;
}

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

-(NSData *) NFCP_Page_drawLineW:(int32_t) w andSx:(int32_t)sx andSy:(int32_t) sy anEx:(int32_t) ex andEy:(int32_t) ey {
    Byte arrayOfByte[13] = {0x1C, 0x4C, 0x6c, (Byte) w, 0x01,
        (Byte) (sx % 256), (Byte) (sx / 256), (Byte) (sy % 256),
        (Byte) (sy / 256), (Byte) (ex % 256), (Byte) (ex / 256),
        (Byte) (ey % 256), (Byte) (ey / 256)};
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:13];
    return sendData;
}

/**
 * 页模式下绘制宽度为2个打印点的线段
 *
 * @param sx 起始点横坐标
 * @param sy 起始点纵坐标
 * @param ex 结束点横坐标
 * @param ey 结束点纵坐标
 * @return 向打印机发送的byte数组
 */

-(NSData *) NFCP_Page_drawLineSx:(int32_t)sx andSy:(int32_t) sy andEx:(int32_t) ex andEy:(int32_t) ey {
    Byte arrayOfByte[] = {0x1C, 0x4C, 0x6c, 0X02, 0x01,
        (Byte) (sx % 256), (Byte) (sx / 256), (Byte) (sy % 256),
        (Byte) (sy / 256), (Byte) (ex % 256), (Byte) (ex / 256),
        (Byte) (ey % 256), (Byte) (ey / 256)};
    NSData *sendData = [[NSData alloc] initWithBytes:arrayOfByte length:13];
    return sendData;
}

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
-(NSData *)NFCP_Page_setTextBox:(int32_t)x andY:(int32_t)y Width:(int32_t)width Height:(int32_t)height andStr:(NSString *)str Fontsize:(int32_t)fontsize Rotate:(int32_t)rotate Bold:(int32_t)bold Underline:(Boolean)underline Reverse:(int32_t)reverse{
    Byte tem1 = 0;
    Byte tem2 = 0;
    Byte data[13] = {0x1c, 0x4c, 0x54, (Byte) (x % 256), (Byte) (x / 256),
        (Byte) (y % 256), (Byte) (y / 256), (Byte) (width % 256),
        (Byte) (width / 256), (Byte) (height % 256),
        (Byte) (height / 256), 0, 0};
    
    NSMutableData *sendData=[[NSMutableData alloc]init];
    
    if (fontsize == 1) {
        tem1 |= 0x10;// 16点阵
    } else if (fontsize == 2) {
        tem1 |= 0x00;// 24点阵
    } else if (fontsize == 3) {
        tem1 |= 0x20;// 32点阵
    } else if (fontsize == 4)// 24点阵放大一倍
    {
        tem1 |= 0x00;
        tem2 |= 0x0A;
    } else if (fontsize == 5)// 32点阵放大一倍
    {
        tem1 |= 0x20;
        tem2 |= 0x0A;
    } else if (fontsize == 6)// 24点阵放大两倍
    {
        tem1 |= 0x00;
        tem2 |= 0x0F;
    } else if (fontsize == 7)// 32点阵放大两倍
    {
        tem1 |= 0x20;
        tem2 |= 0x0F;
    } else {
        tem1 |= 0x00;//  24点阵
    }
    
    if (rotate == 0) {
        tem2 |= 0x00;
    } else if (rotate == 1) {
        tem2 |= 0x40;
    } else if (rotate == 2) {
        tem2 |= 0x80;
    } else if (rotate == 3) {
        tem2 |= 0xC0;
    } else {
        tem2 |= 0x00;
    }
    
    if (bold != 0) {
        tem1 |= 0x02;
    }
    
    if (underline) {
        tem1 |= 0x01;
    }
    
    if (reverse) {
        tem1 |= 0x04;
    }
    
    data[11] = tem1;
    data[12] = tem2;
    
    [sendData appendBytes:data length:13];
    NSData *temp = [self printContent:str];
    [sendData appendData:temp];
    Byte a[1] = {0x00};
    [sendData appendBytes:a length:1];
    return sendData;
}


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

-(NSData *) NFCP_Page_Area_Reverse:(int32_t)startx startY:(int32_t)starty endX:(int32_t)endx endY:(int32_t)endy Reverse:(Boolean)reverse{
    
    Byte data[12] = {0x1c, 0x4c, 0x72, (Byte) (startx % 256), (Byte) (startx / 256),
        (Byte) (starty % 256), (Byte) (starty / 256), (Byte) (endx % 256), (Byte) (endx / 256),
        (Byte) (endy % 256), (Byte) (endy / 256), 0x00};
    
    NSMutableData *sendData=[[NSMutableData alloc]init];
    [sendData appendBytes:data length:13];
    
    if (reverse) {
        data[11] = 0x01;
    } else {
        data[11] = 0x00;
    }
    
    Byte a[1] = {0x00};
    [sendData appendBytes:a length:1];
    
    return sendData;
    
}

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
-(NSData *)NFCP_Page_setTextX:(int32_t)x andY:(int32_t)y andStr:(NSString *)str Fontsize:(int32_t)fontsize Rotate:(int32_t)rotate Bold:(int32_t)bold Underline:(Boolean)underline Reverse:(Boolean)reverse{
    
    NSMutableData *sendData=[[NSMutableData alloc]init];
    
    Byte arrayOfByte[] = {0x1C, 0x4C, 0x74, (Byte) (x % 256),
        (Byte) (x / 256), (Byte) (y % 256), (Byte) (y / 256), 0, 0};
    Byte tem1 = 0;
    Byte tem2 = 0;
    
    if (fontsize == 1) {
        tem1 |= 0x10;// 16点阵
    } else if (fontsize == 2) {
        tem1 |= 0x00;// 24点阵
    } else if (fontsize == 3) {
        tem1 |= 0x20;// 32点阵
    } else if (fontsize == 4)// 24点阵放大一倍
    {
        tem1 |= 0x00;
        tem2 |= 0x0A;
    } else if (fontsize == 5)// 32点阵放大一倍
    {
        tem1 |= 0x20;
        tem2 |= 0x0A;
    } else if (fontsize == 6)// 24点阵放大两倍
    {
        tem1 |= 0x00;
        tem2 |= 0x0F;
    } else if (fontsize == 7)// 32点阵放大两倍
    {
        tem1 |= 0x20;
        tem2 |= 0x0F;
    } else {
        tem1 |= 0x00;// 24点阵
    }
    
    if (rotate == 0) {
        tem2 |= 0x00;
    } else if (rotate == 1) {
        tem2 |= 0x40;
    } else if (rotate == 2) {
        tem2 |= 0x80;
    } else if (rotate == 3) {
        tem2 |= 0xC0;
    } else {
        tem2 |= 0x00;
    }
    
    if (bold != 0) {
        tem1 |= 0x02;
    }
    
    if (underline) {
        tem1 |= 0x01;
    }
    
    if (reverse) {
        tem1 |= 0x04;
    }
    
    arrayOfByte[7] = tem1;
    arrayOfByte[8] = tem2;
    [sendData appendBytes:arrayOfByte length:9];
    
    NSData *temp = [self printContent:str];
    
    [sendData appendData:temp];
    Byte a[1]= {0x00};
    [sendData appendBytes:a length:1];
    return sendData;
}

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
-(NSData *)NFCP_Page_drawBarX:(int32_t)x andY:(int32_t)y andStr:(NSString *)str BarcodeType:(int32_t)barcodetype Rotate:(int32_t)rotate BarWidth:(int32_t)barWidth BarHeight:(int32_t)barHeight{
    
    NSMutableData *sendData=[[NSMutableData alloc]init];
    
    Byte data[10 + 512] = {};
    data[0] = 0x1C;
    data[1] = 0x4C;
    data[2] = 0x62;
    data[3] = (Byte) (x % 256);
    data[4] = (Byte) (x / 256);
    data[5] = (Byte) (y % 256);
    data[6] = (Byte) (y / 256);
    if (barcodetype < 0 || barcodetype > 8)
        data[7] = 1;
    else
        data[7] = (Byte) barcodetype;
    rotate %= 4;
    data[8] = (Byte) (rotate * 64 | barWidth);
    data[9] = (Byte) barHeight;
    
    NSData *tempdata = [self printContent:str];
    Byte *temp =  (Byte *)[tempdata bytes];
    int32_t strLen = [tempdata length];
    //    int32_t strLen = [temp length];
    
    if (barcodetype == 1) // code128需要转码，其他直接打印
    {
        // 自动适配最优字符集
        Byte budf[256] = {};
        int32_t index = 0;
        Byte curset;
        int32_t i = 0;
        
        if (strLen <= 4) {
            // 四个以内字符，直接使用A集
            curset = 'A';
            budf[index++] = 123;
            budf[index++] = 65;
            
            for (i = 0; i < strLen; i++) {
                budf[index++] = temp[i];
            }
        } else {
            i = 0;
            // 判断首四个字节是否都为数字
            if ([self isnum:temp[0]] && [self isnum:temp[1]] && [self isnum:temp[2]] && [self isnum:temp[3]]) {
                // 首四字节为数字，使用字符集C
                curset = 'C';
                budf[index++] = 123;
                budf[index++] = 67;
                
                // 填充四个首字符
                budf[index++] = [self seta2cA:temp[0] andB:temp[1]];
                budf[index++] = [self seta2cA:temp[2] andB:temp[3]];
                i += 4;
            } else {
                // 使用字符集A
                curset = 'A';
                budf[index++] = 123;
                budf[index++] = 65;
                
                // 第一个字节使用字符集A
                budf[index++] = temp[0];
                i += 1;
            }
            
            // 遍历后续字节
            while (i < strLen) {
                if ((strLen - i) == 1) // 判断剩余字节数
                {
                    // 剩余一个字节，必须使用字符集A
                    if (curset == 'A') {
                        budf[index++] = temp[i];
                        i += 1;
                    } else {
                        curset = 'A';
                        budf[index++] = 123;
                        budf[index++] = 65;
                        budf[index++] = temp[i];
                        i += 1;
                    }
                } else if ((strLen - i) == 2) {
                    // 剩余两个字节，按照当前字符集执行
                    if (curset == 'A') {
                        budf[index++] = temp[i];
                        budf[index++] = temp[i + 1];
                        i += 2;
                    } else {
                        if ([self isnum:temp[i]] && [self isnum:temp[i+1]]) {
                            budf[index++] = [self seta2cA:temp[i]
                                                     andB:temp[i+1]];
                            i += 2;
                        } else {
                            curset = 'A';
                            budf[index++] = 123;
                            budf[index++] = 65;
                            
                            budf[index++] = temp[i];
                            budf[index++] = temp[i + 1];
                            i += 2;
                        }
                    }
                } else if ((strLen - i) == 3) {
                    if (curset == 'A') {
                        budf[index++] = temp[i];
                        budf[index++] = temp[i + 1];
                        i += 2;
                    } else {
                        if ([self isnum:temp[i]] && [self isnum:temp[i+1]]) {
                            budf[index++] = [self seta2cA:temp[i]
                                                     andB:temp[i+1]];
                            i += 2;
                        } else {
                            curset = 'A';
                            budf[index++] = 123;
                            budf[index++] = 65;
                            
                            budf[index++] = temp[i];
                            i += 1;
                        }
                    }
                } else {
                    // 剩余超过四个
                    if (curset == 'A') {
                        if ([self isnum:temp[i]] && [self isnum:temp[i+1]]
                            && [self isnum:temp[i+2]]
                            && [self isnum:temp[i+3]]) {
                            // 连续四个数字，可以转换字符集C
                            curset = 'C';
                            budf[index++] = 123;
                            budf[index++] = 67;
                            
                            budf[index++] = [self seta2cA:temp[i]
                                                     andB:temp[i+1]];
                            budf[index++] = [self seta2cA:temp[i+2]
                                                     andB:temp[i+3]];
                            
                            i += 4;
                        } else {
                            budf[index++] = temp[i];
                            
                            i += 1;
                        }
                    } else {
                        if ([self isnum:temp[i]] && [self isnum:temp[i+1]]) {
                            budf[index++] = [self seta2cA:temp[i]
                                                     andB:temp[i+1]];
                            
                            i += 2;
                        } else {
                            curset = 'A';
                            budf[index++] = 123;
                            budf[index++] = 65;
                            budf[index++] = temp[i];
                            i += 1;
                        }
                    }
                    
                }
            }
        }
        
        data[10] = index;
        for (i = 0; i < index; i++) {
            data[10 + 1 + i] = budf[i];
            
        }
        [sendData appendBytes:data length:(11 + index)];
        return sendData;
        
    } else {
        
        data[10] = (Byte) strLen;
        for (int32_t i = 0; i < strLen; i++) {
            data[10 + 1 + i] = temp[i];
        }
        [sendData appendBytes:data length:(11 + strLen)];
        return sendData;
    }
}

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
-(NSData *)NFCP_Page_printQrCodeX:(int32_t)x andY:(int32_t)y Rotate:(int32_t) rotate andVer:(int32_t)Ver Lel:(int32_t)lel andStr:(NSString *)Text{
    Byte n = 0;
    if (rotate == 1) {
        n |= (0x01 << 6);
    } else if (rotate == 2) {
        n |= (0x02 << 6);
    } else if (rotate == 3) {
        n |= (0x03 << 6);
    }
    
    NSMutableData *sendData = [[NSMutableData alloc] init];
    
    NSData *temp = [self printContent:Text];
    //    Byte *tempdata = (Byte *)[temp bytes];
    //    int32_t len =[tempdata length];
    int32_t len =[temp length];
    Byte data[12] = {0x1c, 0x4c, 0x42, (Byte) (x % 256),
        (Byte) (x / 256), (Byte) (y % 256), (Byte) (y / 256), 2, n,
        (Byte) ((lel << 6) + Ver), (Byte) (len % 256),
        (Byte) (len / 256)};
    [sendData appendBytes:data length:12];
    [sendData appendData:temp];
    return sendData;
}

/**
 * 页模式下打印PDF417的函数的函数
 *
 * @param x      打印的起始横坐标
 * @param y      打印的起始纵坐标
 * @param rotate 旋转角度 0：不旋转；1:90°；2:180°；3:270°
 * @param width  宽度
 * @param Text   要打印的字符串
 */
-(NSData *)NFCP_Page_printPDF417X:(int32_t)x andY:(int32_t)y Rotate:(int32_t)rotate Width:(int32_t)width andStr:(NSString *)Text{
    Byte n = 0;
    if (rotate == 1) {
        n |= (0x01 << 6);
    } else if (rotate == 2) {
        n |= (0x02 << 6);
    } else if (rotate == 3) {
        n |= (0x03 << 6);
    }
    
    NSMutableData *sendData = [[NSMutableData alloc] init];
    
    NSData *temp = [self printContent:Text];
    //    Byte *tempdata = (Byte *)[temp bytes];
    int32_t len =[temp length];
    //    int32_t len =[tempdata length];
    Byte data[12] = {0x1c, 0x4c, 0x42, (Byte) (x % 256),
        (Byte) (x / 256), (Byte) (y % 256), (Byte) (y / 256), 0, n,
        (Byte) width, (Byte) (len % 256), (Byte) (len / 256)};
    [sendData appendBytes:data length:12];
    [sendData appendData:temp];
    return sendData;
    
}

/**
 * 页模式下打印位图
 *
 * @param x      起始横坐标
 * @param y      起始纵坐标
 * @param bitmap 位图
 */
-(NSData *) NFCP_Page_printBitmapX:(int32_t)x andY:(int32_t)y Bitmap:(NSString *)bmpName{
    UIImage* image=[UIImage imageNamed:bmpName];
    CGImageRef temImg = image.CGImage;
    int32_t width = CGImageGetWidth(temImg);
    int32_t height = CGImageGetHeight(temImg);
    
    int LineByte = (width/8+3)/4*4;
    
    Byte *imageData  = (Byte *)malloc(LineByte*width*sizeof(Byte));
    memset(imageData, 0, LineByte*width);
    
    NSString *itemPath = bmpName;
    NSArray *aArray = [itemPath componentsSeparatedByString:@"."];
    NSString *filename = [aArray objectAtIndex:0];
    NSString *sufix = [aArray objectAtIndex:1];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:filename ofType:sufix];
    FILE *fp = fopen([imagePath cStringUsingEncoding:NSMacOSRomanStringEncoding],"rb");
    fseek(fp,62,0);
    fread(imageData,LineByte*height,1,fp);
    fclose(fp);
    
    NSMutableData *sendData = [[NSMutableData alloc] init];
    
    Byte data[12] ={} ;
    data[0] = 0x1C;
    data[1] = 0x4C;
    data[2] = 0x6D;
    data[3] = (Byte) (x % 256);
    data[4] = (Byte) (x / 256);
    data[5] = (Byte) (y % 256);
    data[6] = (Byte) (y / 256);
    data[7] = (Byte) (LineByte % 256);
    data[8] = (Byte) (LineByte / 256);
    data[9] = (Byte) (height % 256);
    data[10] = (Byte) (height / 256);
    data[11] = 0;// // 不旋转
    
    [sendData appendBytes:data length:12];
    Byte temp[1] ={};
    
    // 循环高
    for (int32_t i = height -1; i >= 0; i--) {
        // 循环宽度
        for (int32_t j = 0; j < LineByte; j++) {
            
            temp[0] = 0;
            int32_t pixelByte = imageData[j+ i * LineByte];
            if(j < width/8){
                temp[0] = (Byte)(255 - pixelByte);
            }else if(j == width/8){
                for(int k = 0;k < 8;k++){
                    if(j * 8 + k < width){
                        int tempBit = (pixelByte >> (7-k))&0x01;
                        if(tempBit == 0)
                            temp[0] |= (Byte) (128 >> k);
                    }
                }
            }else{
                temp[0] = (Byte)(pixelByte);
            }
            
            [sendData appendBytes:temp length:1];
            
        }
    }
    
    return sendData;
}

@end

