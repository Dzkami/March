//
//  AddProjectViewController.m
//  March
//
//  Created by Dzkami on 2018/7/2.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "AddProjectViewController.h"
#import "MenuViewController.h"
#import "CreateProjectModel.h"
#import "ProjectInfoTextCell.h"
#import "ProjectInfoDateCell.h"
#import "ProjectInfoPickerCell.h"
#import "ClickAddCell.h"
#import "ProjectInfoMileStoneCell.h"
@interface AddProjectViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSInteger mileStoneCount;

}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, retain) NSMutableArray *projectType;
@property (nonatomic, retain) NSMutableArray *projectGroup;
@property (nonatomic, retain) NSMutableDictionary *projectInfoDic;
@property (nonatomic, retain) NSMutableDictionary *milestoneInfoDic;
@property (nonatomic, retain) SqliteUtil *sqlite;
@property (nonatomic, copy) NSString *userId;

@end

@implementation AddProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _userId = [defaults objectForKey:@"userId"];
    
    _sqlite = [[SqliteUtil alloc] init];
    mileStoneCount = 0;
    _endDate = [[NSDate alloc] init];
    _startDate = [[NSDate alloc] init];
    _projectType = [self getProjectType];
    _projectGroup = [self getProjectGroup];
    _projectInfoDic = [NSMutableDictionary dictionary];
    _milestoneInfoDic = [NSMutableDictionary dictionary];
    
    

    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"添加项目"];
    [bar pushNavigationItem:navigationItem animated:true];
    [self.view addSubview:bar];
    
    UIBarButtonItem *cancelBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"取消"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    [navigationItem setLeftBarButtonItem:cancelBtnItem];
    
    UIBarButtonItem *finishBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"完成"] style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
    [navigationItem setRightBarButtonItem:finishBtnItem];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setScrollEnabled:true];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initDataSource];
    [self.view addSubview:_tableView];
    
}

#pragma mark -- BarButton Action
- (void)cancelAction {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)finishAction {
    NSLog(@"------信息打印------");
    NSLog(@"名称:  %@", [_projectInfoDic objectForKey:@"projectName"]);
    NSLog(@"目标:  %@", [_projectInfoDic objectForKey:@"projectGoal"]);
    NSLog(@"类别:  %@", [_projectInfoDic objectForKey:@"PType"]);
    NSLog(@"属族:  %@", [_projectInfoDic objectForKey:@"PGId"]);
    NSLog(@"开始:  %@", [_projectInfoDic objectForKey:@"startDate"]);
    NSLog(@"结束:  %@", [_projectInfoDic objectForKey:@"EEndDate"]);
    for (int i = 0; i < mileStoneCount; i++) {
        NSLog(@"里程碑%d:  名字:%@   时间:%@",i, [_milestoneInfoDic objectForKey:[NSString stringWithFormat:@"name%d",i]],[_milestoneInfoDic objectForKey:[NSString stringWithFormat:@"date%d",i]]);
    }
    
    NSString *pName = [_projectInfoDic objectForKey:@"projectName"];
    if(pName.length == 0)
        [self showAlertMessage:@"项目名称不能为空"];
    
    NSString *pGoal = [_projectInfoDic objectForKey:@"projectGoal"];
    if(pGoal.length == 0)
        [self showAlertMessage:@"项目目标不能为空"];
    
    NSString *pType = [_projectInfoDic objectForKey:@"PType"];
    NSInteger PTId = [_projectType indexOfObject:pType] - 1;
    if(PTId < 0)
        [self showAlertMessage:@"项目类型不能为空"];
    
    NSString *pGroup = [_projectInfoDic objectForKey:@"PGId"];
    NSInteger PGId = [_projectGroup indexOfObject:pGroup];
    
    NSDate *sDate = [_projectInfoDic objectForKey:@"startDate"];
    
    NSDate *eDate = [_projectInfoDic objectForKey:@"EEndDate"];
//    NSComparisonResult compare = [eDate compare:[NSDate date]];
//    if(compare == NSOrderedSame) { //等于开始时间,即为初始值
//        [self showAlertMessage:@"请选择项目结束日期"];
//    }
    
    [_sqlite open_db];
    int projectId = -1;
    NSString *getProjId = @"SELECT COUNT(*) FROM Project";
    FMResultSet *idSet = [_sqlite search_db:getProjId];
    if([idSet next]) {
        projectId = [idSet intForColumnIndex:0];
    }
    
    if(projectId != -1) {
        //写入项目表
        NSString *insertProjStr = [NSString stringWithFormat:@"INSERT INTO Project(projectId, projectName, projectGoal, PTId, PGId, startDate, EEndDate, PStateId) VALUES(:projectId, :projectName, :projectGoal, :PTId, :PGId, :startDate, :EEndDate, :PStateId)"];
        
        NSDictionary *insertProjDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [NSNumber numberWithInt:projectId], @"projectId",
                                       pName, @"projectName",
                                       pGoal, @"projectGoal",
                                       [NSNumber numberWithInteger:PTId], @"PTId",
                                       [NSNumber numberWithInteger:PGId], @"PGId",
                                       sDate, @"startDate",
                                       eDate, @"EEndDate",
                                       [NSNumber numberWithInteger:ProjectStateType_InProgress], @"PStateId", nil];

        [_sqlite add_db:insertProjStr withParamterDic:insertProjDic];

        //写入用户项目关系表
        NSString *insertRelationStr = [NSString stringWithFormat:@"INSERT INTO UPRelationship(userId, projectId, relationId, authorityId) VALUES(:userId, :projectId, :relationId, :authorityId)"];
        
        NSDictionary *insertRelationDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                           _userId, @"userId",
                                           [NSNumber numberWithInt:projectId], @"projectId",
                                           [NSNumber numberWithInt:UPRelationType_Manage], @"relationId",
                                           [NSNumber numberWithInt:AthorityType_Edit], @"authorityId", nil];
        
        [_sqlite add_db:insertRelationStr withParamterDic:insertRelationDic];
        

        //写入里程碑表
        for (int i = 0; i < mileStoneCount;  i++) {
            NSString *mName = [_milestoneInfoDic objectForKey:[NSString stringWithFormat:@"name%d",i]];
            NSString *mDate = [_milestoneInfoDic objectForKey:[NSString stringWithFormat:@"date%d",i]];
            
            NSString *insertMilestoneStr = [NSString stringWithFormat:@"INSERT INTO Milestone(projectId, milestoneName, EArriveDate, MStateId) VALUES(:projectId, :milestoneName, :EArriveDate, :MStateId)"];
            
            NSDictionary *insertMilestoneDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                [NSNumber numberWithInteger:projectId],@"projectId",
                                                mName, @"milestoneName",
                                                mDate, @"EArriveDate",
                                                [NSNumber numberWithInteger:MilestoneStateType_NotArrive], @"MStateId", nil];
            
            [_sqlite add_db:insertMilestoneStr withParamterDic:insertMilestoneDic];
        }
    } else {
        NSLog(@"获取项目id失败");
    }
   
    [_sqlite close_db];
    [self dismissViewControllerAnimated:true completion:nil];
}



