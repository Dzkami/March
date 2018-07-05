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
#import "AddTaskViewController.h"

#define TIME_INTERVAL 24*60*60

@interface ProjectViewController () <UITableViewDelegate, UITableViewDataSource, DataCallBackDelegate> {
  
    NSString *userId;
    SqliteUtil *sqlite;
    NSDate *createDate;
    
}

@property(nonatomic, retain)Project *project;
@property (nonatomic, retain) MenuData *menuData;
@property (nonatomic, strong) UITableView *tw_project;
@property (nonatomic, retain) UIAlertController *alertController;
@property (nonatomic, retain) NSUserDefaults *userDefaults;
@property (nonatomic, retain) Task *task;
@property (nonatomic, assign) NSInteger insertIndex;
@end

@implementation ProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [_userDefaults objectForKey:@"userId"];

     _project = [[Project alloc] init];
    _project.projectId = [[_userDefaults objectForKey:@"presentProjectId"] integerValue];;

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
//    [sqlite open_db];
    MyItem *header = [[MyItem alloc] init];
    header.cellType = ShowProjectCellType_Header;
    header.level = 0;
    header.title = _project.projectGoal;
    [self.menuData.tableViewData addObject:header];
    
    NSInteger subItemCount = 0;
    if([_project.milestone count] == 0) {
        subItemCount = [self calculateMarginDaysFromDate:_project.startDate toDate:[NSDate dateWithTimeInterval:TIME_INTERVAL sinceDate:_project.eEndDate]];
        header.subItems = [self createSubItemWithCount:subItemCount dateFrom:_project.startDate];
    } else {
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
            root.mEArriveDate = ms.eArriveDate;
            root.subItems = [NSMutableArray array];
            
            //计算子节点个数,并生成 -- 里程碑是按日期降序得排列的
            
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
        
        subItemCount = [self calculateMarginDaysFromDate:_project.startDate toDate:[NSDate dateWithTimeInterval:TIME_INTERVAL sinceDate:firstMs.eArriveDate]];//开始-里程碑1
        NSLog(@"开始-里程碑%ld:  %ld",firstMs.milestoneId, subItemCount);
        lastRoot.subItems = [self createSubItemWithCount:subItemCount dateFrom:_project.startDate];
    }


    
    MyItem *footer = [[MyItem alloc] init];
    footer.cellType = ShowProjectCellType_Footer;
    footer.level = 0;
    [self.menuData.tableViewData addObject:footer];
//    [sqlite close_db];
}

