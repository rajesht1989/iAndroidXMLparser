//
//  AndroidView.m
//  AndroidXMLtoiOS
//
//  Created by Rajesh on 1/7/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import "AndroidView.h"

@interface AndroidView () {
    TBXML *rootXML;
}

@property (nonatomic, assign) BOOL isTextConfigured;
@property (nonatomic, assign)TBXML *rootXML;

@end

@implementation AndroidView

+ (instancetype)viewForXMLFileName:(NSString *)xmlName andHandler:(AndroidViewHandler *)handler {
    if (!xmlName) {
        TBXML *tbxml = [TBXML tbxmlWithXMLData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fbfeed.xml" ofType:nil]] error:nil];
        AndroidView *view = [self viewForElement:tbxml.rootXMLElement handler:handler];
        [view setRootXML:tbxml];
        return view;
    }
    
    NSError *error = nil;
    TBXML *tbxml = [TBXML tbxmlWithXMLData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:xmlName ofType:nil]] error:&error];
    if (tbxml.rootXMLElement == NULL) {
        return nil;
    }
    NSMutableDictionary *dataDictCollection;
    NSMutableDictionary *onRightSwipeMenuDictCollection;
    NSMutableDictionary *onLeftSwipeMenuDictCollection;
    TBXMLElement *zml = tbxml.rootXMLElement;
    if ([[TBXML elementName:zml] isEqualToString:@"zml"]) {
        TBXMLElement *head = zml->firstChild;
        if ([[TBXML elementName:head] isEqualToString:@"head"]) {
            TBXMLElement *headElements  = head->firstChild;
            dataDictCollection  = [NSMutableDictionary dictionary];
            onRightSwipeMenuDictCollection  = [NSMutableDictionary dictionary];
            onLeftSwipeMenuDictCollection  = [NSMutableDictionary dictionary];
            while (headElements) {
                if ([[TBXML elementName:headElements] isEqualToString:@"datalist"]) {
                    NSMutableArray *dataArray = [NSMutableArray array];
                    [dataDictCollection setObject:dataArray forKey:[TBXML attributeValue:headElements->firstAttribute]];
                    TBXMLElement *dataElement  = headElements->firstChild;
                    while (dataElement) {
                        NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
                        if ([[TBXML elementName:dataElement] isEqualToString:@"data"]) {
                            TBXMLAttribute * dataAttribute =  dataElement->firstAttribute;
                            while (dataAttribute) {
                                [dataDict setObject:[TBXML attributeValue:dataAttribute] forKey:[TBXML attributeName:dataAttribute]];
                                dataAttribute = dataAttribute->next;
                            }
                        }
                        [dataArray addObject:dataDict];
                        dataElement = dataElement->nextSibling;
                    }
                } else if ([[TBXML elementName:headElements] isEqualToString:@"onrightswipemenu"]) {
                    NSMutableArray *rightSwipeArray = [NSMutableArray array];
                    [onRightSwipeMenuDictCollection setObject:rightSwipeArray forKey:[TBXML attributeValue:headElements->firstAttribute]];
                    TBXMLElement *rightSwipeElement  = headElements->firstChild;
                    while (rightSwipeElement) {
                        NSMutableDictionary *swipeDict = [NSMutableDictionary dictionary];
                        if ([[TBXML elementName:rightSwipeElement] isEqualToString:@"onswipe"]) {
                            TBXMLAttribute * dataAttribute =  rightSwipeElement->firstAttribute;
                            while (dataAttribute) {
                                [swipeDict setObject:[TBXML attributeValue:dataAttribute] forKey:[TBXML attributeName:dataAttribute]];
                                dataAttribute = dataAttribute->next;
                            }
                        }
                        [rightSwipeArray addObject:swipeDict];
                        rightSwipeElement = rightSwipeElement->nextSibling;
                    }
                } else if ([[TBXML elementName:headElements] isEqualToString:@"onleftswipemenu"]) {
                    NSMutableArray *leftSwipeArray = [NSMutableArray array];
                    [onLeftSwipeMenuDictCollection setObject:leftSwipeArray forKey:[TBXML attributeValue:headElements->firstAttribute]];
                    TBXMLElement *dataElement  = headElements->firstChild;
                    while (dataElement) {
                        NSMutableDictionary *swipeDict = [NSMutableDictionary dictionary];
                        if ([[TBXML elementName:dataElement] isEqualToString:@"onswipe"]) {
                            TBXMLAttribute * dataAttribute =  dataElement->firstAttribute;
                            while (dataAttribute) {
                                [swipeDict setObject:[TBXML attributeValue:dataAttribute] forKey:[TBXML attributeName:dataAttribute]];
                                dataAttribute = dataAttribute->next;
                            }
                        }
                        [leftSwipeArray addObject:swipeDict];
                        dataElement = dataElement->nextSibling;
                    }
                }
                headElements = headElements->nextSibling;
            }
        }
        TBXMLElement *body = zml->firstChild->nextSibling;
        if ([[TBXML elementName:body] isEqualToString:@"body"]) {
            TBXMLElement *layout = body->firstChild;
            AndroidView *view = [self viewForElement:layout handler:handler];
            [view setDataDictCollection:dataDictCollection];
            [view setOnRightSwipeMenuDictCollection:onRightSwipeMenuDictCollection];
            [view setOnLeftSwipeMenuDictCollection:onLeftSwipeMenuDictCollection];
            [view setRootXML:tbxml];
            return view;
        }
        

    }
    return nil;
}

