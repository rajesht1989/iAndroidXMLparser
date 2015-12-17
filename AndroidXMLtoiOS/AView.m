//
//  ViewController.m
//  AndroidXMLtoiOS
//
//  Created by Rajesh on 11/23/15.
//  Copyright © 2015 Org. All rights reserved.
//

#import "AView.h"
#import "XMLReader.h"
#import "TBXML.h"
#import <objc/runtime.h>

const NSInteger Undefined = 0;


/*
 //Layouts
 
 private final String LINEAR_LAYOUT_TAG = "LinearLayout";
 
 private final String RELATIVE_LAYOUT_TAG = "RelativeLayout";
 
 private final String TEXTVIEW_TAG = "TextView";
 
 private final String IMGVIEW_TAG = "ImageView";
 
 //Attributes

 private final String ID_ATTRIBUTE = "android:id";
 
 private final String WIDTH_ATTRIBUTE = "android:layout_width";
 
 private final String HEIGHT_ATTRIBUTE = "android:layout_height";
 
 private final String TEXT_ATTRIBUTE = "android:text";
 
 private final String MIN_HEIGHT_ATTRIBUTE = "android:minHeight";
 
 private final String ORIENTATION_ATTRIBUTE = "android:orientation";
 
 private final String MARGIN_ATTRIBUTE = "android:layout_margin";
 
 private final String WEIGHT_ATTRIBUTE = "android:layout_weight";
 
 private final String PADDING_ATTRIBUTE = "android:layout_padding";
 
 private final String TEXT_COLOR_ATTRIBUTE = "android:textColor";
 
 private final String BACKGROUND_ATTRIBUTE = "android:background";
 
 private final String TEXT_SIZE_ATTRIBUTE = "android:textSize";
 
 private final String TEXT_STYLE_ATTRIBUTE = "android:textStyle";
 
 private final String LEFT_OF_ATTRIBUTE = "android:layout_toLeftOf";
 
 private final String RIGHT_OF_ATTRIBUTE = "android:layout_toRightOf";
 
 private final String ABOVE_ATTRIBUTE = "android:layout_above";
 
 private final String BELOW_ATTRIBUTE = "android:layout_below";
 
 private final String PARENT_RIGHT_ATTRIBUTE = "android:layout_alignParentRight";
 
 private final String PARENT_BOTTOM_ATTRIBUTE = "android:layout_alignParentBottom";
 
 private final String PARENT_TOP_ATTRIBUTE = "android:layout_alignParentTop";
 
 private final String PARENT_LEFT_ATTRIBUTE = "android:layout_alignParentLeft";
 
 private final String CENTER_HORIZONTAL_ATTRIBUTE = "android:layout_centerHorizontal";
 
 private final String CENTER_VERTICAL_ATTRIBUTE = "android:layout_centerVertical";
 
 private final String CENTER_PARENT_ATTRIBUTE = "android:layout_centerInParent";
 
 private final String IMG_SRC_ATTRIBUTE = "android:src";
 */

typedef enum {
    kLinearLayout = 1,
    kRelativeLayout,
    kWebViewLayout,
    kListViewLayout,
    kGridViewLayout
}ALayoutType;

typedef enum {
    kButton = 30,
    kTextField,
    kTextView,
    kImageView,
}AUIObjectType;

typedef enum {
    kLayoutWidth = 60,
    kLayoutHeight
}AUILayoutSizeNameType;

typedef enum {
    kMatchParent = 90,
    kWrapContent
}AUILayoutSizeValueType;

typedef enum {
    kLayoutPaddingTop= 120,
    kLayoutPaddingLeft,
    kLayoutPaddingBottom,
    kLayoutPaddingRight
}AUILayoutPaddingNameType;

typedef enum {
    kLayoutPaddingHorizontalMargin = 150,
    kLayoutPaddingVerticalMargin
}AUILayoutPaddingValueType;

typedef enum {
    kSecureText = 180,
}AUIInputNameType;

typedef enum {
    kPassword = 210,
}AUIInputValueType;

typedef enum {
    kIdentifier = 240,
}AUIObjectIdentifierNameType;

typedef enum {
    kLayoutMarginTop = 270,
    kLayoutBelow
}AUILayoutRelationNameType;

