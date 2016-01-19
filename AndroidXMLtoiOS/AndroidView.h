//
//  AndroidView.h
//  AndroidXMLtoiOS
//
//  Created by Rajesh on 1/7/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AView.h"
#import "TBXML.h"

@interface AndroidView : UIView

+ (UIView *)viewForXml:(NSString *)xmlName andHandler:(AndroidViewHandler *)handler;

@property (nonatomic, strong)NSMutableDictionary *elementDict;
@property (nonatomic, strong)NSMutableDictionary *subviewDict;
@property (nonatomic, assign)TBXMLElement *element;
@property (nonatomic, strong)NSString *identifier;
@property (nonatomic, strong)id foregroundView;
@property (nonatomic, assign)AndroidObjectType objectType;
@property (nonatomic, assign)ALinearLayoutOrientationValueType linearLayoutType; // only for linear layout
@property (nonatomic, assign)AndroidPadding padding;
@property (nonatomic, assign)AndroidMargin margin;
@property (nonatomic, assign)AUILayoutSizeValueType widthType;
@property (nonatomic, assign)CGFloat fWidth;
@property (nonatomic, assign)AUILayoutSizeValueType heightType;
@property (nonatomic, assign)CGFloat fHeight;
@property (nonatomic, weak)AndroidView *parentView;
@property (nonatomic, weak)AndroidView *firstChildView;
@property (nonatomic, weak)AndroidView *previousView;
@property (nonatomic, weak)AndroidView *nextView;

@end
