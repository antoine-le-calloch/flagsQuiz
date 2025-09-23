//
//  CountryCard.swift
//  flag-quiz
//
//  Created by Antoine on 9/21/25.
//
import SwiftUI

struct CountryCard: View {
    let flag: String
    @Binding var userAnswer: String
    let onChange: (String) -> Void

    var body: some View {
        VStack(spacing: 30) {
            Text(flag)
                .font(.system(size: 150))

            TextField("Country name", text: $userAnswer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.title2)
                .multilineTextAlignment(.center)
                .onChange(of: userAnswer) { _, newValue in
                    onChange(newValue)
                }
        }
    }
}