#pragma mark -- Init TableView DataSource
- (void)initDataSource {
    _tableViewData = [NSMutableArray array];
    CreateProjectModel *nameModel = [[CreateProjectModel alloc] init];
    nameModel.title = @"项目名称";
    nameModel.placeholder = @"请输入项目名称";
    nameModel.key = @"projectName";
    nameModel.cellType = CreateProjectCellType_TF;
    [_projectInfoDic setObject:@"" forKey:@"projectName"];
    [_tableViewData addObject:nameModel];
    
    CreateProjectModel *goalModel = [[CreateProjectModel alloc] init];
    goalModel.title = @"项目目标";
    goalModel.placeholder = @"请输入项目目标";
    goalModel.key = @"projectGoal";
    goalModel.cellType = CreateProjectCellType_TF;
    [_projectInfoDic setObject:@"" forKey:@"projectGoal"];
    [_tableViewData addObject:goalModel];
    
    CreateProjectModel *tagModel = [[CreateProjectModel alloc] init];
    tagModel.title = @"项目类别";
    tagModel.placeholder = @"选择项目类别";
    tagModel.key = @"PType";
    tagModel.data = _projectType;
    tagModel.cellType = CreateProjectCellType_PK;
    [_projectInfoDic setObject:@"" forKey:@"PType"];
    [_tableViewData addObject:tagModel];
    
    CreateProjectModel *groupModel = [[CreateProjectModel alloc] init];
    groupModel.title = @"所属项目族";
    groupModel.placeholder = @"选择所属项目族";
    groupModel.key = @"PGId";
    groupModel.data = _projectGroup;
    groupModel.cellType = CreateProjectCellType_PK;
    [_projectInfoDic setObject:@"" forKey:@"PGId"];
    [_tableViewData addObject:groupModel];
    
    CreateProjectModel *startTimeModel = [[CreateProjectModel alloc] init];
    startTimeModel.title = @"开始时间";
    startTimeModel.placeholder = @"选择项目开始时间";
    startTimeModel.key = @"startDate";
    startTimeModel.cellType = CreateProjectCellType_DPK;
    startTimeModel.date = [NSDate date];//默认今天
    
    [_projectInfoDic setObject: [NSDate date] forKey:@"startDate"];
    [_tableViewData addObject:startTimeModel];
    
    CreateProjectModel *expectEndTimeModel = [[CreateProjectModel alloc] init];
    expectEndTimeModel.title = @"结束时间";
    expectEndTimeModel.placeholder = @"选择结束时间";
    expectEndTimeModel.key = @"EEndDate";
    expectEndTimeModel.date = [NSDate date];//默认今天
    [self.projectInfoDic setObject:[NSDate date] forKey:@"EEndDate"];
    expectEndTimeModel.cellType = CreateProjectCellType_DPK;
    [_projectInfoDic setObject:@"" forKey:@"EEndDate"];
    [_tableViewData addObject:expectEndTimeModel];
    
    CreateProjectModel *addMileStoneModel = [[CreateProjectModel alloc] init];
    addMileStoneModel.title = @"点击添加里程碑";
    addMileStoneModel.cellType = CreateProjectCellType_CA;
    [_tableViewData addObject:addMileStoneModel];

}

