//
//  AppModel.swift
//  Cozy Up
//
//  Created by Amisha on 15/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//
import UIKit


class AppModel: NSObject {
    static let shared = AppModel()
    var currentUser : UserModel!
    
    func validateUser(dict : [String : Any]) -> Bool{
        if let uID = dict["uID"] as? String, let email = dict["email"] as? String
        {
            if(uID != "" && email != ""){
                return true
            }
        }
        return false
    }
    
    func resetAllModel()
    {
        currentUser = UserModel.init()
    }
}



class UserModel : AppModel
{
    var uId : String!
    var email : String!
    var fname : String!
    var lname : String!
    var url : String!
    var activation_key : String!
    var status : String!
    var post_type : String!
    var collegeID : String!
    var collegeName : String!
    
    override init(){
        uId = ""
        email = ""
        fname = ""
        lname = ""
        url = ""
        activation_key = ""
        status = ""
        post_type = ""
        collegeID = ""
        collegeName = ""
    }
    
    init(dict : [String : Any])
    {
        uId = ""
        email = ""
        fname = ""
        lname = ""
        url = ""
        activation_key = ""
        status = ""
        post_type = ""
        collegeID = ""
        collegeName = ""
        
        if let temp = dict["ID"] as? String {
            uId = temp
        }
        if let temp = dict["user_email"] as? String{
            email = temp
        }
        if let temp = dict["first_name"] as? String{
            fname = temp
        }
        if let temp = dict["last_name"] as? String{
            lname = temp
        }
        if let temp = dict["user_url"] as? String{
            url = temp
        }
        if let temp = dict["user_activation_key"] as? String{
            activation_key = temp
        }
        if let temp = dict["user_status"] as? String{
            status = temp
        }
        if let temp = dict["post_type"] as? String{
            post_type = temp
        }
        if let temp = dict["collegeID"] as? String{
            collegeID = temp
        }
        if let temp = dict["collegeName"] as? String{
            collegeName = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["ID":uId, "user_email" : email, "first_name" : fname, "last_name" : lname, "user_url":url,"user_activation_key" : activation_key,"user_status" : status, "post_type":post_type, "collegeID":collegeID, "collegeName":collegeName]
    }
    
    func toJson(_ dict:[String:Any]) -> String{
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        return jsonString!
    }
}

class PlayerDetailModel : AppModel
{
    var main : PlayerMainModel!
    var playerinfo : PlayerInfoModel!
    var athletics : AthleticsModel!
    var academics : AcademicsModel!
    var photosandvidoes : MediaModel!
    
    override init(){
        main = PlayerMainModel.init()
        playerinfo = PlayerInfoModel.init()
        athletics = AthleticsModel.init()
        academics = AcademicsModel.init()
        photosandvidoes = MediaModel.init()
    }
    
    init(dict : [String : Any])
    {
        main = PlayerMainModel.init()
        playerinfo = PlayerInfoModel.init()
        athletics = AthleticsModel.init()
        academics = AcademicsModel.init()
        photosandvidoes = MediaModel.init()
        
        if let temp = dict["main"] as? [String : Any] {
            main = PlayerMainModel.init(dict: temp)
        }
        if let temp = dict["playerinfo"] as? [String : Any] {
            playerinfo = PlayerInfoModel.init(dict: temp)
        }
        if let temp = dict["athletics"] as? [String : Any] {
            athletics = AthleticsModel.init(dict: temp)
        }
        if let temp = dict["academics"] as? [String : Any] {
            academics = AcademicsModel.init(dict: temp)
        }
        if let temp = dict["photosandvidoes"] as? [String : Any] {
            photosandvidoes = MediaModel.init(dict: temp)
        }
    }
}


class PlayerMainModel : AppModel
{
    var id : String!
    var profile_image : String!
    var name : String!
    var sr : String!
    var grandyear : String!
    var location : String!
    var committed : String!
    var note : String!
    var track_player : String!
    var tracked_by : [String]!
    
    override init(){
        id = ""
        profile_image = ""
        name = ""
        sr = ""
        grandyear = ""
        location = ""
        committed = ""
        note = ""
        track_player = ""
        tracked_by = [String]()
    }
    
