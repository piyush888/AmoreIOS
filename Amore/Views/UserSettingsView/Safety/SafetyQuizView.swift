//
//  SafetyQuizView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 1/16/23.
//

import SwiftUI


struct SafetyQuizView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var showQuiz: Bool
    @State private var questionIndex = 0
    @State private var selectedAnswer = 0
    @State private var score = 0
    @State private var result = ""
    @State private var submitPressed = false
    @State private var successRate = 0.0
   
    var quizObj = LoadQuizData()
    
    // Card color of the quiz
    var cardColor: Gradient {
            colorScheme == .dark ? Gradient(colors: [Color(.systemGray6)]) : Gradient(colors: [Color(hex:0xF2E9FE)])
    }
    
    // Progress View
    var progress: CGFloat {
        CGFloat(questionIndex) / CGFloat(quizObj.safetyQuestions.count)
        }
    
    var body: some View {
        
        VStack {
            if questionIndex < quizObj.safetyQuestions.count {
                
                // Shows a progress bar
                ProgressSubView
                    .padding()
                
                // Question Count
                Text("Quiz \(String(questionIndex+1))/\(String(quizObj.safetyQuestions.count))")
                    .font(.title2)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                
                // Question Text
                Text(quizObj.safetyQuestions[questionIndex].question)
                    .font(.headline)
                    .padding()
                    
               // If user pressed the submit button hide the button and show question explanation
                if submitPressed {
                    // Provides explanation regardless if the answer is correct or incorrect
                    PerQuestionResultView
                } else {
                    
                    // Question options
                    VStack(spacing: 20) {
                        ForEach(0..<quizObj.safetyQuestions[questionIndex].options.count) { index in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(index == self.selectedAnswer ? Color.yellow : Color.white)
                                .frame(height: 50)
                                .overlay(
                                    Button(action: {
                                        self.selectedAnswer = index
                                    }) {
                                        Text(quizObj.safetyQuestions[self.questionIndex].options[index])
                                            .font(.headline)
                                            .padding()
                                    }
                                )
                        }
                    }
                    .padding(.top, 20)
                    
                    // Submit Button SubView
                    SubmitButtonSubView
                        .padding(.top, 40)
                }
            
            } else {
                // Show how many questions user got correct
                FinalResultSubView
                    .padding(.top, 20)
            }
        }
        .padding(40)
        .background(
            // Card background for placing the quiz view in a box
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(LinearGradient(
                    gradient: cardColor,
                    startPoint: .leading,
                    endPoint: .trailing)
                )
                .shadow(radius: 0.5)
        )
        .padding(.horizontal,10)
        
        
    }
    
    // Submit Button
    var SubmitButtonSubView: some View {
        HStack {
            Button("Submit") {
                self.submitPressed.toggle()
                if self.selectedAnswer == quizObj.safetyQuestions[self.questionIndex].correctAnswer {
                    self.score += 1
                }
            }.buttonStyle(GrowingButton(buttonColor:Color.blue, fontColor: Color.white))
        }
    }
    
    // This is displayed to user once they press on submit to show them the explanation for question
    var PerQuestionResultView: some View {
        VStack {
            Text(selectedAnswer == quizObj.safetyQuestions[questionIndex].correctAnswer ? "Correct!" : "Incorrect.")
                .font(.title)
                .foregroundColor(selectedAnswer == quizObj.safetyQuestions[questionIndex].correctAnswer ? .green : .red)
            Text(quizObj.safetyQuestions[questionIndex].explanation)
                .font(.body)
                .padding()
            
            if self.questionIndex == quizObj.safetyQuestions.count {
                Button("Next Question") {
                    self.questionIndex += 1
                    self.selectedAnswer = 0
                    self.submitPressed.toggle()
                }
                .buttonStyle(GrowingButton(buttonColor:Color.blue, fontColor: Color.white))
                
            } else {
                Button("Done") {
                    self.questionIndex += 1
                    self.selectedAnswer = 0
                    if self.questionIndex == quizObj.safetyQuestions.count {
                        self.result = "You scored \(self.score) out of \(quizObj.safetyQuestions.count) points."
                    }
                    self.submitPressed.toggle()
                }
                .buttonStyle(GrowingButton(buttonColor:Color.blue, fontColor: Color.white))
            }
            
        }
    }
    
    // Result View - This View is shown in the end to tell user how did they perform in the test
    var FinalResultSubView: some View {
        Group {
            Text(result)
                .font(.headline)
                .padding(.top, 20)
            
            if(score == 10){
                Text("Good job you got all questions correct !!!")
            } else if(score > 6 && score<10) {
                Text("Pretty Good !!")
            } else {
                Text("Hmm.. Not good, Try the quiz again")
            }
            
            Button(action: {
                self.questionIndex = 0
                self.score = 0
                self.result = ""
                self.selectedAnswer = 0
            }) {
                Text("Retake Quiz")
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
            
            
            Button(action: {
                self.showQuiz = false
            }) {
                Text("Close Quiz")
                    .foregroundColor(Color.black)
            }
            .padding()
        }
    }
    
    var ProgressSubView: some View {
        ZStack(alignment: .leading) {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color(.systemGray6)]), startPoint: .leading, endPoint: .trailing)
                .frame(height: 10)
                .cornerRadius(5)
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .leading, endPoint: .trailing)
                .frame(width: progress * UIScreen.main.bounds.width, height: 10)
                .cornerRadius(5)
        }
    }
}


struct QuizQuestion:Codable, Identifiable  {
    
    enum CodingKeys: CodingKey {
        case question
        case options
        case explanation
        case correctAnswer
    }
    
    var id = UUID()
    var question: String
    var options: [String]
    var explanation: String
    var correctAnswer: Int
}


class LoadQuizData {
    var safetyQuestions = [QuizQuestion]()
    
    init(){
        loadData()
    }
    
    func loadData()  {
        // DO NOT CHANGE THE SEQUENCE/FORMATTING OF THE JSON FILE. ADD NEW FEATURES IN SEQUENECE
        guard let url = Bundle.main.url(forResource: "SafetyQuizData", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        
        let data = try? Data(contentsOf: url)
        let safetyQuestions = try? JSONDecoder().decode([QuizQuestion].self, from: data!)
        self.safetyQuestions = safetyQuestions!
    }
     
}


struct SafetyQuizView_Previews: PreviewProvider {
    // Card color of the quiz
    static var previews: some View {
        SafetyQuizView(showQuiz:Binding.constant(false))
    }
}

