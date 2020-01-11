//
//  SODataModelProvider.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Foundation

class SODataModelProvider {
    let apiService: APIDataProvider
    let localService: LocalDataProvider

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
        self.apiService = APIService()
        self.localService = LocalService()
    }

    func getQuestions() {
        if UserDefaultsConfig.demo {
            localService.getQuestions { result in
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
            apiService.getQuestions { result in
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
            localService.getQuestion { result in
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
            apiService.getQuestion(questionID: questionID) { result in
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
            localService.getUser { result in
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
            apiService.getUser(userID: userID) { result in
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
            localService.getUserQuestions { result in
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
            apiService.getUserQuestions(userID: userID) { result in
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
        apiService.getImage(url: url) { result in
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
        apiService.search(query: query) { result in
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
