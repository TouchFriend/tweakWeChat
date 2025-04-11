#import <UIKit/UIKit.h>
#import "models/NJPerson.h"

#define NJUserDefaults [NSUserDefaults standardUserDefaults]
#define NJAutoKey @"NJAutoKey"
#define NJAssetPath(path) @"/Library/Caches/NJWeChat/" #path

%hook FindFriendEntryViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return %orig + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 2;
    }
    return %orig;
}

// 保存开关
%new
- (void)nj_autoChange:(UISwitch *)autoSwitch {
    [NJUserDefaults setBool:autoSwitch.isOn forKey:NJAutoKey];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != [self numberOfSectionsInTableView:tableView] - 1) {
        return %orig;
    }
    NSString *reuseIdentifier = indexPath.row == 0 ? @"autoRedPacketCellId" : @"exitCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.imageView.image = [UIImage imageWithContentsOfFile:NJAssetPath(skull.png)];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"自动抢红包";
        UISwitch *autoSwitch = [[UISwitch alloc] init];
        cell.accessoryView = autoSwitch;
        autoSwitch.on = [NJUserDefaults boolForKey:NJAutoKey];
        [autoSwitch addTarget:self action:@selector(nj_autoChange:) forControlEvents:UIControlEventValueChanged];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"退出微信";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != [self numberOfSectionsInTableView:tableView] - 1) {
        return %orig;
    }
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != [self numberOfSectionsInTableView:tableView] - 1) {
        %orig;
        return;
    }
    if (indexPath.row == 1) {
//        exit(0);
        abort();
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NJPerson *person = [[NJPerson alloc] init];
    person.age = 10;
    NSLog(@"person age is %ld", person.age);
}



%end