+ (instancetype)viewForXml:(NSString *)xmlString andHandler:(AndroidViewHandler *)handler {
    NSError *error = nil;
    TBXML *tbxml = [TBXML tbxmlWithXMLString:xmlString error:&error];
    if (tbxml.rootXMLElement == NULL) {
        return nil;
    }
    TBXMLElement *element = tbxml.rootXMLElement;
    AndroidView *view = [self viewForElement:element handler:handler];
    [view setRootXML:tbxml];
    return view;
}

+ (instancetype)viewForElement:(TBXMLElement *)element handler:(AndroidViewHandler *)handler {
    AndroidView *view = [self entityFor:element handler:handler];
    [view configureLayout];
    return view;
}

+ (id)entityFor:(TBXMLElement *)element handler:(AndroidViewHandler *)handler {
    AndroidView *view = [[self alloc] initWithElement:element handler:handler];
    [handler.superView addSubview:view];
    return view;
}

- (TBXML *)rootXML{
    return rootXML;
}
- (void)setRootXML:(TBXML *)rootXMLLocal {
    rootXML = rootXMLLocal;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n Object - %p Identifier - %@  \n Frame - %@ \n Objectype - %@ \n Arrributes %@ \n Subviews - %@  \n SubviewDict - %@ \n\n",self, _identifier, NSStringFromCGRect(self.frame),[self objectTypePrettyPrinted],_elementDict,[self subviews],_subviewDict];
}

- (NSString *)objectTypePrettyPrinted {
    NSString *objType = @"";
    switch (self.objectType) {
        case kLinearLayout :
            objType = @"LinearLayout";
            break;
        case kRelativeLayout :
            objType = @"RelativeLayout";
            break;
        case kWebViewLayout :
            objType = @"WebViewLayout";
            break;
        case kListViewLayout :
            objType = @"ListViewLayout";
            break;
        case kGridViewLayout :
            objType = @"GridViewLayout";
            break;
        case kScrollView :
            objType = @"ScrollView";
            break;
        case kHorizontalScrollView :
            objType = @"HorizontalScrollView";
            break;
        case kButton :
            objType = @"Button";
            break;
        case kTextField :
            objType = @"TextField";
            break;
        case kTextView :
            objType = @"TextView";
            break;
        case kImageView :
            objType = @"ImageView";
            break;
        default:
            break;
    }
    return objType;
}

- (UIView *)androidSuperview {
    return self.parentView.foregroundView ? self.parentView.foregroundView :self.superview;
}

- (instancetype)initWithElement:(TBXMLElement *)element handler:(AndroidViewHandler *)handler {
    if (self = [super init]) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        if (!handler.superParentView) {
            [handler setSuperParentView:self];
        }
        [self setSuperParentView:handler.superParentView];
        [self setOwner:handler.owner];
        
        do {
            [self setElement:element];
            [self setObjectType:[[[self.class dataDictionary] objectForKey:[[TBXML elementName:element] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] intValue]];
            [self setClipsToBounds:YES];
            switch (self.objectType) {
                case kScrollView : {
                    UIScrollView *scrollView = [[UIScrollView alloc] init];
                    [self addSubview:scrollView];
                    
                    TBXMLAttribute *attribute = element->firstAttribute;
                    AndroidViewHandler *subviewHandler = [handler copyHandler];
                    [subviewHandler setSuperView:scrollView];
                    [self configureView:scrollView attribute:attribute handler:subviewHandler];
                    
                    AndroidView *view = [self.class entityFor:element->firstChild handler:subviewHandler];
                    [view setParentView:self];
                }
                    break;
                case kHorizontalScrollView : {
                    UIScrollView *scrollView = [[UIScrollView alloc] init];
                    [self addSubview:scrollView];
                    TBXMLAttribute *attribute = element->firstAttribute;
                    [self configureView:scrollView attribute:attribute handler:handler];
                    AndroidViewHandler *subviewHandler = [handler copyHandler];
                    [subviewHandler setSuperView:scrollView];
                    
                    AndroidView *view = [self.class entityFor:element->firstChild handler:subviewHandler];
                    [view setParentView:self];
                }
                    break;
                case kLinearLayout : {
                    UIView *view = [[UIView alloc] init];
                    [self addSubview:view];
                    [self configureView:view attribute:element->firstAttribute handler:handler];
                    [self setLinearLayoutType:_linearLayoutType ==  kLinearVerticalLayout ? kLinearVerticalLayout : kLinearHorizontalLayout];
                    
                    TBXMLElement *child = element->firstChild;
                    AndroidViewHandler *subviewHandler = [handler copyHandler];
                    [subviewHandler setSuperView:view];
                    AndroidView *previousView;
                    while (child) {
                        AndroidView *currentView = [self.class entityFor:child handler:subviewHandler];
                        [currentView setPreviousView:previousView];
                        [currentView setParentView:self];
                        previousView = currentView;
                        child = child->nextSibling;
                    }
                }
                    break;
                case kRelativeLayout : {
                    UIView *view = [[UIView alloc] init];
                    [self addSubview:view];
                    TBXMLAttribute *attribute = element->firstAttribute;
                    [self configureView:view attribute:attribute handler:handler];
                    
                    TBXMLElement *child = element->firstChild;
                    AndroidViewHandler *subviewHandler = [handler copyHandler];
                    [subviewHandler setSuperView:view];
                    AndroidView *previousView;
                    while (child) {
                        AndroidView *currentView = [self.class entityFor:child handler:subviewHandler];
                        [currentView setPreviousView:previousView];
                        [currentView setParentView:self];
                        previousView = currentView;
                        child = child->nextSibling;
                    }
                }
                    break;
                case kListViewLayout : {
                    UITableView *tableView = [[UITableView alloc] init];
                    [tableView setBackgroundColor:[UIColor clearColor]];
                    iOSTableviewAdapter *adapter = [self tableViewAdapter];
                    [tableView setDataSource:adapter];
                    [tableView setDelegate:adapter];
                    [adapter setTableView:tableView];
                    [tableView setRowHeight:UITableViewAutomaticDimension];
                    [tableView setEstimatedRowHeight:44.f];
                    [self addSubview:tableView];
                    [tableView registerClass:AndroidTableViewCell.class forCellReuseIdentifier:NSStringFromClass(AndroidTableViewCell.class)];
                    TBXMLAttribute *attribute = element->firstAttribute;
                    [self configureView:tableView attribute:attribute handler:handler];
                    [adapter setElement:element->firstChild];
                }
                    break;
                case kWebViewLayout :
                case kGridViewLayout :
                    break;
                case kButton : {
                    UIButton *button = [[UIButton alloc] init];
                    [self addSubview:button];
                    [button addTarget:handler.owner action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self configureView:button attribute:element->firstAttribute handler:handler];
                }
                    break;
                case kTextField : {
                    UITextField *textField = [[UITextField alloc] init];
                    [self addSubview:textField];
                    [textField setDelegate:handler.owner];
                    [self configureView:textField attribute:element->firstAttribute handler:handler];
                }
                    break;
                case kTextView : {
                    UILabel *label = [[UILabel alloc] init];
                    [self addSubview:label];
                    [label setNumberOfLines:0];
                    [self configureView:label attribute:element->firstAttribute handler:handler];
                }
                    break;
                case kImageView : {
                    UIImageView *imageView = [[UIImageView alloc] init];
                    [self addSubview:imageView];
                    [self configureView:imageView attribute:element->firstAttribute handler:handler];
                }
                    break;
                default:
                    element = element->firstChild;
                    break;
            }
        } while ([TBXML elementName:element] != NULL && !_foregroundView);

        /*
         [self.layer setBorderWidth:1.f];
         [self.layer setBorderColor:[[UIColor grayColor] CGColor]];
         */
        if (_foregroundView) {
            [self addConstraints:@[
                                   [NSLayoutConstraint constraintWithItem:_foregroundView
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0
                                                                 constant:_padding.paddingTop],
                                   
                                   [NSLayoutConstraint constraintWithItem:_foregroundView
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0
                                                                 constant:_padding.paddingLeft],
                                   
                                   [NSLayoutConstraint constraintWithItem:_foregroundView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-_padding.paddingBottom],
                                   
                                   [NSLayoutConstraint constraintWithItem:_foregroundView
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1
                                                                 constant:-_padding.paddingRight],
                                   ]];
        }
    }
    return self;
}

