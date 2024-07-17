//
//  ContentView.swift
//  Jankenpon
//
//  Created by Eliezer Rodrigo Beltramin de Sant Ana on 16/07/24.
//

import SwiftUI

enum PlayOption {
    case rock
    case paper
    case scissors
    
    var title: String {
        switch self {
        case .rock:
            return "🪨"
        case .paper:
            return "🧻"
        case .scissors:
            return "✂️"
        }
    }
    
    var optionToWin: PlayOption {
        switch self {
        case .rock:
            return .paper
        case .paper:
            return .scissors
        case .scissors:
            return .rock
        }
    }
    
    var optionToLose: PlayOption {
        switch self {
        case .rock:
            return .scissors
        case .paper:
            return .rock
        case .scissors:
            return .paper
        }
    }
}

struct ContentView: View {
    
    let options = [PlayOption.paper, .rock, .scissors]
    @State var currentOption = Int.random(in: 0..<3)
    @State var shouldWin = Bool.random()
    @State var currentScore = 0
    @State var isShowingResultAlert = false
    @State var alertTitle = ""
    @State var questionsAnswered = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.teal
                    .opacity(0.4)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Text("AI selected:")
                        .font(.callout)
                    Text(options[currentOption].title)
                        .font(.system(size: 100))
                        .fontWeight(.semibold)
                        .padding(.bottom, 24)
                    
                    Text("You should:")
                        .font(.callout)
                    Text(shouldWin ? "Win" : "Lose")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding(.bottom, 24)
                    
                    Text("Your choice:")
                        .font(.callout)
                    HStack {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                selectOption(option: option)
                            }, label: {
                                Text(option.title)
                                    .font(.system(size: 100))
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            })
                        }
                    }
                    
                    Spacer()
                    
                    Text("Score: \(currentScore)")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                }
                .padding()
                .navigationTitle("Jankenpon")
                .alert("Game over", isPresented: $isShowingResultAlert) {
                    Button("Restart", action: restartGame)
                } message: {
                    Text("Final score: \(currentScore)")
                        .font(.title)
                }
            }
        }
    }
    
    func restartGame() {
        questionsAnswered = 0
        currentScore = 0
        nextOption()
    }
    
    func nextOption() {
        currentOption = Int.random(in: 0..<3)
        shouldWin.toggle()
    }
    
    func selectOption(option: PlayOption) {
        questionsAnswered += 1
        
        let currentOption = options[currentOption]
        if shouldWin && option == currentOption.optionToWin ||
            !shouldWin && option == currentOption.optionToLose {
            currentScore += 1
        } else {
            currentScore -= 1
        }
        
        if questionsAnswered < 10 {
            nextOption()
        } else {
            isShowingResultAlert = true
        }
    }
}

#Preview {
    ContentView()
}
