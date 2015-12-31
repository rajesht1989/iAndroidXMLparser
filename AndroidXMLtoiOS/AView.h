//
//  ViewController.h
//  AndroidXMLtoiOS
//
//  Created by Rajesh on 11/23/15.
//  Copyright © 2015 Org. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AViewHandlerDelegate <UITextFieldDelegate>
@required
- (void)buttonAction:(UIButton *)button;
@end
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
@interface AViewHandler : NSObject
@property (nonatomic, weak)UIView *superView;
@property (nonatomic, weak)id <AViewHandlerDelegate>owner;
@property (nonatomic, assign)UIView *relationView; //Can be a Sibling/Superview/Subview
@property (nonatomic, assign)AItemPosition position; 
@property (nonatomic, strong)NSMutableDictionary *attributeDict;

- (instancetype)copyHandler;

@end

@interface UIView (AView)
+ (UIView *)viewForXml:(NSString *)xmlName andHandler:(AViewHandler *)viewHandler;
@end

