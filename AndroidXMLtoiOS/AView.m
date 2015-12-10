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

const NSInteger Undefined = 0;

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
    kTextView
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

@implementation UIViewHandler

@end

@interface UIView (AView_Private)

@end

@implementation UIView (AView)
static NSMutableDictionary *dictForTypeOfView;
+ (NSDictionary *)dictForTypeOfView
{
    if (!dictForTypeOfView)
    {
        dictForTypeOfView = [NSMutableDictionary new];
        [dictForTypeOfView setObject:@(kLinearLayout) forKey:@"LinearLayout"];
        [dictForTypeOfView setObject:@(kRelativeLayout) forKey:@"RelativeLayout"];
        [dictForTypeOfView setObject:@(kWebViewLayout) forKey:@"WebViewLayout"];
        [dictForTypeOfView setObject:@(kListViewLayout) forKey:@"ListViewLayout"];
        [dictForTypeOfView setObject:@(kGridViewLayout) forKey:@"GridViewLayout"];
        
        [dictForTypeOfView setObject:@(kButton) forKey:@"Button"];
        [dictForTypeOfView setObject:@(kTextField) forKey:@"EditText"];
        
        [dictForTypeOfView setObject:@(kLayoutWidth) forKey:@"android:layout_width"];
        [dictForTypeOfView setObject:@(kLayoutHeight) forKey:@"android:layout_height"];
        
        [dictForTypeOfView setObject:@(kMatchParent) forKey:@"match_parent"];
        [dictForTypeOfView setObject:@(kWrapContent) forKey:@"wrap_content"];
        
        [dictForTypeOfView setObject:@(kLayoutPaddingTop) forKey:@"android:paddingTop"];
        [dictForTypeOfView setObject:@(kLayoutPaddingLeft) forKey:@"android:paddingLeft"];
        [dictForTypeOfView setObject:@(kLayoutPaddingBottom) forKey:@"android:paddingBottom"];
        [dictForTypeOfView setObject:@(kLayoutPaddingRight) forKey:@"android:paddingRight"];
        
        [dictForTypeOfView setObject:@(kLayoutPaddingHorizontalMargin) forKey:@"@dimen/activity_horizontal_margin"];
        [dictForTypeOfView setObject:@(kLayoutPaddingVerticalMargin) forKey:@"@dimen/activity_vertical_margin"];

    }
    return dictForTypeOfView;
}

+ (UIView *)viewForXml:(NSString *)xmlName andHandler:(UIViewHandler *)viewHandler
{
    NSError *error = nil;
    TBXML *tbxml = [TBXML tbxmlWithXMLData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:xmlName ofType:@"xml"]] error:&error];
//    NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:xmlName ofType:@"xml"]] error:nil];
    return [self subEntityFor:tbxml.rootXMLElement ansHandler:viewHandler];
}
/*
+ (UIView *)viewForXmlFor:(TBXML *)tbxml andHandler:(UIViewHandler *)viewHandler
{
    return ;
}
*/
+ (id)subEntityFor:(TBXMLElement *)element ansHandler:(UIViewHandler *)viewHandler {
    id viewToBeReturn;
    switch ([[[self dictForTypeOfView] objectForKey:[NSString stringWithFormat:@"%s", element->name]] integerValue]) {
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
                switch ([[[self dictForTypeOfView] objectForKey:[NSString stringWithFormat:@"%s", attribute->name]] integerValue]) {
                    case kLayoutWidth:
                        [self setLayoutSizeForView:view superView:viewHandler.superView layoutSizeNameType:kLayoutWidth layoutSizeValueType:(AUILayoutSizeValueType)[[[self dictForTypeOfView] objectForKey:[NSString stringWithFormat:@"%s", attribute->value]] integerValue]];
                        break;
                    case kLayoutHeight:
                        [self setLayoutSizeForView:view superView:viewHandler.superView layoutSizeNameType:kLayoutHeight layoutSizeValueType:(AUILayoutSizeValueType)[[[self dictForTypeOfView] objectForKey:[NSString stringWithFormat:@"%s", attribute->value]] integerValue]];
                        break;
                        
                    default:
                        break;
                }
                
                NSLog(@"%@ %@",[NSString stringWithFormat:@"%s", attribute->name],[NSString stringWithFormat:@"%s", attribute->value]);
                attribute = attribute->next;
            }
            break;
        }
        case kWebViewLayout :
        case kListViewLayout :
        case kGridViewLayout :
        default:
            break;
    }
    return viewToBeReturn;
}

+ (void)setLayoutSizeForView:(UIView *)view superView:(UIView *)superView layoutSizeNameType:(AUILayoutSizeNameType)nameType layoutSizeValueType:(AUILayoutSizeValueType)valueType{
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    switch (nameType) {
        case kLayoutWidth:
            switch (valueType) {
                case kMatchParent:
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
                case kWrapContent:
                    
                    break;
                    
                default:
                    break;
            }
            break;
        case kLayoutHeight:
            switch (valueType) {
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
                    
                    break;
                    
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

/*   for (NSString *aKey in subViewDict)
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
