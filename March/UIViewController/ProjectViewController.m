//
//  ProjectViewController.m
//  March
//
//  Created by Dzkami on 2018/7/3.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "ProjectViewController.h"
#import "Project.h"
#import "Milestone.h"
#import "MenuData.h"
#import "MyItem.h"
#import "ProjectHeaderCell.h"
#import "MilestoneCell.h"
#import "ClickAddTaskCell.h"
#import "TaskCell.h"
#import "ProjectFooterCell.h"
#import "Task.h"

#define TIME_INTERVAL 24*60*60

@interface ProjectViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSUserDefaults *userDefaults;
    NSString *userId;
    SqliteUtil *sqlite;
}

@property(nonatomic, retain)Project *project;
@property (nonatomic, retain) MenuData *menuData;
@property (nonatomic, strong) UITableView *tw_project;
@end

@implementation ProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userId"];
    
     _project = [[Project alloc] init];
    _project.projectId = [[userDefaults objectForKey:@"presentProjectId"] integerValue];;
    
    sqlite = [[SqliteUtil alloc] init];
    [self getProjectInfo];
    
    
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:_project.projectName];
    [bar pushNavigationItem:navigationItem animated:true];
    [self.view addSubview:bar];
    
    UIBarButtonItem *menuBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"菜单"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelf)];
    [navigationItem setLeftBarButtonItem:menuBtnItem];
    
    self.menuData = [[MenuData alloc] init];
    [self initDateSource];
    _tw_project = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _tw_project.dataSource = self;
    _tw_project.delegate = self;
    _tw_project.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tw_project];
    
}

- (void)initDateSource {
    MyItem *header = [[MyItem alloc] init];
    header.cellType = ShowProjectCellType_Header;
    header.level = 0;
    header.title = _project.projectGoal;
    [self.menuData.tableViewData addObject:header];

    //里程碑
    for (int i = 0; i < [_project.milestone count]; i++) {
        Milestone *ms = [_project.milestone objectAtIndex:i];
        MyItem *root = [[MyItem alloc] init];
        root.cellType = ShowProjectCellType_Milestone;
        root.level = 0;
        root.title = ms.milestoneName;
        root.itemId = [NSString stringWithFormat:@"%ld",ms.milestoneId];
        root.mStateId = ms.mStateId;
        root.projectId = ms.projectId;
        root.subItems = [NSMutableArray array];
        
        //计算子节点个数,并生成 -- 里程碑是按日期降序得排列的
        NSInteger subItemCount = 0;
        if(i == 0) { //里程碑n - 结束
            subItemCount = [self calculateMarginDaysFromDate:ms.eArriveDate toDate:[NSDate dateWithTimeInterval:TIME_INTERVAL sinceDate:_project.eEndDate]];
            NSLog(@"里程碑%ld-结束:  %ld",ms.milestoneId, subItemCount);
            header.subItems = [self createSubItemWithCount:subItemCount dateFrom:[NSDate dateWithTimeInterval:TIME_INTERVAL sinceDate:ms.eArriveDate]];
            
        } else {//里程碑i - 里程碑i-1 (i日期小)
            Milestone *toMs = [_project.milestone objectAtIndex: i - 1];
            subItemCount = [self calculateMarginDaysFromDate:[NSDate dateWithTimeInterval:TIME_INTERVAL sinceDate:ms.eArriveDate] toDate:[NSDate dateWithTimeInterval:TIME_INTERVAL sinceDate:toMs.eArriveDate]];
            NSLog(@"里程碑%ld-里程碑%ld:  %ld",ms.milestoneId,toMs.milestoneId, subItemCount);
            
            MyItem *preRoot = [self.menuData.tableViewData objectAtIndex:i];//里程碑数组与tableViewDate错位一个(tableViewDate要多一个header)
            preRoot.subItems = [self createSubItemWithCount:subItemCount dateFrom:[NSDate dateWithTimeInterval:TIME_INTERVAL sinceDate:ms.eArriveDate]];
        }
        [self.menuData.tableViewData addObject:root];
    }
    
    //算第一个里程碑的子节点
    MyItem *lastRoot = [self.menuData.tableViewData lastObject];
    Milestone *firstMs = [_project.milestone lastObject];
    
    NSInteger subItemCount = [self calculateMarginDaysFromDate:_project.startDate toDate:[NSDate dateWithTimeInterval:TIME_INTERVAL sinceDate:firstMs.eArriveDate]];//开始-里程碑1
    NSLog(@"开始-里程碑%ld:  %ld",firstMs.milestoneId, subItemCount);
    lastRoot.subItems = [self createSubItemWithCount:subItemCount dateFrom:_project.startDate];
    
    
    MyItem *footer = [[MyItem alloc] init];
    footer.cellType = ShowProjectCellType_Footer;
    footer.level = 0;
    [self.menuData.tableViewData addObject:footer];
}

