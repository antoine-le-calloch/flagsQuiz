import SwiftUI

struct ContentView: View {
    @StateObject private var countryData = CountryData()
    @State private var currentText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @State private var isValidated = false
    @State private var endOfAnimation = false
    @State private var timeElapsed: Int = 0
    @State private var selectedLanguage: String = "fr"
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(countryData.currentIndex + 1)/\(countryData.countries.count)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 70)
                
                Spacer()
                
                Picker("", selection: $selectedLanguage) {
                    Text("FR").tag("fr")
                    Text("EN").tag("en")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 90)
                .onChange(of: selectedLanguage) { _, newValue in
                    countryData.language = newValue
                }
                
                Spacer()
                
                Text(String(format: "%02d:%02d", timeElapsed / 60, timeElapsed % 60))
                    .font(.headline)
                    .foregroundColor(.white)
                    .onReceive(timer) { _ in
                        timeElapsed += 1
                    }
                    .frame(width: 70)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            
            TabView(selection: $countryData.currentIndex) {
                ForEach(Array(countryData.countries.enumerated()), id: \.element.id) { index, country in
                    VStack(spacing: 30) {
                        Text(country.flag).font(.system(size: 150))
                    }
                    .padding()
                    .frame(maxWidth: 300, maxHeight: 250)
                    .background(
                        Group {
                            if isValidated {
                                Color.green.opacity(0.6)
                            } else {
                                BlurView(style: .systemThinMaterial)
                            }
                        }
                    )
                    .opacity(endOfAnimation ? 0 : 1)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .tag(index)
                }
            }
            .offset(y: !endOfAnimation && isValidated ? -600 : 0)
            .animation(.easeIn(duration: 0.4), value: isValidated)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onChange(of: countryData.currentIndex) { _, _ in
                currentText = countryData.currentCountry?.userAnswer ?? ""
            }
            .onChange(of: countryData.countries.count) { _, _ in
                currentText = countryData.currentCountry?.userAnswer ?? ""
            }
            
            TextField(
                "Country name",
                text: $currentText
            )
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .keyboardType(.alphabet)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .font(.system(size: 25))
            .multilineTextAlignment(.center)
            .onChange(of: currentText) { _, newValue in
                countryData.countries[countryData.currentIndex].userAnswer = newValue
                guard let country = countryData.currentCountry else { return }
                
                if countryData.checkAnswer(for: country) {
                    isValidated = true
                    currentText = ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        isValidated = false
                        endOfAnimation = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            countryData.removeCountry(country)
                            endOfAnimation = false
                        }
                    }
                }
            }
        }
        .blueBackground()
        .onAppear {
            isTextFieldFocused = true
        }
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
