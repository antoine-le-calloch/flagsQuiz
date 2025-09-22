//
//  ContentView.swift
//  flag-quiz
//
//  Created by Antoine on 9/21/25.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var countryData = CountryData()
    @State private var userAnswer = ""
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var showFinalResults = false
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    
    var body: some View {
        ZStack {
            // Fixed blue background
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if showFinalResults {
                FinalResultsView(countryData: countryData) {
                    countryData.resetQuiz()
                    showFinalResults = false
                    userAnswer = ""
                }
            } else {
                VStack(spacing: 0) {
                    // Header with score and progress
                    HStack {
                        Text("Score: \(countryData.score)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text("\(countryData.currentIndex + 1) / \(countryData.countries.count)")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    Spacer()

                    TabView(selection: $countryData.currentIndex) {
                        ForEach(0..<countryData.countries.count, id: \.self) { index in
                            VStack {
                                CountryCard(
                                    country: countryData.countries[index],
                                    userAnswer: $userAnswer,
                                    onChange: { answer in }
                                )
                            }
                            .padding()
                            .frame(maxWidth: 350, maxHeight: 350)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    Spacer()
                }
            }
        }
        .navigationTitle("Flag Quiz")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Result", isPresented: $showResult) {
            Button("OK") {
                if isCorrect {
                    nextQuestion()
                }
            }
        } message: {
            Text(isCorrect ? "Correct! 🎉" : "Incorrect. The answer was: \(countryData.currentCountry?.name ?? "")")
        }
    }
    
    private func nextQuestion() {
        if countryData.currentIndex >= countryData.countries.count - 1 {
            showFinalResults = true
        } else {
            countryData.nextQuestion()
            userAnswer = ""
        }
    }
    
    private func previousQuestion() {
        countryData.previousQuestion()
        userAnswer = ""
    }
}

struct FinalResultsView: View {
    @ObservedObject var countryData: CountryData
    let onRestart: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("🎉 Quiz Complete! 🎉")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Your Score")
                .font(.title2)
                .foregroundColor(.white.opacity(0.8))
            
            Text("\(countryData.score) / \(countryData.countries.count)")
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(.white)
            
            let percentage = Double(countryData.score) / Double(countryData.countries.count) * 100
            Text("\(Int(percentage))% success rate")
                .font(.title3)
                .foregroundColor(.white.opacity(0.7))
            
            Button("Restart") {
                onRestart()
            }
            .buttonStyle(.borderedProminent)
            .font(.title2)
            .controlSize(.large)
        }
        .padding(40)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white.opacity(0.1))
                BlurView(style: .systemUltraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
        )
        .padding(.horizontal, 20)
    }
}

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

#Preview {
    ContentView()
}
