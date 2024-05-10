import Foundation

class UserData: ObservableObject {
    
    @Published var credits = UserDefaults.standard.integer(forKey: "credits") {
        didSet {
            UserDefaults.standard.set(credits, forKey: "credits")
        }
    }
    
    @Published var currentPlane = UserDefaults.standard.string(forKey: "plane") {
        didSet {
            UserDefaults.standard.set(currentPlane, forKey: "plane")
        }
    }
    
}
