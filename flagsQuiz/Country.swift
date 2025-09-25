//
//  Country.swift
//  flag-quiz
//
//  Created by Antoine on 9/21/25.
//
import SwiftUI
import Foundation

struct Country: Identifiable, Codable {
    let id = UUID()
    let en: String
    let fr: String
    let flag: String
    var userAnswer: String = ""
    var language: String = "fr"
    
    enum CodingKeys: String, CodingKey {
        case en, fr, flag
    }
    
    var name: String {
        if language == "fr" {return fr}
        return en
    }
}

class CountryData: ObservableObject {
    @Published var countries: [Country] = []
    @Published var currentIndex: Int = 0
    @Published var answeredQuestions: Set<UUID> = []
    
    init() {
        loadCountries()
    }
    
    private func loadCountries() {
        if let url = Bundle.main.url(forResource: "countries", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedCountries = try JSONDecoder().decode([Country].self, from: data)
                countries = decodedCountries
            } catch {
                print("Error loading countries.json: \(error)")
                countries = []
            }
        } else {
            print("countries.json not found")
            countries = []
        }
        countries.shuffle()
    }
    
    var currentCountry: Country? {
        guard currentIndex < countries.count else { return nil }
        return countries[currentIndex]
    }
    
    var isLastQuestion: Bool {
        return currentIndex >= countries.count - 1
    }
    
    func checkAnswer(for country: Country) -> Bool {
        // Normalize both strings: trim whitespace, lowercase, and remove diacritics (accents)
        let answer = country.userAnswer
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: .current)

        let correctName = country.name
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: .current)

        return answer == correctName
    }
    func removeCountry(_ country: Country) {
        countries.removeAll { $0.id == country.id }
    }
        
    func resetQuiz() {
        currentIndex = 0
        answeredQuestions.removeAll()
        countries.shuffle()
    }
}
