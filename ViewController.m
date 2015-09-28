//
//  ViewController.m
//  ExchangeRate
//
//  Created by 王敏 on 15/9/26.
//  Copyright (c) 2015年 wangmin. All rights reserved.
//

#import "ViewController.h"
#import "CountryModel.h"
#import "CurrencyTableViewCell.h"

@interface ViewController ()
<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *currencyTableView;

@property (nonatomic,strong) NSMutableArray *groupArray;
@property (nonatomic,strong) NSMutableDictionary *dataDic;
@end

@implementation ViewController
@synthesize groupArray,dataDic;

- (void)updateViewConstraints{
    [super updateViewConstraints];
    self.currencyTableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.currencyTableView.contentOffset = CGPointMake(0, -20);
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"currency" ofType:@"json"]];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:0];
    for(NSDictionary *country in jsonArray){
        CountryModel *model = [[CountryModel alloc] initWithDictionary:country error:nil];
        [modelArray addObject:model];
    }
    NSSortDescriptor *sorDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"symbol" ascending:YES];
    
    [modelArray sortUsingDescriptors:@[sorDescriptor]];
    
    
    self.groupArray = [NSMutableArray arrayWithCapacity:0];
    self.dataDic = [NSMutableDictionary dictionaryWithCapacity:0];//数据源
    for (int section = 'A'; section <= 'Z'; section++) {
        [groupArray addObject:[NSString stringWithFormat:@"%c", section]];
        [dataDic setObject:[NSMutableArray arrayWithCapacity:0] forKey:[NSString stringWithFormat:@"%c", section]];
    }
    
    for(CountryModel *model in modelArray){
        NSString *symbolIndex = [model.symbol substringToIndex:1];
        NSMutableArray *specialArray = dataDic[symbolIndex];
        [specialArray addObject:model];
    }

//    self.currencyTableView.separatorInset = UIEdgeInsetsMake(20, 0, 0, 0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return groupArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 33;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
//    label.
//    label.font = [UIFont systemFontOfSize:14];
//    label.text = groupArray[section];
//    return label;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return groupArray[section];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionName = groupArray[section];
    
    NSArray *dataArray = self.dataDic[sectionName];
    
    return dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CurrencyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"currencyCell"];
    
    NSString *sectionName = groupArray[indexPath.section];
    
    NSArray *dataArray = self.dataDic[sectionName];
    CountryModel *model = dataArray[indexPath.row];
//    NSLog(@"---%@",model.currency_name_zh_Hans);
    cell.leftLabel.text = [NSString stringWithFormat:@"%@ %@",model.currency_name_zh_Hans,model.symbol];
    
    return cell;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
