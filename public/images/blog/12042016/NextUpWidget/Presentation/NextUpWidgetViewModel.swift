//
//  NextUpWidgetViewModel.swift
//  Coursera
//
//  Created by Alex Wang on 10/6/16.
//  Copyright © 2016 Coursera. All rights reserved.
//

import CourseraFoundation
import CourseraData

protocol NextUpWidgetViewModel {
    var courses: Dynamic<[FormattedNextUpCourseData]> { get }
}

struct FormattedNextUpCourseData {
    let courseID: String
    let itemID: String?
    let courseName: String
    let topSubtitle: String?
    let mainBodyText: String
    let bottomSubtitle: String?
    let actionText: String
    let photoURL: String?
    let courseSlug: String
    let contentType: String

    func toPlistDict() -> [String: String] {
        var plistDict = [
            "courseID": courseID,
            "courseName": courseName,
            "mainBodyText": mainBodyText,
            "actionText": actionText,
            "contentType": contentType,
            "courseSlug": courseSlug
        ]
        if let itemID = itemID { plistDict["itemID"] = itemID }
        if let topSubtitle = topSubtitle { plistDict["topSubtitle"] = topSubtitle }
        if let bottomSubtitle = bottomSubtitle { plistDict["bottomSubtitle"] = bottomSubtitle }
        if let photoURL = photoURL { plistDict["photoURL"] = photoURL }
        return plistDict
    }

    static func fromPlistDict(dict: [String: String]) -> FormattedNextUpCourseData? {
        guard let courseId = dict["courseID"],
            courseName = dict["courseName"],
            mainBodyText = dict["mainBodyText"],
            actionText = dict["actionText"],
            contentType = dict["contentType"],
            courseSlug = dict["courseSlug"] else {
                return nil
        }

        return FormattedNextUpCourseData(courseID: courseId,
                                         itemID: dict["itemID"],
                                         courseName: courseName,
                                         topSubtitle: dict["topSubtitle"],
                                         mainBodyText: mainBodyText,
                                         bottomSubtitle: dict["bottomSubtitle"],
                                         actionText: actionText,
                                         photoURL: dict["photoURL"],
                                         courseSlug: courseSlug,
                                         contentType: contentType)
    }
}
