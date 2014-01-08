//
//  ViewController.m
//  ImageBasedPickerVIew
//
//  Created by SDT-1 on 2014. 1. 6..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#define MAX_NUM 100
@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate>{
    BOOL betState;
    NSMutableArray *data1;
    NSMutableArray *data2;
    NSMutableArray *data3;
    int betMoney;
    int myMoney;
}
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UILabel *betMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *myMoneyLabel;


@end

@implementation ViewController
-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
    if(alertView.tag == 1){
        NSString *inputStr = [alertView textFieldAtIndex:0].text;
        return [inputStr length] >= 1;
    }
    return YES;
}
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //확인 버튼을 누를 경우 배팅임
    if(buttonIndex == alertView.firstOtherButtonIndex && alertView.tag == 1){
        int betting = [alertView textFieldAtIndex:0].text.intValue;
        if(myMoney < betting){
            [self messageGameFail:@"베팅할 돈이 부족합니다."];//돈이 부족하면 다른 alertView를 띄워준다.
        }else if(betting == 0){
            [self messageGameFail:@"숫자를 입력해 주세요."];
        }else{
            //내 돈이 적당히 있으면 text를 얻어와 저장함.
            //label도 바꾸어 주어야 함.
            [self setBetMoney:betting];
            betState = YES;
        }
    }
}
-(void)setBetMoney:(int)betting{
    betMoney = betting;
    self.betMoneyLabel.text = [NSString stringWithFormat:@"bet Money : %d", betMoney];
}
-(void)setMyMoney:(int)getting{
    myMoney = getting;
    self.myMoneyLabel.text = [NSString stringWithFormat:@"bet Money : %d", myMoney];
}
-(void)messageGameFail:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Fail" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
}
- (IBAction)doBetting:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"베팅" message:@"베팅 금액을 입력하세요." delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1;
    [alert show];
}
- (IBAction)selectRandom:(id)sender {
    if([self newGame]){
        int r1 = arc4random() % MAX_NUM;
        [self.picker selectRow:r1 inComponent:0 animated:YES];
    
        int r2 = arc4random() % MAX_NUM;
        [self.picker selectRow:r2 inComponent:1 animated:YES];
    
        int r3 = arc4random() % MAX_NUM;
        [self.picker selectRow:r3 inComponent:2 animated:YES];
    
        int slot1 = [data1[r1] intValue];
        int slot2 = [data2[r2] intValue];
        int slot3 = [data3[r3] intValue];
        if( slot1 == slot2 && slot2 == slot3){
            NSLog(@"Betting 대성공!");
            NSLog(@"%d %d %d",slot1,slot2,slot3);
            [self setMyMoney:(myMoney += betMoney*100)];
        }else if( slot1 == slot2 || slot2 == slot3 || slot1 == slot3){
            NSLog(@"Betting 성공");
            NSLog(@"%d %d %d",slot1,slot2,slot3);
            [self setMyMoney:(myMoney += betMoney*10)];
        }else{
            NSLog(@"loose money!!");
            NSLog(@"%d %d %d",slot1,slot2,slot3);
            [self setMyMoney:(myMoney-=betMoney)];
        }
        [self setBetMoney:0];
    }else{
        [self messageGameFail:@"베팅을 금액을 설정하세요"];
    }
}
//pickerView 의 component개수 설정
-(NSInteger )numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return MAX_NUM;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
-(BOOL)newGame{
    if(betState == YES){
        for (int index = 0; index < MAX_NUM; index++) {
            NSString *r = [NSString stringWithFormat:@"%d",rand() % 10];
            [data1 addObject:r];
            r = [NSString stringWithFormat:@"%d",rand() % 10];
            [data2 addObject:r];
            r = [NSString stringWithFormat:@"%d",rand() % 10];
            [data3 addObject:r];
        }
        betState = NO;
        return true;
    }else{
        return false;
    }
}
//pickerView의 image를 지정하는 함수
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    NSString *imagePath;
    if(component == 0)
        imagePath = [NSString stringWithFormat:@"%d.png",[data1[row] intValue]];
    else if(component == 1)
        imagePath = [NSString stringWithFormat:@"%d.png",[data2[row] intValue]];
    else if(component == 2)
        imagePath = [NSString stringWithFormat:@"%d.png",[data3[row] intValue]];
    UIImage *image = [UIImage imageNamed:imagePath];
    UIImageView *imageView;
    if(view == nil){
        imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = CGRectMake(0, 0, 50, 30);
    }else{
        imageView = (UIImageView *)view;
        imageView.image = image;
    }

    return imageView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   //self.picker.
    data1 = [[NSMutableArray alloc]init];
    data2 = [[NSMutableArray alloc]init];
    data3 = [[NSMutableArray alloc]init];
    betState = YES;
    
    betMoney = 0;
    myMoney = 1000000;
    self.betMoneyLabel.text = [NSString stringWithFormat:@"bet Money : %d", betMoney];
    self.myMoneyLabel.text = [NSString stringWithFormat:@"my Money : %d", myMoney];
    [self newGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
