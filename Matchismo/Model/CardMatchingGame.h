//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Dylan Kirkby on 2/3/13.
//  Copyright (c) 2013 DKLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (readonly, nonatomic) int score;
@property (nonatomic) NSString *lastFlipDescription;
@property (nonatomic) NSInteger matchBonus;
@property (nonatomic) NSInteger mismatchPenalty;
@property (nonatomic) NSInteger flipCost;
@property (nonatomic) BOOL twoCards;


- (NSArray *)history;

- (id)initWithCardCount:(NSInteger)cardCount
               withDeck:(Deck *)deck
           withTwoCards:(BOOL) twoCards;

- (void)flipCardAtIndex:(NSInteger) index;

- (Card *)cardAtIndex:(NSInteger) index;

@end
