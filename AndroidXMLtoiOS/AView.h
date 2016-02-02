//
//  ViewController.h
//  AndroidXMLtoiOS
//
//  Created by Rajesh on 11/23/15.
//  Copyright © 2015 Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBXML.h"
@protocol AViewHandlerDelegate <UITextFieldDelegate>
@required
- (void)buttonAction:(UIButton *)button;
@end


static const NSInteger Padding = 0;
typedef enum {
    kLinearLayout = 1,
    kRelativeLayout,
    kWebViewLayout,
    kListViewLayout,
    kGridViewLayout,
    kScrollView,
    kHorizontalScrollView,
    kButton,
    kTextField,
    kTextView,
    kImageView,
}AndroidObjectType;


typedef enum {
    kLayoutWidth = 60,
    kLayoutHeight,
    kMinWidth,
    kMinHeight,
    kMaxWidth,
    kMaxHeight,
    kTextStyle
}AUILayoutSizeNameType;

typedef enum {
    kMatchParent = 90,
    kWrapContent,
    kFillParent,
    kCustom
}AUILayoutSizeValueType;

typedef enum {
    kLayoutPadding = 120,
    kLayoutPaddingTop,
    kLayoutPaddingLeft,
    kLayoutPaddingBottom,
    kLayoutPaddingRight
}AUILayoutPaddingNameType;

typedef enum {
    kLayoutPaddingHorizontalMargin = 150,
    kLayoutPaddingVerticalMargin
}AUILayoutValueType;

typedef enum {
    kSecureText = 180,
    kTextSize,
    kLayoutWeight,
    kAlpha
}AUIInputNameType;

typedef enum {
    kPassword = 210,
    kHintText
}AUIInputValueType;

typedef enum {
    kIdentifier = 240,
}AUIObjectIdentifierNameType;

typedef enum {
    kLayoutMargin = 270,
    kLayoutMarginTop,
    kLayoutMarginLeft,
    kLayoutMarginBottom,
    kLayoutMarginRight,
    
}AUILayoutRelationNameType;

typedef enum {
    kText = 300,
    kBackGroundColor,
    kTextColor,
    kImageSrc,
    kLayoutGravity,
    kLayoutOrientation
}AUIGeneralNameType;

typedef enum {
    kCenter = 330,
}AUILayoutGravityValueType;

typedef enum {
    kLinearVerticalLayout = 360,
    kLinearHorizontalLayout
}ALinearLayoutOrientationValueType;

typedef enum {
    kLayoutAbove = 390,
    kLayoutBelow,
    kLayoutAlignBaseline,
    kLayoutAlignBottom,
    kLayoutAlignEnd,
    kLayoutAlignLeft,
    kLayoutAlignParentBottom,
    kLayoutAlignParentEnd,
    kLayoutAlignParentLeft,
    kLayoutAlignParentRight,
    kLayoutAlignParentStart,
    kLayoutAlignParentTop,
    kLayoutAlignRight,
    kLayoutAlignStart,
    kLayoutAlignTop,
    kLayoutAlignWithParentIfMissing,
    kLayoutCenterHorizontal,
    kLayoutCenterInParent,
    kLayoutCenterVertical,
    kLayoutToEndOf,
    kLayoutToLeftOf,
    kLayoutToRightOf,
    kLayoutToStartOf
}ARelativeLayoutAttributeValueType;

typedef struct {
    BOOL isFirstItem;
    BOOL isLastItem;
} AItemPosition;

CG_INLINE AItemPosition
AItemPositionMake(BOOL isFirstItem,BOOL isLastItem)
{
    AItemPosition position;
    position.isFirstItem = isFirstItem;
    position.isLastItem = isLastItem;
    return position;
}

typedef struct {
    CGFloat paddingTop;
    CGFloat paddingLeft;
    CGFloat paddingBottom;
    CGFloat paddingRight;
} AndroidPadding;

CG_INLINE AndroidPadding
AndroidPaddingMake( CGFloat paddingTop,
                   CGFloat paddingLeft,
                   CGFloat paddingBottom,
                   CGFloat paddingRight) {
    AndroidPadding padding;
    padding.paddingTop = paddingTop;
    padding.paddingLeft = paddingLeft;
    padding.paddingBottom = paddingBottom;
    padding.paddingRight = paddingRight;
    return padding;
}

typedef struct {
    CGFloat marginTop;
    CGFloat marginLeft;
    CGFloat marginBottom;
    CGFloat marginRight;
} AndroidMargin;

CG_INLINE AndroidMargin
AndroidMarginMake( CGFloat marginTop,
                   CGFloat marginLeft,
                   CGFloat marginBottom,
                   CGFloat marginRight) {
    AndroidMargin margin;
    margin.marginTop = marginTop;
    margin.marginLeft = marginLeft;
    margin.marginBottom = marginBottom;
    margin.marginRight = marginRight;
    return margin;
}

@interface AndroidViewHandler : NSObject
@property (nonatomic, weak)UIView *superView;
@property (nonatomic, weak)id <AViewHandlerDelegate>owner;
@property (nonatomic, assign)UIView *relationView; //Can be a Sibling/Superview/Subview
@property (nonatomic, assign)AItemPosition position; 
@property (nonatomic, strong)NSMutableDictionary *attributeDict;

- (instancetype)copyHandler;
- (void)loadAttributeDict:(TBXMLElement*)element;

@end

@interface UIView (AView)
+ (NSDictionary *)dataDictionary;
+ (UIView *)viewForXml:(NSString *)xmlName andHandler:(AndroidViewHandler *)viewHandler;
+ (CGFloat)pixels:(NSString *)dp;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
@end