- (void)configureView:(UIView *)view attribute:(TBXMLAttribute *)attribute handler:(AndroidViewHandler *)handler {
    while (attribute) {
        NSLog(@"%@ %@",[TBXML attributeName:attribute],[TBXML attributeValue:attribute]);
        switch ([[[self.class dataDictionary] objectForKey:[TBXML attributeName:attribute]] integerValue]) {
            case kIdentifier:
                [self setIdentifier:[TBXML attributeValue:attribute]];
                break;
            case kSecureText :
                break;
            case kTextSize :
            case kTextStyle :
                [self configureTextStyleAndSize];
                break;
            case kAlpha :
                [self setAlpha:[[TBXML attributeValue:attribute] floatValue]];
                break;
            case kImageSrc :
            case kText :
                [self setContent:[TBXML attributeValue:attribute]];
                break;
            case kHintText :
                break;
            case kLayoutWeight :
                [self setFWeight:[[TBXML attributeValue:attribute] floatValue]];
                break;
            case kLayoutGravity :
                [self setGravity:[[[self.class dataDictionary] objectForKey:[TBXML attributeValue:attribute]] intValue]];
                break;
            case kBackGroundColor :
                [self setBackgroundColor:[self.class colorWithHexString:[TBXML attributeValue:attribute]]];
                break;
            case kTextColor :
                [self setForegroundColor:[TBXML attributeValue:attribute]];
                break;
            case kDividerColor :
                [self setDividerColor:[TBXML attributeValue:attribute]];
                break;
                case kCornerRadius:
                [self.layer setCornerRadius:[[TBXML attributeValue:attribute] floatValue]];
                [[self.foregroundView layer] setCornerRadius:[[TBXML attributeValue:attribute] floatValue]];
                [[self.foregroundView layer] setMasksToBounds:YES];
                break;
            case kDynamicContent :
                [self setIsDynamicContent:[[TBXML attributeValue:attribute] boolValue]];
                break;
            case kLayoutOrientation :
                [self setLinearLayoutType:[[[self.class dataDictionary] objectForKey:[TBXML attributeValue:attribute]] intValue]];
                break;
            case kMinWidth :
                [self setFMinWidth:[self.class pixels:[TBXML attributeValue:attribute]]];
                break;
            case kMinHeight :
                [self setFMinHeight:[self.class pixels:[TBXML attributeValue:attribute]]];
                break;
            case kMaxWidth :
                [self setFMaxWidth:[self.class pixels:[TBXML attributeValue:attribute]]];
                break;
            case kMaxHeight :
                [self setFMaxHeight:[self.class pixels:[TBXML attributeValue:attribute]]];
                break;
            case kLayoutWidth : {
                switch ([[[self.class dataDictionary] objectForKey:[TBXML attributeValue:attribute]] intValue]) {
                    case kMatchParent :
                    case kFillParent :
                        [self setWidthType:kMatchParent];
                        break;
                    case kWrapContent :
                        [self setWidthType:kWrapContent];
                        break;
                    default:
                        [self setWidthType:kCustom];
                        [self setFWidth:[self.class pixels:[TBXML attributeValue:attribute]]];
                        break;
                }
            }
                break;
            case kLayoutHeight : {
                switch ([[[self.class dataDictionary] objectForKey:[TBXML attributeValue:attribute]] intValue]) {
                    case kMatchParent :
                    case kFillParent :
                        [self setHeightType:kMatchParent];
                        break;
                    case kWrapContent :
                        [self setHeightType:kWrapContent];
                        break;
                    default:
                        [self setHeightType:kCustom];
                        [self setFHeight:[self.class pixels:[TBXML attributeValue:attribute]]];
                        break;
                }
            }
                break;
            case kLayoutMargin : {
                CGFloat fMargin = [UIView pixels:[TBXML attributeValue:attribute]];
                [self setMargin:AndroidMarginMake(fMargin, fMargin, fMargin, fMargin)];
            }
                break;
            case kLayoutMarginTop :
                _margin.marginTop = [UIView pixels:[TBXML attributeValue:attribute]];
                break;
            case kLayoutMarginLeft :
                _margin.marginLeft = [UIView pixels:[TBXML attributeValue:attribute]];
                break;
            case kLayoutMarginBottom :
                _margin.marginBottom = [UIView pixels:[TBXML attributeValue:attribute]];
                break;
            case kLayoutMarginRight :
                _margin.marginRight = [UIView pixels:[TBXML attributeValue:attribute]];
                break;
            case kLayoutPadding : {
                CGFloat fPadding = [UIView pixels:[TBXML attributeValue:attribute]];
                [self setPadding:AndroidPaddingMake(fPadding, fPadding, fPadding, fPadding)];
            }
                break;
            case kLayoutPaddingTop :
                _padding.paddingTop = [UIView pixels:[TBXML attributeValue:attribute]];
                break;
            case kLayoutPaddingLeft :
                _padding.paddingLeft = [UIView pixels:[TBXML attributeValue:attribute]];
                break;
            case kLayoutPaddingBottom :
                _padding.paddingBottom = [UIView pixels:[TBXML attributeValue:attribute]];
                break;
            case kLayoutPaddingRight :
                _padding.paddingRight = [UIView pixels:[TBXML attributeValue:attribute]];
                break;
            //RelativeLayout related
            case kLayoutAbove :
                [self setLayoutAbove:[TBXML attributeValue:attribute]];
                break;
            case kLayoutBelow :
                [self setLayoutBelow:[TBXML attributeValue:attribute]];
                break;
            case kLayoutAlignBaseline :
                [self setLayoutAlignBaseLine:[TBXML attributeValue:attribute]];
                break;
            case kLayoutAlignBottom :
                [self setLayoutAlignBottom:[TBXML attributeValue:attribute]];
                break;
            case kLayoutAlignEnd :
                [self setLayoutAlignEnd:[TBXML attributeValue:attribute]];
                break;
            case kLayoutAlignLeft :
                [self setLayoutAlignLeft:[TBXML attributeValue:attribute]];
                break;
            case kLayoutAlignRight :
                [self setLayoutAlignRight:[TBXML attributeValue:attribute]];
                break;
            case kLayoutAlignStart :
                [self setLayoutAlignStart:[TBXML attributeValue:attribute]];
                break;
            case kLayoutAlignTop :
                [self setLayoutAlignTop:[TBXML attributeValue:attribute]];
                break;
            case kLayoutToEndOf :
                [self setLayoutToEndOf:[TBXML attributeValue:attribute]];
                break;
            case kLayoutToLeftOf :
                [self setLayoutToLeftOf:[TBXML attributeValue:attribute]];
                break;
            case kLayoutToRightOf :
                [self setLayoutToRightOf:[TBXML attributeValue:attribute]];
                break;
            case kLayoutToStartOf :
                [self setLayoutToStartOf:[TBXML attributeValue:attribute]];
                break;
            case kLayoutAlignParentBottom :
                [self setIsAlignParentBottom:[[TBXML attributeValue:attribute] boolValue]];
                break;
            case kLayoutAlignParentEnd :
                [self setIsAlignParentEnd:[[TBXML attributeValue:attribute] boolValue]];
                break;
            case kLayoutAlignParentLeft :
                [self setIsAlignParentLeft:[[TBXML attributeValue:attribute] boolValue]];
                break;
            case kLayoutAlignParentRight :
                [self setIsAlignParentRight:[[TBXML attributeValue:attribute] boolValue]];
                break;
            case kLayoutAlignParentStart :
                [self setIsAlignParentStart:[[TBXML attributeValue:attribute] boolValue]];
                break;
            case kLayoutAlignParentTop :
                [self setIsAlignParentTop:[[TBXML attributeValue:attribute] boolValue]];
                break;
            case kLayoutAlignWithParentIfMissing :
                [self setIsAlignWithparentIfMissing:[[TBXML attributeValue:attribute] boolValue]];
                break;
            case kLayoutCenterHorizontal :
                [self setIsAlignCenterHorizontal:[[TBXML attributeValue:attribute] boolValue]];
                break;
            case kLayoutCenterVertical :
                [self setIsAlignCenterVertical:[[TBXML attributeValue:attribute] boolValue]];
                break;
            case kLayoutCenterInParent :
                [self setIsAlignCenterInParent:[[TBXML attributeValue:attribute] boolValue]];
                break;
            default:
                break;
        }
        attribute = attribute->next;
    }
    NSLog(@"\n\n\n");
}

