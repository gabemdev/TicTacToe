//
//  ViewController.m
//  TicTacToe
//
//  Created by Rockstar. on 3/12/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WebViewController.h"

typedef NS_ENUM(NSInteger, LabelPosition) {
    labelPositionTL = 0,
    labelPositionTM = 1,
    labelPositionTR = 2,
    labelPositionML = 3,
    labelPositionMM = 4,
    labelPositionMR = 5,
    labelPositionBL = 6,
    labelPositionBM = 7,
    labelPositionBR = 8
};

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
@property (weak, nonatomic) IBOutlet UILabel *labelFour;
@property (weak, nonatomic) IBOutlet UILabel *labelFive;
@property (weak, nonatomic) IBOutlet UILabel *labelSix;
@property (weak, nonatomic) IBOutlet UILabel *labelSeven;
@property (weak, nonatomic) IBOutlet UILabel *labelEight;
@property (weak, nonatomic) IBOutlet UILabel *labelNine;
@property (weak, nonatomic) IBOutlet UILabel *whichPlayerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeRemainingLabel;
@property (strong, nonatomic) IBOutlet UILabel *movedLabel;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;

@property NSArray *labelArray;
@property BOOL didWin;

@property NSTimer *timer;
@property NSInteger timeRemaining;
@property NSInteger turn;

@property CGPoint originPoint;
@property CGPoint finalPoint;

@property NSInteger currentPlayer;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    //Set label borders.
    [self setBorders];

    //Set initial label text and color
    self.whichPlayerLabel.text = @"X";
    self.whichPlayerLabel.textColor = [UIColor blueColor];

    //set Initial timer label text and color
    self.timeRemainingLabel.text = @"Time Remaining: 10";
    self.timeRemainingLabel.textColor = [UIColor greenColor];

    //Set originPoints point to the location of whichPlayer Label
    self.originPoint = self.whichPlayerLabel.frame.origin;


    //Set up timer, Set initial value of timer to 10.
    self.timeRemaining = 10;

    //Set timer with an interval of 1 second iterations using timeFireMethod(recommended by apple docs)
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(timeFireMethod:)
                                                userInfo:nil
                                                 repeats:YES];

    //Set the labelArray with all the labels.
    self.labelArray = @[self.labelOne, self.labelTwo, self.labelThree, self.labelFour, self.labelFive, self.labelSix, self.labelSeven, self.labelEight, self.labelNine];

    self.currentPlayer = 1;
}

#pragma mark - NSString
- (NSString *)whoWon {

    /* Winning Combinations: 
     1 2 3
     4 5 6
     7 8 9

     */
    NSString *setWinner;

    //1 2 3 solution
    [self checkWinnerwithLabelOne:self.labelOne labelTwo:self.labelTwo labelThree:self.labelThree setWinner:setWinner];

    // 1 4 7
    [self checkWinnerwithLabelOne:self.labelOne labelTwo:self.labelFour labelThree:self.labelSeven setWinner:setWinner];

    // 1 5 9
    [self checkWinnerwithLabelOne:self.labelOne labelTwo:self.labelFive labelThree:self.labelNine setWinner:setWinner];

    //2 5 8
    [self checkWinnerwithLabelOne:self.labelTwo labelTwo:self.labelFive labelThree:self.labelEight setWinner:setWinner];

    //3 5 7
    [self checkWinnerwithLabelOne:self.labelThree labelTwo:self.labelFive labelThree:self.labelSeven setWinner:setWinner];

    //3 6 9
    [self checkWinnerwithLabelOne:self.labelThree labelTwo:self.labelSix labelThree:self.labelNine setWinner:setWinner];

    //4 5 6
    [self checkWinnerwithLabelOne:self.labelFour labelTwo:self.labelFive labelThree:self.labelSix setWinner:setWinner];

    //7 8 9
    [self checkWinnerwithLabelOne:self.labelSeven labelTwo:self.labelEight labelThree:self.labelNine setWinner:setWinner];
    return setWinner;
}

//Custom method to check for winners.
- (void)checkWinnerwithLabelOne:(UILabel *)first labelTwo:(UILabel *)second labelThree:(UILabel *)third setWinner:(NSString *)winnerString {
    //Performs check for 3 labels matching X, if so, set the Winner string as X and show alert
    if ([first.text isEqualToString:@"X"] && [second.text isEqualToString:@"X"] && [third.text isEqualToString:@"X"]) {
        winnerString = @"X";
        self.didWin = YES;
         NSLog(@"Winner: %@ %@ %@, Final String:%@", first.text, second.text, third.text, winnerString);

        [self showAlertWithWinner:winnerString];

        //Same thing but with O
    } else if ([first.text isEqualToString:@"O"] && [second.text isEqualToString:@"O"] && [third.text isEqualToString:@"O"]) {
        winnerString = @"O";
        self.didWin = YES;
         NSLog(@"Winner: %@ %@ %@, Final String:%@", first.text, second.text, third.text, winnerString);
        [self showAlertWithWinner:winnerString];

    }

    else {
        self.didWin = NO;
    }

}