- (NSMutableArray *)createSubItemWithCount:(NSInteger) count dateFrom:(NSDate *)fromDate{
    NSMutableArray *subItemArr = [NSMutableArray array];
    for (int i = 0; i < count;  i++) {
        MyItem *subItem = [[MyItem alloc] init];
        subItem.level = 1;
        subItem.cellType = ShowProjectCellType_AddTask;
        subItem.tStateId = TaskStateType_NotFinish;
        [subItemArr addObject:subItem];
        NSDate *date = [NSDate dateWithTimeInterval:TIME_INTERVAL * i sinceDate:fromDate];
        subItem.title = [Util transDateToString:date];
    }
    return [NSMutableArray arrayWithArray: [[subItemArr reverseObjectEnumerator] allObjects]];//颠倒顺序
}

- (NSInteger)calculateMarginDaysFromDate:(NSDate *)from toDate:(NSDate *)to {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay;//只计算天数
    NSDateComponents *marginDays;
    
    marginDays = [calendar components:unit fromDate:from toDate:to options:0];
    return marginDays.day;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_menuData.tableViewData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyItem *item = [_menuData.tableViewData objectAtIndex:indexPath.row];
    if(item.cellType == ShowProjectCellType_Header) {
        ProjectHeaderCell *cell = [ProjectHeaderCell createCellWithTableView:tableView];
        cell.item = item;
        [cell setProjectGoal:item.title];
        return cell;
    } else if(item.cellType == ShowProjectCellType_Milestone) {
        MilestoneCell *cell = [MilestoneCell createCellWithTableView:tableView];
        cell.item = item;
        [cell setMilestoneName:item.title];
        if(item.mStateId == MilestoneStateType_NotArrive) {
            [cell setMilesoneStateImg:[UIImage imageNamed:@"里程碑"]];
        } else {
            [cell setMilesoneStateImg:[UIImage imageNamed:@"里程碑_fill"]];
        }
        return cell;
    } else if(item.cellType == ShowProjectCellType_AddTask) {
        ClickAddTaskCell *cell = [ClickAddTaskCell createCellWithTableView:tableView];
        [cell setDateText:item.title];
        return cell;
    } else if(item.cellType == ShowProjectCellType_Task) {
        TaskCell *cell = [TaskCell createCellWithTableView:tableView];
        if(item.tStateId == TaskStateType_NotFinish) {
            [cell setTaskStateImgHidden:true];//隐藏img
            
        } else if(item.tStateId == TaskStateType_Delay) {
            [cell setTaskStateImgHidden:false];
            [cell setTaskStateImg:[UIImage imageNamed:@"任务延迟"]];
            
        } else if(item.tStateId == TaskStateType_Faild) {
            [cell setTaskStateImgHidden:false];
            [cell setTaskStateImg:[UIImage imageNamed:@"任务失败"]];
            
        } else {
            [cell setTaskStateImgHidden:false];
            [cell setTaskStateImg:[UIImage imageNamed:@"任务完成"]];
        }
        return cell;
    } else if(item.cellType == ShowProjectCellType_Footer) {
        ProjectFooterCell *cell = [ProjectFooterCell createCellWithTableView:tableView];
        return cell;
    }
    return nil;
}

