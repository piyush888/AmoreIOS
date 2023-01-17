//
//  SafetyQuizView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 1/16/23.
//

import SwiftUI

struct QuizQuestion {
    var question: String
    var options: [String]
    var correctAnswer: Int
}


struct SafetyQuizView: View {
    @State private var showQuiz = false
    @State private var questionIndex = 0
    @State private var selectedAnswer = 0
    @State private var score = 0
    @State private var result = ""
    
    let questions = [
        QuizQuestion(question: "What should you do if you feel uncomfortable on a date?",
                     options: ["Leave the date immediately", "Try to ignore the discomfort", "Confront the person"],
                     correctAnswer: 0),
        QuizQuestion(question: "What should you do if someone asks you for personal information?",
                     options: ["Provide the information", "Ignore the request", "Provide fake information"],
                     correctAnswer: 1)
    ]
    
    var body: some View {
        VStack {
            if questionIndex < questions.count {
                QuizQuestionView(question: questions[questionIndex], selectedAnswer: $selectedAnswer)
                VStack {
                    ForEach(0..<questions[questionIndex].options.count) { index in
                        Button(action: {
                            self.selectedAnswer = index
                        }) {
                            Text(self.questions[self.questionIndex].options[index])
                        }
                    }
                }
                Button(action: {
                    if self.selectedAnswer == self.questions[self.questionIndex].correctAnswer {
                        self.score += 1
                    }
                    self.questionIndex += 1
                    if self.questionIndex == self.questions.count {
                        self.result = "You scored \(self.score) out of \(self.questions.count) points."
                    }
                }) {
                    Text("Submit")
                }
            } else {
                Text(result)
                Button(action: {
                    self.showQuiz = false
                    self.questionIndex = 0
                    self.score = 0
                    self.result = ""
                }) {
                    Text("Retake Quiz")
                }
            }
        }
        .sheet(isPresented: $showQuiz) {
            SafetyQuizView()
        }
    }
}

                    
struct SafetyQuizView_Previews: PreviewProvider {
    static var previews: some View {
        SafetyQuizView()
    }
}


struct QuizQuestionView: View {
    var question: QuizQuestion
    @Binding var selectedAnswer: Int
    
    var body: some View {
        Text(question.question)
    }
}


