//
//  Card.h
//  Matchismo
//
//  Created by Dylan Kirkby on 1/29/13.
//  Copyright (c) 2013 DKLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter=isFaceUp) BOOL faceUp;
@property (nonatomic, getter=isUnplayable) BOOL unplayable;

- (int)match:(NSArray *)otherCards;

@end
