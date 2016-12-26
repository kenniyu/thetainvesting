//
//  NextUpWidgetInteractor.swift
//  Coursera
//
//  Created by Alex Wang on 10/5/16.
//  Copyright © 2016 Coursera. All rights reserved.
//

import CourseraFoundation
import CourseraData

protocol NextUpWidgetInteractor {
    func getMostRecentlyActiveCourses(enrollmentsCallback: Result<[CourseModel]> -> Void)
    func getNextUpForCourse(courseID: String, completion: Result<NextStepOption> -> Void)
    func getItemForItemID(courseID: String, itemID: String, completion: Result<CourseMaterialItemModel> -> Void)
    
}

class Interactor: NextUpWidgetInteractor {
    let courseraDataAPI = CourseraDataAPI()
    
    func getMostRecentlyActiveCourses(enrollmentsCallback: Result<[CourseModel]> -> Void) {
        courseraDataAPI.getEnrollments(CourseEnrollmentStatus.Current, expires: .Always) { (currentMemberships, error) in
            if let error = error {
                logError("Error getting enrollments: \(error.localizedDescription)")
                enrollmentsCallback(Result(error))
                return
            }
            
            guard let currentMemberships = currentMemberships else {
                enrollmentsCallback(Result(NSError(kind: CourseraErrorKind.NoDataAvailable)))
                return
            }
            
            guard let courses = currentMemberships.courses else {
                enrollmentsCallback(Result(NSError(kind: CourseraErrorKind.NoDataAvailable)))
                return
            }
            
            enrollmentsCallback(Result(courses))
        }
    }
    
    func getNextUpForCourse(courseID: String, completion: Result<NextStepOption> -> Void) {
        courseraDataAPI.getNextUpItemForCourse(courseID) { [weak self] (nextStepsResult) in
            guard let `self` = self else { return }
            
            switch nextStepsResult {
            case .Value(let nextSteps):
                guard let nextStepDictionary = nextSteps.nextStep, formattedNextSteps = self.processNextStepDictionary(nextStepDictionary) else {
                    logError("Cannot process next step dictionary!")
                    completion(Result(NSError(kind: CourseraErrorKind.UnableToDecodeDataFromRemoteService)))
                    return
                }
                
                completion(Result(formattedNextSteps))
            case .Error(let error):
                logError("Error getting next step! \(error.localizedDescription)")
                completion(Result(error))
            }
        }
    }
    
    func getItemForItemID(courseID: String, itemID: String, completion: Result<CourseMaterialItemModel> -> Void) {
        courseraDataAPI.courseMaterialItem(courseID, itemID: itemID, courseMaterialItemCallback: completion)
    }
    
    /**
     This takes the code the server returns us and creates a human-readable thing that we all love and enjoy.
     
     - parameter nextSteps: Dictionary with next step information. See the GuidedProgressNextStepsItemModel for information
     */
    func processNextStepDictionary(nextSteps: [String: AnyObject]) -> NextStepOption? {
        guard let key = nextSteps.keys.first else {
            assertError("No keys exist in next step!")
            return nil
        }
        
        guard let value = nextSteps[key] else {
            assertError("No value exists for key \(key) in next step dictionary!")
            return nil
        }
        
        guard let nextStepKey = key.componentsSeparatedByString(".").last else {
            assertError("Invalid key found! \(key)")
            return nil
        }
        
        switch nextStepKey {
        case "CourseMaterialNextStep":
            guard let result = value as? [String: AnyObject],
                dueAt = result["dueAt"] as? Double,
                isOverdue = result["isOverdue"] as? Bool,
                progressStatus = result["courseOnTrackStatus"] as? String else {
                    assertError("Unexpected value received - expected duedate, overdue status, and progress status for course materials")
                    return nil
            }
            
            let nextStepStruct = CourseMaterialNextStepData(dueAt: dueAt,
                                                            isOverdue: isOverdue,
                                                            progress: progressStatus,
                                                            preparatoryItemID: result["preparatoryItemId"] as? String,
                                                            passableItemID: result["passableLessonElementId"] as? String)
            return NextStepOption.formatCourseMaterialNextStep(nextStepStruct)
        case "SwitchSessionNextStep":
            guard let result = value as? [String: String], reason = result["reason"] else {
                assertError("Unexpected value received - expected a reason for switching sessions")
                return nil
            }
            
            return NextStepOption.SwitchSession(reason)
        case "CourseCompletedNextStep":
            guard let result = value as? String else {
                assertError("Unknown value received - expected string")
                return nil
            }
            
            return NextStepOption.CourseComplete(result)
        default:
            assertError("Unknown next step key encountered: \(nextStepKey)")
            return nil
        }
    }
}
