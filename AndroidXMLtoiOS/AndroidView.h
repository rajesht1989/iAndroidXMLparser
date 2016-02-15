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
#import "iOSTableviewAdapter.h"

@interface AndroidView : UIView

+ (instancetype)viewForXMLFileName:(NSString *)xmlName andHandler:(AndroidViewHandler *)handler;
+ (instancetype)viewForXml:(NSString *)xmlString andHandler:(AndroidViewHandler *)handler;
+ (instancetype)viewForElement:(TBXMLElement *)element handler:(AndroidViewHandler *)handler;
- (UIView *)androidSuperview;
- (void)setContent:(NSString *)content;

@property (nonatomic, weak)id <AViewHandlerDelegate>owner;
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

@property (nonatomic, assign)CGFloat fTotalWeight;
@property (nonatomic, assign)CGFloat fWeight;

@property (nonatomic, assign)AUILayoutSizeValueType heightType;
@property (nonatomic, assign)CGFloat fHeight;
@property (nonatomic, assign)CGFloat fMinWidth;
@property (nonatomic, assign)CGFloat fMinHeight;
@property (nonatomic, assign)CGFloat fMaxWidth;
@property (nonatomic, assign)CGFloat fMaxHeight;

@property (nonatomic, weak)AndroidView *parentView;
@property (nonatomic, weak)AndroidView *firstChildView;
@property (nonatomic, weak)AndroidView *previousView;
@property (nonatomic, weak)AndroidView *nextView;

@property (nonatomic, weak)NSLayoutConstraint *leadingMargin;
@property (nonatomic, weak)NSLayoutConstraint *trailingMargin;
@property (nonatomic, weak)NSLayoutConstraint *topMargin;
@property (nonatomic, weak)NSLayoutConstraint *bottomMargin;
@property (nonatomic, weak)NSLayoutConstraint *widthConstraint;
@property (nonatomic, weak)NSLayoutConstraint *heightConstraint;

//RelativeLayout
@property (nonatomic, assign)BOOL isAlignParentStart;
@property (nonatomic, assign)BOOL isAlignParentLeft;
@property (nonatomic, assign)BOOL isAlignParentTop;
@property (nonatomic, assign)BOOL isAlignParentRight;
@property (nonatomic, assign)BOOL isAlignParentEnd;
@property (nonatomic, assign)BOOL isAlignParentBottom;
@property (nonatomic, assign)BOOL isAlignWithparentIfMissing;//Not now
@property (nonatomic, assign)BOOL isAlignCenterHorizontal;
@property (nonatomic, assign)BOOL isAlignCenterVertical;
@property (nonatomic, assign)BOOL isAlignCenterInParent;
@property (nonatomic, strong)NSString *layoutAlignBaseLine;
@property (nonatomic, strong)NSString *layoutAlignStart;
@property (nonatomic, strong)NSString *layoutAlignLeft;
@property (nonatomic, strong)NSString *layoutAlignTop;
@property (nonatomic, strong)NSString *layoutAlignRight;
@property (nonatomic, strong)NSString *layoutAlignEnd;
@property (nonatomic, strong)NSString *layoutAlignBottom;
@property (nonatomic, strong)NSString *layoutAbove;
@property (nonatomic, strong)NSString *layoutBelow;
@property (nonatomic, strong)NSString *layoutToStartOf;
@property (nonatomic, strong)NSString *layoutToLeftOf;
@property (nonatomic, strong)NSString *layoutToRightOf;
@property (nonatomic, strong)NSString *layoutToEndOf;

//ListLayout
@property (nonatomic, strong) iOSTableviewAdapter *tableViewAdapter;
@property (nonatomic, assign)TBXMLElement *cellLayoutElement;
@property (nonatomic, weak)AndroidView *superParentView;
@property (nonatomic, strong)NSMutableDictionary *subviewInSuperParentDict;

@property (nonatomic, strong)NSMutableDictionary *dataDictCollection;
@property (nonatomic, strong)NSMutableDictionary *onRightSwipeMenuDictCollection;
@property (nonatomic, strong)NSMutableDictionary *onLeftSwipeMenuDictCollection;

@property (nonatomic, assign)BOOL isDynamicContent;

@end
