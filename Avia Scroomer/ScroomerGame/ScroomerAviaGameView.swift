import SwiftUI
import SpriteKit

struct ScroomerAviaGameView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userData: UserData
    
    @State var gameWin = false
    @State var gameLose = false
    
    @State var gameCreditsWin = 0
    
    private var scroomerGameScene: ScroomerGameScene {
        get {
            return ScroomerGameScene()
        }
    }
    
    var body: some View {
        VStack {
            if gameWin {
                Spacer()
                
                Image("win")
                    .resizable()
                    .frame(width: 100, height: 50)
                
                Spacer().frame(height: 30)
                
                ZStack {
                    Image("value_bg")
                        .resizable()
                        .frame(width: 140, height: 50)
                    Text("+\(gameCreditsWin)")
                        .font(.custom("Rubik-Bold", size: 24))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        gameWin = false
                        gameLose = false
                    }
                } label: {
                    Image("restart_btn")
                        .resizable()
                        .frame(width: 200, height: 50)
                }
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("go_to_home")
                        .resizable()
                        .frame(width: 200, height: 50)
                }
                
                Spacer().frame(height: 100)
            } else if gameLose {
                Spacer()
                                
                Image("loss")
                    .resizable()
                    .frame(width: 100, height: 50)
                
                Spacer().frame(height: 30)
                
                ZStack {
                    Image("value_bg")
                        .resizable()
                        .frame(width: 140, height: 50)
                    Text("\(gameCreditsWin)")
                        .font(.custom("Rubik-Bold", size: 24))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        gameWin = false
                        gameLose = false
                    }
                } label: {
                    Image("restart_btn")
                        .resizable()
                        .frame(width: 200, height: 50)
                }
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("go_to_home")
                        .resizable()
                        .frame(width: 200, height: 50)
                }
                
                Spacer().frame(height: 100)
            } else {
                SpriteView(scene: scroomerGameScene)
                    .ignoresSafeArea()
                    .onReceive(NotificationCenter.default.publisher(for: Notification.Name("LOSE_ROUND"))) { notification in
                        if let credits = notification.userInfo?["credits"] as? Int {
                            gameCreditsWin = credits
                            withAnimation {
                                gameLose = true
                            }
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: Notification.Name("WIN_ROUND"))) { notification in
                        if let credits = notification.userInfo?["credits"] as? Int {
                            gameCreditsWin = credits
                            let totalCredits = userData.credits + credits
                            userData.credits = totalCredits
                            withAnimation {
                                gameWin = true
                            }
                        }
                    }
            }
        }
        .background(
            Image("game_back")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    ScroomerAviaGameView()
        .environmentObject(UserData())
}
