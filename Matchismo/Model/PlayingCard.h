//
//  PlayingCard.h
//  Matchismo
//
//  Created by Dylan Kirkby on 1/29/13.
//  Copyright (c) 2013 DKLabs. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSInteger rank;

+ (NSArray *)validSuits;
+ (NSInteger)maxRank;

@end