@implementation UIViewHandler
@end

@interface UIView (AView_Private)

@property (nonatomic, strong) NSString *identifier;

+ (CGFloat)getHeightOfView:(UIView *)view;

@end

@implementation UIView (AView)

static char identifierInstance;

- (NSString *)identifier {
    return objc_getAssociatedObject(self, &identifierInstance);
}

- (void)setIdentifier:(NSString *)identifier {
    [self willChangeValueForKey:@"identifierInstance"];
    objc_setAssociatedObject(self, &identifierInstance,
                             identifier,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"identifierInstance"];
}


+ (CGFloat)getHeightOfView:(UIView *)view {
    if ([view isKindOfClass:[UITextField class]]) {
        return 40;
    } else if ([view isKindOfClass:[UILabel class]]) {
        return 40;
    } else if ([view isKindOfClass:[UIImageView class]]) {
        return 40;
    } else if ([view isKindOfClass:[UIButton class]]) {
        return 40;
    }
    return 0;
}

static NSMutableDictionary *dictUtil;
+ (NSDictionary *)dictUtil
{
    if (!dictUtil)
    {
        dictUtil = [NSMutableDictionary new];
        [dictUtil setObject:@(kLinearLayout) forKey:@"LinearLayout"];
        [dictUtil setObject:@(kRelativeLayout) forKey:@"RelativeLayout"];
        [dictUtil setObject:@(kWebViewLayout) forKey:@"WebViewLayout"];
        [dictUtil setObject:@(kListViewLayout) forKey:@"ListViewLayout"];
        [dictUtil setObject:@(kGridViewLayout) forKey:@"GridViewLayout"];
        
        [dictUtil setObject:@(kButton) forKey:@"Button"];
        [dictUtil setObject:@(kTextField) forKey:@"EditText"];
        [dictUtil setObject:@(kTextView) forKey:@"TextView"];
        [dictUtil setObject:@(kImageView) forKey:@"ImageView"];
        
        
        [dictUtil setObject:@(kLayoutWidth) forKey:@"android:layout_width"];
        [dictUtil setObject:@(kLayoutHeight) forKey:@"android:layout_height"];
        
        [dictUtil setObject:@(kMatchParent) forKey:@"match_parent"];
        [dictUtil setObject:@(kWrapContent) forKey:@"wrap_content"];
        
        [dictUtil setObject:@(kLayoutPaddingTop) forKey:@"android:paddingTop"];
        [dictUtil setObject:@(kLayoutPaddingLeft) forKey:@"android:paddingLeft"];
        [dictUtil setObject:@(kLayoutPaddingBottom) forKey:@"android:paddingBottom"];
        [dictUtil setObject:@(kLayoutPaddingRight) forKey:@"android:paddingRight"];
        
        [dictUtil setObject:@(kLayoutPaddingHorizontalMargin) forKey:@"@dimen/activity_horizontal_margin"];
        [dictUtil setObject:@(kLayoutPaddingVerticalMargin) forKey:@"@dimen/activity_vertical_margin"];
     
        [dictUtil setObject:@(kSecureText) forKey:@"android:inputType"];
        [dictUtil setObject:@(kPassword) forKey:@"textPassword"];
        
        [dictUtil setObject:@(kIdentifier) forKey:@"android:id"];
        
        [dictUtil setObject:@(kLayoutMarginTop) forKey:@"android:layout_marginTop"];
        [dictUtil setObject:@(kLayoutBelow) forKey:@"android:layout_below"];

    }
    return dictUtil;
}

+ (UIView *)viewForXml:(NSString *)xmlName andHandler:(UIViewHandler *)viewHandler
{
    NSError *error = nil;
    TBXML *tbxml = [TBXML tbxmlWithXMLData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:xmlName ofType:@"xml"]] error:&error];
//    NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:xmlName ofType:@"xml"]] error:nil];
    return [self subEntityFor:tbxml.rootXMLElement ansHandler:viewHandler];
}

