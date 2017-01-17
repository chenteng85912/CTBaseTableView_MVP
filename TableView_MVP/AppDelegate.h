//
//  AppDelegate.h
//  TableView_MVP
//
//  Created by 腾 on 2017/1/14.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

