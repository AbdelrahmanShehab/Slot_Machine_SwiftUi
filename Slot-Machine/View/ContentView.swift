//
//  ContentView.swift
//  Slot-Machine
//
//  Created by Abdelrahman Shehab on 16/04/2023.
//

import SwiftUI

struct ContentView: View {
    // MARK: -  PROPERTIES
    let symbols: [String] = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
    let feedback = UINotificationFeedbackGenerator()
    
    @State private var hightScore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10
    @State private var reels: [Int] = [0, 1, 2]
    @State private var showingInfoView: Bool = false
    @State private var isActivateBet10: Bool = false
    @State private var isActivateBet20: Bool = false
    @State private var showingModel: Bool = false
    @State private var animatingModel: Bool = false
    @State private var isAnimatingSymbol: Bool = false
    
    // MARK: -  FUNCTIONS
    
    func spinReels() {
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
        
        playSound(sound: "spin", type: "mp3")
        feedback.notificationOccurred(.success)
    }
    
    func checkWinning() {
        if reels[0] == reels[1] && reels[1] == reels[2] && reels[0] == reels[2] {
            
            playerWins()
            if coins > hightScore {
                newHighScore()
            } else {
                playSound(sound: "win", type: "mp3")
            }
        
        } else {
            playerLoses()
        }
    }
    
    func playerWins() {
        coins += betAmount * 10
    }
    func newHighScore() {
        hightScore = coins
        UserDefaults.standard.set(hightScore, forKey: "HighScore")
        playSound(sound: "high-score", type: "mp3")
    }
    
    func playerLoses() {
        coins -= betAmount
    }
    
    func activateBet10() {
        betAmount = 10
        isActivateBet10 = true
        isActivateBet20 = false
        playSound(sound: "casino-chips", type: "mp3")
        feedback.notificationOccurred(.success)

    }
    
    func activateBet20() {
        betAmount = 20
        isActivateBet20 = true
        isActivateBet10 = false
        playSound(sound: "casino-chips", type: "mp3")
        feedback.notificationOccurred(.success)

    }
    
    func isGameOver() {
        if coins <= 0 {
            showingModel = true
            playSound(sound: "game-over", type: "mp3")

        }
    }
    