    init(dict : [String : Any])
    {
        id = ""
        profile_image = ""
        name = ""
        sr = ""
        grandyear = ""
        location = ""
        committed = ""
        note = ""
        track_player = ""
        tracked_by = [String]()
        
        if let temp = dict["id"] as? String {
            id = temp
        }
        if let temp = dict["profile_image"] as? String {
            profile_image = temp
        }
        if let temp = dict["name"] as? String{
            name = temp
        }
        if let temp = dict["sr"] as? String{
            sr = temp
        }
        if let temp = dict["grandyear"] as? String{
            grandyear = temp
        }
        if let temp = dict["location"] as? String{
            location = temp
        }
        if let temp = dict["committed"] as? String{
            committed = temp
        }
        if let temp = dict["note"] as? String{
            note = temp
        }
        if let temp = dict["track_player"] as? String{
            track_player = temp
        }
        else if let temp = dict["tracked"] as? String{
            track_player = temp
        }
        if let temp = dict["tracked_by"] as? [String]{
            tracked_by = temp
        }
    }
}

class PlayerInfoModel : AppModel
{
    var location : String!
    var player_email : String!
    var school_name : String!
    var gpa : String!
    var beachclub : String!
    var currenteducationlevel : String!
    var about : String!
    var birthdate : String!
    var parents_email : String!
    var mailing_address : String!
    var parents_name : String!
    var phone : String!
    var citezenship : String!
    var passport : String!
    var scholarship : String!
    var collage_location_preference : [ValueModel]!
    var willing_travel : String!
    var money_contribute : String!
    var height : String!
    var weight : String!
    var standing_reach : String!
    var vertical_touch : String!
    var vertical_jump : String!
    var hit : String!
    
    
    override init(){
        location = ""
        player_email = ""
        school_name = ""
        gpa = ""
        beachclub = ""
        currenteducationlevel = ""
        about = ""
        birthdate = ""
        parents_email = ""
        mailing_address = ""
        parents_name = ""
        phone = ""
        citezenship = ""
        passport = ""
        scholarship = ""
        collage_location_preference = [ValueModel]()
        willing_travel = ""
        money_contribute = ""
        height = ""
        weight = ""
        standing_reach = ""
        vertical_touch = ""
        vertical_jump = ""
        hit = ""
    }
    
