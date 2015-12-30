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
static const NSInteger Padding = 8;
typedef enum {
    kLinearLayout = 1,
    kRelativeLayout,
    kWebViewLayout,
    kListViewLayout,
    kGridViewLayout,
    kScrollView
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
    kHintText
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
    kBackGroundColor,
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

@implementation AViewHandler

- (instancetype)copyHandler {
    AViewHandler *viewHandlerCopy = [[AViewHandler alloc] init];
    [viewHandlerCopy setSuperView:self.superView];
    [viewHandlerCopy setOwner:self.owner];
    [viewHandlerCopy setRelationView:self.relationView];
    return viewHandlerCopy;
}

@end


@interface AndroidConstraint : NSObject
@property(nonatomic, strong)NSString *id1;
@property(nonatomic, assign)NSLayoutAttribute attr1;
@property(nonatomic, strong)NSString *id2;
@property(nonatomic, assign)NSLayoutAttribute attr2;
@property(nonatomic, assign)CGFloat multiplier;
@property(nonatomic, assign)CGFloat constant;

+(instancetype)constraintWithid:(NSString *)id1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toId:(NSString *)id2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c;
@end

@implementation AndroidConstraint
+(instancetype)constraintWithid:(NSString *)id1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toId:(NSString *)id2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c {
    AndroidConstraint *constraint = [AndroidConstraint new];
    [constraint setId1:id1];
    [constraint setAttr1:attr1];
    [constraint setId2:id2];
    [constraint setAttr2:attr2];
    [constraint setMultiplier:multiplier];
    [constraint setConstant:c];
    return constraint;
}
@end

@interface UIView (AView_Private)

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) NSInteger layoutType;
@property (nonatomic, strong) NSMutableDictionary *viewDictionary;
@property (nonatomic, strong) NSMutableArray *virtualConstraints;

@end

@implementation UIView (AView)

static char identifierInstance;
static char layoutTypeInstance;
static char viewDictionaryInstance;
static char virtualConstraintsInstance;

- (NSString *)identifier {
    return objc_getAssociatedObject(self, &identifierInstance);
}

- (void)setIdentifier:(NSString *)identifier {
    if (identifier.length) {
        [self.superview.viewDictionary setObject:self forKey:identifier];
    }
    [self willChangeValueForKey:@"identifierInstance"];
    objc_setAssociatedObject(self, &identifierInstance,
                             identifier,
                             OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"identifierInstance"];
}

- (NSInteger)layoutType {
    return [objc_getAssociatedObject(self, &layoutTypeInstance) integerValue];
}

- (void)setLayoutType:(NSInteger)layoutType {
    [self willChangeValueForKey:@"layoutTypeInstance"];
    objc_setAssociatedObject(self, &layoutTypeInstance,
                             [NSNumber numberWithInteger:layoutType],
                             OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"layoutTypeInstance"];
}

- (NSMutableDictionary *)viewDictionary {
    NSMutableDictionary *viewDictionary = objc_getAssociatedObject(self, &viewDictionaryInstance);
    if (!viewDictionary) {
        [self setViewDictionary:[NSMutableDictionary dictionary]];
        viewDictionary = objc_getAssociatedObject(self, &viewDictionaryInstance);
    }
    return viewDictionary;
}

- (void)setViewDictionary:(NSMutableDictionary *)viewDictionary {
    [self willChangeValueForKey:@"viewDictionaryInstance"];
    objc_setAssociatedObject(self, &viewDictionaryInstance,
                             viewDictionary,
                             OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"viewDictionaryInstance"];
}

- (NSMutableArray *)virtualConstraints {
    NSMutableArray *array = objc_getAssociatedObject(self, &virtualConstraintsInstance);
    if (!array) {
        [self setVirtualConstraints:[NSMutableArray array]];
        array = objc_getAssociatedObject(self, &virtualConstraintsInstance);
    }
    return array;
}

