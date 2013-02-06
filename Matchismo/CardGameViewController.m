//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Dylan Kirkby on 1/29/13.
//  Copyright (c) 2013 DKLabs. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameSelector;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if(!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                          withDeck:[[PlayingCardDeck alloc] init]
                                                      withTwoCards:YES];
    return _game;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.historySlider.value = self.historySlider.maximumValue;
    
    UIImage *cardBackImage = [UIImage imageNamed:@"cardBack.png"];
    UIImage *blank = [[UIImage alloc] init];
    
    for(UIButton *cardButton in self.cardButtons)
    {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        [cardButton setImage:blank forState:UIControlStateSelected];
        [cardButton setImage:blank forState:UIControlStateSelected|UIControlStateDisabled];
        [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
    }
}

- (void)updateUI
{
    for(UIButton *cardButton in self.cardButtons)
    {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        
        cardButton.alpha = cardButton.enabled ? 1.0 : 0.3;
    }
    
    if(self.game.history.count) self.historySlider.maximumValue = self.game.history.count;
    [self.historySlider setValue:self.historySlider.maximumValue animated:NO];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.lastFlipLabel.text = self.game.lastFlipDescription;
}


- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipCount];
}
- (IBAction)deal
{
    self.game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count withDeck:[[PlayingCardDeck alloc] init] withTwoCards:self.game.twoCards];
    self.flipCount = 0;
    [self.gameSelector setEnabled:YES];
    [self updateUI];
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.gameSelector setEnabled:NO];
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}

//precondition: no cards have been flipped & score and flips are zeroed out.
- (IBAction)gameSwitched:(UISegmentedControl*)sender
{
    NSString *gameMode =[sender titleForSegmentAtIndex:[sender selectedSegmentIndex]];
    
    //2 card matching mode
    if([gameMode isEqualToString:@"2"])
    {
        self.game.twoCards = YES;
    }
    //3 card matching mode
    else if([gameMode isEqualToString:@"3"])
    {
        self.game.twoCards = NO;
    }
}
- (IBAction)sliderMoved
{
    NSString *labelText = self.lastFlipLabel.text;
    int nearestValue = floorf(self.historySlider.value);
    if(self.historySlider.value == self.historySlider.maximumValue) nearestValue--;
    
    NSLog(@"Slider at: %i", nearestValue);

    if(self.game.history.count)labelText = self.game.history[nearestValue];
    
    
    self.lastFlipLabel.text = labelText;
}

@end