- (void)addSubview:(UIView *)view {
    [self setForegroundView:view];
    [super addSubview:view];
}

- (void)setElement:(TBXMLElement *)element {
    _element = element;
    TBXMLAttribute * attribute = element->firstAttribute;
    self.elementDict = [NSMutableDictionary dictionary];
    while (attribute) {
        [self.elementDict setObject:[TBXML attributeValue:attribute] forKey:[TBXML attributeName:attribute]];
        attribute = attribute->next;
    }
}

- (void)setForegroundView:(UIView *)foregroundView {
    _foregroundView = foregroundView;
    [_foregroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setParentView:(AndroidView *)parentView {
    _parentView = parentView;
    parentView.fTotalWeight +=  _fWeight;
    if(!_parentView.firstChildView) {
        _parentView.firstChildView = self;
    }
    if (_identifier) {
        [parentView.subviewDict setObject:self forKey:_identifier];
        [self.superParentView.subviewInSuperParentDict setObject:self forKey:_identifier];
    }
}

- (NSMutableDictionary *)subviewInSuperParentDict {
    if (!_subviewInSuperParentDict) {
        _subviewInSuperParentDict = [NSMutableDictionary dictionary];
    }
    return _subviewInSuperParentDict;
}

- (NSMutableDictionary *)subviewDict {
    if (!_subviewDict) {
        _subviewDict = [NSMutableDictionary dictionary];
    }
    return _subviewDict;
}

- (void)setPreviousView:(AndroidView *)previousView {
    _previousView = previousView;
    [previousView setNextView:self];
}

- (void)setContent:(NSString *)content {
    switch (_objectType) {
        case kButton :
            [_foregroundView setTitle:content forState:UIControlStateNormal];
            break;
        case kTextView :
            [_foregroundView setText:content];
            break;
        case kImageView :
            [_foregroundView setImage:[UIImage imageNamed:content]];
            /* [_foregroundView setImage:[UIImage imageNamed:@"abc"]]; */
            break;
        case kTextField :
            [_foregroundView setText:content];
            break;
        default:
            break;
    }
}

- (void)configureTextStyleAndSize {
    if (!_isTextConfigured) {
        [self setIsTextConfigured:YES];
        NSString *textSize = self.elementDict[@"android:textSize"];
        NSString *textStyle = self.elementDict[@"android:textStyle"];
        CGFloat fTextSize = [self.class pixels:textSize];
        UIFont *font = [UIFont systemFontOfSize:fTextSize ? fTextSize : 15.f];
        if (textStyle) {
            if ([textStyle containsString:@"bold"] && [textStyle containsString:@"italic"]) {
                UIFontDescriptorSymbolicTraits symbolicTraits =  UIFontDescriptorTraitItalic | UIFontDescriptorTraitBold;
                font = [UIFont fontWithDescriptor:[font.fontDescriptor fontDescriptorWithSymbolicTraits:symbolicTraits] size:0];
            } else if ([textStyle containsString:@"bold"]) {
                UIFontDescriptorSymbolicTraits symbolicTraits =   UIFontDescriptorTraitBold;
                font = [UIFont fontWithDescriptor:[font.fontDescriptor fontDescriptorWithSymbolicTraits:symbolicTraits] size:0];
            } else if ([textStyle containsString:@"italic"]) {
                UIFontDescriptorSymbolicTraits symbolicTraits =   UIFontDescriptorTraitItalic;
                font = [UIFont fontWithDescriptor:[font.fontDescriptor fontDescriptorWithSymbolicTraits:symbolicTraits] size:0];
            } else {
                font = [UIFont systemFontOfSize:fTextSize];
            }
        }
        else {
            font = [UIFont systemFontOfSize:fTextSize];
        }
        switch (_objectType) {
            case kButton:
                [[_foregroundView titleLabel] setFont:font];
                break;
            case kTextView:
            case kTextField:
                [_foregroundView setFont:font];
                break;
            default:
                break;
        }
    }
}

- (void)setForegroundColor:(NSString *)fgColor {
    switch (_objectType) {
        case kButton :
            [_foregroundView setTitleColor:[self.class colorWithHexString:fgColor] forState:UIControlStateNormal];
            break;
        case kTextView :
        case kTextField :
            [_foregroundView setTextColor:[self.class colorWithHexString:fgColor]];
            break;
        default:
            break;
    }
}

- (void)setDividerColor:(NSString *)dividerColor {
    switch (_objectType) {
        case kListViewLayout :
            [(UITableView *)_foregroundView setSeparatorColor:[self.class colorWithHexString:dividerColor]];
            break;
        case kTextView :
        case kTextField :
            break;
        default:
            break;
    }
}
- (void)setGravity:(AUILayoutGravityValueType)type {
    switch (_objectType) {
        case kButton :
            break;
        case kTextView :
        case kTextField : {
            switch (type) {
                case kCenter:
                    [_foregroundView setTextAlignment:NSTextAlignmentCenter];
                    break;
            }
            break;
        default:
            break;
    }
    }
}

- (iOSTableviewAdapter *)tableViewAdapter {
    if (!_tableViewAdapter) {
        _tableViewAdapter = [[iOSTableviewAdapter alloc] init];
    }
    return _tableViewAdapter;
}

- (void)configureLayout {
    [self setDefaultLayout];
    AndroidView *childView = [self firstChildView];
    while (childView) {
        [childView configureLayoutAsPerSuperView];
        childView = childView.nextView;
    }
}

- (void)setDefaultLayout {
    UIView *superView = [self androidSuperview];
    switch (self.widthType) {
        case kFillParent :
        case kMatchParent :
            [self setLeadingMargin:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1 constant:self.margin.marginLeft]];
            [self setTrailingMargin:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-self.margin.marginRight]];
            [superView addConstraints:@[_leadingMargin, _trailingMargin]];
            break;
        case kWrapContent :
            [self setLeadingMargin:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1 constant:self.margin.marginLeft]];
            [self setTrailingMargin:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:superView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-self.margin.marginRight]];
            [superView addConstraints:@[_leadingMargin, _trailingMargin]];
            break;
        case kCustom:
            [self setLeadingMargin:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1 constant:self.margin.marginLeft]];
            [superView addConstraints:@[_leadingMargin]];
            [self setWidthConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.fWidth]];
            [self addConstraint:_widthConstraint];
            break;
        default:
            break;
    }
    
    switch (self.heightType) {
        case kFillParent :
        case kMatchParent :
            [self setTopMargin:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:self.margin.marginTop]];
            [self setBottomMargin:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1 constant:self.margin.marginBottom]];
            [superView addConstraints:@[_topMargin, _bottomMargin]];
            break;
        case kWrapContent :
            [self setTopMargin:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:self.margin.marginTop]];
            [self setBottomMargin:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1 constant:-self.margin.marginBottom]];
            [superView addConstraints:@[_topMargin, _bottomMargin]];
            break;
        case kCustom:
            [self setTopMargin:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:self.margin.marginTop]];
            [self setBottomMargin:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1 constant:-self.margin.marginBottom]];
            [superView addConstraints:@[_topMargin, _bottomMargin]];
            [self setHeightConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.fHeight]];
            [self addConstraint:_heightConstraint];
            break;
        default:
            break;
    }
    
    if (self.fMinWidth) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.fMinWidth]];
    }
    if (self.fMinHeight) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.fMinHeight]];
    }
    
    if (self.fMaxWidth) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.fMaxWidth]];
    }
    if (self.fMaxHeight) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.fMaxHeight]];
    }
}

