//
//  XMLReader.h
//  AndroidXMLtoiOS
//
//  Created by Rajesh on 11/25/15.
//  Copyright © 2015 Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLReader : NSObject
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError *errorPointer;
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)errorPointer;

@end