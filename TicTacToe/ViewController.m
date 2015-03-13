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

@property NSArray *labelArray;
@property BOOL didWin;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property NSTimer *timer;
@property NSInteger timeRemaining;
@property NSInteger turn;

@property CGPoint originPoint;
@property CGPoint finalPoint;


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
        self.whichPlayerLabel.text = @"O";
    } else if ([locatedLabel.text isEqualToString:@"O"]) {
        self.whichPlayerLabel.text = @"X";
    }

}

- (IBAction)onLabelMoved:(UIPanGestureRecognizer *)panGestureRecognizer {
//    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        [UIView animateWithDuration:1.0 animations:^{
//            self.movedLabel.center = self.originPoint;
//        }];
//    } else {
//        self.finalPoint = [panGestureRecognizer locationInView:self.view];
//        self.movedLabel.center = self.finalPoint;
//        if (CGRectContainsPoint(self.movedLabel.frame, self.finalPoint)) {
//
//        }
//
//
//    }

//    self.movedLabel.center = self.originPoint;
//    self.finalPoint = [panGestureRecognizer locationInView:self.view];
//    self.movedLabel.center = self.finalPoint;
//
//    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        for (UILabel *label in self.labelArray) {
//            if (CGRectContainsPoint(label.frame, self.movedLabel.center)) {
//                label.text = self.whichPlayerLabel.text;
//                label.textColor = self.whichPlayerLabel.textColor;
//                NSLog(@"Text: %@, Color: %@", label.text, label.textColor);
//
//                [UIView animateWithDuration:0.55f animations:^{
//                    self.movedLabel.center = self.whichPlayerLabel.center;
//                } completion:^(BOOL finished) {
//                    if (finished) {
//                        NSLog(@"Moved:");
//
//                    }
//                }];
//            }
//        }
//    }

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
                    return label;
                } else {
                    self.whichPlayerLabel.text = @"X";
                    self.whichPlayerLabel.textColor = [UIColor blueColor];
                    [self whoWon];
                    [self restartTimer];
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

    } else if ([self.whichPlayerLabel.text isEqualToString:@"O"]) {
        self.whichPlayerLabel.text = @"X";
        self.movedLabel.text = self.whichPlayerLabel.text;
        self.whichPlayerLabel.textColor = [UIColor blueColor];
        self.movedLabel.textColor = self.whichPlayerLabel.textColor;
    }
}


@end