- (void)configureLayoutAsPerSuperView {
    AndroidView *parentView = self.parentView;
    if (!parentView || ![parentView isKindOfClass:[AndroidView class]]) return;
    switch (parentView.objectType) {
        case kLinearLayout: {
            switch (parentView.linearLayoutType) {
                case kLinearVerticalLayout :
                    [self.class configureVerticalLinearLayoutForView:self];
                    break;
                case kLinearHorizontalLayout :
                    [self.class configureHorizontalLinearLayoutForView:self];
                    break;
                default:
                    break;
            }
        }
            break;
        case kScrollView :
            [self.class configureScrollViewForView:self];
            break;
        case kHorizontalScrollView :
            [self.class configureHorizontalScrollViewForView:self];
            break;
        case kRelativeLayout :
            [self.class configureRelativeLayoutForView:self];
        default:
            break;
    }
}

+ (void)configureVerticalLinearLayoutForView:(AndroidView*) androidView {
    UIView *superView = [androidView androidSuperview];
    AndroidView *previousView = androidView.previousView;
    AndroidView *nextView = androidView.nextView;
    AndroidView *parentView = [androidView parentView];

    switch (androidView.widthType) {
        case kFillParent :
        case kMatchParent :
            [superView addConstraints:@[
                                        [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1 constant:androidView.margin.marginLeft],
                                        [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-androidView.margin.marginRight]
                                        ]];
            break;
        case kWrapContent :
            [superView addConstraints:@[
                                        [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1 constant:androidView.margin.marginLeft],
                                        [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:superView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-androidView.margin.marginRight]
                                        ]];
            break;
        case kCustom:
            [superView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1 constant:androidView.margin.marginLeft]];
            [androidView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:androidView.fWidth]];
            break;
        default:
            break;
    }
    
    switch (androidView.heightType) {
        case kFillParent :
        case kMatchParent :
            if (previousView) {
                [superView addConstraints:@[
                                            [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1 constant:androidView.margin.marginTop + previousView.margin.marginBottom],
                                            [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1 constant:androidView.margin.marginBottom]
                                            ]];
            } else {
                [superView addConstraints:@[
                                            [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:androidView.margin.marginTop],
                                            [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1 constant:androidView.margin.marginBottom]
                                            ]];
            }
            
            break;
        case kWrapContent :
            if (previousView) {
                [superView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1 constant:androidView.margin.marginTop + previousView.margin.marginBottom]];
            } else {
                [superView addConstraints:@[
                                            [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:androidView.margin.marginTop]]];
            }
            if (!nextView && parentView.heightType == kWrapContent) {
                [superView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1 constant:-androidView.margin.marginBottom]];
            }
            break;
        case kCustom:
            if (previousView) {
                [superView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1 constant:androidView.margin.marginTop + previousView.margin.marginBottom]];
                
            } else {
                [superView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:androidView.margin.marginTop]];
            }
            [androidView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:androidView.fHeight]];
            if (!nextView) {
                [superView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1 constant:-androidView.margin.marginBottom]];
            }
            break;
        default:
            break;
    }
    
    if (androidView.fMinWidth) {
        [androidView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:androidView.fMinWidth]];
    }
    if (androidView.fMinHeight) {
        [androidView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:androidView.fMinHeight]];
    }
    
    if (androidView.fMaxWidth) {
        [androidView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:androidView.fMaxWidth]];
    }
    if (androidView.fMaxHeight) {
        [androidView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:androidView.fMaxHeight]];
    }
    
    if (androidView.fWeight) {
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeHeight multiplier:androidView.fWeight/parentView.fTotalWeight constant:0]];
    }
    
    AndroidView *childView = [androidView firstChildView];
    while (childView) {
        [childView configureLayoutAsPerSuperView];
        childView = childView.nextView;
    }
}

