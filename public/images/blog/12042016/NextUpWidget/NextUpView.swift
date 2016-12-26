//
//  NextUpView.swift
//  Coursera
//
//  Created by Daniel Shusta on 10/6/16.
//  Copyright © 2016 Coursera. All rights reserved.
//

import CourseraUIKit

class NextUpView: UIView {

    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var courseNameLabel: UILabel!

    @IBOutlet weak var assignmentItemTypeLabel: UILabel!
    @IBOutlet weak var assignmentBarView: UIView!
    @IBOutlet weak var assignmentNameLabel: UILabel!
    @IBOutlet weak var assignmentEstimatedTimeLabel: UILabel!
    @IBOutlet weak var nextStepButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        nextStepButton.backgroundColor = ColorPalette.BackgroundColor.MentorBlue.color()
        nextStepButton.setTitleColor(ColorPalette.DarkTextTheme.Primary.color(), forState: .Normal)
        nextStepButton.layer.cornerRadius = 2.0
        nextStepButton.setTitle(CourseraLocalizedString("Resume", comment: "Button title to launch next up item"), forState: .Normal)

        courseImageView.clipsToBounds = true

        assignmentBarView.backgroundColor = ColorPalette.BackgroundColor.MentorBlue.color()

        updateStyling()
    }

    func updateStyling() {
        let pointSize = 16.0 * FontBook.Title.accessibilityPreferenceScaleFactor()
        let font = UIFont.systemFontOfSize(pointSize, weight: UIFontWeightMedium)
        courseNameLabel.font = font

        assignmentItemTypeLabel.alpha = 0.5
        assignmentItemTypeLabel.font = FontBook.Caption.font()

        assignmentNameLabel.font = FontBook.Body1.font()

        assignmentEstimatedTimeLabel.alpha = 0.5
        assignmentEstimatedTimeLabel.font = FontBook.Caption.font()
    }

    func configure(nextUpData: FormattedNextUpCourseData) {
        courseNameLabel.text = nextUpData.courseName

        assignmentItemTypeLabel.text = nextUpData.topSubtitle
        assignmentNameLabel.text = nextUpData.mainBodyText
        assignmentEstimatedTimeLabel.text = nextUpData.bottomSubtitle

        if let photoPath = nextUpData.photoURL, photoURL = NSURL(string: photoPath) {
            courseImageView.setNetworkImage(URL: photoURL)
        }
    }
}
