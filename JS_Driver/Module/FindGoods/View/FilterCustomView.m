//
//  FilterCustomView.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/24.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "FilterCustomView.h"

#define LineCount 4
#define CellWidth (WIDTH -12*5)/LineCount

@interface FilterCustomView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
     CGFloat viewH;
    NSArray *dataSource1;
    NSArray *dataSource2;
    UICollectionView *bgCollectV;
}
@end

@implementation FilterCustomView

-(instancetype)initWithFrame:(CGRect)frame {
    CGRect frame1 = CGRectMake(0, kNavBarH+46, WIDTH, HEIGHT-kNavBarH-46-kTabBarSafeH);
    self = [super initWithFrame:frame1];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    UIWindow *myWindow= [[[UIApplication sharedApplication] delegate] window];
    [myWindow addSubview:self];
    self.hidden = YES;
    viewH = self.height;
    dataSource1 = @[@"不限类型",@"整车",@"零担",@"整车"];
    dataSource2 = @[@"不限",@"今天",@"明天",@"明天以后",@"整车",@"整车",@"整车",@"整车"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    bgCollectV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width-12, self.height-autoScaleW(50)) collectionViewLayout:layout];
    bgCollectV.alwaysBounceVertical = YES;
    bgCollectV.backgroundColor = [UIColor whiteColor];
    bgCollectV.delegate = self;
    bgCollectV.dataSource = self;
    bgCollectV.clipsToBounds = NO;
    [self addSubview:bgCollectV];
    //注册cell
    [bgCollectV registerClass:[MyCollectionCell class] forCellWithReuseIdentifier:@"filterCollectCellID"];
    //注册header
    [bgCollectV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"filterCollectHeaderID"];
    [bgCollectV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"filterCollectFooterID"];
    
    UIButton *sender = [[UIButton alloc]initWithFrame:CGRectMake(0, self.height-autoScaleW(50), autoScaleW(150), autoScaleW(50))];
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [sender setTitle:@"清空条件" forState:UIControlStateNormal];
    [self addSubview:sender];
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(sender.right, sender.top, WIDTH-sender.width, sender.height)];
    sureBtn.backgroundColor = AppThemeColor;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [sureBtn setTitle:@"确定条件" forState:UIControlStateNormal];
    [self addSubview:sureBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, sender.top, WIDTH, 1)];
    lineView.backgroundColor = PageColor;
    [self addSubview:lineView];
}

#pragma mark -- dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return dataSource2.count;;
    }
    return dataSource1.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"filterCollectCellID" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell.button setTitle:dataSource2[indexPath.row] forState:UIControlStateNormal];
    }
    else {
        [cell.button setTitle:dataSource1[indexPath.row] forState:UIControlStateNormal];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"filterCollectHeaderID" forIndexPath:indexPath];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 8, WIDTH/2.0, 20)];
        label.text = @"用车类型";
        label.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:label];
        return headerView;
    }
    else {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"filterCollectFooterID" forIndexPath:indexPath];
        UITextField *contentTF = [[UITextField alloc]initWithFrame:CGRectMake(12, 10, WIDTH/2.0, 36)];
        contentTF.placeholder = @"请输入其他车长";
        contentTF.layer.borderColor = RGBValue(0xB4B4B4).CGColor;
        contentTF.layer.borderWidth = 0.5;
        contentTF.layer.cornerRadius =2;
        contentTF.layer.masksToBounds = YES;
        contentTF.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:contentTF];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 1)];
        contentTF.leftView = lineView;
        contentTF.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, contentTF.bottom+15, WIDTH, 10)];
        bgView.backgroundColor = RGBValue(0xF5f5f5);
        [headerView addSubview:bgView];
        
        return headerView;
    }
}


//header高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(WIDTH, 30);
}

//footer高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(WIDTH, 71);
}

//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CellWidth, CellWidth*0.5);
}

//调节item边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 12, 0, 0);
}


- (void)showView {
    __weak typeof(self) weakSelf = self;
    weakSelf.height = 0;
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.height = self->viewH;
    } completion:^(BOOL finished) {
    }];
}


- (void)hiddenView {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.height = 0;
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation MyCollectionCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _button = [self createButton];
//        _button.frame = CGRectMake(0, 0, CellWidth, CellWidth*0.5);
        [_button setTitle:@"标题" forState:UIControlStateNormal];
        [self addSubview:_button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            // make 代表约束:
            make.top.equalTo(self.contentView).with.offset(0);   // 对当前view的top进行约束,距离参照view的上边界是 :
            make.left.equalTo(self.contentView).with.offset(0);  // 对当前view的left进行约束,距离参照view的左边界是 :
//            make.height.equalTo(@(itemHeight/2));                // 高度
            make.right.equalTo(self.contentView).with.offset(0); // 对当前view的right进行约束,距离参照view的右边界是 :
        }];
    }
    return self;
}

-(UIButton *)createButton{
    UIButton *sender = [[UIButton alloc]init];
    sender.layer.borderColor = RGBValue(0xB4B4B4).CGColor;
    sender.layer.borderWidth = 0.5;
    sender.layer.cornerRadius =2;
    sender.layer.masksToBounds = YES;
    sender.titleLabel.font = [UIFont systemFontOfSize:14];
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [sender setTitleColor:AppThemeColor forState:UIControlStateHighlighted];
    return sender;
}


@end