- (NSMutableArray *)createSubItemWithCount:(NSInteger) count dateFrom:(NSDate *)fromDate{
    [sqlite open_db];
    NSMutableArray *subItemArr = [NSMutableArray array];
    for (int i = 0; i < count;  i++) {
        NSDate *date = [NSDate dateWithTimeInterval:TIME_INTERVAL * i sinceDate:fromDate];
        
        //获取此日期下的任务
        MyItem *taskItem;
        NSString *searchTaskStr = [NSString stringWithFormat:@"SELECT * FROM Task WHERE projectId = '%@' AND createDate = '%@'",[NSNumber numberWithInteger:self.project.projectId] , [Util transDateToString:date]];
        FMResultSet *taskSet = [sqlite search_db:searchTaskStr];
        
        while([taskSet next]) {
            taskItem = [[MyItem alloc] init];
            taskItem.level = 1;
            taskItem.cellType = ShowProjectCellType_Task;
            taskItem.tStateId = [taskSet  intForColumn:@"tStateId"];
            taskItem.title = [taskSet stringForColumn:@"taskName"];
            taskItem.itemId = [NSString stringWithFormat:@"%d", [taskSet intForColumn:@"taskId"]];
            
            NSInteger isDelay = [self calculateMarginDaysFromDate:date toDate:[NSDate date]];
            NSLog(@"时间差:%ld", isDelay);
            if(taskItem.tStateId == TaskStateType_NotFinish && (isDelay >= 1)) { //任务过期
                taskItem.tStateId = TaskStateType_Delay;//修改任务为过期状态
                NSString *update = [NSString stringWithFormat:@"UPDATE Task SET TStateId = '%@' WHERE taskId = '%@'",[NSNumber numberWithInteger:TaskStateType_Delay], [NSNumber numberWithInteger:[taskSet intForColumn:@"taskId"]]];
                [sqlite update_db:update];
            }
            
            [subItemArr addObject:taskItem];
        }
      
        MyItem *subItem = [[MyItem alloc] init];
        subItem.level = 1;
        subItem.cellType = ShowProjectCellType_AddTask;
        subItem.tStateId = TaskStateType_NotFinish;
        subItem.taskAddDate = [Util transDateToString:date];
        subItem.title = [Util transDateToString:date];
        [subItemArr addObject:subItem];
        
    }
    [sqlite close_db];
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
        NSLog(@"项目状态:::%ld", self.project.pStateId);
        if(self.project.pStateId == ProjectStateType_InProgress ||self.project.pStateId == ProjectStateType_NotStarted) {
            [cell setProjectStateImg:[UIImage imageNamed:@"终点"]];
        } else if(self.project.projectId == ProjectStateType_InProgress ){
            [cell setProjectStateImg:[UIImage imageNamed:@"项目延迟"]];
        } else {
            [cell setProjectStateImg:[UIImage imageNamed:@"项目完成"]];
        }
        return cell;
    } else if(item.cellType == ShowProjectCellType_Milestone) {
        MilestoneCell *cell = [MilestoneCell createCellWithTableView:tableView];
        [self controlMenuWithItem:item tableView:tableView indexPath:indexPath];

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
        [cell setTaskName:item.title];
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
    self.alertController = [[UIAlertController alloc] init];
    if(selectItem.level == 0 ) {
        if(selectItem.cellType == ShowProjectCellType_Header) {
            ProjectHeaderCell *cell = (ProjectHeaderCell *)[tableView cellForRowAtIndexPath:indexPath];
            if(cell.item.isSubItemOpen) {
                UIAlertAction *openTaskList = [UIAlertAction actionWithTitle:@"收起任务列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self controlMenuWithItem:selectItem tableView:tableView indexPath:indexPath];
                }];
                [self.alertController addAction:openTaskList];
            } else {
                UIAlertAction *openTaskList = [UIAlertAction actionWithTitle:@"展开任务列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self controlMenuWithItem:selectItem tableView:tableView indexPath:indexPath];
                }];
                [self.alertController addAction:openTaskList];

            }
            
            __block NSInteger pStateId = self.project.pStateId;
            __block NSInteger pState = self.project.pStateId;
            __block NSDate *today = [NSDate date];
            __block NSDate *eEndDate = self.project.eEndDate;
            UIAlertAction *finishProject = [UIAlertAction actionWithTitle:@"标记项目完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"项目标记 :::: %ld",pState);
                if(pStateId == ProjectStateType_InProgress && ([today compare:eEndDate] == NSOrderedSame)) { //准时到达
                    pState = ProjectStateType_EndOnTime;
                    
                } else if(pStateId == ProjectStateType_InProgress && ([today compare:eEndDate] == NSOrderedAscending)) { // 提前到达
                    pState = ProjectStateType_EndPrematurely;
                    
                } else if(pStateId == ProjectStateType_InProgress && ([today compare:eEndDate] == NSOrderedDescending)) { //延迟到达
                    pState = ProjectStateType_EndOfDelay;
                }
                
                NSString *update = [NSString stringWithFormat:@"UPDATE Project SET PStateId = '%@',AEndDate = '%@' WHERE  projectId = '%@'",[NSNumber numberWithInteger:pState], today, [NSNumber numberWithInteger:self.project.projectId]];
                [self saveState:update];
                [cell setProjectStateImg:[UIImage imageNamed:@"项目完成"]];
                
            }];
            
//            UIAlertAction *delayProject = [UIAlertAction actionWithTitle:@"延迟项目" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//
//
//            }];
        
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.alertController dismissViewControllerAnimated:true completion:nil];
            }];
            
            [self.alertController addAction:finishProject];
