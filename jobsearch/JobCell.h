//
//  JobCell.h
//  jobsearch
//
//  Created by CHAN on 13. 6. 2..
//  Copyright (c) 2013년 CHAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@end
