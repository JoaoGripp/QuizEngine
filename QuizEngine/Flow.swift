//
//  Flow.swift
//  QuizEngine
//
//  Created by Joao Gripp on 19/08/22.
//

import Foundation

protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer
    
    func routeTo(question: Question, answerCallBack: @escaping (Answer) -> Void)
    func routeTo(result: [Question: Answer])
}

class Flow<Question: Hashable, Answer, R: Router> where R.Question == Question, R.Answer == Answer {
    private let router: R
    private let questions: [Question]
    private var result: [Question: Answer] = [:]
    
    init(questions: [Question], router: R) {
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
    
    private func nextCallBack(from question: Question) -> (Answer) -> Void {
        return { [weak self] in self?.routeNext(question, $0) }
        
    }
    
    private func routeNext(_ question: Question, _ answer: Answer) {
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