+ (void)configureHorizontalLinearLayoutForView:(AndroidView*) androidView {
    UIView *superView = [androidView androidSuperview];
    AndroidView *previousView = androidView.previousView;
    AndroidView *nextView = androidView.nextView;
    AndroidView *parentView = [androidView parentView];

    switch (androidView.widthType) {
        case kFillParent :
        case kMatchParent :
            if (previousView) {
                [superView addConstraints:@[
                                            [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeTrailing multiplier:1 constant:previousView.margin.marginRight + androidView.margin.marginLeft],
                                            [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-androidView.margin.marginRight]
                                            ]];
            } else {
                [superView addConstraints:@[
                                            [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1 constant:androidView.margin.marginLeft],
                                            [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-androidView.margin.marginRight]
                                            ]];
            }
            
            break;
        case kWrapContent :
            if (previousView) {
                [superView addConstraints:@[
                                            [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeTrailing multiplier:1 constant:previousView.margin.marginRight + androidView.margin.marginLeft]
                                            ]];
            } else {
                [superView addConstraints:@[
                                            [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1 constant:androidView.margin.marginLeft]
                                            ]];
            }
            
            if(!nextView && parentView.widthType == kWrapContent) {
                [superView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:superView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-androidView.margin.marginRight]];
            }
            break;
        case kCustom:
            if (previousView) {
                [superView addConstraints:@[
                                            [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-(previousView.margin.marginRight + androidView.margin.marginLeft)],
                                            ]];
                [androidView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:androidView.fWidth]];
            } else {
                [superView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1 constant:androidView.margin.marginLeft]];
                [androidView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:androidView.fWidth]];
            }
            break;
        default:
            break;
    }
    
    switch (androidView.heightType) {
        case kFillParent :
        case kMatchParent :
            [superView addConstraints:@[
                                        [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:androidView.margin.marginTop],
                                        [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1 constant:-androidView.margin.marginBottom]
                                        ]];
            break;
        case kWrapContent :
            [superView addConstraints:@[
                                        [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:androidView.margin.marginTop],
                                        [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1 constant:-androidView.margin.marginBottom]
                                        ]];
            break;
        case kCustom:
            [superView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:androidView.margin.marginTop]];
            [androidView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:androidView.fHeight]];
            [superView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1 constant:-androidView.margin.marginBottom]];
            break;
        default:
            break;
    }
    
    if (androidView.fMinWidth) {
        [androidView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:androidView.fMinWidth]];
    }
    
    if (androidView.fMinHeight) {
        [androidView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:androidView.fMinHeight]];
    }
    
    if (androidView.fMaxWidth) {
        [androidView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:androidView.fMaxWidth]];
    }
    if (androidView.fMaxHeight) {
        [androidView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:androidView.fMaxHeight]];
    }
    
    if (androidView.fWeight) {
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeWidth multiplier:androidView.fWeight/parentView.fTotalWeight constant:0]];
    }
    
    AndroidView *childView = [androidView firstChildView];
    while (childView) {
        [childView configureLayoutAsPerSuperView];
        childView = childView.nextView;
    }
}

