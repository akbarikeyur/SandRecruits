    
//  Cozy Up
//
//  Created by Amisha on 15/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import Foundation
import SystemConfiguration
import Alamofire
import AlamofireJsonToObjects

let CLIENT_ID = "1"
let CLIENT_SECRET = "cBt0yIIZEH2GQlTUli457Pmw8Uo4VVW1R9irrROc"

//Development
struct API {
    static let BASE_URL = "https://sandrecruits.com/wp-json/rest_apis/v1/"
    
    static let SIGNUP_STATUS        =       BASE_URL + "restrictreg/"
    
    static let USER_LOGIN           =       BASE_URL + "authentication/"
    static let FORGOT_PASSWORD      =       BASE_URL + "forgot_password/"
    static let PLAYER_DETAIL        =       BASE_URL + "player/"
    static let EVENT_LIST           =       BASE_URL + "events/"
    static let EVENT_DETAIL         =       BASE_URL + "event/"
    
    static let COLLAGE_FILTER       =       BASE_URL + "collegesfilters/"
    static let COLLAGE_LIST         =       BASE_URL + "colleges/"
    static let COLLAGE_DETAIL       =       BASE_URL + "college/"
    static let ADD_FAVORITE_COLLAGE =       BASE_URL + "setfavorite/"
    static let TRACK_PLAYER         =       BASE_URL + "settrackplayer/"
    
    static let COACH_DETAIL         =       BASE_URL + "coach/"
    static let SAVE_NOTE            =       BASE_URL + "savenote/"
    
    static let PLAYER_FILTER        =       BASE_URL + "playersfilters/"
    static let PLAYER_LIST          =       BASE_URL + "players/"
    
    static let SHARE_PROFILE        =       BASE_URL + "shareprofile/"
    
}


public class APIManager {
    
    static let shared = APIManager()
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func getJsonHeader() -> [String:String]{
        return ["Content-Type":"application/json", "Accept" : "application/json"]
    }
    
    func getMultipartHeader() -> [String:String]{
        return ["Content-Type":"multipart/form-data", "Accept" : "application/json"]
    }
    
    func getJsonHeaderWithToken() -> [String:String]{
        return ["Content-Type":"application/json", "Accept" : "application/json"]
    }
    
    func getMultipartHeaderWithToken() -> [String:String]{
        return ["Content-Type":"multipart/form-data", "Accept" : "application/json"]
    }
    
    func networkErrorMsg()
    {
        removeLoader()
        showAlert("SandRecruits", message: "You are not connected to the internet") {
            
        }
    }
    
    func toJson(_ dict:[String:Any]) -> String {
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        return jsonString!
    }
    
//    func isServiceError(_ code: Int?) -> Bool{
//        if(code == 401    )
//        {
//            AppDelegate().sharedDelegate().logoutApp()
//            return true
//        }
//        return false
//    }
    