    init(dict : [String : Any])
    {
        location = ""
        player_email = ""
        school_name = ""
        gpa = ""
        beachclub = ""
        currenteducationlevel = ""
        about = ""
        birthdate = ""
        parents_email = ""
        mailing_address = ""
        parents_name = ""
        phone = ""
        citezenship = ""
        passport = ""
        scholarship = ""
        collage_location_preference = [ValueModel]()
        willing_travel = ""
        money_contribute = ""
        height = ""
        weight = ""
        standing_reach = ""
        vertical_touch = ""
        vertical_jump = ""
        hit = ""
        
        if let temp = dict["location"] as? String {
            location = temp
        }
        if let temp = dict["player_email"] as? String{
            player_email = temp
        }
        if let temp = dict["school_name"] as? String{
            school_name = temp
        }
        if let temp = dict["gpa"] as? String{
            gpa = temp
        }
        if let temp = dict["beachclub"] as? String{
            beachclub = temp
        }
        if let temp = dict["currenteducationlevel"] as? String{
            currenteducationlevel = temp
        }
        if let temp = dict["about"] as? String{
            about = temp
        }
        if let temp = dict["birthdate"] as? String{
            birthdate = temp
        }
        if let temp = dict["parents_email"] as? String{
            parents_email = temp
        }
        if let temp = dict["mailing_address"] as? String{
            mailing_address = temp
        }
        if let temp = dict["parents_name"] as? String{
            parents_name = temp
        }
        if let temp = dict["phone"] as? String{
            phone = temp
        }
        if let temp = dict["citezenship"] as? String{
            citezenship = temp
        }
        if let temp = dict["passport"] as? String{
            passport = temp
        }
        if let temp = dict["scholarship"] as? String{
            scholarship = temp
        }
        if let temp = dict["collage_location_preference"] as? [[String : Any]] {
            
            for tempDict in temp
            {
                collage_location_preference.append(ValueModel.init(dict: tempDict))
            }
        }
        if let temp = dict["willing_travel"] as? String{
            willing_travel = temp
        }
        if let temp = dict["money_contribute"] as? String{
            money_contribute = temp
        }
        if let temp = dict["height"] as? String{
            height = temp
        }
        if let temp = dict["weight"] as? String{
            weight = temp
        }
        if let temp = dict["standing_reach"] as? String{
            standing_reach = temp
        }
        if let temp = dict["vertical_touch"] as? String{
            vertical_touch = temp
        }
        if let temp = dict["vertical_jump"] as? String{
            vertical_jump = temp
        }
        if let temp = dict["hit"] as? String{
            hit = temp
        }
    }
}

class AthleticsModel : AppModel
{
    var describe_your_ideal_teammate : String!
    var position : String!
    var are_you_registered_with_the_ncaa : String!
    var describe_why_you_like_beach_volleyball : String!
    var what_tournament_series_do_you_play : String!
    var how_many_times_have_you_placed_1st_in_a_tournament : String!
    var how_many_times_have_you_finished_in_the_top_3_in_a_tournament : String!
    var tournament_results : [String]!
    var schedule : String!
    var how_many_years_have_you_played_beach_volleyball : String!
    var do_you_currently_play_with_a_beach_club : String!
    var beach_club_name : String!
    var beach_club_website : String!
    var beach_club_directors_name : String!
    var beach_club_directors_phone_number : String!
    var beach_club_directors_email_address : String!
    var do_you_currently_play_high_school_or_college_beach : String!
    var school_name_hs : String!
    var coachs_name_hs : String!
    var coachs_phone_number_hs : String!
    var coachs_email_address_hs : String!
    var how_many_years_have_you_played_indoor_volleyball : String!
    var do_you_currently_play_with_an_indoor_club : String!
    var position_played : String!
    var indoor_club_name : String!
    var indoor_club_website : String!
    var indoor_club_directors_name : String!
    var indoor_club_directors_phone_number : String!
    var indoor_club_directors_email_address : String!
    var do_you_currently_play_high_school_or_college_indoor : String!
    var school_name_hsc : String!
    var coachs_name_hsc : String!
    var coachs_phone_number_hsc : String!
    var coachs_email_address_hsc : String!
    
    override init(){
        describe_your_ideal_teammate = ""
        position = ""
        are_you_registered_with_the_ncaa = ""
        describe_why_you_like_beach_volleyball = ""
        what_tournament_series_do_you_play = ""
        how_many_times_have_you_placed_1st_in_a_tournament = ""
        how_many_times_have_you_finished_in_the_top_3_in_a_tournament = ""
        tournament_results = [String]()
        schedule = ""
        how_many_years_have_you_played_beach_volleyball = ""
        do_you_currently_play_with_a_beach_club = ""
        beach_club_name = ""
        beach_club_website = ""
        beach_club_directors_name = ""
        beach_club_directors_phone_number = ""
        beach_club_directors_email_address = ""
        do_you_currently_play_high_school_or_college_beach = ""
        school_name_hs = ""
        coachs_name_hs = ""
        coachs_phone_number_hs = ""
        coachs_email_address_hs = ""
        how_many_years_have_you_played_indoor_volleyball = ""
        do_you_currently_play_with_an_indoor_club = ""
        position_played = ""
        indoor_club_name = ""
        indoor_club_website = ""
        indoor_club_directors_name = ""
        indoor_club_directors_phone_number = ""
        indoor_club_directors_email_address = ""
        do_you_currently_play_high_school_or_college_indoor = ""
        school_name_hsc = ""
        coachs_name_hsc = ""
        coachs_phone_number_hsc = ""
        coachs_email_address_hsc = ""
    }
    
