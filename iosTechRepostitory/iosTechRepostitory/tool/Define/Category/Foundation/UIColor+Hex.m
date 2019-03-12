//
//  UIColor.m
//  july
//
//  Created by laihj on 2018/7/24.
//  Copyright © 2018年 Yingzi. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor(Hex)

+ (UIColor *) lighgGreen {
    return RGB(0x139248, 1);
}

+ (UIColor *) darkGray {
    return RGB(0x0a2712, 1);
}

+ (UIColor *) darkGreen {
    return RGB(0x122222, 1);
}

+ (UIColor *) yzProHigh {
    return RGB(0xed0000, 1);
}

+ (UIColor *) yzProMidium {
    return RGB(0xff872e, 1);
}
+ (UIColor *) yzProLow {
    return RGB(0x129046, 1);
}

+ (UIColor *)colorWithHex:(NSString *)hexstring andAlpha:(CGFloat)alpha {
    if (hexstring.length == 0)
    {
        return [UIColor clearColor];
    }

    if('#' != [hexstring characterAtIndex:0])
    {
        hexstring = [NSString stringWithFormat:@"#%@", hexstring];
    }

    // RETURNING NO OBJECT ON WRONG ALPHA VALUES
    NSArray *validHexStringLengths = @[@7,];
    NSNumber *hexStringLengthNumber = [NSNumber numberWithUnsignedInteger:hexstring.length];
    if ([validHexStringLengths indexOfObject:hexStringLengthNumber] == NSNotFound)
    {
        return nil;
    }

    unsigned value = 0;
    NSScanner *hexValueScanner = nil;

    NSString *redHex = [NSString stringWithFormat:@"0x%@", [hexstring substringWithRange:NSMakeRange(1, 2)]];
    hexValueScanner = [NSScanner scannerWithString:redHex];
    [hexValueScanner scanHexInt:&value];
    unsigned redInt = value;
    hexValueScanner = nil;

    NSString *greenHex = [NSString stringWithFormat:@"0x%@", [hexstring substringWithRange:NSMakeRange(3, 2)]];
    hexValueScanner = [NSScanner scannerWithString:greenHex];
    [hexValueScanner scanHexInt:&value];
    unsigned greenInt = value;
    hexValueScanner = nil;

    NSString *blueHex = [NSString stringWithFormat:@"0x%@", [hexstring substringWithRange:NSMakeRange(5, 2)]];
    hexValueScanner = [NSScanner scannerWithString:blueHex];
    [hexValueScanner scanHexInt:&value];
    unsigned blueInt = value;
    hexValueScanner = nil;

    alpha = MIN(alpha, 1.0f);
    alpha = MAX(0, alpha);

    return [UIColor colorWithRed:redInt/255.0f green:greenInt/255.0f blue:blueInt/255.0f alpha:alpha];
}

@end
