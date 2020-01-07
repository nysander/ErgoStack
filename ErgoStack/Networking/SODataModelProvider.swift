//
//  SODataModelProvider.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Combine
import Foundation

class SODataModelProvider: ObservableObject{
    var didChange = PassthroughSubject<SODataModelProvider, Never>()

    let service: SODataProvider

    @Published var questions = [Question]() {
        didSet {
            didChange.send(self)
        }
    }

    @Published var question: Question? {
        didSet {
            didChange.send(self)
        }
    }

    @Published var user: User? {
        didSet {
            didChange.send(self)
        }
    }

    @Published var imageData: Data? {
        didSet {
            didChange.send(self)
        }
    }

    init() {
        self.service = SOService()
    }

    func getQuestions() {
        service.getQuestions { result in
            DispatchQueue.main.async {
                do {
                    self.questions = try result.get()
                } catch {
                    print(error)
                }
            }
        }
    }

    func getQuestion(questionID: Int) {
        service.getQuestion(questionID: questionID) { result in
            DispatchQueue.main.async {
                do {
                    self.question = try result.get()
                } catch {
                    print(error)
                }
            }
        }
    }

    func getUser(userID: Int) {
        service.getUser(userID: userID) { result in
            DispatchQueue.main.async {
                do {
                    self.user = try result.get()
                } catch {
                    print(error)
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
}