    init(dict : [String : Any])
    {
        describe_your_ideal_teammate = ""
        position = ""
        are_you_registered_with_the_ncaa = ""
        describe_why_you_like_beach_volleyball = ""
        what_tournament_series_do_you_play = ""
        how_many_times_have_you_placed_1st_in_a_tournament = ""
        how_many_times_have_you_finished_in_the_top_3_in_a_tournament = ""
        tournament_results = [String]()
        schedule = ""
        how_many_years_have_you_played_beach_volleyball = ""
        do_you_currently_play_with_a_beach_club = ""
        beach_club_name = ""
        beach_club_website = ""
        beach_club_directors_name = ""
        beach_club_directors_phone_number = ""
        beach_club_directors_email_address = ""
        do_you_currently_play_high_school_or_college_beach = ""
        school_name_hs = ""
        coachs_name_hs = ""
        coachs_phone_number_hs = ""
        coachs_email_address_hs = ""
        how_many_years_have_you_played_indoor_volleyball = ""
        do_you_currently_play_with_an_indoor_club = ""
        position_played = ""
        indoor_club_name = ""
        indoor_club_website = ""
        indoor_club_directors_name = ""
        indoor_club_directors_phone_number = ""
        indoor_club_directors_email_address = ""
        do_you_currently_play_high_school_or_college_indoor = ""
        school_name_hsc = ""
        coachs_name_hsc = ""
        coachs_phone_number_hsc = ""
        coachs_email_address_hsc = ""
        
        if let temp = dict["describe_your_ideal_teammate"] as? String {
            describe_your_ideal_teammate = temp
        }
        if let temp = dict["position"] as? String{
            position = temp
        }
        if let temp = dict["are_you_registered_with_the_ncaa"] as? String{
            are_you_registered_with_the_ncaa = temp
        }
        if let temp = dict["describe_why_you_like_beach_volleyball"] as? String{
            describe_why_you_like_beach_volleyball = temp
        }
        if let temp = dict["what_tournament_series_do_you_play"] as? String{
            what_tournament_series_do_you_play = temp
        }
        if let temp = dict["how_many_times_have_you_placed_1st_in_a_tournament"] as? String{
            how_many_times_have_you_placed_1st_in_a_tournament = temp
        }
        if let temp = dict["how_many_times_have_you_finished_in_the_top_3_in_a_tournament"] as? String{
            how_many_times_have_you_finished_in_the_top_3_in_a_tournament = temp
        }
        if let temp = dict["tournament_results"] as? [String]{
            tournament_results = temp
        }
        if let temp = dict["schedule"] as? String{
            schedule = temp
        }
        if let temp = dict["how_many_years_have_you_played_beach_volleyball"] as? String{
            how_many_years_have_you_played_beach_volleyball = temp
        }
        if let temp = dict["do_you_currently_play_with_a_beach_club"] as? String{
            do_you_currently_play_with_a_beach_club = temp
        }
        if let temp = dict["beach_club_name"] as? String{
            beach_club_name = temp
        }
        if let temp = dict["beach_club_website"] as? String{
            beach_club_website = temp
        }
        if let temp = dict["beach_club_directors_name"] as? String{
            beach_club_directors_name = temp
        }
        if let temp = dict["beach_club_directors_phone_number"] as? String{
            beach_club_directors_phone_number = temp
        }
        if let temp = dict["beach_club_directors_email_address"] as? String{
            beach_club_directors_email_address = temp
        }
        if let temp = dict["do_you_currently_play_high_school_or_college_beach"] as? String{
            do_you_currently_play_high_school_or_college_beach = temp
        }
        if let temp = dict["school_name_hs"] as? String{
            school_name_hs = temp
        }
        if let temp = dict["coachs_name_hs"] as? String{
            coachs_name_hs = temp
        }
        if let temp = dict["coachs_phone_number_hs"] as? String{
            coachs_phone_number_hs = temp
        }
        if let temp = dict["coachs_email_address_hs"] as? String{
            coachs_email_address_hs = temp
        }
        if let temp = dict["how_many_years_have_you_played_indoor_volleyball"] as? String{
            how_many_years_have_you_played_indoor_volleyball = temp
        }
        if let temp = dict["do_you_currently_play_with_an_indoor_club"] as? String{
            do_you_currently_play_with_an_indoor_club = temp
        }
        if let temp = dict["position_played"] as? String{
            position_played = temp
        }
        if let temp = dict["indoor_club_name"] as? String{
            indoor_club_name = temp
        }
        if let temp = dict["indoor_club_website"] as? String{
            indoor_club_website = temp
        }
        if let temp = dict["indoor_club_directors_name"] as? String{
            indoor_club_directors_name = temp
        }
        if let temp = dict["indoor_club_directors_phone_number"] as? String{
            indoor_club_directors_phone_number = temp
        }
        if let temp = dict["indoor_club_directors_email_address"] as? String{
            indoor_club_directors_email_address = temp
        }
        if let temp = dict["do_you_currently_play_high_school_or_college_indoor"] as? String{
            do_you_currently_play_high_school_or_college_indoor = temp
        }
        if let temp = dict["school_name_hsc"] as? String{
            school_name_hsc = temp
        }
        if let temp = dict["coachs_name_hsc"] as? String{
            coachs_name_hsc = temp
        }
        if let temp = dict["coachs_phone_number_hsc"] as? String{
            coachs_phone_number_hsc = temp
        }
        if let temp = dict["coachs_email_address_hsc"] as? String{
            coachs_email_address_hsc = temp
        }
    }
}

class AcademicsModel : AppModel
{
    var currenteducationlevel : String!
    var school : String!
    var gpa : String!
    var verbal_sat : String!
    var math_sat : String!
    var cumulative_sat : String!
    var act : String!
    var class_rank : String!
    var class_size : String!
    var academic_honors : String!
    var desired_cour_of_study : String!
    var excracurricular_activties : String!
    var hobbies : String!
    