+ (id)subEntityFor:(TBXMLElement *)element ansHandler:(UIViewHandler *)viewHandler {
    id viewToBeReturn;
    switch ([[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", element->name]] integerValue]) {
        case kLinearLayout :
            break;
        case kRelativeLayout :
        {
            UIView *view = [[UIView alloc] init];
            viewToBeReturn = view;
            [viewHandler.superView addSubview:view];
            [view setBackgroundColor:[UIColor greenColor]];
            TBXMLAttribute *attribute = element->firstAttribute;
            [self configureView:view superView:viewHandler.superView attribute:attribute];
            TBXMLElement *child = element->firstChild;
            while (child) {
                UIViewHandler *subviewHandler = [[UIViewHandler alloc] init];
                [subviewHandler setSuperView:viewToBeReturn];
                [subviewHandler setOwner:viewHandler.owner];
                [self subEntityFor:child ansHandler:subviewHandler];
                child = child->nextSibling;
            }
            break;
        }
        case kListViewLayout :
        case kWebViewLayout :
        case kGridViewLayout :
            break;
        case kButton :
        {
            UIButton *button = [[UIButton alloc] init];
            viewToBeReturn = button;
            [viewHandler.superView addSubview:button];
            [button addTarget:viewHandler.owner action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self configureView:button superView:viewHandler.superView attribute:element->firstAttribute];
        }
            break;
        case kTextField :
        {
            UITextField *textField = [[UITextField alloc] init];
            [textField setDelegate:viewHandler.owner];
            viewToBeReturn = textField;
            [viewHandler.superView addSubview:textField];
            [self configureView:textField superView:viewHandler.superView attribute:element->firstAttribute];
        }
            break;
        case kTextView :
        {
            UILabel *label = [[UILabel alloc] init];
            viewToBeReturn = label;
            [viewHandler.superView addSubview:label];
            [self configureView:label superView:viewHandler.superView attribute:element->firstAttribute];
        }
            break;
        default:
            break;
    }
    return viewToBeReturn;
}

+ (void)configureView:(UIView *)view superView:(UIView *)superView attribute:(TBXMLAttribute *)attribute {
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    while (attribute) {
        switch ([[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->name]] integerValue]) {
            case kLayoutWidth:
                switch ([[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->value]] integerValue]) {
                    case kMatchParent:
                    {
                        NSLayoutConstraint *width =[NSLayoutConstraint
                                                    constraintWithItem:view
                                                    attribute:NSLayoutAttributeWidth
                                                    relatedBy:0
                                                    toItem:superView
                                                    attribute:NSLayoutAttributeWidth
                                                    multiplier:1.f
                                                    constant:0];
                        [superView addConstraint:width];
                        NSLayoutConstraint *centerX =[NSLayoutConstraint
                                                      constraintWithItem:view
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:0
                                                      toItem:superView
                                                      attribute:NSLayoutAttributeCenterX
                                                      multiplier:1.0
                                                      constant:0];
                        [superView addConstraint:centerX];
                    }
                        break;
                    case kWrapContent:
                    {
                        NSLayoutConstraint *width =[NSLayoutConstraint
                                                    constraintWithItem:view
                                                    attribute:NSLayoutAttributeWidth
                                                    relatedBy:0
                                                    toItem:superView
                                                    attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0
                                                    constant:0];
                        [superView addConstraint:width];
                        NSLayoutConstraint *centerX =[NSLayoutConstraint
                                                      constraintWithItem:view
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:0
                                                      toItem:superView
                                                      attribute:NSLayoutAttributeCenterX
                                                      multiplier:1.0
                                                      constant:0];
                        [superView addConstraint:centerX];
                    }
                        break;
                        
                    default:
                        break;
                }
                break;
            case kLayoutHeight:
                switch ([[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->value]] integerValue]) {
                    case kMatchParent:
                    {
                        NSLayoutConstraint *height =[NSLayoutConstraint
                                                     constraintWithItem:view
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:0
                                                     toItem:superView
                                                     attribute:NSLayoutAttributeHeight
                                                     multiplier:1.0
                                                     constant:0];
                        [superView addConstraint:height];
                        NSLayoutConstraint *centerY =[NSLayoutConstraint
                                                      constraintWithItem:view
                                                      attribute:NSLayoutAttributeCenterY
                                                      relatedBy:0
                                                      toItem:superView
                                                      attribute:NSLayoutAttributeCenterY
                                                      multiplier:1.0
                                                      constant:0];
                        [superView addConstraint:centerY];
                    }
                        break;
                    case kWrapContent:
                    {
                        NSLayoutConstraint *height =[NSLayoutConstraint
                                                     constraintWithItem:view
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:0
                                                     toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1.0
                                                     constant:[UIView getHeightOfView:view]];
                        [superView addConstraint:height];
                    }
                        break;
                        
                    default:
                        break;
                }
                break;
            case kSecureText:
                if ([view isKindOfClass:[UITextField class]]) {
                    [(UITextField *)view setSecureTextEntry:[[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->value]] integerValue] == kPassword];
                }
                break;
            case kIdentifier:
                [view setIdentifier:[NSString stringWithFormat:@"%s", attribute->value]];
                break;
            default:
                break;
        }
        NSLog(@"%@ %@",[NSString stringWithFormat:@"%s", attribute->name],[NSString stringWithFormat:@"%s", attribute->value]);
        attribute = attribute->next;
    }
}

