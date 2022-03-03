//
//  ViewController.m
//  ObjCSampleCode
//
//  Created by Monalisa on 27/02/22.
//  Copyright © 2022 Monalisa. All rights reserved.


#import "ViewController.h"
#import "Course.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray<Course *> *courses;

@end

@implementation ViewController

NSString *cellId = @"cellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCourses];
    [self fetchCoursesUsingJSON];
    
    self.navigationItem.title = @"Courses";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellId];
}

- (void)fetchCoursesUsingJSON {
    NSLog(@"Fetching Courses");
//
    NSString *urlString = @"https://api.letsbuildthatapp.com/jsondecodable/courses";
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"Finished fetching courses....");
        
        NSError *err;
        NSArray *courseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        if (err){
            NSLog(@"Failed to serialize into JSON: %@", err);
            return;
        }
        
        NSMutableArray<Course *> *courses = NSMutableArray.new;
        for (NSDictionary *courseDict in courseJSON) {
            NSString *name = courseDict[@"name"];
            NSNumber *numberOfLessons = courseDict[@"number_of_lessons"];
            Course *course = Course.new;
            course.name = name;
            course.numberOfLessons = numberOfLessons;
            [courses addObject:course];
        }
        
//        NSLog(@"%@", courses);
        self.courses = courses;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
        
    }] resume];
}

- (void)setupCourses{
    self.courses = NSMutableArray.new;
    
    Course *course = Course.new;
    course.name = @"Instagram Firebase";
    course.numberOfLessons = @(49);
    [self.courses addObject:course];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    // quick hack
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    
    Course *course = self.courses[indexPath.row];
    
    cell.textLabel.text = course.name;
    cell.detailTextLabel.text = course.numberOfLessons.stringValue;
    return cell;
}















@end
