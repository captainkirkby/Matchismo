//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Dylan Kirkby on 2/3/13.
//  Copyright (c) 2013 DKLabs. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSMutableArray *descriptionHistory;
@property (nonatomic) int score;
@end

@implementation CardMatchingGame

- (NSMutableArray *)descriptionHistory
{
    if(!_descriptionHistory) _descriptionHistory = [[NSMutableArray alloc] init];
    return _descriptionHistory;
}

- (NSArray *)history
{
    return [self.descriptionHistory copy];
}

- (NSString *)lastFlipDescription
{
    if(!_lastFlipDescription) _lastFlipDescription = [[NSString alloc] init];
    return _lastFlipDescription;
}

- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSInteger)cardCount withDeck:(Deck *)deck withTwoCards:(BOOL)twoCards
{
    self = [super init];
    
    if(self)
    {
        for(int i=0;i<cardCount;i++)
        {
            Card *card = [deck drawRandomCard];
            if(!card)
            {
                self = nil;
            }
            else
            {
                self.cards[i] = card;
            }
        }
        self.matchBonus = 4;
        self.mismatchPenalty = 2;
        self.flipCost = 1;
        self.twoCards = twoCards;
    }
    return self;
}

- (void)flipCardAtIndex:(NSInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if(!card.isFaceUp) self.lastFlipDescription = [NSString stringWithFormat:@"Flipped up %@",card.contents];
    if(card.isFaceUp) self.lastFlipDescription = [NSString stringWithFormat:@"Flipped down %@",card.contents];
    
    if(card && !card.isUnplayable)
    {
        if(!card.isFaceUp)
        {
            //see if flipping creates a match
            if(self.twoCards)
            {
                for(Card *otherCard in self.cards)
                {
                    if(otherCard.isFaceUp && !otherCard.isUnplayable)
                    {
                        int matchScore = [card match:@[otherCard]];
                        if(matchScore)
                        {
                            otherCard.unplayable = YES;
                            card.unplayable = YES;
                            self.score += matchScore * self.matchBonus;
                            self.lastFlipDescription = [NSString stringWithFormat:@"Matched %@ and %@ for %i points", card.contents, otherCard.contents, matchScore * self.matchBonus];
                        }
                        else
                        {
                            otherCard.faceUp = NO;
                            self.score -= self.mismatchPenalty;
                            self.lastFlipDescription = [NSString stringWithFormat:@"%@ and %@ don't match! %i point penalty",card.contents,otherCard.contents,self.mismatchPenalty];
                        }
                        break;
                    }
                }
            }
            else if(!self.twoCards)
            {
                Card *firstCard;
                Card *secondCard;
                for(Card *otherCard in self.cards)
                {
                    if(otherCard.isFaceUp && !otherCard.isUnplayable && !firstCard)
                    {
                        firstCard = otherCard;
                    }
                    if(otherCard.isFaceUp && !otherCard.isUnplayable && firstCard && otherCard != firstCard)
                    {
                        secondCard = otherCard;
                    }
                }
                //play the game
                if(secondCard)
                {
                    NSLog(@"3 flipped cards! %@ %@ %@", card.contents,firstCard.contents,secondCard.contents);
                    int matchScore = [card match:@[firstCard,secondCard]];
                    if(matchScore)
                    {
                        firstCard.unplayable = YES;
                        secondCard.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore * self.matchBonus;
                        self.lastFlipDescription = [NSString stringWithFormat:@"Matched %@, %@ and %@ for %i points", card.contents, firstCard.contents, secondCard.contents, matchScore * self.matchBonus];
                    }
                    else
                    {
                        firstCard.faceUp = NO;
                        secondCard.faceUp = NO;
                        self.score -= self.mismatchPenalty;
                        self.lastFlipDescription = [NSString stringWithFormat:@"%@, %@ and %@ don't match! %i point penalty",card.contents,firstCard.contents, secondCard.contents,self.mismatchPenalty];
                    }
                }
            }
            
            self.score -= self.flipCost;
        }
        card.faceUp = !card.isFaceUp;
    }
    [self.descriptionHistory addObject:self.lastFlipDescription];
}

- (Card *)cardAtIndex:(NSInteger)index
{
    return (index < self.cards.count ? self.cards[index] : nil);
}

@end
