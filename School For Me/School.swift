//
//  School.swift
//  School For Me
//
//  Created by Jamone Alexander Kelly on 12/13/15.
//  Copyright © 2015 Jamone Kelly. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import CoreLocation

class School: Object, Mappable {
    dynamic var id  = ""
    dynamic var school_name: String = ""
    dynamic var nces_school_id = ""
    dynamic var state_school_id = ""
    dynamic var nces_district_id = ""
    dynamic var state_district_id = ""
    dynamic var low_grade = ""
    dynamic var high_grade = ""
    dynamic var district = ""
    dynamic var county_name = ""
    dynamic var street = ""
    dynamic var city = ""
    dynamic var state = ""
    dynamic var zip = ""
    dynamic var zip4 = ""
    dynamic var phone = ""
    dynamic var locale_code = ""
    dynamic var locale = ""
    dynamic var charter = ""
    dynamic var magnet = ""
    dynamic var lat = ""
    dynamic var lon = ""
    dynamic var title1 = ""
    dynamic var title1SchoolWide = ""
    dynamic var students = ""
    dynamic var teachers = ""
    dynamic var studentTeacherRatio = ""
    dynamic var freeLunch = ""
    dynamic var reducedLunch = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(_ map: Map) {
        id <- map["properties.id"]
        school_name <- map["properties.school_name"]
        nces_district_id <- map["properties.nces_district_id"]
        state_district_id <- map["properties.state_district_id"]
        state_school_id <- map["properties.state_school_id"]
        low_grade <- map["properties.low_grade"]
        high_grade <- map["properties.high_grade"]
        district <- map["properties.district"]
        county_name <- map["properties.county_name"]
        street <- map["properties.street"]
        city <- map["properties.city"]
        state <- map["properties.state"]
        zip <- map["properties.zip"]
        zip4 <- map["properties.zip4"]
        phone <- map["properties.phone"]
        locale_code <- map["properties.locale_code"]
        locale <- map["properties.locale"]
        charter <- map["properties.charter"]
        magnet <- map["properties.magnet"]
        lat <- map["geometry.coordinates.lat"]
        lon <- map["geometry.coordinates.lon"]
        title1 <- map["properties.title1"]
        title1SchoolWide <- map["properties.title1_school_wide"]
        students <- map["properties.students"]
        teachers <- map["properties.teachers"]
        studentTeacherRatio <- map["properties.student_teacher_ratio"]
        freeLunch <- map["properties.free_lunch"]
        reducedLunch <- map["properties.reduced_lunch"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func mappedSchool(_ dict:Dictionary<String, AnyObject>) -> School {
        return Mapper<School>().map(dict)! as School
    }
}