    override init(){
        currenteducationlevel = ""
        school = ""
        gpa = ""
        verbal_sat = ""
        math_sat = ""
        cumulative_sat = ""
        act = ""
        class_rank = ""
        class_size = ""
        academic_honors = ""
        desired_cour_of_study = ""
        excracurricular_activties = ""
        hobbies = ""
    }
    
    init(dict : [String : Any])
    {
        currenteducationlevel = ""
        school = ""
        gpa = ""
        verbal_sat = ""
        math_sat = ""
        cumulative_sat = ""
        act = ""
        class_rank = ""
        class_size = ""
        academic_honors = ""
        desired_cour_of_study = ""
        excracurricular_activties = ""
        hobbies = ""
        
        if let temp = dict["currenteducationlevel"] as? String {
            currenteducationlevel = temp
        }
        if let temp = dict["school"] as? String{
            school = temp
        }
        if let temp = dict["gpa"] as? String {
            gpa = temp
        }
        if let temp = dict["verbal_sat"] as? String{
            verbal_sat = temp
        }
        if let temp = dict["math_sat"] as? String {
            math_sat = temp
        }
        if let temp = dict["cumulative_sat"] as? String{
            cumulative_sat = temp
        }
        if let temp = dict["act"] as? String {
            act = temp
        }
        if let temp = dict["class_rank"] as? String{
            class_rank = temp
        }
        if let temp = dict["class_size"] as? String {
            class_size = temp
        }
        if let temp = dict["academic_honors"] as? String{
            academic_honors = temp
        }
        if let temp = dict["desired_cour_of_study"] as? String {
            desired_cour_of_study = temp
        }
        if let temp = dict["excracurricular_activties"] as? String{
            excracurricular_activties = temp
        }
        if let temp = dict["hobbies"] as? String {
            hobbies = temp
        }
    }
}

class MediaModel : AppModel
{
    var video_urls : [String]!
    var photo_urls : [String]!
    
    override init(){
        video_urls = [String]()
        photo_urls = [String]()
    }
    
    init(dict : [String : Any])
    {
        video_urls = [String]()
        photo_urls = [String]()
        
        if let temp = dict["video_urls"] as? [String] {
            video_urls = temp
        }
        if let temp = dict["photo_urls"] as? [String] {
            photo_urls = temp
        }
    }
}


class ValueModel : AppModel
{
    var value : String!
    var label : String!
    
    override init(){
        value = ""
        label = ""
    }
    
    init(dict : [String : Any])
    {
        value = ""
        label = ""
        
        if let temp = dict["value"] as? String {
            value = temp
        }
        if let temp = dict["label"] as? String{
            label = temp
        }
    }
}

class EventModel : AppModel
{
    var id : String!
    var image : String!
    var name : String!
    var start : String!
    var end : String!
    var location : String!
    var host : String!
    var content : String!
    var schedule : String!
    var register_for_event : String!
    