/*
 {
 id viewToBeReturn;
 switch ([[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", element->name]] integerValue]) {
 case kLinearLayout :
 break;
 case kRelativeLayout :
 {
 UIView *view = [[UIView alloc] init];
 viewToBeReturn = view;
 [viewHandler.superView addSubview:view];
 [view setBackgroundColor:[UIColor greenColor]];
 TBXMLAttribute *attribute = element->firstAttribute;
 while (attribute) {
 switch ([[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->name]] integerValue]) {
 case kLayoutWidth:
 [self setLayoutSizeForView:view superView:viewHandler.superView layoutSizeNameType:kLayoutWidth layoutSizeValueType:(AUILayoutSizeValueType)[[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->value]] integerValue]];
 break;
 case kLayoutHeight:
 [self setLayoutSizeForView:view superView:viewHandler.superView layoutSizeNameType:kLayoutHeight layoutSizeValueType:(AUILayoutSizeValueType)[[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->value]] integerValue]];
 break;
 
 default:
 break;
 }
 NSLog(@"%@ %@",[NSString stringWithFormat:@"%s", attribute->name],[NSString stringWithFormat:@"%s", attribute->value]);
 attribute = attribute->next;
 }
 TBXMLElement *child = element->firstChild;
 while (child) {
 UIViewHandler *subviewHandler = [[UIViewHandler alloc] init];
 [subviewHandler setSuperView:viewToBeReturn];
 [subviewHandler setOwner:viewHandler.owner];
 [self subEntityFor:child ansHandler:subviewHandler];
 child = child->nextSibling;
 }
 break;
 }
 case kWebViewLayout :
 break;
 case kListViewLayout :
 break;
 case kGridViewLayout :
 break;
 case kButton :
 {
 UIButton *button = [[UIButton alloc] init];
 viewToBeReturn = button;
 [viewHandler.superView addSubview:button];
 }
 break;
 case kTextField :
 {
 UITextField *textField = [[UITextField alloc] init];
 viewToBeReturn = textField;
 [viewHandler.superView addSubview:textField];
 }
 break;
 case kTextView :
 {
 UITextView *textView = [[UITextView alloc] init];
 viewToBeReturn = textView;
 [viewHandler.superView addSubview:textView];
 }
 break;
 default:
 break;
 }
 return viewToBeReturn;
 }
 
 
 
 
 for (NSString *aKey in subViewDict)
 {
 NSDictionary *aSubDict = subViewDict[aKey];
 switch ([[[self dictForTypeOfView] objectForKey:aKey] intValue]) {
 case Undefined:
 break;
 case kLinearLayout:
 break;
 case kRelativeLayout:
 {
 view = [[UIView alloc] init];
 [view setBackgroundColor:[UIColor greenColor]];
 
 //                [self subViewForDict:subViewDict[aKey] fileOwner:fileOwner];
 
 
 }
 break;
 case kWebViewLayout:
 case kListViewLayout:
 case kGridViewLayout:
 break;
 case kButton :
 break;
 case kTextField :
 break;
 case kTextView :
 break;
 default:
 break;
 }
 }*/

@end