#pragma mark - Actions

- (IBAction)onLabelTapped:(UITapGestureRecognizer *)tapGestureRecognizer {
    //Set point for tapGesture recognizer's locatin in the view
    CGPoint point = [tapGestureRecognizer locationInView:self.view];

    //Create a label with the point of the label found using findLabelUsingPoint method.
    UILabel *locatedLabel = [self findLabelUsingPoint:point];

    //Change string depending on current player.
    if ([locatedLabel.text isEqualToString:@"X"]) {
//        self.whichPlayerLabel.text = @"O";
//        self.movedLabel.text = self.whichPlayerLabel.text;
//        self.movedLabel.textColor = self.whichPlayerLabel.textColor;
        self.currentPlayer = 2;
        [self computerPlay];
    } else if ([locatedLabel.text isEqualToString:@"O"]) {
        self.currentPlayer = 1;
        self.whichPlayerLabel.text = @"X";
        self.whichPlayerLabel.textColor = [UIColor blueColor];
        self.movedLabel.text = self.whichPlayerLabel.text;
        self.movedLabel.textColor = self.whichPlayerLabel.textColor;
    }

}

- (IBAction)onLabelMoved:(UIPanGestureRecognizer *)panGestureRecognizer {
    //Set CGPoint with panGesture's locatin in the view.
    self.originPoint = [panGestureRecognizer locationInView:self.view];

    //Set the center of the movable label to the above origin point.
    self.movedLabel.center = self.originPoint;

    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {

        // Iterate through label array
        for (UILabel *label in self.labelArray) {

            //If statement that sets the color and text of the moved label in the selected label.
            if (CGRectContainsPoint(label.frame, self.movedLabel.center)) {
                // Set the label text and color in the selected label.
                label.text = self.whichPlayerLabel.text;
                label.textColor = self.whichPlayerLabel.textColor;

                [UIView animateWithDuration:0.5 animations:^{
                    //Animate back to original position
                    self.movedLabel.center = self.whichPlayerLabel.center;

                    //Restart timer as soon as label is let go
                    [self restartTimer];

                    //Switch player as label returns to original position
                    [self switchPlayer];

                } completion:^(BOOL finished) {
                    if (finished) {
                        // If animation finished, check if there's a winner
                        [self whoWon];
                        NSLog(@"Finished");
                    }
                }];
            }
        }
    }

}

- (IBAction)onHelpButtonTapped:(id)sender {
//Empty implemnetation since used segue.

}

#pragma mark - Helper Methods
- (UILabel *)findLabelUsingPoint:(CGPoint)point {
    //Iterates through label Arrtay
    for (UILabel *label in self.labelArray) {
        //If the CGect contains a CGPoint
        if (CGRectContainsPoint(label.frame, point)) {
            //If the label's text is empty, set the text and color
            if ([label.text isEqualToString:@""]) {
                label.text = self.whichPlayerLabel.text;
                label.textColor = self.whichPlayerLabel.textColor;

                // Swhich player after tap, restart timer and check if player won
                if ([self.whichPlayerLabel.text isEqualToString:@"X"]) {
                    self.whichPlayerLabel.text = @"O";
                    self.whichPlayerLabel.textColor = [UIColor redColor];
                    [self restartTimer];
                    [self whoWon];
                    [self computerPlay];
                    return label;
                } else {
                    self.whichPlayerLabel.text = @"X";
                    self.whichPlayerLabel.textColor = [UIColor blueColor];
                    [self whoWon];
                    [self restartTimer];
                    self.currentPlayer = 1;
                    return label;
                }
            }
        }
    }
    return nil;
}


// Custom method to change border on all labels
- (void)setBorder:(UILabel *)label {
    label.layer.borderColor = [UIColor blackColor].CGColor;
    label.layer.borderWidth = 1.0;
}

- (void)setBorders {
    [self setBorder:self.labelOne];
    [self setBorder:self.labelTwo];
    [self setBorder:self.labelThree];
    [self setBorder:self.labelFour];
    [self setBorder:self.labelFive];
    [self setBorder:self.labelSix];
    [self setBorder:self.labelSeven];
    [self setBorder:self.labelEight];
    [self setBorder:self.labelNine];
    [self setBorder:self.whichPlayerLabel];
    [self setBorder:self.movedLabel];

}