    override init(){
        id = ""
        image = ""
        name = ""
        start = ""
        end = ""
        location = ""
        host = ""
        content = ""
        schedule = ""
        register_for_event = ""
    }
    
    init(dict : [String : Any])
    {
        id = ""
        image = ""
        name = ""
        start = ""
        end = ""
        location = ""
        host = ""
        content = ""
        schedule = ""
        register_for_event = ""
        
        if let temp = dict["id"] as? String {
            id = temp
        }
        if let temp = dict["image"] as? String{
            image = temp
        }
        if let temp = dict["name"] as? String{
            name = temp
        }
        if let temp = dict["start"] as? String{
            start = temp
        }
        if let temp = dict["end"] as? String{
            end = temp
        }
        if let temp = dict["location"] as? String{
            location = temp
        }
        if let temp = dict["host"] as? String{
            host = temp
        }
        if let temp = dict["content"] as? String{
            content = temp
        }
        if let temp = dict["schedule"] as? String{
            schedule = temp
        }
        if let temp = dict["register_for_event"] as? String{
            register_for_event = temp
        }
    }
}

class AttendeesModel : AppModel
{
    var id : String!
    var court_assignment : String!
    var grandyear : String!
    var name : String!
    var note : String!
    var pool : String!
    var profile_image : String!
    var sr : String!
    var track : String!
    
    override init(){
        id = ""
        court_assignment = ""
        grandyear = ""
        name = ""
        note = ""
        pool = ""
        profile_image = ""
        sr = ""
        track = ""
    }
    
    init(dict : [String : Any])
    {
        id = ""
        court_assignment = ""
        grandyear = ""
        name = ""
        note = ""
        pool = ""
        profile_image = ""
        sr = ""
        track = ""
        
        if let temp = dict["id"] as? String {
            id = temp
        }
        if let temp = dict["court_assignment"] as? String{
            court_assignment = temp
        }
        if let temp = dict["name"] as? String{
            name = temp
        }
        if let temp = dict["grandyear"] as? String{
            grandyear = temp
        }
        if let temp = dict["note"] as? String{
            note = temp
        }
        if let temp = dict["pool"] as? String{
            pool = temp
        }
        if let temp = dict["profile_image"] as? String{
            profile_image = temp
        }
        if let temp = dict["sr"] as? String{
            sr = temp
        }
        if let temp = dict["track"] as? String{
            track = temp
        }
    }
}


class CollageModel : AppModel
{
    var id : String!
    var profile_image : String!
    var name : String!
    var devision : String!
    var city : String!
    var state : String!
    var favorite : String!
    
    override init(){
        id = ""
        profile_image = ""
        name = ""
        devision = ""
        city = ""
        state = ""
        favorite = ""
    }
    
    init(dict : [String : Any])
    {
        id = ""
        profile_image = ""
        name = ""
        devision = ""
        city = ""
        state = ""
        favorite = ""
        
        if let temp = dict["id"] as? String {
            id = temp
        }
        if let temp = dict["profile_image"] as? String{
            profile_image = temp
        }
        if let temp = dict["name"] as? String{
            name = temp
        }
        if let temp = dict["devision"] as? String{
            devision = temp
        }
        if let temp = dict["city"] as? String{
            city = temp
        }
        if let temp = dict["state"] as? String{
            state = temp
        }
        if let temp = dict["favorite"] as? String{
            favorite = temp
        }
    }
}

class CollageInfoModel : AppModel
{
    var type_of_college : String!
    var website : String!
    var city : String!
    var region : String!
    var college_conference : String!
    var tournament_wins : String!
    var acceptance : String!
    var local_population : String!
    var facebook_link : String!
    var twitter_link : String!
    var instagram_link : String!
    
    override init(){
        type_of_college = ""
        website = ""
        city = ""
        region = ""
        college_conference = ""
        tournament_wins = ""
        acceptance = ""
        local_population = ""
        facebook_link = ""
        twitter_link = ""
        instagram_link = ""
    }
    