    func resetGame() {
        UserDefaults.standard.set(0, forKey: "HighScore")
        hightScore = 0
        coins = 100
        activateBet10()
        playSound(sound: "chimeup", type: "mp3")
    }
    
    
    // MARK: -  BODY
    var body: some View {
        
        ZStack {
            
            // MARK: -  BACKGROUND
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            // MARK: -  INTERFACE
            VStack(alignment: .center, spacing: 5) {
                
                // MARK: -  HEADER
                
                LogoView()
                
                Spacer()
                
                // SCORE
                HStack {
                    HStack {
                        Text("Your\nCoin".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }//: HSTACK
                    .modifier(ScoreContainerModifier())
                
                    Spacer()
                    
                    HStack {
                        
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                        Text("\(hightScore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }//: HSTACK
                    .modifier(ScoreContainerModifier())
                }
                .padding()
                
                Spacer()
                    // MARK: -  SLOT MACHINE
                    
                VStack(alignment: .center, spacing: 0) {
                     // MARK: -  REEL #1
                    ZStack {
                        RealView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(isAnimatingSymbol ? 1 : 0)
                            .offset(y: isAnimatingSymbol ? 0 : 50)
                            .animation(.easeIn(duration: Double.random(in: 0.5...0.7)))
                            .onAppear {
                                self.isAnimatingSymbol.toggle()
                                // SOUND CODE
                            }
                    }//: ZSTACk
                    
                    HStack(alignment: .center, spacing: 0) {
                        // MARK: -  REEL  #2
                        ZStack {
                            RealView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(isAnimatingSymbol ? 1 : 0)
                                .offset(y: isAnimatingSymbol ? 0 : 50)
                                .animation(.easeIn(duration: Double.random(in: 0.7...0.9)))
                                .onAppear {
                                    self.isAnimatingSymbol.toggle()
 
                                }
                        }//: ZSTACK
                        Spacer()
                        // MARK: -  REEL  #3
                        ZStack {
                            RealView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(isAnimatingSymbol ? 1 : 0)
                                .offset(y: isAnimatingSymbol ? 0 : 50)
                                .animation(.easeIn(duration: Double.random(in: 0.9...1.1)))
                                .onAppear {
                                    self.isAnimatingSymbol.toggle()
                                }
                        }//: ZSTACK
                    }//: HSTACK
                    .frame(maxWidth: 500)
                    
                    // MARK: -  SPIN BUTTON
                    Button {
                        
                        withAnimation {
                            self.isAnimatingSymbol = false
                        }
                        self.spinReels()
                        withAnimation {
                            self.isAnimatingSymbol = true
                        }
                        self.checkWinning()
                        self.isGameOver()
                        
                    } label: {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    }

                }//: VSTACK (SLOT MACHINE)
                .layoutPriority(2)

                
                // MARK: -  FOOTER
                Spacer()
                HStack {
                    // MARK: -  BET 20
                    HStack(alignment: .center, spacing: 10) {
                        Button {
                            self.activateBet20()
                        } label: {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(isActivateBet20 ? Color("ColorYellow") : .white)
                                .modifier(BetNumberModifier())
                                
                        }
                        .modifier(BetCapsuleModifier())
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: isActivateBet20 ? 0 : 20)
                            .opacity(isActivateBet20 ? 1 : 0)
                            .modifier(CAsinoChipsModifier())
                    }//: HSTACK
                    Spacer()
                    
                    // MARK: -  BET 10
                    HStack(alignment: .center, spacing: 10) {
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: isActivateBet10 ? 0 : -20)
                            .opacity(isActivateBet10 ? 1 : 0)
                            .modifier(CAsinoChipsModifier())
                        
                        Button {
                            self.activateBet10()
                        } label: {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(isActivateBet10 ? Color("ColorYellow") : .white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())

                    }//: HSTACK
                }
            }// VSTACK
            
                // MARK: -  BUTTONS
            .overlay(
                // RESET
                Button(action: {
                    self.resetGame()
                }, label: {
                    Image(systemName: "arrow.2.circlepath.circle")
                        .modifier(ButtonModifier())
                })
                ,alignment: .topLeading
            )
            
            .overlay(
                //INFO
                Button(action: {
                    self.showingInfoView = true
                }, label: {
                    Image(systemName: "info.circle")
                        .modifier(ButtonModifier())
                })
                ,alignment: .topTrailing
            )
            .padding()
            .frame(maxWidth: 720)
            .blur(radius: $showingModel.wrappedValue ? 5 : 0, opaque: false)
            
            // MARK: -  POPUP
            if $showingModel.wrappedValue {
                ZStack {
                    Color("ColorTransparentBlack")
                        .edgesIgnoringSafeArea(.all)
                    
                    // MODEL
                    VStack {
                        Text("Game OVER")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("ColorPink"))
                            .foregroundColor(.white)
                        
                            Spacer()
                        
                        // MESSAGE
                        VStack(alignment: .center, spacing: 15) {
                            Image("gfx-seven-reel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
                                .padding(.top, 8)
                            
                            Text("Bad luck! You lost all of the coins. \nLet's play again!")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .layoutPriority(1)
                                .padding(.vertical, 4)
                            
                            Button {
                                self.showingModel = false
                                self.animatingModel = false
                                self.activateBet10()
                                self.coins = 100
                            } label: {
                                Text("New GAME".uppercased())
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .accentColor(Color("ColorPink"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 128)
                                    .background(
                                        Capsule()
                                            .strokeBorder(lineWidth: 1.75)
                                            .foregroundColor(Color("ColorPink"))
                                            .shadow(radius: 2, x: 2, y: 3)
                                    )
                                    
                            }//: BUTTON
                            Spacer()
                        }//: VSTACK
                    }//: VSTACK
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 0)
                    .opacity($animatingModel.wrappedValue ? 1 : 0)
                    .offset(y: $animatingModel.wrappedValue ? 0 : -100)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))
                    .onAppear(perform: {
                        self.animatingModel = true
                    })
                    
                }//: ZSTACK
            }
            
        }//: ZSTACK
        .sheet(isPresented: $showingInfoView) {
            InfoView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
