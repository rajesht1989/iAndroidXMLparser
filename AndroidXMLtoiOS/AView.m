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
static const NSInteger Padding = 20;
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
    kWrapContent,
    kFillParent
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
    kHintText,
    kBackGroundColor,
    kLayoutGravity
}AUIInputValueType;

typedef enum {
    kIdentifier = 240,
}AUIObjectIdentifierNameType;

typedef enum {
    kLayoutMarginTop = 270,
    kLayoutBelow
}AUILayoutRelationNameType;

typedef enum {
    kText = 300,
}AUILayoutTextNameType;

typedef enum {
    kCenter = 330,
}AUILayoutGravityValueType;

@implementation UIViewHandler

- (instancetype)copyHandler {
    UIViewHandler *viewHandlerCopy = [[UIViewHandler alloc] init];
    [viewHandlerCopy setSuperView:self.superView];
    [viewHandlerCopy setOwner:self.owner];
    [viewHandlerCopy setLayoutType:self.layoutType];
    [viewHandlerCopy setRelationView:self.relationView];
    return viewHandlerCopy;
}

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

- (void)setAndroidText:(NSString *)text {
    id selfObject = self;
    if ([selfObject isKindOfClass:[UITextField class]]) {
        [selfObject setText:text];
    } else if ([selfObject isKindOfClass:[UILabel class]]) {
        [selfObject setText:text];
    } else if ([self isKindOfClass:[UIImageView class]]) {
    } else if ([self isKindOfClass:[UIButton class]]) {
        [selfObject setTitle:text forState:UIControlStateNormal];
    }
}

- (void)setLayoutGravity:(AUILayoutGravityValueType)type {
    id selfObject = self;
    switch (type) {
        case kCenter:
            if ([selfObject isKindOfClass:[UILabel class]] || [selfObject isKindOfClass:[UITextField class]]) {
                [selfObject setTextAlignment:NSTextAlignmentCenter];
            } else if ([self isKindOfClass:[UIButton class]]) {
                //                [selfObject :NSTextAlignmentCenter];
            }
            break;
            
        default:
            break;
    }
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
        [dictUtil setObject:@(kHintText) forKey:@"android:hint"];
        [dictUtil setObject:@(kLayoutGravity) forKey:@"android:layout_gravity"];
        
        [dictUtil setObject:@(kIdentifier) forKey:@"android:id"];
        
        [dictUtil setObject:@(kLayoutMarginTop) forKey:@"android:layout_marginTop"];
        [dictUtil setObject:@(kLayoutBelow) forKey:@"android:layout_below"];
        [dictUtil setObject:@(kText) forKey:@"android:text"];
        
        [dictUtil setObject:@(kCenter) forKey:@"center"];
        
        [dictUtil setObject:@(kBackGroundColor) forKey:@"android:background"];
    }
    return dictUtil;
}

+ (UIView *)viewForXml:(NSString *)xmlName andHandler:(UIViewHandler *)viewHandler
{
    NSError *error = nil;
    TBXML *tbxml = [TBXML tbxmlWithXMLData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:xmlName ofType:@"xml"]] error:&error];
    /*    NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:xmlName ofType:@"xml"]] error:nil];*/
//    [viewHandler.superView setBackgroundColor:[UIColor colorWithWhite:.7 alpha:.8]];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [viewHandler.superView addSubview:scrollView];
    
    [viewHandler.superView addConstraint:[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:viewHandler.superView attribute:NSLayoutAttributeLeading multiplier:1.f constant:0]];
    [viewHandler.superView addConstraint:[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:viewHandler.superView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0]];
    [viewHandler.superView addConstraint:[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:viewHandler.superView attribute:NSLayoutAttributeTop multiplier:1.f constant:0]];
    [viewHandler.superView addConstraint:[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:viewHandler.superView attribute:NSLayoutAttributeBottom multiplier:1.f constant:0]];
    
    UIViewHandler *subviewHandler = [viewHandler copyHandler];
    [subviewHandler setSuperView:scrollView];
    [scrollView addSubview:[self subEntityFor:tbxml.rootXMLElement ansHandler:subviewHandler]];
    return scrollView;
}

