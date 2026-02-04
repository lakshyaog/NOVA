import SwiftUI

// MARK: - Example Detail Model
struct ExampleDetail: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let description: String
    let funFact: String
    let quizQuestion: String
    let quizOptions: [String]
    let correctAnswerIndex: Int
    let spectrumBandName: String
    
    // Dictionary to look up example details
    static func detail(for example: String, bandName: String) -> ExampleDetail? {
        return allExamples.first { $0.name == example && $0.spectrumBandName == bandName }
    }
}

// MARK: - All Example Details Data
extension ExampleDetail {
    static let allExamples: [ExampleDetail] = [
        // MARK: - Radio Waves Examples
        ExampleDetail(
            name: "AM/FM Radio",
            icon: "radio.fill",
            description: "AM and FM radio use different modulation techniques to transmit audio. AM (Amplitude Modulation) varies the signal strength, while FM (Frequency Modulation) varies the frequency.",
            funFact: "FM radio was invented in 1933 by Edwin Armstrong and provides better sound quality than AM!",
            quizQuestion: "What does FM stand for?",
            quizOptions: ["Fast Modulation", "Frequency Modulation", "Fine Music", "Free Media"],
            correctAnswerIndex: 1,
            spectrumBandName: "Radio Waves"
        ),
        ExampleDetail(
            name: "Television",
            icon: "tv.fill",
            description: "Television broadcasts use radio waves to transmit video and audio signals to your TV. Different channels use different frequencies.",
            funFact: "The first TV broadcast was in 1928, but regular broadcasting began in the 1930s!",
            quizQuestion: "How does TV receive signals?",
            quizOptions: ["Through light beams", "Through radio waves", "Through sound waves", "Through cables only"],
            correctAnswerIndex: 1,
            spectrumBandName: "Radio Waves"
        ),
        ExampleDetail(
            name: "Cell Phones",
            icon: "iphone.gen3",
            description: "Cell phones communicate using radio waves between your device and cell towers. 4G and 5G use different frequencies for faster speeds.",
            funFact: "The first mobile phone call was made in 1973 by Martin Cooper!",
            quizQuestion: "Cell phones communicate using what?",
            quizOptions: ["Sound waves", "Light beams", "Radio waves", "Magnetic fields"],
            correctAnswerIndex: 2,
            spectrumBandName: "Radio Waves"
        ),
        ExampleDetail(
            name: "WiFi",
            icon: "wifi",
            description: "WiFi uses radio waves at 2.4 GHz or 5 GHz frequencies to connect devices wirelessly to the internet.",
            funFact: "WiFi stands for 'Wireless Fidelity' and was first released in 1997!",
            quizQuestion: "What frequencies does WiFi typically use?",
            quizOptions: ["1 GHz and 3 GHz", "2.4 GHz and 5 GHz", "10 GHz and 20 GHz", "100 MHz and 200 MHz"],
            correctAnswerIndex: 1,
            spectrumBandName: "Radio Waves"
        ),
        ExampleDetail(
            name: "Bluetooth",
            icon: "wave.3.right.circle.fill",
            description: "Bluetooth uses short-range radio waves to connect devices like headphones, keyboards, and speakers wirelessly.",
            funFact: "Bluetooth is named after Harald Bluetooth, a 10th-century Danish king who unified Denmark!",
            quizQuestion: "Bluetooth is used for:",
            quizOptions: ["Long-range communication", "Short-range device connection", "Satellite signals", "Underground communication"],
            correctAnswerIndex: 1,
            spectrumBandName: "Radio Waves"
        ),
        ExampleDetail(
            name: "GPS",
            icon: "location.fill",
            description: "GPS (Global Positioning System) uses radio signals from satellites to determine your exact location on Earth.",
            funFact: "There are at least 24 GPS satellites orbiting Earth at all times!",
            quizQuestion: "How many GPS satellites orbit Earth?",
            quizOptions: ["At least 24", "Exactly 10", "Only 5", "Over 100"],
            correctAnswerIndex: 0,
            spectrumBandName: "Radio Waves"
        ),
        
        // MARK: - Microwave Examples
        ExampleDetail(
            name: "Microwave Ovens",
            icon: "microwave.fill",
            description: "Microwave ovens heat food by using microwaves to vibrate water molecules, creating friction and heat.",
            funFact: "Microwaves were accidentally discovered in 1945 when a radar engineer's chocolate bar melted!",
            quizQuestion: "Microwave ovens heat food by vibrating:",
            quizOptions: ["Air molecules", "Water molecules", "Metal atoms", "Light particles"],
            correctAnswerIndex: 1,
            spectrumBandName: "Microwaves"
        ),
        ExampleDetail(
            name: "Radar",
            icon: "antenna.radiowaves.left.and.right",
            description: "Radar uses microwaves to detect objects by measuring the time it takes for signals to bounce back.",
            funFact: "RADAR stands for 'Radio Detection And Ranging' and was crucial in World War II!",
            quizQuestion: "What does RADAR stand for?",
            quizOptions: ["Radio Detection And Ranging", "Remote Data And Recording", "Rapid Distance Analysis Receiver", "Range Detection Active Relay"],
            correctAnswerIndex: 0,
            spectrumBandName: "Microwaves"
        ),
        ExampleDetail(
            name: "Satellite Communication",
            icon: "antenna.radiowaves.left.and.right.circle.fill",
            description: "Satellites use microwaves to relay TV, internet, and phone signals around the world.",
            funFact: "The first communication satellite, Telstar, was launched in 1962!",
            quizQuestion: "What was the first communication satellite?",
            quizOptions: ["Sputnik", "Telstar", "Apollo", "Voyager"],
            correctAnswerIndex: 1,
            spectrumBandName: "Microwaves"
        ),
        ExampleDetail(
            name: "WiFi",
            icon: "wifi",
            description: "WiFi uses microwave frequencies at 2.4 GHz or 5 GHz to connect devices wirelessly to the internet. These are in the microwave portion of the spectrum.",
            funFact: "WiFi routers emit microwaves similar to microwave ovens, but at much lower power levels!",
            quizQuestion: "What frequencies does WiFi typically use?",
            quizOptions: ["1 GHz and 3 GHz", "2.4 GHz and 5 GHz", "10 GHz and 20 GHz", "100 MHz and 200 MHz"],
            correctAnswerIndex: 1,
            spectrumBandName: "Microwaves"
        ),
        ExampleDetail(
            name: "Bluetooth",
            icon: "wave.3.right.circle.fill",
            description: "Bluetooth operates at 2.4 GHz in the microwave spectrum, using short-range microwaves to connect devices wirelessly.",
            funFact: "Bluetooth and WiFi both use 2.4 GHz microwaves, which is why they can sometimes interfere with each other!",
            quizQuestion: "Bluetooth operates at what frequency?",
            quizOptions: ["900 MHz", "2.4 GHz", "5 GHz", "10 GHz"],
            correctAnswerIndex: 1,
            spectrumBandName: "Microwaves"
        ),
        
        // MARK: - Infrared Examples
        ExampleDetail(
            name: "Remote Controls",
            icon: "av.remote.fill",
            description: "TV remote controls use infrared light to send signals to your TV. That's why they need a clear line of sight!",
            funFact: "The first wireless remote control was invented in 1956 and used ultrasonics, not infrared!",
            quizQuestion: "Why do remotes need line of sight to work?",
            quizOptions: ["They use sound", "Infrared can't pass through walls", "They use WiFi", "They need to see the TV"],
            correctAnswerIndex: 1,
            spectrumBandName: "Infrared"
        ),
        ExampleDetail(
            name: "Thermal Cameras",
            icon: "camera.viewfinder",
            description: "Thermal cameras detect infrared radiation from objects to create heat maps, showing temperature differences.",
            funFact: "Firefighters use thermal cameras to see through smoke and find people!",
            quizQuestion: "Thermal cameras detect what from objects?",
            quizOptions: ["Radio waves", "Visible light", "Infrared radiation", "X-rays"],
            correctAnswerIndex: 2,
            spectrumBandName: "Infrared"
        ),
        ExampleDetail(
            name: "Heat Lamps",
            icon: "lightbulb.fill",
            description: "Heat lamps emit infrared radiation to keep food warm in restaurants or provide warmth for animals.",
            funFact: "Heat lamps are used to keep baby chicks warm since they can't regulate their body temperature!",
            quizQuestion: "Heat lamps emit what type of radiation?",
            quizOptions: ["Ultraviolet", "Gamma rays", "Infrared", "X-rays"],
            correctAnswerIndex: 2,
            spectrumBandName: "Infrared"
        ),
        ExampleDetail(
            name: "Night Vision",
            icon: "eye.circle.fill",
            description: "Night vision goggles amplify small amounts of light or detect infrared to see in darkness.",
            funFact: "Some snakes can 'see' infrared radiation to detect warm-blooded prey in total darkness!",
            quizQuestion: "Night vision works by detecting:",
            quizOptions: ["X-rays", "Infrared or amplified light", "Radio waves", "Sound waves"],
            correctAnswerIndex: 1,
            spectrumBandName: "Infrared"
        ),
        ExampleDetail(
            name: "Infrared Saunas",
            icon: "flame.fill",
            description: "Infrared saunas use infrared light to heat your body directly instead of heating the air around you.",
            funFact: "Infrared saunas operate at lower temperatures than traditional saunas but feel just as warm!",
            quizQuestion: "How do infrared saunas work?",
            quizOptions: ["Heat the air", "Heat your body directly", "Use steam", "Use hot rocks"],
            correctAnswerIndex: 1,
            spectrumBandName: "Infrared"
        ),
        
        // MARK: - Visible Light Examples
        ExampleDetail(
            name: "Sunlight",
            icon: "sun.max.fill",
            description: "Sunlight contains all colors of visible light combined, which appears white to our eyes.",
            funFact: "Sunlight takes about 8 minutes and 20 seconds to reach Earth from the Sun!",
            quizQuestion: "How long does sunlight take to reach Earth?",
            quizOptions: ["Instant", "About 8 minutes", "1 hour", "1 day"],
            correctAnswerIndex: 1,
            spectrumBandName: "Visible Light"
        ),
        ExampleDetail(
            name: "LED Lights",
            icon: "lightbulb.led.fill",
            description: "LEDs produce light when electricity passes through a semiconductor, creating specific colors of light.",
            funFact: "LED stands for Light Emitting Diode, and they use 75% less energy than incandescent bulbs!",
            quizQuestion: "What does LED stand for?",
            quizOptions: ["Light Energy Device", "Low Emission Display", "Light Emitting Diode", "Laser Electric Device"],
            correctAnswerIndex: 2,
            spectrumBandName: "Visible Light"
        ),
        ExampleDetail(
            name: "Lasers",
            icon: "laser.burst",
            description: "Lasers produce concentrated beams of light at a single wavelength, making them extremely precise.",
            funFact: "LASER stands for 'Light Amplification by Stimulated Emission of Radiation'!",
            quizQuestion: "What makes lasers special?",
            quizOptions: ["They're invisible", "Single wavelength, concentrated beam", "They're hot", "They're magnetic"],
            correctAnswerIndex: 1,
            spectrumBandName: "Visible Light"
        ),
        ExampleDetail(
            name: "Photography",
            icon: "camera.fill",
            description: "Cameras capture visible light to create images. Digital cameras use sensors to detect light intensity and color.",
            funFact: "The first photograph ever taken required an 8-hour exposure time in 1826!",
            quizQuestion: "How long was the exposure for the first photograph?",
            quizOptions: ["1 second", "1 minute", "8 hours", "1 day"],
            correctAnswerIndex: 2,
            spectrumBandName: "Visible Light"
        ),
        ExampleDetail(
            name: "Rainbows",
            icon: "rainbow",
            description: "Rainbows form when sunlight is refracted and dispersed by water droplets, separating into its component colors.",
            funFact: "A rainbow is actually a full circle, but we only see half because the ground blocks the rest!",
            quizQuestion: "What causes rainbows to form?",
            quizOptions: ["Clouds reflecting", "Light refracted by water", "Colored air", "Magic"],
            correctAnswerIndex: 1,
            spectrumBandName: "Visible Light"
        ),
        ExampleDetail(
            name: "Prisms",
            icon: "triangle.fill",
            description: "Prisms separate white light into its component colors by bending different wavelengths at different angles.",
            funFact: "Isaac Newton used prisms to prove that white light is made of all colors combined!",
            quizQuestion: "Who proved white light contains all colors?",
            quizOptions: ["Einstein", "Newton", "Galileo", "Edison"],
            correctAnswerIndex: 1,
            spectrumBandName: "Visible Light"
        ),
        
        // MARK: - Ultraviolet Examples
        ExampleDetail(
            name: "Black Lights",
            icon: "light.beacon.max.fill",
            description: "Black lights emit UV-A light that makes certain materials glow (fluoresce) while remaining mostly invisible to us.",
            funFact: "Scorpions glow bright green under black lights, helping scientists find them at night!",
            quizQuestion: "What glows under black lights?",
            quizOptions: ["All objects", "Only white objects", "Fluorescent materials", "Nothing"],
            correctAnswerIndex: 2,
            spectrumBandName: "Ultraviolet"
        ),
        ExampleDetail(
            name: "Sunscreen Testing",
            icon: "sun.max.trianglebadge.exclamationmark.fill",
            description: "UV cameras can show how sunscreen blocks ultraviolet light, appearing dark on skin where applied.",
            funFact: "Sunscreen was invented in 1938 by Franz Greiter after getting a severe sunburn!",
            quizQuestion: "Sunscreen protects us from what?",
            quizOptions: ["Visible light", "Radio waves", "Ultraviolet rays", "Infrared heat"],
            correctAnswerIndex: 2,
            spectrumBandName: "Ultraviolet"
        ),
        ExampleDetail(
            name: "Water Purification",
            icon: "drop.fill",
            description: "UV-C light destroys the DNA of bacteria and viruses, making it effective for sterilizing water.",
            funFact: "UV water purification kills 99.99% of harmful microorganisms without adding chemicals!",
            quizQuestion: "How does UV purify water?",
            quizOptions: ["Heating it", "Destroying microbe DNA", "Filtering particles", "Adding chemicals"],
            correctAnswerIndex: 1,
            spectrumBandName: "Ultraviolet"
        ),
        ExampleDetail(
            name: "Forensics",
            icon: "magnifyingglass",
            description: "UV light reveals hidden evidence like fingerprints, bodily fluids, and altered documents at crime scenes.",
            funFact: "Many security features in money and passports are only visible under UV light!",
            quizQuestion: "UV light in forensics reveals:",
            quizOptions: ["Fingerprints and fluids", "Sound recordings", "Magnetic fields", "Temperature"],
            correctAnswerIndex: 0,
            spectrumBandName: "Ultraviolet"
        ),
        ExampleDetail(
            name: "Vitamin D Production",
            icon: "figure.walk",
            description: "When UV-B light hits your skin, it triggers the production of Vitamin D, essential for bone health.",
            funFact: "Just 10-30 minutes of midday sun a few times a week can provide enough Vitamin D!",
            quizQuestion: "UV-B light helps produce what vitamin?",
            quizOptions: ["Vitamin A", "Vitamin C", "Vitamin D", "Vitamin E"],
            correctAnswerIndex: 2,
            spectrumBandName: "Ultraviolet"
        ),
        
        // MARK: - X-ray Examples
        ExampleDetail(
            name: "Medical X-rays",
            icon: "xray",
            description: "Medical X-rays pass through soft tissue but are absorbed by bones, creating shadow images for diagnosis.",
            funFact: "Wilhelm Röntgen discovered X-rays in 1895 and won the first Nobel Prize in Physics!",
            quizQuestion: "Who discovered X-rays?",
            quizOptions: ["Marie Curie", "Wilhelm Röntgen", "Albert Einstein", "Nikola Tesla"],
            correctAnswerIndex: 1,
            spectrumBandName: "X-rays"
        ),
        ExampleDetail(
            name: "CT Scans",
            icon: "rotate.3d",
            description: "CT scans use multiple X-ray images taken from different angles to create detailed 3D views of the body.",
            funFact: "CT stands for 'Computed Tomography' and can capture images in just seconds!",
            quizQuestion: "What does CT stand for?",
            quizOptions: ["Computer Technology", "Computed Tomography", "Cellular Testing", "Cross Transmission"],
            correctAnswerIndex: 1,
            spectrumBandName: "X-rays"
        ),
        ExampleDetail(
            name: "Airport Security",
            icon: "airplane",
            description: "Airport X-ray machines scan luggage to reveal hidden objects, with different materials showing different colors.",
            funFact: "Modern airport scanners can identify specific materials by their density!",
            quizQuestion: "Airport X-rays identify objects by:",
            quizOptions: ["Weight", "Material density", "Color", "Sound"],
            correctAnswerIndex: 1,
            spectrumBandName: "X-rays"
        ),
        ExampleDetail(
            name: "Dental X-rays",
            icon: "mouth.fill",
            description: "Dental X-rays reveal cavities, impacted teeth, and bone loss that can't be seen during a regular exam.",
            funFact: "Dental X-rays use very low radiation—about the same as a few hours of natural background radiation!",
            quizQuestion: "Dental X-rays can reveal:",
            quizOptions: ["Only cavities", "Hidden problems under the gums", "Bacteria", "Saliva composition"],
            correctAnswerIndex: 1,
            spectrumBandName: "X-rays"
        ),
        ExampleDetail(
            name: "Bone Imaging",
            icon: "figure.stand",
            description: "X-rays are ideal for imaging bones because calcium absorbs X-rays well, creating clear contrast with soft tissue.",
            funFact: "The first X-ray image ever was of Röntgen's wife's hand, showing her bones and wedding ring!",
            quizQuestion: "Why are bones visible in X-rays?",
            quizOptions: ["They reflect X-rays", "Calcium absorbs X-rays", "They glow", "They're hollow"],
            correctAnswerIndex: 1,
            spectrumBandName: "X-rays"
        ),
        
        // MARK: - Gamma Ray Examples
        ExampleDetail(
            name: "Nuclear Reactions",
            icon: "atom",
            description: "Gamma rays are released during nuclear reactions when atomic nuclei undergo changes.",
            funFact: "The Sun produces gamma rays in its core, but they take thousands of years to reach the surface!",
            quizQuestion: "Where in the Sun are gamma rays produced?",
            quizOptions: ["The surface", "The core", "The corona", "The spots"],
            correctAnswerIndex: 1,
            spectrumBandName: "Gamma Rays"
        ),
        ExampleDetail(
            name: "Cosmic Rays",
            icon: "sparkles",
            description: "Cosmic gamma rays come from distant galaxies, supernovae, and black holes across the universe.",
            funFact: "Earth's atmosphere protects us from cosmic gamma rays—we can only detect them from space!",
            quizQuestion: "What protects us from cosmic gamma rays?",
            quizOptions: ["The Moon", "Earth's atmosphere", "The magnetic field only", "Nothing"],
            correctAnswerIndex: 1,
            spectrumBandName: "Gamma Rays"
        ),
        ExampleDetail(
            name: "Radioactive Decay",
            icon: "radiowaves.right",
            description: "Some radioactive materials emit gamma rays as they decay into more stable forms.",
            funFact: "The Hulk's powers in comics come from gamma ray exposure—but in reality, it would be very harmful!",
            quizQuestion: "Gamma rays from decay indicate:",
            quizOptions: ["Stable atoms", "Unstable radioactive material", "Chemical reactions", "Magnetism"],
            correctAnswerIndex: 1,
            spectrumBandName: "Gamma Rays"
        ),
        ExampleDetail(
            name: "Lightning",
            icon: "bolt.fill",
            description: "Lightning produces brief bursts of gamma rays through a phenomenon called terrestrial gamma-ray flashes.",
            funFact: "A single lightning bolt can produce gamma rays with the energy of 100 million X-rays!",
            quizQuestion: "Lightning produces gamma rays through:",
            quizOptions: ["Heat", "Sound", "Terrestrial gamma-ray flashes", "Friction"],
            correctAnswerIndex: 2,
            spectrumBandName: "Gamma Rays"
        ),
        ExampleDetail(
            name: "Nuclear Medicine",
            icon: "cross.circle.fill",
            description: "Gamma rays are used in medicine to diagnose and treat diseases, including certain cancers.",
            funFact: "Gamma knife surgery uses focused gamma rays to treat brain tumors without any incisions!",
            quizQuestion: "Gamma knife surgery treats what?",
            quizOptions: ["Broken bones", "Brain tumors", "Skin conditions", "Heart disease"],
            correctAnswerIndex: 1,
            spectrumBandName: "Gamma Rays"
        )
    ]
}