+ (void)configureScrollViewForView:(AndroidView *)androidView {
    [androidView configureLayout];
    [androidView.parentView.foregroundView addConstraint:[NSLayoutConstraint
                                                          constraintWithItem:androidView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                          toItem:androidView.parentView.foregroundView
                                                          attribute:NSLayoutAttributeWidth
                                                          multiplier:1.f
                                                          constant:0]];
    if (androidView.heightType == kMatchParent) {
        [androidView.parentView.foregroundView addConstraint:[NSLayoutConstraint
                                                              constraintWithItem:androidView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                              toItem:androidView.parentView.foregroundView
                                                              attribute:NSLayoutAttributeHeight
                                                              multiplier:1.f
                                                              constant:0]];
    }
}

+ (void)configureHorizontalScrollViewForView:(AndroidView *)androidView {
    [androidView configureLayout];
    [androidView.parentView.foregroundView addConstraint:[NSLayoutConstraint
                                                          constraintWithItem:androidView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                          toItem:androidView.parentView.foregroundView
                                                          attribute:NSLayoutAttributeHeight
                                                          multiplier:1.f
                                                          constant:0]];
    if (androidView.widthType == kMatchParent) {
        [androidView.parentView.foregroundView addConstraint:[NSLayoutConstraint
                                                              constraintWithItem:androidView
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                              toItem:androidView.parentView.foregroundView
                                                              attribute:NSLayoutAttributeWidth
                                                              multiplier:1.f
                                                              constant:0]];
    }
}