+ (id)subEntityFor:(TBXMLElement *)element ansHandler:(UIViewHandler *)viewHandler {
    id viewToBeReturn;
    switch ([[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", element->name]] integerValue]) {
        case kLinearLayout : {
            UIView *view = [[UIView alloc] init];
            viewToBeReturn = view;
            [viewHandler.superView addSubview:view];
            TBXMLAttribute *attribute = element->firstAttribute;
            [self configureLayoutView:view attribute:attribute handler:viewHandler];
            
            
            TBXMLElement *child = element->firstChild;
            UIViewHandler *subviewHandler = [[UIViewHandler alloc] init];
            [subviewHandler setSuperView:viewToBeReturn];
            [subviewHandler setOwner:viewHandler.owner];
            [subviewHandler setLayoutType:kLinearLayout];
            UIView *previousView;
            while (child) {
                [subviewHandler setRelationView:previousView];
                previousView = [self subEntityFor:child ansHandler:subviewHandler];
                child = child->nextSibling;
            }
        }
            break;
        case kRelativeLayout :
        {
            //            Actual pixels = dp * ( dpi / 160 ),

            UIView *view = [[UIView alloc] init];
            viewToBeReturn = view;
            [viewHandler.superView addSubview:view];
            TBXMLAttribute *attribute = element->firstAttribute;
            [self configureLayoutView:view attribute:attribute handler:viewHandler];
            TBXMLElement *child = element->firstChild;
            UIViewHandler *subviewHandler = [[UIViewHandler alloc] init];
            [subviewHandler setSuperView:viewToBeReturn];
            [subviewHandler setOwner:viewHandler.owner];
            [subviewHandler setLayoutType:kRelativeLayout];
            while (child) {
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
            [button.layer setBorderWidth:1.f];
            [button.layer setBorderColor:[[UIColor darkTextColor] CGColor]];
            [button addTarget:viewHandler.owner action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self configureLayoutView:button attribute:element->firstAttribute handler:viewHandler];
        }
            break;
        case kTextField :
        {
            UITextField *textField = [[UITextField alloc] init];
            [textField setDelegate:viewHandler.owner];
            [textField.layer setBorderWidth:1.f];
            [textField.layer setBorderColor:[[UIColor grayColor] CGColor]];
            viewToBeReturn = textField;
            [viewHandler.superView addSubview:textField];
            [self configureLayoutView:textField attribute:element->firstAttribute handler:viewHandler];
        }
            break;
        case kTextView :
        {
            UILabel *label = [[UILabel alloc] init];
            viewToBeReturn = label;
            [label setNumberOfLines:0];
            [label.layer setBorderWidth:1.f];
            [label.layer setBorderColor:[[UIColor grayColor] CGColor]];
            [viewHandler.superView addSubview:label];
            [self configureLayoutView:label attribute:element->firstAttribute handler:viewHandler];
        }
            break;
        default:
            break;
    }
    return viewToBeReturn;
}

+ (void)configureLayoutView:(UIView *)view attribute:(TBXMLAttribute *)attribute handler:(UIViewHandler *) handler {
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    if (handler.layoutType == kLinearLayout) {
        if (handler.relationView) {
            NSLayoutConstraint *yConstraint =[NSLayoutConstraint
                                              constraintWithItem:view
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:handler.relationView
                                              attribute:NSLayoutAttributeBottom
                                              multiplier:1.f
                                              constant:Padding];
            [view.superview addConstraint:yConstraint];
        } else {
            NSLayoutConstraint *yConstraint =[NSLayoutConstraint
                                              constraintWithItem:view
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:view.superview
                                              attribute:NSLayoutAttributeTop
                                              multiplier:1.f
                                              constant:Padding];
            [view.superview addConstraint:yConstraint];
        }
    }
    while (attribute) {
        switch ([[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->name]] integerValue]) {
            case kLayoutWidth:
                switch ([[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->value]] integerValue]) {
                    case kMatchParent:
                    {
                        NSLayoutConstraint *width =[NSLayoutConstraint
                                                    constraintWithItem:view
                                                    attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual
                                                    toItem:view.superview
                                                    attribute:NSLayoutAttributeWidth
                                                    multiplier:1.f
                                                    constant:0];
                        [view.superview addConstraint:width];
                        NSLayoutConstraint *centerX =[NSLayoutConstraint
                                                      constraintWithItem:view
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual
                                                      toItem:view.superview
                                                      attribute:NSLayoutAttributeCenterX
                                                      multiplier:1.0
                                                      constant:0];
                        [view.superview addConstraint:centerX];
                    }
                        break;
                    case kWrapContent:
                    {
                        NSLayoutConstraint *width =[NSLayoutConstraint
                                                    constraintWithItem:view
                                                    attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual
                                                    toItem:view.superview
                                                    attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0
                                                    constant:0];
                        [view.superview addConstraint:width];
                        NSLayoutConstraint *centerX =[NSLayoutConstraint
                                                      constraintWithItem:view
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual
                                                      toItem:view.superview
                                                      attribute:NSLayoutAttributeCenterX
                                                      multiplier:1.0
                                                      constant:0];
                        [view.superview addConstraint:centerX];
                    }
                        break;
                    case kFillParent:
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
                                                     relatedBy:NSLayoutRelationEqual
                                                     toItem:view.superview
                                                     attribute:NSLayoutAttributeHeight
                                                     multiplier:1.0
                                                     constant:0];
                        [view.superview addConstraint:height];
                        NSLayoutConstraint *centerY =[NSLayoutConstraint
                                                      constraintWithItem:view
                                                      attribute:NSLayoutAttributeCenterY
                                                      relatedBy:NSLayoutRelationEqual
                                                      toItem:view.superview
                                                      attribute:NSLayoutAttributeCenterY
                                                      multiplier:1.0
                                                      constant:0];
                        [view.superview addConstraint:centerY];
                    }
                        break;
                    case kWrapContent:
                    {
                        NSLayoutConstraint *height =[NSLayoutConstraint
                                                     constraintWithItem:view
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                     toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1.0
                                                     constant:[UIView getHeightOfView:view]];
                        [view addConstraint:height];
                    }
                        break;
                    case kFillParent:
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
            case kText:
                [view setAndroidText:[NSString stringWithFormat:@"%s", attribute->value]];
                break;
            case kHintText:
                if ([view isKindOfClass:[UITextField class]]) {
                    [(UITextField *)view setPlaceholder:[NSString stringWithFormat:@"%s", attribute->value]];
                }
                break;
            case kLayoutGravity:
                [view setLayoutGravity:[[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->value]] intValue]];
                break;
            case kBackGroundColor:
                [view setBackgroundColor:[self colorWithHexString:[NSString stringWithFormat:@"%s", attribute->value]]];
                break;
            default:
                break;
        }
        NSLog(@"%@ %@",[NSString stringWithFormat:@"%s", attribute->name],[NSString stringWithFormat:@"%s", attribute->value]);
        attribute = attribute->next;
    }
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    unsigned int r, g, b,alpha = 1;
    NSRange range;
    range.location = 0;
    range.length = 2;

    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] == 8) {
        [[NSScanner scannerWithString:[cString substringWithRange:range]] scanHexInt:&alpha];
      cString = [cString substringFromIndex:2];
    }
    if ([cString length] != 6) return [UIColor blackColor];
    // Separate into r, g, b substrings

    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:((float) alpha / 255.0f)];
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
