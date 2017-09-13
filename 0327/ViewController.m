//
//  ViewController.m
//  0327
//
//  Created by tim on 2017/9/8.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "ViewController.h"
#import "TMquestion.h"

@interface ViewController ()
/** 所有的题目 */
@property(nonatomic,strong) NSArray *questions;
/** 当前是第几题(当前题目的序号) */
@property(nonatomic,assign) int index;


@property(nonatomic,weak) UILabel *noLable;

@property(nonatomic,weak) UILabel *titleLable;
/** 中间图片 */
@property(nonatomic,weak) UIButton *iconBtn;

@property(nonatomic,weak) UIButton *nextQuestion;
/** 大图按钮 */
@property(nonatomic,weak) UIButton *bigImg;

@property(nonatomic,weak) UIButton *helpBtn;

@property(nonatomic,weak) UIButton *tipBtn;

@property(nonatomic,weak) UIButton *coinBtn;
/** 存放正确答案 */
@property(nonatomic,weak) UIView *answerView;
/** 存放待选答案 */
@property(nonatomic,weak) UIView *optionView;

@property(nonatomic,weak) UIButton *cover;

@property(nonatomic,weak) UIView *notop;

@property(nonatomic,weak) UIView *titletop;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiController];
    
    self.index = -1;
    
    [self nextQuestions];
    
}
- (NSArray *)questions
{
    if (_questions == nil) {
         NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"]];
        
        NSMutableArray *questionArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            TMquestion *question = [TMquestion questionWithDict:dict];
            [questionArray addObject:question];
            _questions = questionArray;
        }
    }
    return _questions;
}


- (void)nextQuestions
{
    self.index++;
    
    TMquestion *question = self.questions[self.index];
    
    [self settingData:question];
    /**添加答案*/
    [self addAnswerBtn:question];
    /**添加待选答案*/
    [self addOptionBtn:question];
}
/**deltaScore需要添加的分数*/
- (void)addScore:(int)deltaScore
{
    int score = [self.coinBtn titleForState:UIControlStateNormal].intValue;
    
    score +=deltaScore;
    
    [self.coinBtn setTitle:[NSString stringWithFormat:@"%d",score] forState:UIControlStateNormal];
}

- (void)tip
{
    for (UIButton *answerBtn in self.answerView.subviews) {
        [self answerClick:answerBtn];
    }
    TMquestion *question =self.questions[self.index];
    NSString *firstAnswer = [question.answer substringToIndex:1];
    
    for (UIButton *optionBtn in self.optionView.subviews) {
        if ([optionBtn.currentTitle isEqualToString:firstAnswer]) {
            [self optionClick:optionBtn];
            break;
        }
    }
    [self addScore:-1000];
}