#pragma mark -- Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyItem *selectItem = [_menuData.tableViewData objectAtIndex:indexPath.row];
    if(selectItem.level == 0 ) {
        if(selectItem.cellType == ShowProjectCellType_Header) {
            ProjectHeaderCell *cell = (ProjectHeaderCell *)[tableView cellForRowAtIndexPath:indexPath];
            if(cell.item.isSubItemOpen) {
                NSArray *arr = [_menuData deleteMenuIndexPaths:cell.item];
                if([arr count] > 0) {
                    [tableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
                }
            } else {
                NSArray *arr = [_menuData insertMenuIndexPaths:cell.item];
                if([arr count] > 0) {
                    [tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
                }
            }
        } else {
            
            
            MilestoneCell *cell = (MilestoneCell *)[tableView cellForRowAtIndexPath:indexPath];
            if(cell.item.isSubItemOpen) {
                NSArray *arr = [_menuData deleteMenuIndexPaths:cell.item];
                if([arr count] > 0) {
                    [tableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
                }
            } else {
                NSArray *arr = [_menuData insertMenuIndexPaths:cell.item];
                if([arr count] > 0) {
                    [tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
                }
            }
        }
    }
}




- (void)getProjectInfo {
    [sqlite open_db];
    
    //项目基本信息
    FMResultSet *projectInfoSet = [sqlite search_db:[NSString stringWithFormat:@"SELECT * FROM Project WHERE projectId = '%@'", [NSNumber numberWithInteger: _project.projectId]]];
    
    while([projectInfoSet next]) {
        _project.projectName = [projectInfoSet stringForColumn:@"projectName"];
        _project.projectGoal = [projectInfoSet stringForColumn:@"projectGoal"];
        _project.startDate = [projectInfoSet dateForColumn:@"startDate"];
        _project.eEndDate = [projectInfoSet dateForColumn:@"EEndDate"];
        NSLog(@"---项目信息---");
        NSLog(@"名称:  %@", _project.projectName);
        NSLog(@"目标:  %@", _project.projectGoal);
        NSLog(@"开始:  %@", _project.startDate);
        NSLog(@"结束:  %@", _project.eEndDate);
    }
    
    //项目里程碑-----按时间倒序输出!
    NSMutableArray *milestoneArr = [NSMutableArray array];
    FMResultSet *milestoneSet = [sqlite search_db:[NSString stringWithFormat:@"SELECT * FROM Milestone WHERE projectId = '%@' ORDER BY EArriveDate DESC", [NSNumber numberWithInteger: _project.projectId]]];
    while([milestoneSet next]) {
        Milestone *ms = [[Milestone alloc] init];
        ms.milestoneId = [milestoneSet intForColumn:@"milestoneId"];
        ms.milestoneName = [milestoneSet stringForColumn:@"milestoneName"];
        ms.projectId = _project.projectId;
        ms.mStateId = [milestoneSet intForColumn:@"MStateId"];
        ms.eArriveDate = [milestoneSet dateForColumn:@"EArriveDate"];
        NSLog(@"---里程碑信息---");
        NSLog(@"id:  %ld", ms.milestoneId);
        NSLog(@"名字:  %@", ms.milestoneName);
        NSLog(@"项目id:  %ld", ms.projectId);
        NSLog(@"状态id: %ld", ms.mStateId);
        NSLog(@"时间:  %@", ms.eArriveDate);
        
        [milestoneArr addObject:ms];
    }
    
    _project.milestone = milestoneArr;
    [sqlite close_db];
}

- (void)dismissSelf {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