    init(dict : [String : Any])
    {
        type_of_college = ""
        website = ""
        city = ""
        region = ""
        college_conference = ""
        tournament_wins = ""
        acceptance = ""
        local_population = ""
        facebook_link = ""
        twitter_link = ""
        instagram_link = ""
        
        if let temp = dict["type_of_college"] as? String {
            type_of_college = temp
        }
        if let temp = dict["website"] as? String{
            website = temp
        }
        if let temp = dict["city"] as? String{
            city = temp
        }
        if let temp = dict["region"] as? String{
            region = temp
        }
        if let temp = dict["college_conference"] as? String{
            college_conference = temp
        }
        if let temp = dict["tournament_wins"] as? String{
            tournament_wins = temp
        }
        if let temp = dict["acceptance"] as? String{
            acceptance = temp
        }
        if let temp = dict["local_population"] as? String{
            local_population = temp
        }
        if let temp = dict["facebook_link"] as? String{
            facebook_link = temp
        }
        if let temp = dict["twitter_link"] as? String{
            twitter_link = temp
        }
        if let temp = dict["instagram_link"] as? String{
            instagram_link = temp
        }
    }
}

class CollageMainModel : AppModel
{
    var profile_image : String!
    var name : String!
    var state : String!
    var devision : String!
    
    override init(){
        profile_image = ""
        name = ""
        state = ""
        devision = ""
    }
    
    init(dict : [String : Any])
    {
        profile_image = ""
        name = ""
        state = ""
        devision = ""
        
        if let temp = dict["profile_image"] as? String {
            profile_image = temp
        }
        if let temp = dict["name"] as? String{
            name = temp
        }
        if let temp = dict["state"] as? String{
            state = temp
        }
        if let temp = dict["devision"] as? String{
            devision = temp
        }
    }
}

class CoachInfoModel : AppModel
{
    var profile_image : String!
    var name : String!
    var phone : String!
    var desk_phone : String!
    var email_address : String!
    var bio : String!
    var position : String!
    
    override init() {
        profile_image = ""
        name = ""
        phone = ""
        desk_phone = ""
        email_address = ""
        bio = ""
        position = ""
    }
    
    init(dict : [String : Any])
    {
        profile_image = ""
        name = ""
        phone = ""
        desk_phone = ""
        email_address = ""
        bio = ""
        position = ""
        
        if let temp = dict["profile_image"] as? String {
            profile_image = temp
        }
        if let temp = dict["name"] as? String {
            name = temp
        }
        if let temp = dict["phone"] as? String {
            phone = temp
        }
        if let temp = dict["desk_phone"] as? String {
            desk_phone = temp
        }
        if let temp = dict["email_address"] as? String {
            email_address = temp
        }
        if let temp = dict["bio"] as? String {
            bio = temp
        }
        if let temp = dict["position"] as? String {
            position = temp
        }
        else if let temp = dict["role"] as? String {
            position = temp
        }        
    }
}


class CoachModel : AppModel
{
    var main : CoachInfoModel!
    var collage : CollageModel!
    var tracked : [PlayerMainModel]!
    
    override init(){
        main = CoachInfoModel.init()
        collage = CollageModel.init()
        tracked = [PlayerMainModel]()
    }
    
    init(dict : [String : Any])
    {
        main = CoachInfoModel.init()
        collage = CollageModel.init()
        tracked = [PlayerMainModel]()
        
        if let temp = dict["main"] as? [String : Any] {
            main = CoachInfoModel.init(dict: temp)
        }
        if let temp = dict["college"] as? [String : String] {
            collage = CollageModel.init(dict: temp)
        }
        if let temp = dict["tracked"] as? [[String : Any]]{
            for tempDict in temp
            {
                tracked.append(PlayerMainModel.init(dict: tempDict))
            }
        }
    }
}

class CoachesModel : AppModel
{
    var head_coach : [String]!
    var assistant_coach : [String]!
    var other_coach : [String]!
    
    override init(){
        head_coach = [String]()
        assistant_coach = [String]()
        other_coach = [String]()
    }
    
    init(dict : [String : Any])
    {
        head_coach = [String]()
        assistant_coach = [String]()
        other_coach = [String]()
        
        if let temp = dict["head_coach"] as? [String] {
            head_coach = temp
        }
        if let temp = dict["assistant_coach"] as? [String] {
            assistant_coach = temp
        }
        if let temp = dict["other_coach"] as? [String] {
            other_coach = temp
        }
    }
}