- (void)addOptionBtn:(TMquestion *)question
{
    [self.optionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat optionW = TMGScaleW(44);
    CGFloat optionH = optionW;
    CGFloat margin = TMGScaleW(10);
    int count = question.options.count;
    for (int i = 0; i<count; i++) {
        UIButton *optionBtn = [[UIButton alloc] init];
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
        
        int totolCol = 7;
        CGFloat leftMargin = (TMGWidth - totolCol * optionW - margin * (totolCol -1)) * 0.5;
        int col = i % totolCol;
        CGFloat optionX = leftMargin + col * (optionW + margin);
        int row = i / totolCol;
        CGFloat optionY = row * (optionH + margin);
        optionBtn.frame = CGRectMake(optionX, optionY, optionW, optionH);
        [optionBtn setTitle:question.options[i] forState:UIControlStateNormal];
        [optionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.optionView addSubview:optionBtn];
        [optionBtn addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
    }

}

- (void)settingData:(TMquestion *)question
{
    self.noLable.text = [NSString stringWithFormat:@"%d/%d",self.index + 1, self.questions.count];
    
    self.titleLable.text = question.title;
    
    [self.iconBtn setImage:[UIImage imageNamed:question.icon] forState:UIControlStateNormal];
    
    self.nextQuestion.enabled = self.index != (self.questions.count - 1);
}

- (void)addAnswerBtn:(TMquestion *)question
{
    [self.answerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int length = question.answer.length;
    for (int i = 0; i< length; i++) {
        UIButton *answerBtn = [[UIButton alloc] init];
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        /**按钮宽度*/
        CGFloat answerBtnH = self.answerView.frame.size.height;
        CGFloat answerBtnW = answerBtnH;
        CGFloat margin = TMGScaleW(10);
        CGFloat leftMargin = (TMGWidth - length * answerBtnW - margin * (length - 1)) * 0.5;
        CGFloat answerX = leftMargin + i * (answerBtnW + margin);
        answerBtn.frame = CGRectMake(answerX, 0, answerBtnW, answerBtnH);
        [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.answerView addSubview:answerBtn];
        [answerBtn addTarget:self action:@selector(answerClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (void)answerClick:(UIButton *)answerBtn
{
//    NSString *answerTitle = [answerBtn titleForState:UIControlStateNormal];
    for (UIButton *optionBtn in self.optionView.subviews) {
        if ([optionBtn.currentTitle isEqualToString:answerBtn.currentTitle]
            && optionBtn.hidden == YES) { //
            optionBtn.hidden = NO;
            break;
        }//恢复
    }
    [answerBtn setTitle:nil forState:UIControlStateNormal];

    for (UIButton *answerBtn in self.answerView.subviews) {
        [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)optionClick:(UIButton *)optionBtn
{
    optionBtn.hidden = YES;
    for (UIButton *answerBtn in self.answerView.subviews) {
        if (answerBtn.currentTitle.length == 0) {
            // 设置答案按钮的 文字 为 被点击待选按钮的文字
            NSString *optionTitle = optionBtn.currentTitle;
            [answerBtn setTitle:optionTitle forState:UIControlStateNormal];
            break;
            }
        }
        BOOL full = YES; //假设默认为填满
        NSMutableString *tempAnswerTitle = [NSMutableString string];
        for (UIButton *answerBtn in self.answerView.subviews) {
            if (answerBtn.currentTitle.length == 0) { //如果为0没有文字（按钮没填满）
                full = NO;
                for (UIButton *answerBtn in self.answerView.subviews) {
                    [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
            }
            if (answerBtn.currentTitle) {
                [tempAnswerTitle appendString:answerBtn.currentTitle];
            }
            if (full) {
                TMquestion *question = self.questions[self.index];
                //核对临时答案跟答案是否相等
                if ([tempAnswerTitle isEqualToString:question.answer]) {//答对
                    for (UIButton *answerBtn in self.answerView.subviews) {
                    [answerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    }
                    [self performSelector:@selector(nextQuestions) withObject:nil afterDelay:0.5];
                    
                    [self addScore:800];
                }else{
                    for (UIButton *answerBtn in self.answerView.subviews) {
                        [answerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    }
                }
                
            }
        }
}

- (void)iconClick
{
    if (self.cover == nil) { // 没有遮盖,要放大
        [self bigImgs];
    } else { // 有遮盖,要缩小
        [self smallImg];
    }

}

- (void)bigImgs
{
    // 1.添加阴影
    UIButton *cover = [[UIButton alloc] init];
    cover.frame = self.view.bounds;
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.0;
    [cover addTarget:self action:@selector(smallImg) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cover];
    [self.view addSubview:_iconBtn];
    self.cover = cover;
    
    [self.cover bringSubviewToFront: self.iconBtn];
    
    // 3.执行动画
    [UIView animateWithDuration:0.25 animations:^{
        // 3.1.阴影慢慢显示出来
        cover.alpha = 0.7;
        
        // 3.2.头像慢慢变大,慢慢移动到屏幕的中间
        CGFloat iconW = TMGWidth;
        CGFloat iconH = iconW;
        CGFloat iconY = (TMGHeight - iconH) * 0.5;
        self.iconBtn.frame = CGRectMake(0, iconY, iconW, iconH);
    }];
}

- (void)smallImg
{
    // 执行动画
    [UIView animateWithDuration:0.25 animations:^{
        // 存放需要执行动画的代码
        
        // 1.头像慢慢变为原来的位置和尺寸
        CGFloat iconBtnX = TMGWidth * 0.3;
        CGFloat iconBtnY =  (self.titletop.frame.origin.y + self.titletop.frame.size.height) + LineY(5);
        self.iconBtn.frame = CGRectMake(iconBtnX, iconBtnY, TMGScaleW(150), TMGScaleW(150));
        
        // 2.阴影慢慢消失
        self.cover.alpha = 0.0;
    } completion:^(BOOL finished) {

        // 3.动画执行完毕后,移除遮盖(从内存中移除)
        [self.cover removeFromSuperview];
        [self.iconBtn removeFromSuperview];
        self.cover = nil;
        [self.view addSubview:_iconBtn];
    }];
}



- (void)uiController
{
    UIImageView *bg = [[UIImageView alloc]init];
    bg.frame = [[UIScreen mainScreen]bounds];
    bg.image = [UIImage imageNamed:@"bj"];
    [self.view addSubview:bg];
    
    UIView *notop = [[UIView alloc]init];
    self.notop = notop;
    notop.frame = CGRectMake(LineX(0), LineY(20), TMGWidth, TMGScaleH(30));
    [self.view addSubview:notop];
    
    UILabel *noLable = [[UILabel alloc]init];
    self.noLable = noLable;
    CGFloat noLableX = TMGWidth *0.29;
    noLable.frame = CGRectMake(noLableX, LineY(0), TMGScaleW(160), TMGScaleH(30));
    [noLable setText:@"1/10"];
    noLable.textColor = [UIColor whiteColor];
    noLable.textAlignment = NSTextAlignmentCenter;
    [noLable setFont:Font(15)];
    [notop addSubview:noLable];
    
    UIButton *coinBtn = [[UIButton alloc]init];
    self.coinBtn = coinBtn;
    coinBtn.frame = CGRectMake((TMGWidth - LineX(90)), LineY(0), TMGScaleW(100), TMGScaleH(30));
    coinBtn.titleLabel.font = Font(15);
    coinBtn.userInteractionEnabled = NO;
    [coinBtn setImage:[UIImage imageNamed:@"coin"] forState:UIControlStateNormal];
    [coinBtn setTitle:@"10000" forState:UIControlStateNormal];
    [notop addSubview:coinBtn];
    
    UIView *titletop = [[UIView alloc]init];
    self.titletop = titletop;
    titletop.frame = CGRectMake(LineX(0), LineY(55), TMGWidth, TMGScaleH(30));
    [self.view addSubview:titletop];
    
    UILabel *titleLable = [[UILabel alloc]init];
    self.titleLable = titleLable;
    titleLable.frame = CGRectMake(LineX(0), LineY(0), TMGWidth, TMGScaleH(30));
    [titleLable setText:@"恶搞风格的喜剧大片"];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [titleLable setFont:Font(15)];
    [titletop addSubview:titleLable];
    
    /**中间区域*/
    UIView *questionArea = [[UIView alloc]init];
    CGFloat tipY = titletop.frame.origin.y + titletop.frame.size.height;
    questionArea.frame = CGRectMake(LineX(0), tipY + LineY(5), TMGWidth, TMGScaleH(160));
    [self.view addSubview:questionArea];
    
    /**  左边按钮*/
    UIButton *tipBtn = [[UIButton alloc]init];
    self.tipBtn = tipBtn;
    tipBtn.frame = CGRectMake(LineX(0), LineY(25), TMGScaleW(70), TMGScaleH(36));
    tipBtn.titleLabel.font = Font(15);
    [tipBtn setTitle:@"提示" forState:UIControlStateNormal];
    [tipBtn setAdjustsImageWhenHighlighted:NO];
    [tipBtn setImage:[UIImage imageNamed:@"icon_tip"] forState:UIControlStateNormal];
    [tipBtn setBackgroundImage:[UIImage imageNamed:@"btn_left"] forState:UIControlStateNormal];
    [tipBtn setBackgroundImage:[UIImage imageNamed:@"btn_left_highlighted"] forState:UIControlStateHighlighted];
    [tipBtn addTarget:self action:@selector(tip) forControlEvents:UIControlEventTouchUpInside];
    
    [questionArea addSubview:tipBtn];
    
    UIButton *helpBtn = [[UIButton alloc]init];
    self.helpBtn = helpBtn;
    CGFloat helpY = tipBtn.frame.origin.y + tipBtn.frame.size.height + LineY(40);
    helpBtn.frame = CGRectMake(LineX(0),helpY , TMGScaleW(70), TMGScaleH(36));
    helpBtn.titleLabel.font = Font(15);
    [helpBtn setTitle:@"帮助" forState:UIControlStateNormal];
    [helpBtn setAdjustsImageWhenHighlighted:NO];
    [helpBtn setImage:[UIImage imageNamed:@"icon_help"] forState:UIControlStateNormal];
    [helpBtn setBackgroundImage:[UIImage imageNamed:@"btn_left"] forState:UIControlStateNormal];
    [helpBtn setBackgroundImage:[UIImage imageNamed:@"btn_left_highlighted"] forState:UIControlStateHighlighted];
    [questionArea addSubview:helpBtn];
    /**  中图片按钮*/
    UIButton *iconBtn = [[UIButton alloc]init];
    self.iconBtn = iconBtn;
    CGFloat iconBtnX = TMGWidth * 0.3;
    iconBtn.frame = CGRectMake(iconBtnX, LineY(5), TMGScaleW(150), TMGScaleW(150));
    iconBtn.imageEdgeInsets =UIEdgeInsetsMake(5, 5, 5, 5);
    [iconBtn setAdjustsImageWhenHighlighted:NO];
    [iconBtn setBackgroundImage:[UIImage imageNamed:@"center_img"] forState:UIControlStateNormal];
    [iconBtn setImage:[UIImage imageNamed:@"movie_jf"] forState:UIControlStateNormal];
    [iconBtn addTarget:self action:@selector(iconClick) forControlEvents:UIControlEventTouchUpInside];
    [questionArea addSubview:iconBtn];
    
    /**  右边按钮*/
    UIButton *bigImg = [[UIButton alloc]init];
    self.bigImg = bigImg;
    CGFloat bigImgX = TMGWidth  - LineX(70);
    bigImg.frame = CGRectMake(bigImgX,tipBtn.frame.origin.y, TMGScaleW(70), TMGScaleH(36));
    bigImg.titleLabel.font = Font(15);
    [bigImg setTitle:@"大图" forState:UIControlStateNormal];
    [bigImg setAdjustsImageWhenHighlighted:NO];
    [bigImg setImage:[UIImage imageNamed:@"icon_help"] forState:UIControlStateNormal];
    [bigImg setBackgroundImage:[UIImage imageNamed:@"btn_right"] forState:UIControlStateNormal];
    [bigImg setBackgroundImage:[UIImage imageNamed:@"btn_right_highlighted"] forState:UIControlStateHighlighted];
    [bigImg addTarget:self action:@selector(bigImgs) forControlEvents:UIControlEventTouchUpInside];
    [questionArea addSubview:bigImg];
    
    UIButton *nextQuestion = [[UIButton alloc]init];
    self.nextQuestion = nextQuestion;
    CGFloat netxQuestionX = bigImgX;
    nextQuestion.frame = CGRectMake(netxQuestionX,helpY, TMGScaleW(70), TMGScaleH(36));
    nextQuestion.titleLabel.font = Font(15);
    [nextQuestion setTitle:@"下一题" forState:UIControlStateNormal];
    [nextQuestion setAdjustsImageWhenHighlighted:NO];
    [nextQuestion setBackgroundImage:[UIImage imageNamed:@"btn_right"] forState:UIControlStateNormal];
    [nextQuestion setBackgroundImage:[UIImage imageNamed:@"btn_right_highlighted"] forState:UIControlStateHighlighted];
    [nextQuestion addTarget:self action:@selector(nextQuestions) forControlEvents:UIControlEventTouchUpInside];
    [questionArea addSubview:nextQuestion];
    
    /**答案区域*/
    UIView *answerView = [[UIView alloc] init];
    self.answerView = answerView;
    CGFloat answerY = questionArea.frame.origin.y + questionArea.frame.size.height + LineY(10);
    answerView.frame = CGRectMake(0, answerY, TMGWidth, TMGScaleH(48));
    
    [self.view addSubview:answerView];
    
    /**待选区域*/
    UIView *optionView = [[UIView alloc] init];
    self.optionView = optionView;
    CGFloat optionViewH = (TMGHeight - notop.frame.size.height + questionArea.frame.size.height +titletop.frame.size.height + answerView.frame.size.height) ;
    CGFloat optionViewY = answerView.frame.origin.y + answerView.frame.size.height + LineY(20);
    optionView.frame = CGRectMake(0, optionViewY, TMGWidth, optionViewH);
    
    [self.view addSubview:optionView];

    
    

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
