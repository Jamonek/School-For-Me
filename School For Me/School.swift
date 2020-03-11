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
    @objc dynamic var id  = ""
    @objc dynamic var school_name: String = ""
    @objc dynamic var nces_school_id = ""
    @objc dynamic var state_school_id = ""
    @objc dynamic var nces_district_id = ""
    @objc dynamic var state_district_id = ""
    @objc dynamic var low_grade = ""
    @objc dynamic var high_grade = ""
    @objc dynamic var district = ""
    @objc dynamic var county_name = ""
    @objc dynamic var street = ""
    @objc dynamic var city = ""
    @objc dynamic var state = ""
    @objc dynamic var zip = ""
    @objc dynamic var zip4 = ""
    @objc dynamic var phone = ""
    @objc dynamic var locale_code = ""
    @objc dynamic var locale = ""
    @objc dynamic var charter = ""
    @objc dynamic var magnet = ""
    @objc dynamic var lat = ""
    @objc dynamic var lon = ""
    @objc dynamic var title1 = ""
    @objc dynamic var title1SchoolWide = ""
    @objc dynamic var students = ""
    @objc dynamic var teachers = ""
    @objc dynamic var studentTeacherRatio = ""
    @objc dynamic var freeLunch = ""
    @objc dynamic var reducedLunch = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
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
    
    @objc static func mappedSchool(_ dict:Dictionary<String, AnyObject>) -> School {
        //return Mapper<School>().map(dict)! as School
        return Mapper<School>().map(JSON: dict)! as School
    }
}
