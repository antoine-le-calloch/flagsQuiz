//
//  Country.swift
//  flag-quiz
//
//  Created by Antoine on 9/21/25.
//

import Foundation

struct Country: Identifiable, Codable {
    let id = UUID()
    let name: String
    let flag: String
}

class CountryData: ObservableObject {
    @Published var countries: [Country] = []
    @Published var currentIndex: Int = 0
    @Published var score: Int = 0
    @Published var answeredQuestions: Set<UUID> = []
    
    init() {
        loadCountries()
    }
    
    private func loadCountries() {
        countries = [
            Country(name: "France", flag: "🇫🇷"),
            Country(name: "Germany", flag: "🇩🇪"),
            Country(name: "Spain", flag: "🇪🇸"),
            Country(name: "Italy", flag: "🇮🇹"),
            Country(name: "United Kingdom", flag: "🇬🇧"),
            Country(name: "United States", flag: "🇺🇸"),
            Country(name: "Canada", flag: "🇨🇦"),
            Country(name: "Japan", flag: "🇯🇵"),
            Country(name: "China", flag: "🇨🇳"),
            Country(name: "Brazil", flag: "🇧🇷"),
            Country(name: "Australia", flag: "🇦🇺"),
            Country(name: "India", flag: "🇮🇳"),
            Country(name: "Russia", flag: "🇷🇺"),
            Country(name: "South Korea", flag: "🇰🇷"),
            Country(name: "Mexico", flag: "🇲🇽")
        ]
        countries.shuffle()
    }
    
    var currentCountry: Country? {
        guard currentIndex < countries.count else { return nil }
        return countries[currentIndex]
    }
    
    var isLastQuestion: Bool {
        return currentIndex >= countries.count - 1
    }
    
    func checkAnswer(_ answer: String) -> Bool {
        guard let current = currentCountry else { return false }
        let isCorrect = answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == current.name.lowercased()
        
        if isCorrect && !answeredQuestions.contains(current.id) {
            score += 1
            answeredQuestions.insert(current.id)
        }
        
        return isCorrect
    }
    
    func nextQuestion() {
        if currentIndex < countries.count - 1 {
            currentIndex += 1
        }
    }
    
    func previousQuestion() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }
    
    func resetQuiz() {
        currentIndex = 0
        score = 0
        answeredQuestions.removeAll()
        countries.shuffle()
    }
}
