//
//  Card.m
//  Matchismo
//
//  Created by Dylan Kirkby on 1/29/13.
//  Copyright (c) 2013 DKLabs. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for(Card *card in otherCards)
    {
        if([self.contents isEqualToString:card.contents])
        {
            score = 1;
        }
    }
    
    return score;
}

@end
