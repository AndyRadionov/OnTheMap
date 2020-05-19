//
//  OnTheMapClient.swift
//  OnTheMap
//
//  Created by Andy on 14.05.2020.
//  Copyright © 2020 AndyRadionov. All rights reserved.
//

import Foundation

class OnTheMapClient {
    
    private static var currentStudent: Student!
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case session
        case signUp
        case studentLocations
        case getUserData(String)
        case addLocation
        
        var stringValue: String {
            switch self {
            case .session:
                return Endpoints.base + "/session"
            case .signUp:
                return "https://www.udacity.com/account/auth#!/signup"
            case .studentLocations:
                return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .getUserData(let userId):
                return Endpoints.base + "/users/\(userId)"
            case .addLocation:
                return Endpoints.base + "/StudentLocation"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    enum OnTheMapError: LocalizedError {
        case networkError
        case loginError
        case decodeError
        
        var localizedDescription: String {
            switch self {
            case .networkError:
                return "Network Error\nPlease try Again later"
            case .loginError:
                return "Wrong Login/Password!\nPlease Try Again later"
            case .decodeError:
                return "Something went wrong\nPlease Try Again later"
            }
        }
    }
    
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
    
    class func createSession(username: String, password: String, completion: @escaping (Bool, OnTheMapError?) -> Void) {
        let body = AuthRequest(username: username, password: password)
        taskForPOSTRequest(url: Endpoints.session.url, trimResponseIndex: 5, responseType: AuthResponse.self, body: body, completion: { (response, error) in
            if let response = response {
                getUserData(userId: response.account!.key, completion: completion)
            } else {
                completion(false, error)
            }
        })
    }
    
    class func deleteSession(completion: @escaping (Bool, OnTheMapError?) -> Void) {
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(false, .networkError)
                return
            }
            
            do {
                let newData = data?.subdata(in: 5..<data!.count)
                _ = try decoder.decode(AuthResponse.self, from: newData!)
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                completion(false, .decodeError)
            }
        }
        task.resume()
    }
    
    class func getUserData(userId: String, completion: @escaping (Bool, OnTheMapError?) -> Void) {
        taskForGETRequest(url: Endpoints.getUserData(userId).url, trimResponseIndex: 5, responseType: Student.self) { response, error in
            if let response = response {
                currentStudent = response
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getStudentLocations(completion: @escaping ([StudentLocation], OnTheMapError?) -> Void) {
        taskForGETRequest(url: Endpoints.studentLocations.url, responseType: GetStudentLocationResponse.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func postStudentLocation(longitude: Double, latitude: Double, mapString: String, link: String, completion: @escaping (Bool, OnTheMapError?) -> Void) {
        let body = StudentLocation(
            firstName: currentStudent.firstName,
            lastName: currentStudent.lastName,
            longitude: longitude,
            latitude: latitude,
            mapString: mapString,
            mediaURL: link,
            uniqueKey: currentStudent.key
        )
        
        taskForPOSTRequest(url: Endpoints.addLocation.url, responseType: AddStudentLocationResponse.self, body: body, completion: { (response, error) in
            if error != nil {
                completion(false, error)
            } else {
                completion(true, error)
            }
        })
    }
    
    private class func taskForGETRequest<ResponseType: Decodable>(url: URL, trimResponseIndex: Int = 0, responseType: ResponseType.Type, completion: @escaping (ResponseType?, OnTheMapError?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil, .networkError)
                return
            }
            do {
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let newData = data.subdata(in: trimResponseIndex..<data.count)
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                completion(nil, .decodeError)
            }
        }
        task.resume()
    }
    
    private class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, trimResponseIndex: Int = 0, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, OnTheMapError?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! encoder.encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, .networkError)
                return
            }
            do {
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let newData = data.subdata(in: trimResponseIndex..<data.count)
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                completion(nil, .decodeError)
            }
        }
        task.resume()
    }
}