- (void)showAlertWithWinner:(NSString *)winner {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Won"
                                                    message:[NSString stringWithFormat:@"%@ is the winner!", winner]
                                                   delegate:self
                                          cancelButtonTitle:@"Restart"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //Calls restart game when button pressed. In this case we only had 1 button so called the 0 index.
        [self restartGame];
    }
}

- (void)timeFireMethod:(NSTimer *)timer {
    //Reduce timer by 1 second.
    self.timeRemaining -= 1;

    //Update timer label with new second
    self.timeRemainingLabel.text = [NSString stringWithFormat:@"Time Remaining: %li", (long)self.timeRemaining];


    //Change colors depending on the current second..
    if ((self.timeRemaining <=6) && (self.timeRemaining >3)) {
        self.timeRemainingLabel.textColor = [UIColor orangeColor];

    } else if (self.timeRemaining <= 3) {
        self.timeRemainingLabel.textColor = [UIColor redColor];
    }

    //If timer reaches 0, restart the timer and switch the player.
    if (self.timeRemaining == 0) {
        [self restartTimer];
        [self switchPlayer];
    }

}

- (void)restartGame {
    //Iterate through labelArray and remove all set labels.
    for (UILabel *label in self.labelArray) {
        label.text = @"";
    }
    self.whichPlayerLabel.text = @"X";
    self.whichPlayerLabel.textColor = [UIColor blueColor];
    self.movedLabel.text = self.whichPlayerLabel.text;
    self.movedLabel.textColor = self.whichPlayerLabel.textColor;
    [self restartTimer];
    self.currentPlayer = 1;

}

- (void)restartTimer {
    // For some reason when timer set to 10, the clock would start at 9.. ?
    self.timeRemaining = 11;
    [self timeFireMethod:self.timer];
    self.timeRemainingLabel.textColor = [UIColor greenColor];
}

- (void)switchPlayer {
    if ([self.whichPlayerLabel.text isEqualToString:@"X"]) {
        self.whichPlayerLabel.text = @"O";
        self.movedLabel.text = self.whichPlayerLabel.text;
        self.whichPlayerLabel.textColor = [UIColor redColor];
        self.movedLabel.textColor = self.whichPlayerLabel.textColor;
        self.currentPlayer = 2;
        [self computerPlay];

    } else if ([self.whichPlayerLabel.text isEqualToString:@"O"]) {
        self.whichPlayerLabel.text = @"X";
        self.movedLabel.text = self.whichPlayerLabel.text;
        self.whichPlayerLabel.textColor = [UIColor blueColor];
        self.movedLabel.textColor = self.whichPlayerLabel.textColor;
        self.currentPlayer = 1;
    }
}

//Computer play??????

/*
 1. Identify players.
 2. Be able to switch from players(already implemented)
 3. Make player pick random number from 1 - 9
 4. Depending on random number, then if that label is empty, then set O
 6. check if computer won
 */