- (void)setVirtualConstraints:(NSMutableArray *)virtualConstraints {
    [self willChangeValueForKey:@"virtualConstraintsInstance"];
    objc_setAssociatedObject(self, &virtualConstraintsInstance,
                             virtualConstraints,
                             OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"virtualConstraintsInstance"];
}

- (void)setAndroidText:(NSString *)text {
    id selfObject = self;
    if ([selfObject isKindOfClass:[UITextField class]]) {
        [selfObject setText:text];
    } else if ([selfObject isKindOfClass:[UILabel class]]) {
        [selfObject setText:text];
    } else if ([self isKindOfClass:[UIImageView class]]) {
        [(UIImageView *)selfObject setImage:[UIImage imageNamed:@"1"]];
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
            }
            break;
            
        default:
            break;
    }
}

+ (BOOL)attributeToMargin:(UIView *)view {
    if ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIImageView class]] || [view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UIButton class]]) {
        return YES;
    }
    return NO;
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
        [dictUtil setObject:@(kScrollView) forKey:@"ScrollView"];
        [dictUtil setObject:@(kScrollView) forKey:@"HorizontalScrollView"];
        
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
        [dictUtil setObject:@(kImageSrc) forKey:@"android:src"];

        [dictUtil setObject:@(kLayoutOrientation) forKey:@"android:orientation"];
        
        [dictUtil setObject:@(kLinearVerticalLayout) forKey:@"vertical"];
        [dictUtil setObject:@(kLinearHorizontalLayout) forKey:@"horizontal"];
        
    }
    return dictUtil;
}

+ (UIView *)viewForXml:(NSString *)xmlName andHandler:(AViewHandler *)viewHandler
{
    NSError *error = nil;
    TBXML *tbxml = [TBXML tbxmlWithXMLData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:xmlName ofType:@"xml"]] error:&error];
/*
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [viewHandler.superView addSubview:scrollView];
    
    AViewHandler *subviewHandler = [viewHandler copyHandler];
    [subviewHandler setSuperView:scrollView];
    UIView *view = [self subEntityFor:tbxml.rootXMLElement ansHandler:subviewHandler];
    switch (view.layoutType) {
        case kLinearVerticalLayout: {
            NSLayoutConstraint *width =[NSLayoutConstraint
                                        constraintWithItem:view
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:view.superview
                                        attribute:NSLayoutAttributeWidth
                                        multiplier:1.f
                                        constant:0];
            [view.superview addConstraint:width];
            
            NSLayoutConstraint *bottom =[NSLayoutConstraint
                                         constraintWithItem:view
                                         attribute:NSLayoutAttributeBottom
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:view.superview
                                         attribute:NSLayoutAttributeBottom
                                         multiplier:1.f
                                         constant:0];
            [view.superview addConstraint:bottom];
        }
            break;
        case kLinearHorizontalLayout: {
            NSLayoutConstraint *height =[NSLayoutConstraint
                                         constraintWithItem:view
                                         attribute:NSLayoutAttributeHeight
                                         relatedBy:NSLayoutRelationLessThanOrEqual
                                         toItem:view.superview
                                         attribute:NSLayoutAttributeHeight
                                         multiplier:1.f
                                         constant:0];
            [view.superview addConstraint:height];
            
            NSLayoutConstraint *trailing =[NSLayoutConstraint
                                           constraintWithItem:view
                                           attribute:NSLayoutAttributeTrailing
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:view.superview
                                           attribute:NSLayoutAttributeTrailing
                                           multiplier:1.f
                                           constant:0];
            [view.superview addConstraint:trailing];
        }
            break;
            
        default:
            break;
    }
    [scrollView addSubview:view];
 */
    UIView *view = [self subEntityFor:tbxml.rootXMLElement ansHandler:viewHandler];
    return view;
}

