import SwiftUI

struct ExampleMiniGameView: View {
    let example: ExampleDetail
    let bandColor: Color
    @Binding var isPresented: Bool
    
    @State private var showQuiz = false
    @State private var selectedAnswer: Int? = nil
    @State private var hasAnswered = false
    @State private var isCorrect = false
    @State private var showConfetti = false
    @State private var cardScale: CGFloat = 0.9
    @State private var cardOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.95)
                .ignoresSafeArea()
            
            // Main content card
            VStack(spacing: 0) {
                // Header with close button
                HStack {
                    Spacer()
                    Button(action: { dismissView() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Icon and Title
                        iconSection
                        
                        // Description
                        descriptionSection
                        
                        // Fun Fact
                        funFactSection
                        
                        // Quiz Section
                        if showQuiz {
                            quizSection
                        } else {
                            startQuizButton
                        }
                    }
                    .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(white: 0.08))
            .scaleEffect(cardScale)
            .opacity(cardOpacity)
            
            // Confetti effect
            if showConfetti {
                ConfettiView(color: bandColor)
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                cardScale = 1.0
                cardOpacity = 1.0
            }
        }
    }
    
    // MARK: - Icon Section
    private var iconSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(bandColor.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Circle()
                    .stroke(bandColor.opacity(0.5), lineWidth: 2)
                    .frame(width: 80, height: 80)
                
                Image(systemName: example.icon)
                    .font(.system(size: 32))
                    .foregroundColor(bandColor)
            }
            
            Text(example.name)
                .font(.title2.bold())
                .foregroundColor(.white)
        }
    }
    
    // MARK: - Description Section
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("How it works", systemImage: "info.circle.fill")
                .font(.caption.bold())
                .foregroundColor(bandColor)
            
            Text(example.description)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    // MARK: - Fun Fact Section
    private var funFactSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Fun Fact", systemImage: "lightbulb.fill")
                .font(.caption.bold())
                .foregroundColor(.yellow)
            
            Text(example.funFact)
                .font(.callout)
                .foregroundColor(.white.opacity(0.85))
                .italic()
                .lineSpacing(3)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.yellow.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.yellow.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Start Quiz Button
    private var startQuizButton: some View {
        Button(action: {
            HapticFeedback.medium()
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showQuiz = true
            }
        }) {
            HStack {
                Image(systemName: "gamecontroller.fill")
                Text("Test Your Knowledge!")
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(bandColor)
            )
        }
        .padding(.top, 8)
    }
    
    // MARK: - Quiz Section
    private var quizSection: some View {
        VStack(spacing: 16) {
            // Question
            Text(example.quizQuestion)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
            
            // Answer Options
            ForEach(0..<example.quizOptions.count, id: \.self) { index in
                QuizOptionButton(
                    text: example.quizOptions[index],
                    index: index,
                    selectedAnswer: selectedAnswer,
                    correctAnswer: example.correctAnswerIndex,
                    hasAnswered: hasAnswered,
                    bandColor: bandColor,
                    action: { selectAnswer(index) }
                )
            }
            
            // Result message
            if hasAnswered {
                resultSection
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(bandColor.opacity(0.3), lineWidth: 1)
                )
        )
        .transition(.asymmetric(
            insertion: .scale(scale: 0.9).combined(with: .opacity),
            removal: .opacity
        ))
    }
    
    // MARK: - Result Section
    private var resultSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(isCorrect ? .green : .red)
                Text(isCorrect ? "Correct! 🎉" : "Not quite right")
                    .foregroundColor(isCorrect ? .green : .red)
            }
            .font(.headline)
            
            if !isCorrect {
                Text("The answer is: \(example.quizOptions[example.correctAnswerIndex])")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Button(action: { dismissView() }) {
                Text("Continue Exploring")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(bandColor)
                    )
            }
            .padding(.top, 8)
        }
        .transition(.scale.combined(with: .opacity))
    }
    
    // MARK: - Helper Functions
    private func selectAnswer(_ index: Int) {
        guard !hasAnswered else { return }
        
        HapticFeedback.selection()
        selectedAnswer = index
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                hasAnswered = true
                isCorrect = index == example.correctAnswerIndex
                
                if isCorrect {
                    showConfetti = true
                    HapticFeedback.heavy()
                } else {
                    HapticFeedback.light()
                }
            }
        }
    }
    
    private func dismissView() {
        HapticFeedback.light()
        isPresented = false
    }
}

// MARK: - Quiz Option Button
struct QuizOptionButton: View {
    let text: String
    let index: Int
    let selectedAnswer: Int?
    let correctAnswer: Int
    let hasAnswered: Bool
    let bandColor: Color
    let action: () -> Void
    
    private var backgroundColor: Color {
        if hasAnswered {
            if index == correctAnswer {
                return Color.green.opacity(0.3)
            } else if index == selectedAnswer {
                return Color.red.opacity(0.3)
            }
        } else if selectedAnswer == index {
            return bandColor.opacity(0.4)
        }
        return Color.white.opacity(0.08)
    }
    
    private var borderColor: Color {
        if hasAnswered {
            if index == correctAnswer {
                return Color.green
            } else if index == selectedAnswer {
                return Color.red
            }
        } else if selectedAnswer == index {
            return bandColor
        }
        return Color.white.opacity(0.2)
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(optionLetter)
                    .font(.caption.bold())
                    .foregroundColor(bandColor)
                    .frame(width: 24, height: 24)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.1))
                    )
                
                Text(text)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if hasAnswered {
                    if index == correctAnswer {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else if index == selectedAnswer {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1.5)
            )
        }
        .disabled(hasAnswered)
        .scaleEffect(selectedAnswer == index && !hasAnswered ? 0.98 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: selectedAnswer)
    }
    
    private var optionLetter: String {
        let letters = ["A", "B", "C", "D"]
        return letters[index]
    }
}

// MARK: - Confetti View
struct ConfettiView: View {
    let color: Color
    @State private var particles: [ConfettiParticle] = []
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .position(particle.position)
                        .opacity(particle.opacity)
                }
            }
            .onAppear {
                createParticles(in: geo.size)
                animateParticles()
            }
        }
        .allowsHitTesting(false)
    }
    
    private func createParticles(in size: CGSize) {
        let colors: [Color] = [color, .yellow, .green, .orange, .pink, .purple]
        particles = (0..<50).map { _ in
            ConfettiParticle(
                position: CGPoint(x: size.width / 2, y: size.height / 3),
                color: colors.randomElement() ?? color,
                size: CGFloat.random(in: 6...12),
                velocity: CGPoint(
                    x: CGFloat.random(in: -200...200),
                    y: CGFloat.random(in: -400...(-100))
                ),
                opacity: 1.0
            )
        }
    }
    
    private func animateParticles() {
        withAnimation(.easeOut(duration: 1.5)) {
            for i in particles.indices {
                particles[i].position.x += particles[i].velocity.x
                particles[i].position.y += particles[i].velocity.y + 400
                particles[i].opacity = 0
            }
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let color: Color
    let size: CGFloat
    let velocity: CGPoint
    var opacity: Double
}

// MARK: - Preview
#Preview {
    ExampleMiniGameView(
        example: ExampleDetail.allExamples.first!,
        bandColor: .red,
        isPresented: .constant(true)
    )
}