- (void)computerPlay {
    self.currentPlayer = 2;
    self.turn = arc4random() % 10;



//    for (UILabel *label in self.labelArray){
//        if (![label.text isEqualToString:@"X"] || ![label.text isEqualToString:@"O"]) {
//            if (self.turn == 1) {
//                self.labelOne.text = self.whichPlayerLabel.text;
//            } else if (self.turn == 2) {
//                self.labelTwo.text = self.whichPlayerLabel.text;
//            } else if (self.turn == 3) {
//                self.labelThree.text = self.whichPlayerLabel.text;
//            } else if (self.turn == 4) {
//                self.labelFour.text = self.whichPlayerLabel.text;
//            } else if (self.turn == 5) {
//                self.labelFive.text = self.whichPlayerLabel.text;
//            } else if (self.turn == 6) {
//                self.labelSix.text = self.whichPlayerLabel.text;
//            } else if (self.turn == 7) {
//                self.labelSeven.text = self.whichPlayerLabel.text;
//            } else if (self.turn == 8) {
//                self.labelEight.text = self.whichPlayerLabel.text;
//            } else if (self.turn == 9) {
//                self.labelNine.text = self.whichPlayerLabel.text;
//            }
//        }
//    }

//    switch (self.turn) {
//        case 0:
//            if ([self.labelOne.text isEqualToString:@""]) {
//
//            }
//            break;
//
//        default:
//            break;
//    }

    
    if (self.turn == labelPositionTL && [self.labelOne.text isEqualToString:@""]) {
        self.labelOne.text = @"O";
        self.labelOne.textColor = [UIColor redColor];
        [self changePlayerTextAndColor];
    }
    else if (self.turn == labelPositionTM && [self.labelTwo.text isEqualToString:@""]) {
        self.labelTwo.text = @"O";
        self.labelTwo.textColor = [UIColor redColor];
        [self changePlayerTextAndColor];
    }
    else if (self.turn == labelPositionTR && [self.labelThree.text isEqualToString:@""]) {
        self.labelThree.text = @"O";
        self.labelThree.textColor = [UIColor redColor];
        [self changePlayerTextAndColor];
    }
    else if (self.turn == labelPositionML && [self.labelFour.text isEqualToString:@""]) {
        self.labelFour.text = @"O";
        self.labelFour.textColor = [UIColor redColor];
        [self changePlayerTextAndColor];
    }
    else if (self.turn == labelPositionMM && [self.labelFive.text isEqualToString:@""]) {
        self.labelFive.text = @"O";
        self.labelFive.textColor = [UIColor redColor];
        [self changePlayerTextAndColor];
    }
    else if (self.turn == labelPositionMR && [self.labelSix.text isEqualToString:@""]) {
        self.labelSix.text = @"O";
        self.labelSix.textColor = [UIColor redColor];
        [self changePlayerTextAndColor];
    }
    else if (self.turn == labelPositionBL && [self.labelSeven.text isEqualToString:@""]) {
        self.labelSeven.text = @"O";
        self.labelSeven.textColor = [UIColor redColor];
        [self changePlayerTextAndColor];
    }
    else if (self.turn == labelPositionBM && [self.labelEight.text isEqualToString:@""]) {
        self.labelEight.text = @"O";
        self.labelEight.textColor = [UIColor redColor];
        [self changePlayerTextAndColor];
    }
    else if (self.turn == labelPositionBR && [self.labelNine.text isEqualToString:@""]) {
        self.labelNine.text = @"O";
        self.labelNine.textColor = [UIColor redColor];
        [self changePlayerTextAndColor];
    }

    if (self.turn == 0) {
        [self computerPlay];
    }

//    if (((self.turn == 1) && [self.labelOne.text isEqualToString:@"X"]) || [self.labelOne.text isEqualToString:@"O"]) {
//        NSLog(@"Repeat");
//        [self changePlayerTextAndColor];
//    }
//    else if (((self.turn == 2) && [self.labelTwo.text isEqualToString:@"X"]) || [self.labelTwo.text isEqualToString:@"O"]) {
//        NSLog(@"Repeat");
//        [self changePlayerTextAndColor];
//    }
//    else if (((self.turn == 3) && [self.labelThree.text isEqualToString:@"X"]) || [self.labelThree.text isEqualToString:@"O"]) {
//        NSLog(@"Repeat");
//        [self changePlayerTextAndColor];
//    }
//    else if (((self.turn == 4) && [self.labelFour.text isEqualToString:@"X"]) || [self.labelFour.text isEqualToString:@"O"]) {
//       NSLog(@"Repeat");
//        [self changePlayerTextAndColor];
//    }
//    else if (((self.turn == 5) && [self.labelFive.text isEqualToString:@"X"]) || [self.labelFive.text isEqualToString:@"O"]) {
//        NSLog(@"Repeat");
//        [self changePlayerTextAndColor];
//    }
//    else if (((self.turn == 6) && [self.labelSix.text isEqualToString:@"X"]) || [self.labelSix.text isEqualToString:@"O"]) {
//        NSLog(@"Repeat");
//    }
//    else if (((self.turn == 7) && [self.labelSeven.text isEqualToString:@"X"]) || [self.labelSeven.text isEqualToString:@"O"]) {
//        NSLog(@"Repeat");
//    }
//    else if (((self.turn == 8) && [self.labelEight.text isEqualToString:@"X"]) || [self.labelEight.text isEqualToString:@"O"]) {
//        NSLog(@"Repeat");
//    }
//    else if (((self.turn == 9) && [self.labelNine.text isEqualToString:@"X"]) || [self.labelNine.text isEqualToString:@"O"]) {
//        NSLog(@"Repeat");
//    }

}

- (void)changePlayerTextAndColor {
    self.currentPlayer = 1;
    self.whichPlayerLabel.text = @"X";
    self.whichPlayerLabel.textColor = [UIColor blueColor];
    self.movedLabel.text = self.whichPlayerLabel.text;
    self.movedLabel.textColor = self.whichPlayerLabel.textColor;
}

@end