//            [self.alertController addAction:delayProject];
            [self.alertController addAction:cancelAction];
            [self presentViewController:self.alertController animated:true completion:nil];
        } else if(selectItem.cellType == ShowProjectCellType_Milestone) {
            MilestoneCell *cell = (MilestoneCell *)[tableView cellForRowAtIndexPath:indexPath];
            if(cell.item.isSubItemOpen) {
                UIAlertAction *openTaskList = [UIAlertAction actionWithTitle:@"收起任务列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self controlMenuWithItem:selectItem tableView:tableView indexPath:indexPath];
                }];
                [self.alertController addAction:openTaskList];
            } else {
                UIAlertAction *openTaskList = [UIAlertAction actionWithTitle:@"展开任务列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self controlMenuWithItem:selectItem tableView:tableView indexPath:indexPath];
                }];
                [self.alertController addAction:openTaskList];
                
            }
            
            __block NSInteger mState = selectItem.mStateId;
            __block NSInteger milestoneId = [selectItem.itemId integerValue];
            __block NSDate *today = [NSDate date];
            UIAlertAction *arriveMilestone = [UIAlertAction actionWithTitle:@"到达里程碑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if(selectItem.mStateId == MilestoneStateType_NotArrive && ([today compare:selectItem.mEArriveDate] == NSOrderedSame)) { //准时到达
                    mState = MilestoneStateType_ArriveOnTime;
                    
                } else if(selectItem.mStateId == MilestoneStateType_NotArrive && ([today compare:selectItem.mEArriveDate] == NSOrderedAscending)) { // 提前到达
                    mState = MilestoneStateType_ArrivePrematurely;
                    
                } else if(selectItem.mStateId == MilestoneStateType_NotArrive && ([today compare:selectItem.mEArriveDate] == NSOrderedDescending)) { //延迟到达
                    mState = MilestoneStateType_ArriveOfDelay;
                }
                
                NSString *update = [NSString stringWithFormat:@"UPDATE Milestone SET MStateId = '%@',AArriveDate = '%@' WHERE  milestoneId = '%@'",[NSNumber numberWithInteger:mState], today, [NSNumber numberWithInteger:milestoneId]];
                [self saveState:update];
                [cell setMilesoneStateImg:[UIImage imageNamed:@"里程碑_fill"]];
            }];
            
            UIAlertAction *unArriveMilestone = [UIAlertAction actionWithTitle:@"取消标记里程碑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *update = [NSString stringWithFormat:@"UPDATE Milestone SET MStateId = '%@',AArriveDate = '%@' WHERE  milestoneId = '%@'",[NSNumber numberWithInteger:MilestoneStateType_NotArrive], today, [NSNumber numberWithInteger:milestoneId]];//这里的到达日期未取消,后面记得处理...
                [self saveState:update];
                [cell setMilesoneStateImg:[UIImage imageNamed:@"里程碑"]];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.alertController dismissViewControllerAnimated:true completion:nil];
            }];
            
            [self.alertController addAction:arriveMilestone];
            [self.alertController addAction:unArriveMilestone];
            [self.alertController addAction:cancelAction];
            [self presentViewController:self.alertController animated:true completion:nil];
        }
        
    } else {
        if(selectItem.cellType == ShowProjectCellType_AddTask) {
            //添加任务
            self.insertIndex = indexPath.row + 1;
            [self.userDefaults setObject:selectItem.taskAddDate forKey:@"taskAddDate"];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            AddTaskViewController *vc_addTask = [storyboard instantiateViewControllerWithIdentifier:@"addTaskView"];
            vc_addTask.dataDelegate = self;
            [self presentViewController:vc_addTask animated:true completion:nil];
            
        } else if(selectItem.cellType == ShowProjectCellType_Task) {
            TaskCell *cell = (TaskCell *)[tableView cellForRowAtIndexPath:indexPath];
            
            __block NSInteger tState = selectItem.tStateId;
            __block NSInteger taskId = [selectItem.itemId integerValue];
            UIAlertAction *finishTaskAction = [UIAlertAction actionWithTitle:@"标记任务完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSDate *createDate = [Util transStringToDate:selectItem.taskAddDate];
                if(selectItem.tStateId == TaskStateType_NotFinish && ([[NSDate date] compare:createDate] == NSOrderedSame)) { //按时完成
                    tState = TaskStateType_FinishOnTime;
                } else if(selectItem.tStateId == TaskStateType_NotFinish && ([[NSDate date] compare:createDate] == NSOrderedAscending)) {//提前完成
                    tState = TaskStateType_FinishOfDelay;
                } else if(selectItem.tStateId == TaskStateType_Delay) { //延迟完成
                    tState = TaskStateType_FinishOfDelay;
                }
                
                //收集完成日期和时间! 更改状态
                [self saveTaskFinishHourWithState:tState taskId:taskId ];
                [cell setTaskStateImgHidden:false];
                [cell setTaskStateImg:[UIImage imageNamed:@"任务完成"]];
                
            }];
            
            UIAlertAction *faildTaskAction = [UIAlertAction actionWithTitle:@"标记任务失败" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                tState = TaskStateType_Faild;
                NSString *update = [NSString stringWithFormat:@"UPDATE Task SET TStateId = '%@', finishDate = '%@' WHERE  taskId = '%@'",
                                    [NSNumber numberWithInteger:tState],
                                    [Util transDateToString:[NSDate date]],
                                    [NSNumber numberWithInteger:taskId]];

                [self saveState:update];
                
                [cell setTaskStateImgHidden:false];
                [cell setTaskStateImg:[UIImage imageNamed:@"任务失败"]];
            }];
            
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.alertController dismissViewControllerAnimated:true completion:nil];
            }];
            
            [self.alertController addAction:finishTaskAction];
            [self.alertController addAction:faildTaskAction];
            [self.alertController addAction:cancelAction];
            [self presentViewController:self.alertController animated:true completion:nil];
        }
    }
}

