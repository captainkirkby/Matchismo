//
//  PlayingCard.m
//  Matchismo
//
//  Created by Dylan Kirkby on 1/29/13.
//  Copyright (c) 2013 DKLabs. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if(otherCards.count == 1)
    {
        PlayingCard *otherCard = [otherCards lastObject];
        if([otherCard.suit isEqualToString:self.suit])
        {
            score += 1;
        }
        else if(otherCard.rank == self.rank)
        {
            score += 4;
        }
    }
    else if(otherCards.count == 2)
    {
        PlayingCard *otherCardOne = [otherCards objectAtIndex:0];
        PlayingCard *otherCardTwo = [otherCards objectAtIndex:1];
        
        if([otherCardOne.suit isEqualToString:self.suit] && [otherCardTwo.suit isEqualToString:self.suit])
        {
            score += 2;
        }
        else if(otherCardOne.rank == self.rank && otherCardTwo.rank == self.rank)
        {
            score += 8;
        }
        else
        {
            score += [self match:@[otherCardOne]];
            score += [self match:@[otherCardTwo]];
            score += [otherCardOne match:@[otherCardTwo]];

        }
    }
    
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;
+ (NSArray *)validSuits
{
    return @[@"♣",@"♥",@"♦",@"♠"];
}
+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}
+ (NSInteger)maxRank
{
    return [PlayingCard rankStrings].count-1;
}
- (void)setSuit:(NSString *)suit
{
    if([[PlayingCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}
- (NSString *)suit
{
    return _suit ? _suit : @"?";
}
- (void)setRank:(NSInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
