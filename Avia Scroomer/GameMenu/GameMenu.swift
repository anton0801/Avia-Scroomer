import SwiftUI

struct GameMenu: View {
    
    @StateObject var userData: UserData = UserData()
    
    var body: some View {
        NavigationView {
            VStack {
                Image("menu_plane")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: 500)
                
                ZStack {
                    Image("value_bg")
                        .resizable()
                        .frame(width: 140, height: 50)
                    Text("\(userData.credits)")
                        .font(.custom("Rubik-Bold", size: 24))
                        .foregroundColor(.black)
                }
                
                NavigationLink(destination: ScroomerAviaGameView()
                    .environmentObject(userData)
                    .navigationBarBackButtonHidden(true)) {
                        Image("play_btn")
                            .resizable()
                            .frame(width: 300, height: 60)
                    }
                
                Spacer()
                
                HStack {
                    
                    Spacer()
                    
                    NavigationLink(destination: DailyRewardsView()
                        .environmentObject(userData)
                        .navigationBarBackButtonHidden(true)) {
                        Image("ic_daily")
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                    Spacer()
                    
                    NavigationLink(destination: ScroomerStoreView()
                        .environmentObject(userData)
                        .navigationBarBackButtonHidden(true)) {
                        Image("ic_store")
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: SettingsView()
                        .environmentObject(userData)
                        .navigationBarBackButtonHidden(true)) {
                        Image("ic_settings")
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: GameRulesView()
                        .environmentObject(userData)
                        .navigationBarBackButtonHidden(true)) {
                        Image("ic_rules")
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            .background(
                Image("game_back")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
            .onAppear {
                if !UserDefaults.standard.bool(forKey: "set_data_first") {
                    userData.currentPlane = "plane"
                    UserDefaults.standard.set(true, forKey: "is_music_enabled")
                    UserDefaults.standard.set(true, forKey: "is_audio_enabled")
                    UserDefaults.standard.set(true, forKey: "set_data_first")
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    GameMenu()
}