+ (void)configureRelativeLayoutForView:(AndroidView *)androidView  {
    UIView *superView = [androidView androidSuperview];
    AndroidView *parentView = [androidView parentView];
    [androidView setDefaultLayout];
    if(androidView.isAlignParentEnd || androidView.isAlignParentRight) {
        [androidView.trailingMargin setActive:NO];
        [androidView setTrailingMargin:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-androidView.margin.marginRight]];
        [superView addConstraint:androidView.trailingMargin];
        [androidView.leadingMargin setActive:NO];
        if (androidView.isAlignParentLeft || androidView.isAlignParentStart) {
            [androidView.leadingMargin setActive:YES];
        } else {
            [androidView setLeadingMargin:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1 constant:androidView.margin.marginLeft]];
            [superView addConstraint:androidView.leadingMargin];
        }
    }
    
    if (androidView.isAlignParentBottom) {
        [androidView.bottomMargin setActive:NO];
        [androidView setBottomMargin:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1 constant:-androidView.margin.marginBottom]];
        [superView addConstraint:androidView.bottomMargin];
        
        [androidView.topMargin setActive:NO];
        if (androidView.isAlignParentTop) {
            [androidView.topMargin setActive:YES];
        }
        else {
            [androidView setTopMargin:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:androidView.margin.marginTop]];
            [superView addConstraint:androidView.topMargin];
        }
    }
    
    if (androidView.layoutToStartOf || androidView.layoutToLeftOf) {
        NSString *rightViewId = androidView.layoutToStartOf;
        if (!rightViewId.length) {
            rightViewId = androidView.layoutToLeftOf;
        }
        AndroidView *rightView = [[parentView subviewDict] objectForKey:rightViewId];
        [androidView.trailingMargin setActive:NO];
        [androidView setTrailingMargin:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:rightView attribute:NSLayoutAttributeLeading multiplier:1 constant:androidView.margin.marginLeft + rightView.margin.marginRight]];
        [superView addConstraint:androidView.trailingMargin];
    }
    
    if (androidView.layoutToRightOf || androidView.layoutToEndOf) {
        NSString *leftViewId = androidView.layoutToRightOf;
        if (!leftViewId.length) {
            leftViewId = androidView.layoutToEndOf;
        }
        AndroidView *leftView = [[parentView subviewDict] objectForKey:leftViewId];
        [androidView.leadingMargin setActive:NO];
        [androidView setLeadingMargin:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeTrailing multiplier:1 constant:androidView.margin.marginLeft + parentView.margin.marginRight]];
        [superView addConstraint:androidView.leadingMargin];
    }
    
    if (androidView.layoutAlignStart || androidView.layoutAlignLeft) {
        NSString *alignViewId = androidView.layoutAlignStart;
        if (!alignViewId.length) {
            alignViewId = androidView.layoutAlignLeft;
        }
        AndroidView *alignView = [[parentView subviewDict] objectForKey:alignViewId];
        [androidView.leadingMargin setActive:NO];
        [androidView setLeadingMargin:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:alignView attribute:NSLayoutAttributeLeading multiplier:1 constant:androidView.margin.marginLeft + alignView.margin.marginRight]];
        [superView addConstraint:androidView.leadingMargin];
    }
    
    if (androidView.layoutAlignRight || androidView.layoutAlignEnd) {
        NSString *alignViewId = androidView.layoutAlignRight;
        if (!alignViewId.length) {
            alignViewId = androidView.layoutAlignEnd;
        }
        AndroidView *alignView = [[parentView subviewDict] objectForKey:alignViewId];
        [androidView.trailingMargin setActive:NO];
        [androidView setTrailingMargin:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:alignView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-(androidView.margin.marginRight + alignView.margin.marginLeft)]];
        [superView addConstraint:androidView.trailingMargin];
    }
    
    if (androidView.layoutAlignTop) {
        NSString *alignViewId = androidView.layoutAlignTop;
        AndroidView *alignView = [[parentView subviewDict] objectForKey:alignViewId];
        [androidView.topMargin setActive:NO];
        [androidView setTopMargin:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:alignView attribute:NSLayoutAttributeTrailing multiplier:1 constant:androidView.margin.marginTop]];
        [superView addConstraint:androidView.topMargin];
    }
    
    if (androidView.layoutAlignBottom) {
        NSString *alignViewId = androidView.layoutAlignBottom;
        AndroidView *alignView = [[parentView subviewDict] objectForKey:alignViewId];
        [androidView.bottomMargin setActive:NO];
        [androidView setBottomMargin:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:alignView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-androidView.margin.marginTop]];
        [superView addConstraint:androidView.bottomMargin];
    }
    
    if (androidView.isAlignCenterHorizontal) {
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        if (androidView.widthType == kWrapContent) {
            if (androidView.leadingMargin.secondItem == superView) {
                [androidView.leadingMargin setActive:NO];
                [androidView setLeadingMargin:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1 constant:androidView.margin.marginLeft]];
                [superView addConstraint:androidView.leadingMargin];
            }
            if (androidView.trailingMargin.secondItem == superView) {
                [androidView.trailingMargin setActive:NO];
                [androidView setTrailingMargin:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:superView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-androidView.margin.marginRight]];
                [superView addConstraint:androidView.trailingMargin];
            }
        }
    }
    
    if (androidView.isAlignCenterVertical) {
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        if (androidView.heightType == kWrapContent) {
            if (androidView.topMargin.secondItem == superView) {
                [androidView.topMargin setActive:NO];
                [androidView setTopMargin:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:androidView.margin.marginTop]];
                [superView addConstraint:androidView.topMargin];
            }
            if (androidView.bottomMargin.secondItem == superView) {
                [androidView.bottomMargin setActive:NO];
                [androidView setBottomMargin:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1 constant:-androidView.margin.marginBottom]];
                [superView addConstraint:androidView.bottomMargin];
            }
        }
    }
    
    if (androidView.isAlignCenterInParent) {
        [superView addConstraints:@[
                                    [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                                    [NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]
                                    ]];
        if (androidView.widthType == kWrapContent) {
            if (androidView.leadingMargin.secondItem == superView) {
                [androidView.leadingMargin setActive:NO];
                [androidView setLeadingMargin:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1 constant:androidView.margin.marginLeft]];
                [superView addConstraint:androidView.leadingMargin];
            }
            if (androidView.trailingMargin.secondItem == superView) {
                [androidView.trailingMargin setActive:NO];
                [androidView setTrailingMargin:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:superView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-androidView.margin.marginRight]];
                [superView addConstraint:androidView.trailingMargin];
            }
        }
        if (androidView.heightType == kWrapContent) {
            if (androidView.topMargin.secondItem == superView) {
                [androidView.topMargin setActive:NO];
                [androidView setTopMargin:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:androidView.margin.marginTop]];
                [superView addConstraint:androidView.topMargin];
            }
            if (androidView.bottomMargin.secondItem == superView) {
                [androidView.bottomMargin setActive:NO];
                [androidView setBottomMargin:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1 constant:-androidView.margin.marginBottom]];
                [superView addConstraint:androidView.bottomMargin];
            }
        }
    }
    
    AndroidView *childView = [androidView firstChildView];
    while (childView) {
        [childView configureLayoutAsPerSuperView];
        childView = childView.nextView;
    }
}

@end