- (void) saveState:(NSString *)sqlStr{
    [sqlite open_db];
    NSLog(@"状态修改成功");
    [sqlite update_db:sqlStr];
    [sqlite close_db];
}

- (void)saveTaskFinishHourWithState:(NSInteger) tState taskId:(NSInteger)taskId {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"任务完成时间" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:true completion:nil];
    }];
    
    __block double finishHour = 0;
    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf_hour = alert.textFields[0];
        if(tf_hour.text.length > 0)
            finishHour += [tf_hour.text doubleValue];
        
        UITextField *tf_min = alert.textFields[1];
        if(tf_min.text.length > 0)
            finishHour += [tf_min.text doubleValue] / 60;
        
       NSString *update = [NSString stringWithFormat:@"UPDATE Task SET TStateId = '%@', finishDate = '%@', AFHour = '%@' WHERE  taskId = '%@'",
                           [NSNumber numberWithInteger:tState],
                           [Util transDateToString:[NSDate date]],
                           [NSNumber numberWithDouble:finishHour],
                           [NSNumber numberWithInteger:taskId]];
        
        [self saveState:update];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:commitAction];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入完成的小时";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入完成的分钟";
    }];
    [self presentViewController:alert animated:true completion:nil];
}



- (void)controlMenuWithItem:(MyItem *)selectItem tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
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
    } else if(selectItem.cellType == ShowProjectCellType_Milestone){
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




- (void)getProjectInfo {
    [sqlite open_db];
    
    //项目基本信息
    FMResultSet *projectInfoSet = [sqlite search_db:[NSString stringWithFormat:@"SELECT * FROM Project WHERE projectId = '%@'", [NSNumber numberWithInteger: _project.projectId]]];
    
    while([projectInfoSet next]) {
        _project.projectName = [projectInfoSet stringForColumn:@"projectName"];
        _project.projectGoal = [projectInfoSet stringForColumn:@"projectGoal"];
        _project.startDate = [projectInfoSet dateForColumn:@"startDate"];
        _project.eEndDate = [projectInfoSet dateForColumn:@"EEndDate"];
        _project.pStateId = [projectInfoSet intForColumn:@"PStateId"];
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

- (void)viewWillAppear:(BOOL)animated {
    if([self.menuData.tableViewData count]) {
        [self.menuData.tableViewData removeAllObjects];
    }
    [self initDateSource];
    [self.tw_project reloadData];
}

#pragma mark DataCallBackDelegate

- (void)willDismissModalView:(id)sender {
    AddTaskViewController *vc_addTask = (AddTaskViewController *)sender;
    NSLog(@"新增的任务日期为:::::%@",vc_addTask.task.createDate);
  
}

@end
