//
//  SODataModelProvider.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Foundation

class SODataModelProvider {
    let service: SODataProvider
    let demoService: DemoDataProvider

    var questions = [Question]() {
        didSet {
            self.notify(notificationName: "QuestionListLoaded")
        }
    }

    var question: Question? {
        didSet {
            self.notify(notificationName: "QuestionDetailsLoaded")
        }
    }

    var user: User? {
        didSet {
            self.notify(notificationName: "UserProfileLoaded")
        }
    }

    var userQuestions = [Question]() {
        didSet {
            self.notify(notificationName: "UserQuestionListLoaded")
        }
    }

    var imageData = Data() {
        didSet {
            self.notify(notificationName: "ImageLoaded")
        }
    }

    init() {
        self.service = SOService()
        self.demoService = DemoService()
    }

    func getQuestions() {
        if UserDefaultsConfig.demo {
            demoService.getQuestions { result in
                DispatchQueue.main.async {
                    do {
                        let results = try result.get()
                        self.questions = results.items
                    } catch {
                        print(error)
                    }
                }
            }
        } else {
            service.getQuestions { result in
                DispatchQueue.main.async {
                    do {
                        let results = try result.get()
                        self.questions = results.items
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }

    func getQuestion(questionID: Int) {
        if UserDefaultsConfig.demo {
            demoService.getQuestion { result in
                DispatchQueue.main.async {
                    do {
                        let results = try result.get()
                        self.question = results.items.first
                    } catch {
                        print(error)
                    }
                }
            }
        } else {
            service.getQuestion(questionID: questionID) { result in
                DispatchQueue.main.async {
                    do {
                        let results = try result.get()
                        self.question = results.items.first
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }

    func getUser(userID: Int) {
        if UserDefaultsConfig.demo {
            demoService.getUser { result in
                DispatchQueue.main.async {
                    do {
                        let results = try result.get()
                        self.user = results.items.first
                    } catch {
                        print(error)
                    }
                }
            }
        } else {
            service.getUser(userID: userID) { result in
                DispatchQueue.main.async {
                    do {
                        let results = try result.get()
                        self.user = results.items.first
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }

    func getUserQuestions(userID: Int) {
        if UserDefaultsConfig.demo {
            demoService.getUserQuestions { result in
                DispatchQueue.main.async {
                    do {
                        let results = try result.get()
                        self.userQuestions = results.items
                    } catch {
                        print(error)
                    }
                }
            }
        } else {
            service.getUserQuestions(userID: userID) { result in
                DispatchQueue.main.async {
                    do {
                        let results = try result.get()
                        self.userQuestions = results.items
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }

    func getImage(url: String) {
        service.getImage(url: url) { result in
            DispatchQueue.main.async {
                do {
                    self.imageData = try result.get()
                } catch {
                    print(error)
                }
            }
        }
    }

    func search(query: String) {
        service.search(query: query) { result in
            DispatchQueue.main.async {
                do {
                    let results = try result.get()
                    self.questions = results.items
                } catch {
                    print(error)
                }
            }
        }
    }

    func notify(notificationName: String) {
        NotificationCenter.default.post(name: NSNotification.Name(notificationName),
                                        object: self,
                                        userInfo: [:])
    }
}

// FIXME: --- MOVE TO OTHER FILES ---
class DemoService: DemoDataProvider {
    var demoData = DemoData()
}

protocol DemoDataProvider {
    var demoData: DemoData { get }

    func getQuestions(_ completion: @escaping (Result<QuestionListResponse, Error>) -> Void)
    func getQuestion(_ completion: @escaping (Result<QuestionListResponse, Error>) -> Void)
    func getUser(_ completion: @escaping (Result<UserListResponse, Error>) -> Void)
    func getUserQuestions(_ completion: @escaping (Result<QuestionListResponse, Error>) -> Void)
}

extension DemoDataProvider {
    func getQuestions(_ completion: @escaping (Result<QuestionListResponse, Error>) -> Void) {
        demoData.loadDemoData(from: "questions", completion: completion)
    }

    func getQuestion(_ completion: @escaping (Result<QuestionListResponse, Error>) -> Void) {
        demoData.loadDemoData(from: "questionDetails", completion: completion)
    }

    func getUser(_ completion: @escaping (Result<UserListResponse, Error>) -> Void) {
        demoData.loadDemoData(from: "userProfile", completion: completion)
    }

    func getUserQuestions(_ completion: @escaping (Result<QuestionListResponse, Error>) -> Void) {
        demoData.loadDemoData(from: "userQuestions", completion: completion)
    }
}

class DemoData: DemoDataSource { }

protocol DemoDataSource {
    func loadDemoData<T: Decodable>(from fileName: String, completion: @escaping (Result<T, Error>) -> Void)
}

extension DemoDataSource {
    func loadDemoData<T: Decodable>(from fileName: String, completion: @escaping (Result<T, Error>) -> Void) {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let decodedObject = try decoder.decode(T.self, from: data)
                return completion(.success(decodedObject))
            } catch {
                return completion(.failure(error))
            }
        }
    }
}