+ (id)subEntityFor:(TBXMLElement *)element ansHandler:(AViewHandler *)handler {
    UIView *viewToBeReturn;
    switch ([[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", element->name]] integerValue]) {
        case kScrollView : {
            UIScrollView *view = [[UIScrollView alloc] init];
            viewToBeReturn = view;
            [handler.superView addSubview:view];
            TBXMLAttribute *attribute = element->firstAttribute;
            [self configureLayoutView:view attribute:attribute handler:handler];
            AViewHandler *subviewHandler = [handler copyHandler];
            [subviewHandler setSuperView:view];
            [self subEntityFor:element->firstChild ansHandler:subviewHandler];
        }
            break;
        case kLinearLayout : {
            UIView *view = [[UIView alloc] init];
            viewToBeReturn = view;
            [handler.superView addSubview:view];
            TBXMLAttribute *attribute = element->firstAttribute;
            [self configureLayoutView:view attribute:attribute handler:handler];
            
            [view setLayoutType:view.layoutType == kLinearHorizontalLayout ? kLinearHorizontalLayout : kLinearVerticalLayout];
            TBXMLElement *child = element->firstChild;
            AViewHandler *subviewHandler = [[AViewHandler alloc] init];
            [subviewHandler setSuperView:view];
            [subviewHandler setOwner:handler.owner];
            UIView *previousView;
            while (child) {
                [subviewHandler setRelationView:previousView];
                [subviewHandler setPosition:AItemPositionMake(child->previousSibling ? NO : YES, child->nextSibling ? NO : YES)];
                previousView = [self subEntityFor:child ansHandler:subviewHandler];
                child = child->nextSibling;
            }
        }
            break;
        case kRelativeLayout : {
            UIView *view = [[UIView alloc] init];
            viewToBeReturn = view;
            [handler.superView addSubview:view];
            TBXMLAttribute *attribute = element->firstAttribute;
            [self configureLayoutView:view attribute:attribute handler:handler];
            TBXMLElement *child = element->firstChild;
            AViewHandler *subviewHandler = [[AViewHandler alloc] init];
            [subviewHandler setSuperView:viewToBeReturn];
            [subviewHandler setOwner:handler.owner];
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
        case kButton : {
            UIButton *button = [[UIButton alloc] init];
            viewToBeReturn = button;
            [handler.superView addSubview:button];
            [button.layer setBorderWidth:1.f];
            [button.layer setBorderColor:[[UIColor darkTextColor] CGColor]];
            [button addTarget:handler.owner action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self configureLayoutView:button attribute:element->firstAttribute handler:handler];
        }
            break;
        case kTextField : {
            UITextField *textField = [[UITextField alloc] init];
            [textField setDelegate:handler.owner];
            [textField.layer setBorderWidth:1.f];
            [textField.layer setBorderColor:[[UIColor grayColor] CGColor]];
            viewToBeReturn = textField;
            [handler.superView addSubview:textField];
            [self configureLayoutView:textField attribute:element->firstAttribute handler:handler];
        }
            break;
        case kTextView : {
            UILabel *label = [[UILabel alloc] init];
            viewToBeReturn = label;
            [label setNumberOfLines:0];
            [label.layer setBorderWidth:1.f];
            [label.layer setBorderColor:[[UIColor grayColor] CGColor]];
            [handler.superView addSubview:label];
            [self configureLayoutView:label attribute:element->firstAttribute handler:handler];
        }
            break;
        case kImageView : {
            UIImageView *imageView = [[UIImageView alloc] init];
            viewToBeReturn = imageView;
            [handler.superView addSubview:imageView];
            [self configureLayoutView:imageView attribute:element->firstAttribute handler:handler];
        }
            break;
        default:
            break;
    }
    BOOL isMarginConstraint = [UIView attributeToMargin:viewToBeReturn];
    switch (viewToBeReturn.superview.layoutType) {
        case kLinearVerticalLayout: {
            if (handler.relationView) {
                NSLayoutConstraint *yConstraint =[NSLayoutConstraint
                                                  constraintWithItem:viewToBeReturn
                                                  attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:handler.relationView
                                                  attribute:NSLayoutAttributeBottom
                                                  multiplier:1.f
                                                  constant:Padding];
                [viewToBeReturn.superview addConstraint:yConstraint];
            }
            if (handler.position.isFirstItem) {
                NSLayoutConstraint *top =[NSLayoutConstraint
                                          constraintWithItem:viewToBeReturn
                                          attribute:NSLayoutAttributeTop
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:viewToBeReturn.superview
                                          attribute:isMarginConstraint ? NSLayoutAttributeTopMargin : NSLayoutAttributeTop
                                          multiplier:1.f
                                          constant:isMarginConstraint ? 0 :Padding];
                [viewToBeReturn.superview addConstraint:top];
            }
            if (handler.position.isLastItem) {
            /*    if (isMarginConstraint) { //should be added for scrollview
                    NSLayoutConstraint *bottom =[NSLayoutConstraint
                                                 constraintWithItem:viewToBeReturn
                                                 attribute:NSLayoutAttributeBottom
                                                 relatedBy:NSLayoutRelationLessThanOrEqual
                                                 toItem:viewToBeReturn.superview
                                                 attribute:NSLayoutAttributeBottomMargin
                                                 multiplier:1.f
                                                 constant:isMarginConstraint ? 0 :Padding];
                    [viewToBeReturn.superview addConstraint:bottom];
                }
                */
            }
        }
            break;
        case kLinearHorizontalLayout: {
            if (handler.relationView) {
                NSLayoutConstraint *xConstraint =[NSLayoutConstraint
                                                  constraintWithItem:viewToBeReturn
                                                  attribute:NSLayoutAttributeLeft
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:handler.relationView
                                                  attribute:NSLayoutAttributeRight
                                                  multiplier:1.f
                                                  constant:Padding];
                [viewToBeReturn.superview addConstraint:xConstraint];
            }
            if (handler.position.isFirstItem) {
                NSLayoutConstraint *leading =[NSLayoutConstraint
                                              constraintWithItem:viewToBeReturn
                                              attribute:NSLayoutAttributeLeading
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:viewToBeReturn.superview
                                              attribute:isMarginConstraint ? NSLayoutAttributeLeadingMargin :  NSLayoutAttributeLeading
                                              multiplier:1.f
                                              constant:isMarginConstraint ? 0 :Padding];
                [viewToBeReturn.superview addConstraint:leading];
            }
            if (handler.position.isLastItem) {
                NSLayoutConstraint *trailing =[NSLayoutConstraint
                                               constraintWithItem:viewToBeReturn
                                               attribute:NSLayoutAttributeTrailing
                                               relatedBy:NSLayoutRelationLessThanOrEqual
                                               toItem:viewToBeReturn.superview
                                               attribute:isMarginConstraint ? NSLayoutAttributeTrailingMargin : NSLayoutAttributeTrailing
                                               multiplier:1.f
                                               constant:isMarginConstraint ? 0 :-Padding];
                [viewToBeReturn.superview addConstraint:trailing];
            }
            break;
        default:
            break;
        }
    }
    return viewToBeReturn;
}

+ (void)configureLayoutView:(UIView *)view attribute:(TBXMLAttribute *)attribute handler:(AViewHandler *)handler {
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    while (attribute) {
        NSLog(@"%@ %@",[NSString stringWithFormat:@"%s", attribute->name],[NSString stringWithFormat:@"%s", attribute->value]);
        switch ([[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->name]] integerValue]) {
            case kIdentifier:
                [view setIdentifier:[NSString stringWithFormat:@"%s", attribute->value]];
                break;
            case kSecureText:
                if ([view isKindOfClass:[UITextField class]]) {
                    [(UITextField *)view setSecureTextEntry:[[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->value]] integerValue] == kPassword];
                }
                break;
            case kImageSrc:
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
            case kLayoutOrientation:
                [view setLayoutType:[[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->value]] intValue]];
                break;
            case kLayoutWidth:
            case kLayoutHeight:
                [self configureConstraintsForView:view attribute:attribute handler:handler];
                break;
            default:
                break;
        }
        attribute = attribute->next;
    }
}

