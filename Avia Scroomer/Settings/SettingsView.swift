import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @EnvironmentObject var userData: UserData
    
    @State var soundEnabled = UserDefaults.standard.bool(forKey: "is_audio_enabled") {
        didSet {
            UserDefaults.standard.set(soundEnabled, forKey: "is_audio_enabled")
        }
    }
    @State var musicEnabled = UserDefaults.standard.bool(forKey: "is_music_enabled") {
        didSet {
            UserDefaults.standard.set(musicEnabled, forKey: "is_music_enabled")
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presMode.wrappedValue.dismiss()
                } label: {
                    Image("close_btn")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                
                Spacer()
                
                ZStack {
                    Image("value_bg")
                        .resizable()
                        .frame(width: 140, height: 50)
                    Text("\(userData.credits)")
                        .font(.custom("Rubik-Bold", size: 24))
                        .foregroundColor(.black)
                }
            }
            .padding()
            
            Spacer()
            
            HStack {
                Image("ic_music")
                    .resizable()
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading) {
                    Image("ic_sound_title")
                        .resizable()
                        .frame(width: 70, height: 15)
                    if soundEnabled {
                        Button {
                            withAnimation {
                                soundEnabled = false
                            }
                        } label: {
                            Image("slider_on")
                                .resizable()
                                .frame(width: 200, height: 15)
                        }
                    } else {
                        Button {
                            withAnimation {
                                soundEnabled = true
                            }
                        } label: {
                            Image("slider_off")
                                .resizable()
                                .frame(width: 200, height: 15)
                        }
                    }
                }
            }
            .background(
                Image("settings_field_bg")
                    .resizable()
                    .frame(width: 300, height: 65)
            )
            
            Spacer().frame(height: 40)
            
            HStack {
                Image("ic_sound")
                    .resizable()
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading) {
                    Image("ic_music_title")
                        .resizable()
                        .frame(width: 70, height: 15)
                    if musicEnabled {
                        Button {
                            withAnimation {
                                musicEnabled = false
                            }
                        } label: {
                            Image("slider_on")
                                .resizable()
                                .frame(width: 200, height: 15)
                        }
                    } else {
                        Button {
                            withAnimation {
                                musicEnabled = true
                            }
                        } label: {
                            Image("slider_off")
                                .resizable()
                                .frame(width: 200, height: 15)
                        }
                    }
                }
            }
            .background(
                Image("settings_field_bg")
                    .resizable()
                    .frame(width: 300, height: 65)
            )
            
            Spacer()
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
    SettingsView()
        .environmentObject(UserData())
}
