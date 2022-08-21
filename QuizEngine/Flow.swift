//
//  Flow.swift
//  QuizEngine
//
//  Created by Joao Gripp on 19/08/22.
//

import Foundation

protocol Router {
    typealias AnswerCallback = (String) -> Void
    
    func routeTo(question: String, answerCallBack: @escaping (String) -> Void)
    func routeTo(result: [String: String])
}

class Flow {
    private let router: Router
    private let questions: [String]
    
    private var result: [String: String] = [:]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, answerCallBack: nextCallBack(from: firstQuestion))
        } else {
            router.routeTo(result: result)
        }
    }
    
    private func nextCallBack(from question: String) -> Router.AnswerCallback {
        return { [weak self] in self?.routeNext(question, $0) }
        
    }
    
    private func routeNext(_ question: String, _ answer: String) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            result[question] = answer
            
            let nextQuestionIndex = currentQuestionIndex + 1
            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                router.routeTo(question: nextQuestion, answerCallBack: nextCallBack(from: nextQuestion))
                
            } else {
                router.routeTo(result: result)
            }
        }
    }
    
}
