//
//  NextUpWidgetPresenter.swift
//  Coursera
//
//  Created by Alex Wang on 10/5/16.
//  Copyright © 2016 Coursera. All rights reserved.
//

import CourseraFoundation
import CourseraData

class NextUpWidgetPresenter: NextUpWidgetViewModel {
    let interactor: NextUpWidgetInteractor
    
    let courses: Dynamic<[FormattedNextUpCourseData]> = Dynamic([])
    
    init(interactor: NextUpWidgetInteractor = Interactor()) {
        self.interactor = interactor
    }
    
    func loadNextUpItem(completion: (Result<Bool> -> Void)? = nil) {
        interactor.getMostRecentlyActiveCourses { [weak self] (recentCourses) in
            guard let `self` = self else { return }
            
            switch recentCourses {
            case .Value(let courses):
                var nextUpCourses = [CourseModel]()

                if !courses.isEmpty {
                    nextUpCourses = Array(courses.prefix(2))
                } else {
                    completion?(Result(NSError(kind: CourseraErrorKind.NoDataAvailable)))
                    return
                }
                
                for nextUpCourse in nextUpCourses {
                    self.formatCourseForNextUp(nextUpCourse)
                }
                
                completion?(Result(true))
            case .Error(let error):
                logError("Error getting courses! \(error.localizedDescription)")
                completion?(Result(error))
            }
        }
    }
    
    func formatCourseForNextUp(course: CourseModel) {
        guard let courseID = course.remoteID, courseSlug = course.slug, courseName = course.name else { return }
        
        interactor.getNextUpForCourse(courseID) { [weak self] (nextStepsResult) in
            guard let `self` = self else { return }
            
            switch nextStepsResult {
            case .Value(let nextStepOption):
                switch nextStepOption {
                case .CourseComplete(_):
                    let formattedNextStepData = FormattedNextUpCourseData(courseID: courseID,
                                                                          itemID: nil,
                                                                          courseName: courseName,
                                                                          topSubtitle: LocalizedStrings.courseComplete,
                                                                          mainBodyText: LocalizedStrings.viewCertificate,
                                                                          bottomSubtitle: nil,
                                                                          actionText: LocalizedStrings.view,
                                                                          photoURL: course.photoURL,
                                                                          courseSlug: courseSlug,
                                                                          contentType: "courseComplete")
                    self.courses.value.append(formattedNextStepData)
                case .SwitchSession(_):
                    let formattedNextStepData = FormattedNextUpCourseData(courseID: courseID,
                                                                          itemID: nil,
                                                                          courseName: courseName,
                                                                          topSubtitle: LocalizedStrings.switchSessions.uppercaseString,
                                                                          mainBodyText: LocalizedStrings.nextStepSwitchSessionsOverdue,
                                                                          bottomSubtitle: nil,
                                                                          actionText: LocalizedStrings.switchButton,
                                                                          photoURL: course.photoURL,
                                                                          courseSlug: courseSlug,
                                                                          contentType: "switchSession")
                    self.courses.value.append(formattedNextStepData)
                case .CourseMaterial(_, _, _, _, _):
                    let courseMaterial = NextStepOption.getCourseMaterialNextStep(nextStepOption)
                    
                    if let prepatoryItemID = courseMaterial.preparatoryItemID {
                        self.getItemInformationForID(courseID,
                                                     courseName: courseName,
                                                     courseSlug: courseSlug,
                                                     itemID: prepatoryItemID,
                                                     photoURL: course.photoURL)
                    } else if let passableItemID = courseMaterial.passableItemID {
                        self.getItemInformationForID(courseID,
                                                     courseName: courseName,
                                                     courseSlug: courseSlug,
                                                     itemID: passableItemID,
                                                     photoURL: course.photoURL)
                    }
                }
            case .Error(let error):
                logError("Error loading next up: \(error.localizedDescription)")
            }
        }
    }
    
    func getItemInformationForID(courseID: String, courseName: String, courseSlug: String, itemID: String, photoURL: String?) {
        interactor.getItemForItemID(courseID, itemID: itemID, completion: { [weak self] (courseMaterialResult) in
            guard let `self` = self else { return }
            
            switch courseMaterialResult {
            case .Value(let item):
                guard let itemName = item.name else {
                    break
                }
                
                let itemType = self.contentNameForItemType(item.contentType).uppercaseString
                let timeEstimation = self.millisecondsToMinutes(item.timeCommitment)
                
                let formattedNextStepData = FormattedNextUpCourseData(courseID: courseID,
                    itemID: itemID,
                    courseName: courseName,
                    topSubtitle: itemType,
                    mainBodyText: itemName,
                    bottomSubtitle: timeEstimation,
                    actionText: LocalizedStrings.start,
                    photoURL: photoURL,
                    courseSlug: courseSlug,
                    contentType: item.contentType.rawValue)
                self.courses.value.append(formattedNextStepData)
            case .Error(let error):
                logError("Error getting item for item ID \(itemID): \(error.localizedDescription)")
            }
        })
    }
    
    func contentNameForItemType(itemType: CourseMaterialItemContentType) -> String {
        switch itemType {
        case .Lecture:
            return LocalizedStrings.video
        case .Supplement:
            return LocalizedStrings.reading
        case .PeerReview, .PhasedPeerReview, .SplitPeerReview, .ClosedPeerReview, .GradedPeerReview:
            return LocalizedStrings.peerReviewAssignment
        case .DiscussionPrompt:
            return LocalizedStrings.discussionPrompt
        case .GradedLti, .GradedProgramming, .Programming:
            return LocalizedStrings.gradedAssignment
        case .Quiz:
            return LocalizedStrings.practiceQuiz
        case .Exam:
            return LocalizedStrings.exam
        case .UngradedProgramming:
            return LocalizedStrings.practiceAssignment
        case .Unknown:
            return ""
        }
    }
    
    func millisecondsToMinutes(milliseconds: Double) -> String {
        let millisecondsPerMinute = 1000 * 60
        let millisecondsPerSecond = 1000
        let minutesPerHour = 60
        let minutes = Int(milliseconds) / millisecondsPerMinute
        
        if minutes == 0 {
            return LocalizedStrings.numberOfSecondsPlural(Int(milliseconds) / millisecondsPerSecond)
        } else if minutes < minutesPerHour {
            if minutes == 1 {
                return LocalizedStrings.numberOfMinutesSingular(minutes)
            } else {
                return LocalizedStrings.numberOfMinutesPlural(minutes)
            }
        } else {
            let hours = minutes / minutesPerHour
            let remainder = minutes % minutesPerHour
            return LocalizedStrings.numberOfHoursAndMinutesShort(hours, minutes: remainder)
        }
    }
}

protocol NextUpWidgetEventHandler {
    func didLoad()
    func updateData(completion: Result<Bool> -> Void)
}

extension NextUpWidgetPresenter: NextUpWidgetEventHandler {
    func didLoad() {
        loadNextUpItem()
    }
    
    func updateData(completion: Result<Bool> -> Void) {
        loadNextUpItem(completion)
    }
}