- (NSMutableArray *)getProjectType {
    [_sqlite open_db];
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:@"--选择项目类型--"];
    NSString *searchType = @"SELECT * FROM ProjectType";
    FMResultSet *resultSet = [_sqlite search_db:searchType];
    while([resultSet next]) {
        NSString *tName = [resultSet stringForColumn:@"PTName"];
        [result addObject:tName];
    }
    
    [_sqlite close_db];
    return result;
}

- (NSMutableArray *)getProjectGroup {
    [_sqlite open_db];
    
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:@"--选择项目族--"];

    NSString *searchGroup = [NSString stringWithFormat:@"SELECT * FROM ProjectGroup WHERE userId = '%@'",_userId];
    FMResultSet *resultSet = [_sqlite search_db:searchGroup];
    while([resultSet next]) {
        NSString *PGName = [resultSet stringForColumn:@"PGName"];
        [result addObject:PGName];
    }
    [_sqlite close_db];
    return result;
}
                     
                     

#pragma mark -- UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableViewData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreateProjectModel *createModel = [_tableViewData objectAtIndex:indexPath.row];
    if(createModel.cellType == CreateProjectCellType_TF) {
        ProjectInfoTextCell *cell = [ProjectInfoTextCell createCellWithTableView:tableView];
        [cell refreshContentFromModel:createModel];
        cell.block = ^(NSString *key, NSString *text) {
            NSLog(@"%@: %@",key,text);
            createModel.text = text;
            [self.projectInfoDic setObject:text forKey:key];
        };
        return cell;
        
    } else if(createModel.cellType == CreateProjectCellType_DPK) {
        ProjectInfoDateCell *cell = [ProjectInfoDateCell createCellWithTableView:tableView];
        [cell refreshContentFromModel:createModel];
        
        cell.dateBlock =^(NSString *key, NSDate *date) {
            NSLog(@"%@: %@",key,[Util transDateToString:date]);
            //记录开始和结束日期
            if([key isEqualToString:@"startDate"]) {
                self.startDate = date;
            } else {
                self.endDate = date;
            }
            createModel.date = date;
            [self.projectInfoDic setObject:date forKey:key];
        };
        cell.startDate = self.startDate;

        return cell;
    } else if(createModel.cellType == CreateProjectCellType_PK) {
        ProjectInfoPickerCell *cell = [ProjectInfoPickerCell createCellWithTableView:tableView];
        [cell refreshContentFromModel:createModel];
        cell.block =^(NSString *key, NSString *text) {
            NSLog(@"%@: %@",key,text);
            createModel.text = text;
            [self.projectInfoDic setObject:text forKey:key];
        };

        return cell;
    } else if(createModel.cellType == CreateProjectCellType_CA) {
        ClickAddCell *cell = [ClickAddCell createCellWithTableView:tableView];
        [cell refreshContentFromModel:createModel];
        
        return cell;
    }else if(createModel.cellType == CreateProjectCellType_MS) {
        ProjectInfoMileStoneCell *cell = [ProjectInfoMileStoneCell createCellWithTableView:tableView];
        [cell refreshContentFromModel:createModel];
        
        cell.nameBlock =^(NSString *key, NSString *name) {
            NSLog(@"第%ld个里程碑的名字: %@",[key integerValue] + 1,name);
            createModel.text = name;
            [self.milestoneInfoDic setObject:name forKey:[@"name" stringByAppendingString:key]];
        };
        
        cell.dateBlock =^(NSString *key, NSDate *date) {
            NSLog(@"第%ld个里程碑的日期: %@",[key integerValue] + 1,[Util transDateToString:date]);
            createModel.date = date;
            [self.milestoneInfoDic setObject:date forKey:[@"date" stringByAppendingString:key]];
        };
        
        [cell.datePicker setMaximumDate:_endDate];
        [cell.datePicker setMinimumDate:_startDate];
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CreateProjectModel *model = [_tableViewData objectAtIndex:indexPath.row];
    if(model.cellType == CreateProjectCellType_CA) {
        CreateProjectModel *model_ms = [[CreateProjectModel alloc] init];
        model_ms.cellType = CreateProjectCellType_MS;
        model_ms.key = [NSString stringWithFormat:@"%d",mileStoneCount++];
        [_milestoneInfoDic setObject:@"" forKey:[NSString stringWithFormat:@"name%d",model_ms.key]];
         [_milestoneInfoDic setObject:@"" forKey:[NSString stringWithFormat:@"date%d",model_ms.key]];
        [_tableViewData insertObject:model_ms atIndex:indexPath.row];
        [tableView reloadData];
    }
}

#pragma mark -- Alert
- (void)showAlertMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:true completion:nil];
}




@end
