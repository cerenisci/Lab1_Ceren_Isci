import SwiftUI

struct ContentView: View {
    @State private var number: Int = Int.random(in: 1...100)
    @State private var correctAnswers: Int = 0
    @State private var wrongAnswers: Int = 0
    @State private var attempts: Int = 0
    @State private var showResult: Bool = false
    @State private var showCorrect: Bool? = nil
    @State private var timer: Timer? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("Is this number prime?")
                .font(.title)
                .padding()
            
            Text("\(number)")
                .font(.system(size: 50, weight: .bold))
                .padding()
            
            HStack {
                Button(action: {
                    checkAnswer(isPrimeSelected: true)
                }) {
                    Text("Prime")
                        .font(.title)
                        .padding()
                        .frame(width: 120, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    checkAnswer(isPrimeSelected: false)
                }) {
                    Text("Not Prime")
                        .font(.title)
                        .padding()
                        .frame(width: 120, height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            if let correct = showCorrect {
                Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(correct ? .green : .red)
                    .transition(.scale)
            }

        }
        .onAppear(perform: startTimer)
        .alert(isPresented: $showResult) {
            Alert(
                title: Text("Game Summary"),
                message: Text("Correct: \(correctAnswers)\nWrong: \(wrongAnswers)"),
                dismissButton: .default(Text("OK")) {
                    resetGame()
                }
            )
        }
    }
    
    func checkAnswer(isPrimeSelected: Bool) {
        let isPrime = isNumberPrime(number)
        if isPrime == isPrimeSelected {
            correctAnswers += 1
            showCorrect = true
        } else {
            wrongAnswers += 1
            showCorrect = false
        }
        
        attempts += 1
        nextNumber()
        
        if attempts % 10 == 0 {
            showResult = true
        }
    }

    func nextNumber() {
        number = Int.random(in: 1...100)
        restartTimer()
    }

    func isNumberPrime(_ num: Int) -> Bool {
        if num < 2 { return false }
        for i in 2..<num {
            if num % i == 0 { return false }
        }
        return true
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            wrongAnswers += 1
            attempts += 1
            nextNumber()
            
            if attempts % 10 == 0 {
                showResult = true
            }
        }
    }

    func restartTimer() {
        timer?.invalidate()
        startTimer()
    }

    func resetGame() {
        correctAnswers = 0
        wrongAnswers = 0
        attempts = 0
        nextNumber()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