+ (void)configureConstraintsForView:(UIView *)view attribute:(TBXMLAttribute *)attribute handler:(AViewHandler *)handler {
    BOOL isMarginConstraint = [UIView attributeToMargin:view];
    switch (view.superview.layoutType) {
        case kLinearVerticalLayout: {
            switch ([[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->name]] integerValue]) {
                case kLayoutWidth:
                    switch ([[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->value]] integerValue]) {
                        case kFillParent:
                        case kMatchParent: {
                            NSLayoutConstraint *leading =[NSLayoutConstraint
                                                          constraintWithItem:view
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                          toItem:view.superview
                                                          attribute:isMarginConstraint ? NSLayoutAttributeLeadingMargin : NSLayoutAttributeLeading
                                                          multiplier:1.f
                                                          constant:0];
                            [view.superview addConstraint:leading];
                            NSLayoutConstraint *trailing =[NSLayoutConstraint
                                                           constraintWithItem:view
                                                           attribute:NSLayoutAttributeTrailing
                                                           relatedBy:NSLayoutRelationEqual
                                                           toItem:view.superview
                                                           attribute:isMarginConstraint ? NSLayoutAttributeTrailingMargin : NSLayoutAttributeTrailing
                                                           multiplier:1.f
                                                           constant:0];
                            [view.superview addConstraint:trailing];
                        }
                            break;
                        case kWrapContent: {
                            NSLayoutConstraint *leading =[NSLayoutConstraint
                                                          constraintWithItem:view
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                          toItem:view.superview
                                                          attribute:isMarginConstraint ? NSLayoutAttributeLeadingMargin : NSLayoutAttributeLeading
                                                          multiplier:1.f
                                                          constant:0];
                            [view.superview addConstraint:leading];
                            
                            NSLayoutConstraint *trailing =[NSLayoutConstraint
                                                           constraintWithItem:view
                                                           attribute:NSLayoutAttributeTrailing
                                                           relatedBy:NSLayoutRelationLessThanOrEqual
                                                           toItem:view.superview
                                                           attribute:isMarginConstraint ? NSLayoutAttributeTrailingMargin : NSLayoutAttributeTrailing
                                                           multiplier:1.f
                                                           constant:0];
                            [view.superview addConstraint:trailing];
                        }
                            break;
                        default: {
                            NSLayoutConstraint *leading =[NSLayoutConstraint
                                                          constraintWithItem:view
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                          toItem:view.superview
                                                          attribute:isMarginConstraint ? NSLayoutAttributeLeadingMargin : NSLayoutAttributeLeading
                                                          multiplier:1.f
                                                          constant:0];
                            [view.superview addConstraint:leading];
                            
                            NSLayoutConstraint *width =[NSLayoutConstraint
                                                        constraintWithItem:view
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.f
                                                        constant:[self pixels:[NSString stringWithFormat:@"%s", attribute->value]]];
                            [view addConstraint:width];

                            NSLayoutConstraint *trailing =[NSLayoutConstraint
                                                           constraintWithItem:view
                                                           attribute:NSLayoutAttributeTrailing
                                                           relatedBy:NSLayoutRelationLessThanOrEqual
                                                           toItem:view.superview
                                                           attribute:isMarginConstraint ? NSLayoutAttributeTrailingMargin : NSLayoutAttributeTrailing
                                                           multiplier:1.f
                                                           constant:0];
                            [view.superview addConstraint:trailing];
                        }
                            break;
                    }
                    break;
                case kLayoutHeight:
                    switch ([[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->value]] integerValue]) {
                        case kFillParent:
                        case kMatchParent: {
                            NSLayoutConstraint *bottom =[NSLayoutConstraint
                                                         constraintWithItem:view
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                         toItem:view.superview
                                                         attribute:isMarginConstraint ? NSLayoutAttributeBottomMargin : NSLayoutAttributeBottom
                                                         multiplier:1.f
                                                         constant:0];
                            [view.superview addConstraint:bottom];
                        }
                            break;
                        case kWrapContent: {
                            NSLayoutConstraint *top =[NSLayoutConstraint
                                                      constraintWithItem:view
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                      toItem:view.superview
                                                      attribute:isMarginConstraint ? NSLayoutAttributeTopMargin : NSLayoutAttributeTop
                                                      multiplier:1.f
                                                      constant:0];
                            [view.superview addConstraint:top];
                        }
                            break;
                        default: {
                            NSLayoutConstraint *height =[NSLayoutConstraint
                                                         constraintWithItem:view
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                         toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.f
                                                         constant:[self pixels:[NSString stringWithFormat:@"%s", attribute->value]]];
                            [view addConstraint:height];
                        }
                            break;
                    }
            }
        }
            break;
        case kLinearHorizontalLayout: {
            switch ([[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->name]] integerValue]) {
                case kLayoutWidth:
                    switch ([[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->value]] integerValue]) {
                        case kFillParent:
                        case kMatchParent: {
                            NSLayoutConstraint *leading =[NSLayoutConstraint
                                                          constraintWithItem:view
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                          toItem:view.superview
                                                          attribute:isMarginConstraint ? NSLayoutAttributeLeadingMargin : NSLayoutAttributeLeading
                                                          multiplier:1.f
                                                          constant:0];
                            [view.superview addConstraint:leading];
                            
                            NSLayoutConstraint *trailing =[NSLayoutConstraint
                                                           constraintWithItem:view
                                                           attribute:NSLayoutAttributeTrailing
                                                           relatedBy:NSLayoutRelationEqual
                                                           toItem:view.superview
                                                           attribute:isMarginConstraint ? NSLayoutAttributeTrailingMargin : NSLayoutAttributeTrailing
                                                           multiplier:1.f
                                                           constant:0];
                            [view.superview addConstraint:trailing];
                        }
                            break;
                        case kWrapContent: {
/*                            NSLayoutConstraint *leading =[NSLayoutConstraint
                                                          constraintWithItem:view
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                          toItem:view.superview
                                                          attribute:isMarginConstraint ? NSLayoutAttributeLeadingMargin : NSLayoutAttributeLeading
                                                          multiplier:1.f
                                                          constant:0];
                            [view.superview addConstraint:leading];
                            
                            NSLayoutConstraint *trailing =[NSLayoutConstraint
                                                           constraintWithItem:view
                                                           attribute:NSLayoutAttributeTrailing
                                                           relatedBy:NSLayoutRelationLessThanOrEqual
                                                           toItem:view.superview
                                                           attribute:isMarginConstraint ? NSLayoutAttributeTrailingMargin : NSLayoutAttributeTrailing
                                                           multiplier:1.f
                                                           constant:0];
                            [view.superview addConstraint:trailing];
 */
                        }
                            break;
                        default : {
                            NSLayoutConstraint *width =[NSLayoutConstraint
                                                        constraintWithItem:view
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.f
                                                        constant:[self pixels:[NSString stringWithFormat:@"%s", attribute->value]]];
                            [view addConstraint:width];
                        }
                            break;
                    }
                    break;
                case kLayoutHeight:
                    switch ([[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->value]] integerValue]) {
                        case kFillParent:
                        case kMatchParent: {
                            NSLayoutConstraint *top =[NSLayoutConstraint
                                                      constraintWithItem:view
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                      toItem:view.superview
                                                      attribute:isMarginConstraint ? NSLayoutAttributeTopMargin : NSLayoutAttributeTop
                                                      multiplier:1.f
                                                      constant:0];
                            [view.superview addConstraint:top];
                            
                            NSLayoutConstraint *bottom =[NSLayoutConstraint
                                                         constraintWithItem:view
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                         toItem:view.superview
                                                         attribute:isMarginConstraint ? NSLayoutAttributeBottomMargin : NSLayoutAttributeBottom
                                                         multiplier:1.f
                                                         constant:0];
                            [view.superview addConstraint:bottom];
                        }
                            break;
                        case kWrapContent: {
                            NSLayoutConstraint *top =[NSLayoutConstraint
                                                      constraintWithItem:view
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                      toItem:view.superview
                                                      attribute:isMarginConstraint ? NSLayoutAttributeTopMargin : NSLayoutAttributeTop
                                                      multiplier:1.f
                                                      constant:0];
                            [view.superview addConstraint:top];
                            NSLayoutConstraint *bottom =[NSLayoutConstraint
                                                         constraintWithItem:view
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationLessThanOrEqual
                                                         toItem:view.superview
                                                         attribute:isMarginConstraint ? NSLayoutAttributeBottomMargin : NSLayoutAttributeBottom
                                                         multiplier:1.f
                                                         constant:0];
                            [view.superview addConstraint:bottom];
                        }
                            break;
                        default: {
                            NSLayoutConstraint *top =[NSLayoutConstraint
                                                      constraintWithItem:view
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                      toItem:view.superview
                                                      attribute:isMarginConstraint ? NSLayoutAttributeTopMargin : NSLayoutAttributeTop
                                                      multiplier:1.f
                                                      constant:0];
                            [view.superview addConstraint:top];
                            
                            NSLayoutConstraint *bottom =[NSLayoutConstraint
                                                         constraintWithItem:view
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationLessThanOrEqual
                                                         toItem:view.superview
                                                         attribute:isMarginConstraint ? NSLayoutAttributeBottomMargin : NSLayoutAttributeBottom
                                                         multiplier:1.f
                                                         constant:0];
                            [view.superview addConstraint:bottom];
                            
                            NSLayoutConstraint *height =[NSLayoutConstraint
                                                         constraintWithItem:view
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                         toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.f
                                                         constant:[self pixels:[NSString stringWithFormat:@"%s", attribute->value]]];
                            [view addConstraint:height];
                        }
                            break;
                    }
            }
        }
            break;
        default: {
            switch ([[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->name]] integerValue]) {
                case kLayoutWidth:
                    switch ([[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->value]] integerValue]) {
                        case kFillParent:
                        case kMatchParent: {
                            NSLayoutConstraint *leading =[NSLayoutConstraint
                                                          constraintWithItem:view
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                          toItem:view.superview
                                                          attribute:isMarginConstraint ? NSLayoutAttributeLeadingMargin : NSLayoutAttributeLeading
                                                          multiplier:1.f
                                                          constant:0];
                            [view.superview addConstraint:leading];
                            
                            NSLayoutConstraint *trailing =[NSLayoutConstraint
                                                           constraintWithItem:view
                                                           attribute:NSLayoutAttributeTrailing
                                                           relatedBy:NSLayoutRelationEqual
                                                           toItem:view.superview
                                                           attribute:isMarginConstraint ? NSLayoutAttributeTrailingMargin : NSLayoutAttributeTrailing
                                                           multiplier:1.f
                                                           constant:0];
                            [view.superview addConstraint:trailing];
                        }
                            break;
                        case kWrapContent: {
                            NSLayoutConstraint *leading =[NSLayoutConstraint
                                                          constraintWithItem:view
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                          toItem:view.superview
                                                          attribute:isMarginConstraint ? NSLayoutAttributeLeadingMargin : NSLayoutAttributeLeading
                                                          multiplier:1.f
                                                          constant:0];
                            [view.superview addConstraint:leading];
                            
                            NSLayoutConstraint *trailing =[NSLayoutConstraint
                                                           constraintWithItem:view
                                                           attribute:NSLayoutAttributeTrailing
                                                           relatedBy:NSLayoutRelationLessThanOrEqual
                                                           toItem:view.superview
                                                           attribute:isMarginConstraint ? NSLayoutAttributeTrailingMargin : NSLayoutAttributeTrailing
                                                           multiplier:1.f
                                                           constant:0];
                            [view.superview addConstraint:trailing];
                        }
                            break;
                        default: {
                            NSLayoutConstraint *width =[NSLayoutConstraint
                                                         constraintWithItem:view
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                         toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.f
                                                         constant:[self pixels:[NSString stringWithFormat:@"%s", attribute->value]]];
                            [view addConstraint:width];
                        }
                            break;
                    }
                    break;
                case kLayoutHeight:
                    switch ([[[self dictUtil] objectForKey:[NSString stringWithFormat:@"%s", attribute->value]] integerValue]) {
                        case kFillParent:
                        case kMatchParent: {
                            NSLayoutConstraint *top =[NSLayoutConstraint
                                                      constraintWithItem:view
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                      toItem:view.superview
                                                      attribute:isMarginConstraint ? NSLayoutAttributeTopMargin : NSLayoutAttributeTop
                                                      multiplier:1.f
                                                      constant:0];
                            [view.superview addConstraint:top];
                            
                            NSLayoutConstraint *bottom =[NSLayoutConstraint
                                                         constraintWithItem:view
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                         toItem:view.superview
                                                         attribute:isMarginConstraint ? NSLayoutAttributeBottomMargin : NSLayoutAttributeBottom
                                                         multiplier:1.f
                                                         constant:0];
                            [view.superview addConstraint:bottom];
                        }
                            break;
                        case kWrapContent: {
                            NSLayoutConstraint *top =[NSLayoutConstraint
                                                      constraintWithItem:view
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                      toItem:view.superview
                                                      attribute:isMarginConstraint ? NSLayoutAttributeTopMargin : NSLayoutAttributeTop
                                                      multiplier:1.f
                                                      constant:0];
                            [view.superview addConstraint:top];
                            
                            NSLayoutConstraint *bottom =[NSLayoutConstraint
                                                      constraintWithItem:view
                                                      attribute:NSLayoutAttributeBottom
                                                      relatedBy:NSLayoutRelationLessThanOrEqual
                                                      toItem:view.superview
                                                      attribute:isMarginConstraint ? NSLayoutAttributeBottomMargin : NSLayoutAttributeBottom
                                                      multiplier:1.f
                                                      constant:0];
                            [view.superview addConstraint:bottom];
                        }
                            break;
                        default: {
                            NSLayoutConstraint *height =[NSLayoutConstraint
                                                         constraintWithItem:view
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                         toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.f
                                                         constant:[self pixels:[NSString stringWithFormat:@"%s", attribute->value]]];
                            [view addConstraint:height];
                        }
                            break;
                    }
            }
        }
            break;
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


//Below method written with reference of http://stackoverflow.com/questions/3860305/get-ppi-of-iphone-ipad-ipod-touch-at-runtime
+ (CGFloat)pixels:(NSString *)dp {
    float scale = 1;
 /*
  if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        scale = [[UIScreen mainScreen] scale];
    }
  */
    float dpi;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        dpi = 132 * scale;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        dpi = 163 * scale;
    } else {
        dpi = 160 * scale;
    }
    
    CGFloat fdp;
    if ([dp hasSuffix:@"dp"]) {
        dp = [dp stringByReplacingOccurrencesOfString:@"dp" withString:@""];
    }
    fdp = [dp floatValue];
    CGFloat px = fdp * (dpi / 160);
    return px;
}

@end
