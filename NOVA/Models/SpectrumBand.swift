import SwiftUI

struct SpectrumBand: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let color: Color
    let description: String
    let wavelength: String
    let frequency: String
    let examples: [String]
    let icon: String
    let applications: [String]
    let dangers: String?
    
    // MARK: - Complete Electromagnetic Spectrum Data
    static let allBands: [SpectrumBand] = [
        // Radio Waves
        SpectrumBand(
            name: "Radio Waves",
            color: Color(red: 0.8, green: 0.2, blue: 0.2),
            description: "Radio waves have the longest wavelengths and lowest frequencies in the electromagnetic spectrum. They can travel long distances and pass through most materials.",
            wavelength: "1mm - 100km",
            frequency: "3 kHz - 300 GHz",
            examples: ["AM/FM Radio", "Television", "Cell Phones", "WiFi", "Bluetooth", "GPS"],
            icon: "dot.radiowaves.left.and.right",
            applications: ["Broadcasting", "Communication", "Navigation", "Radar", "Astronomy"],
            dangers: nil
        ),
        
        // Microwaves
        SpectrumBand(
            name: "Microwaves",
            color: Color(red: 0.9, green: 0.4, blue: 0.2),
            description: "Microwaves are used for cooking food and in radar systems. They can heat water molecules efficiently.",
            wavelength: "1mm - 1m",
            frequency: "300 MHz - 300 GHz",
            examples: ["Microwave Ovens", "Radar", "Satellite Communication", "Bluetooth", "WiFi"],
            icon: "wave.3.right",
            applications: ["Cooking", "Weather Radar", "Air Traffic Control", "Astronomy", "Medical Therapy"],
            dangers: "Can cause burns and tissue heating at high power"
        ),
        
        // Infrared
        SpectrumBand(
            name: "Infrared",
            color: Color(red: 1.0, green: 0.5, blue: 0.0),
            description: "Infrared radiation is heat energy that we can feel but not see. All warm objects emit infrared radiation.",
            wavelength: "700nm - 1mm",
            frequency: "300 GHz - 430 THz",
            examples: ["Remote Controls", "Thermal Cameras", "Heat Lamps", "Night Vision", "Infrared Saunas"],
            icon: "flame.fill",
            applications: ["Thermal Imaging", "Medical Therapy", "Heating", "Astronomy", "Security Systems"],
            dangers: "Can cause burns at high intensity"
        ),
        
        // Visible Light
        SpectrumBand(
            name: "Visible Light",
            color: Color(red: 0.2, green: 0.8, blue: 0.2),
            description: "Visible light is the only part of the electromagnetic spectrum that human eyes can detect. It contains all colors from red to violet.",
            wavelength: "380nm - 700nm",
            frequency: "430 THz - 790 THz",
            examples: ["Sunlight", "LED Lights", "Lasers", "Photography", "Rainbows", "Prisms"],
            icon: "eye.fill",
            applications: ["Illumination", "Photography", "Optical Communications", "Microscopy", "Art"],
            dangers: "Bright light can damage eyes"
        ),
        
        // Ultraviolet - Changed to more purple/violet
        SpectrumBand(
            name: "Ultraviolet",
            color: Color(red: 0.4, green: 0.2, blue: 0.9),
            description: "Ultraviolet light is invisible to humans but can cause sunburn and is used for sterilization. It's divided into UV-A, UV-B, and UV-C.",
            wavelength: "10nm - 380nm",
            frequency: "790 THz - 30 PHz",
            examples: ["Black Lights", "Sunscreen Testing", "Water Purification", "Forensics", "Vitamin D Production"],
            icon: "sun.max.fill",
            applications: ["Sterilization", "Medical Treatment", "Forensic Analysis", "Tanning", "Water Treatment"],
            dangers: "Can cause skin cancer, sunburn, and eye damage"
        ),
        
        // X-rays
        SpectrumBand(
            name: "X-rays",
            color: Color(red: 0.2, green: 0.4, blue: 0.9),
            description: "X-rays can penetrate soft tissues but are absorbed by bones and dense materials. Essential for medical imaging.",
            wavelength: "0.01nm - 10nm",
            frequency: "30 PHz - 30 EHz",
            examples: ["Medical X-rays", "CT Scans", "Airport Security", "Dental X-rays", "Bone Imaging"],
            icon: "cross.case.fill",
            applications: ["Medical Imaging", "Security Screening", "Industrial Testing", "Astronomy", "Art Analysis"],
            dangers: "Ionizing radiation - can cause cancer and cell damage"
        ),
        
        // Gamma Rays - Changed to more magenta/pink
        SpectrumBand(
            name: "Gamma Rays",
            color: Color(red: 0.9, green: 0.2, blue: 0.7),
            description: "Gamma rays have the highest energy and shortest wavelength. They're produced by radioactive decay and cosmic events.",
            wavelength: "< 0.01nm",
            frequency: "> 30 EHz",
            examples: ["Nuclear Reactions", "Cosmic Rays", "Radioactive Decay", "Lightning", "Nuclear Medicine"],
            icon: "bolt.fill",
            applications: ["Cancer Treatment", "Nuclear Medicine", "Food Sterilization", "Astronomy", "Industrial Radiography"],
            dangers: "Highly dangerous - can cause severe radiation sickness and death"
        )
    ]
    
    // Keep the original sampleBands for compatibility
    static let sampleBands = allBands
}

// MARK: - Computed Properties
extension SpectrumBand {
    var waveFrequency: Double {
        switch name {
        case "Radio Waves": return 0.3
        case "Microwaves": return 0.5
        case "Infrared": return 0.7
        case "Visible Light": return 1.0
        case "Ultraviolet": return 1.4
        case "X-rays": return 1.8
        case "Gamma Rays": return 2.2
        default: return 1.0
        }
    }
    
    var energyLevel: Int {
        switch name {
        case "Radio Waves": return 1
        case "Microwaves": return 1
        case "Infrared": return 2
        case "Visible Light": return 2
        case "Ultraviolet": return 3
        case "X-rays": return 4
        case "Gamma Rays": return 5
        default: return 1
        }
    }
    
    var energyDescription: String {
        switch name {
        case "Radio Waves": return "Very low energy"
        case "Microwaves": return "Low energy"
        case "Infrared": return "Heat energy"
        case "Visible Light": return "Light energy"
        case "Ultraviolet": return "High energy"
        case "X-rays": return "Very high energy"
        case "Gamma Rays": return "Extremely high energy"
        default: return "Energy"
        }
    }
    
    var safetyLevel: String {
        switch name {
        case "Radio Waves", "Microwaves": return "Generally Safe"
        case "Infrared": return "Safe at normal levels"
        case "Visible Light": return "Safe except intense sources"
        case "Ultraviolet": return "Caution - Can cause burns"
        case "X-rays": return "Harmful - Controlled exposure"
        case "Gamma Rays": return "Dangerous - Extreme caution"
        default: return "Unknown"
        }
    }
    
    var colorGradient: LinearGradient {
        LinearGradient(
            colors: [color, color.opacity(0.6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Haptic Feedback Helper
struct HapticFeedback {
    static func light() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    static func medium() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    static func heavy() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
    
    static func selection() {
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
    }
}
