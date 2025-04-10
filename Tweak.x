#import <UIKit/UIKit.h>

#define NJUserDefaults [NSUserDefaults standardUserDefaults]
#define NJAutoKey @"NJAutoKey"

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
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        static NSString *autoReuseIdentifier = @"autoRedPacket";
        cell = [tableView dequeueReusableCellWithIdentifier:autoReuseIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:autoReuseIdentifier];
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.textLabel.text = @"自动抢红包";
        UISwitch *autoSwitch = [[UISwitch alloc] init];
        cell.accessoryView = autoSwitch;
        autoSwitch.on = [NJUserDefaults boolForKey:NJAutoKey];
        [autoSwitch addTarget:self action:@selector(nj_autoChange:) forControlEvents:UIControlEventValueChanged];
    }
    if (indexPath.row == 1) {
        static NSString *exitReuseIdentifier = @"exit";
        cell = [tableView dequeueReusableCellWithIdentifier:exitReuseIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:exitReuseIdentifier];
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.textLabel.text = @"退出微信";
    }
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"111"];
        cell.backgroundColor = [UIColor whiteColor];
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
}


%end