    func serviceCallToCheckSignupStatus(_ completion: @escaping (_ value : Int) -> Void) {
        let headerParams : [String : String] = APIManager.shared.getJsonHeaderWithToken()
        printData(headerParams)
        Alamofire.request(API.SIGNUP_STATUS, method: .post, parameters: [String : Any](), encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let status : Bool = result["status"] as? Bool, status == true {
                        
                        if let data : [String : Any] = result["data"] as? [String : Any]
                        {
                            if let isSignup : String = data["isSignup"] as? String, isSignup == "false"
                            {
                                let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
                                if let version : String = data["version"] as? String, version == appVersion
                                {
                                    completion(0)
                                    return
                                }
                            }
                            completion(1)
                            return
                        }
                    }
                }
                break
            case .failure(let error) :
                printData(error)
                completion(-1)
                break
            }
        }
    }

    func serviceCallToLoginUser(_ param : [String  :Any],_ completion: @escaping () -> Void) {
        showLoader()
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        printData(headerParams)
        Alamofire.request(API.USER_LOGIN, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                
                printData(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let status : Bool = result["status"] as? Bool, status == true {
                        
                        if let data : [String : Any] = result["data"] as? [String : Any]
                        {
                            if let data : [String : Any] = data["data"] as? [String : Any]
                            {
                                AppModel.shared.currentUser = UserModel.init(dict: data)
                            }
                            if let first_name : String = data["first_name"] as? String
                            {
                                AppModel.shared.currentUser.fname = first_name
                            }
                            if let last_name : String = data["last_name"] as? String
                            {
                                AppModel.shared.currentUser.lname = last_name
                            }
                            if let post_type : String = data["post_type"] as? String
                            {
                                AppModel.shared.currentUser.post_type = post_type
                                if post_type.lowercased() == "player"
                                {
                                    setIsPlayerLogin(isUserLogin: true)
                                }
                                else
                                {
                                    setIsPlayerLogin(isUserLogin: false)
                                    if let college : [String : Any] = data["college"] as? [String : Any]
                                    {
                                        if let cid : Int = college["id"] as? Int
                                        {
                                            AppModel.shared.currentUser.collegeID = String(cid)
                                        }
                                        if let cName : String = college["name"] as? String
                                        {
                                            AppModel.shared.currentUser.collegeName = cName
                                        }
                                    }
                                }
                            }                            
                            setLoginUserData(AppModel.shared.currentUser.dictionary())
                            setIsUserLogin(isUserLogin: true)
                            completion()
                            return
                        }
                    }
                    else {
                        displayToast("Invalid credential")
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error) :
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToForgotPassword(_ param : [String  :Any],_ completion: @escaping () -> Void) {
        showLoader()
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        printData(headerParams)
        print(param)
        Alamofire.request(API.FORGOT_PASSWORD, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let status : Bool = result["status"] as? Bool {
                        if let message : String = result["message"] as? String {
                            displayToast(message)
                        }
                        if status {
                            completion()
                            return
                        }
                    }
                    else {
                        displayToast("Invalid credential")
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error) :
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetPlayerDetail(_ param : [String  :Any],_ completion: @escaping (_ data : [String : Any]) -> Void) {
        showLoader()
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        printData(headerParams)
        Alamofire.request(API.PLAYER_DETAIL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                
                printData(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let status : Bool = result["status"] as? Bool, status == true {
                        
                        if let data : [String : Any] = result["data"] as? [String : Any]
                        {
                            completion(data)
                            return
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error) :
                printData(error)
                break
            }
        }
    }
    
    //Event
    func serviceCallToGetEventList(_ completion: @escaping (_ data : [[String : Any]]) -> Void) {
        showLoader()
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        printData(headerParams)
        Alamofire.request(API.EVENT_LIST, method: .post, parameters: [String  :Any](), encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                
                printData(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let status : Bool = result["status"] as? Bool, status == true {
                        
                        if let data : [[String : Any]] = result["data"] as? [[String : Any]]
                        {
                            completion(data)
                            return
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error) :
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetEventDetail(_ event_id : String,_ completion: @escaping (_ data : [String : Any]) -> Void) {
        showLoader()
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        printData(headerParams)
        
        var param : [String : Any] = [String : Any]()
        param["user_id"] = AppModel.shared.currentUser.uId
        param["event_id"] = event_id
        
        Alamofire.request(API.EVENT_DETAIL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                
                printData(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let status : Bool = result["status"] as? Bool, status == true {
                        
                        if let data : [String : Any] = result["data"] as? [String : Any]
                        {
                            completion(data)
                            return
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error) :
                printData(error)
                break
            }
        }
    }
    
    //Collage
    func serviceCallToGetCollageFilter(_ completion: @escaping (_ data : [String : Any]) -> Void) {
        showLoader()
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        printData(headerParams)
        
        var param : [String : Any] = [String : Any]()
        
        Alamofire.request(API.COLLAGE_FILTER, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                
                printData(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let status : Bool = result["status"] as? Bool, status == true {
                        
                        if let data : [String : Any] = result["data"] as? [String : Any]
                        {
                            completion(data)
                            return
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error) :
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetCollageList(_ param : [String : Any],_ completion: @escaping (_ data : [String : Any], _ total : String) -> Void) {
        showLoader()
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        printData(headerParams)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }, usingThreshold: UInt64.init(), to: API.COLLAGE_LIST, method: .post
        , headers: headerParams) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                })
                upload.responseJSON { response in
                    removeLoader()
                    printData(response.result.value!)
                    if let result : [String : Any] = response.result.value as? [String : Any]
                    {
                        if let status : Bool = result["status"] as? Bool, status == true {
                            
                            if let data : [String : Any] = result["data"] as? [String : Any]
                            {
                                if let total_count : String = data["total_count"] as? String
                                {
                                    completion(data, total_count)
                                    return
                                }
                                completion(data, "0")
                                return
                            }
                        }
                    }
                    else if let error = response.error{
                        displayToast(error.localizedDescription)
                        return
                    }
                    //displayToast("Registeration error")
                }
            case .failure(let error):
                removeLoader()
                
                displayToast(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToGetCollageListWithFilter(_ param : [String : Any],_ completion: @escaping (_ data : [String : Any], _ total : String) -> Void) {
        showLoader()
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        printData(headerParams)
        
         Alamofire.request(API.COLLAGE_LIST, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
                case .success:
                printData(response.result.value!)
                 if let result : [String : Any] = response.result.value as? [String : Any]
                 {
                    if let status : Bool = result["status"] as? Bool, status == true {
                        if let data : [String : Any] = result["data"] as? [String : Any]
                        {
                            if let total_count : String = data["total_count"] as? String
                            {
                                completion(data, total_count)
                                return
                            }
                            completion(data, "0")
                            return
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
             case .failure(let error) :
                 printData(error)
                 break
             }
         }
    }
    
    func serviceCallToGetCollageDetail(_ param : [String : Any],_ completion: @escaping (_ data : [String : Any]) -> Void) {
        showLoader()
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        printData(headerParams)
        
        Alamofire.request(API.COLLAGE_DETAIL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let status : Bool = result["status"] as? Bool, status == true {
                        
                        if let data : [String : Any] = result["data"] as? [String : Any]
                        {
                            completion(data)
                            return
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error) :
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToAddFavoriteCollage(_ param : [String : Any],_ completion: @escaping (_ data : [String : Any]) -> Void) {
        showLoader()
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        print(API.ADD_FAVORITE_COLLAGE)
        printData(headerParams)
        print(param)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }, usingThreshold: UInt64.init(), to: API.ADD_FAVORITE_COLLAGE, method: .post
        , headers: headerParams) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                })
                upload.responseJSON { response in
                    removeLoader()
                    printData(response.result.value!)
                    if let result : [String : Any] = response.result.value as? [String : Any]
                    {
                        if let status : Bool = result["status"] as? Bool, status == true {
                            
                            if let data : [String : Any] = result["data"] as? [String : Any]
                            {
                                completion(data)
                                return
                            }
                        }
                    }
                    else if let error = response.error{
                        displayToast(error.localizedDescription)
                        return
                    }
                    //displayToast("Registeration error")
                }
            case .failure(let error):
                removeLoader()
                
                displayToast(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToTrackPlayer(_ param : [String : Any],_ completion: @escaping (_ data : [String : Any]) -> Void) {
        showLoader()
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        printData(headerParams)
        print(param)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }, usingThreshold: UInt64.init(), to: API.TRACK_PLAYER, method: .post
        , headers: headerParams) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                })
                upload.responseJSON { response in
                    removeLoader()
                    printData(response.result.value!)
                    if let result : [String : Any] = response.result.value as? [String : Any]
                    {
                        if let status : Bool = result["status"] as? Bool, status == true {
                            
                            if let data : [String : Any] = result["data"] as? [String : Any]
                            {
                                completion(data)
                                return
                            }
                        }
                    }
                    else if let error = response.error{
                        displayToast(error.localizedDescription)
                        return
                    }
                    //displayToast("Registeration error")
                }
            case .failure(let error):
                removeLoader()
                
                displayToast(error.localizedDescription)
                break
            }
        }
        /*
        Alamofire.request(API.TRACK_PLAYER, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let status : Bool = result["status"] as? Bool, status == true {
                        
                        if let data : [String : Any] = result["data"] as? [String : Any]
                        {
                            completion(data)
                            return
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error) :
                printData(error)
                break
            }
        }
        */
    }
    
    //MARK:- Coach
    func serviceCallToGetCoachDetail(_ completion: @escaping (_ data : [String : Any]) -> Void) {
        showLoader()
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        printData(headerParams)
        var param : [String : Any] = [String : Any]()
        param["user_id"] = AppModel.shared.currentUser.uId
        
        Alamofire.request(API.COACH_DETAIL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let status : Bool = result["status"] as? Bool, status == true {
                        
                        if let data : [String : Any] = result["data"] as? [String : Any]
                        {
                            completion(data)
                            return
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error) :
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToSaveNote(_ param : [String : Any], _ completion: @escaping (_ data : [String : Any]) -> Void) {
        showLoader()
        let headerParams :[String : String] = APIManager.shared.getMultipartHeader()
        printData(headerParams)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }, usingThreshold: UInt64.init(), to: API.SAVE_NOTE, method: .post
        , headers: headerParams) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                })
                upload.responseJSON { response in
                    removeLoader()
                    printData(response.result.value!)
                    if let result : [String : Any] = response.result.value as? [String : Any]
                    {
                        if let status : Bool = result["status"] as? Bool, status == true {
                            
                            if let data : [String : Any] = result["data"] as? [String : Any]
                            {
                                completion(data)
                                return
                            }
                        }
                    }
                    else if let error = response.error{
                        displayToast(error.localizedDescription)
                        return
                    }
                    //displayToast("Registeration error")
                }
            case .failure(let error):
                removeLoader()
                
                displayToast(error.localizedDescription)
                break
            }
        }
    }
    
    //MARK:- Coach
    func serviceCallToGetPlayerFilter(_ completion: @escaping (_ data : [String : Any]) -> Void) {
        showLoader()
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        printData(headerParams)
        let param : [String : Any] = [String : Any]()
        
        Alamofire.request(API.PLAYER_FILTER, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let status : Bool = result["status"] as? Bool, status == true {
                        
                        if let data : [String : Any] = result["data"] as? [String : Any]
                        {
                            completion(data)
                            return
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error) :
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetPlayerList(_ param : [String : Any],_ completion: @escaping (_ data : [[String : Any]], _ totla : String) -> Void) {
        showLoader()
        let headerParams :[String : String] = APIManager.shared.getJsonHeader()
        printData(headerParams)
        
        Alamofire.request(API.PLAYER_LIST, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let status : Int = result["status"] as? Int, status == 1 {
                        
                        if let tempData : [String : Any] = result["data"] as? [String : Any]
                        {
                            if let data : [[String : Any]] = tempData["data"] as? [[String : Any]]
                            {
                                
                                if let total_count : String = tempData["total_count"] as? String {
                                    completion(data, total_count)
                                    return
                                }
                                else{
                                    completion(data, "0")
                                    return
                                }
                            }
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error) :
                printData(error)
                break
            }
        }
        
    }
    
    //Share Profile
    func serviceCallToShareProfile(_ param : [String : Any],_ completion: @escaping () -> Void) {
        showLoader()
        let headerParams :[String : String] = APIManager.shared.getJsonHeaderWithToken()
        printData(headerParams)
        
        Alamofire.request(API.SHARE_PROFILE, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                
                printData(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let status : Int = result["status"] as? Int, status == 1 {
                        
                        completion()
                        return
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error) :
                printData(error)
                break
            }
        }
    }
    
}
