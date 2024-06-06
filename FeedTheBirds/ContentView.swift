//
//  ContentView.swift
//  FeedTheBirds
//
//  Created by Doug Marttila on 6/3/24.
//

import SwiftUI

struct ContentView: View {
    @State private var hasWorm = false
    @State private var findingWorm = false
    @State private var smallBirdHungry = false
    @State private var birdOffset = CGSize(width: -50, height: 0)
    @State private var birdAngle = Angle.degrees(0)
    @State private var isRotated = false
    @State private var isDancing = false
    @State private var fedCount = 0

    @State var hungryTimer: Timer?
    @State var findingWormTimer: Timer?

    let birdRestOffset = CGSize(width: -50, height: 0)

    func goFindWorm() {
        findingWorm = true
        birdOffset = CGSize(width: 50, height: 0)

        withAnimation(.linear(duration: 1)) { // Animate offset change
            birdOffset = CGSize(width: 400, height: -400) // Move bird offscreen
        }
        if let existingTimer = findingWormTimer {
            existingTimer.invalidate() // Invalidate existing timer
        }

        findingWormTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            findingWorm = false
            hasWorm = true
            birdOffset = CGSize(width: -400, height: -400)
            withAnimation(.linear(duration: 0.5)) { // Animate offset change
                birdOffset = birdRestOffset // Move bird offscreen
            }
        })
    }

    func feedBaby() {
        startHungryTimer()
        withAnimation {
            isRotated = true
        } completion: {
            hasWorm = false
            isRotated = false
            smallBirdHungry = false
            isDancing = false
        }
        fedCount += 1
    }

    func startHungryTimer() {
        hungryTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
            smallBirdHungry = true
            hungryTimer = nil
        })
    }
    func getButtonText () -> String {
        var str = "Make the bird dance "
        if (fedCount < 5) {
            str += "\((5 - fedCount))"
        }
        return str
    }
    let smallBirdXOffset: CGFloat = 55
    let babyBirdSize: CGFloat = 100
    let mamaBirdSize: CGFloat = 200
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                if hasWorm {
                    Image("birdAndWorm")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: mamaBirdSize, height: mamaBirdSize)
                        .offset(birdOffset)
                        .rotationEffect(.degrees(isRotated ? 30 : 0))
                } else {
                    Image(systemName: "bird.fill")
                        .resizable()
                        .frame(width: mamaBirdSize, height: mamaBirdSize)
                        .foregroundColor(.orange)
                        .offset(birdOffset)
                        .scaleEffect(x: (findingWorm ? -1 : 1), y: 1)
                        .rotationEffect(.degrees(isDancing ? 35 : 0))
                        .animation(
                            isDancing ?
                                .easeInOut(duration: 1).repeatForever(autoreverses: true) :
                                    .default,
                            value: isDancing
                        )
                }
                VStack {
                    Text(smallBirdHungry ? "I'm\nhungry!" : "           \n        ")
                        .font(.system(size: 14))
                        .foregroundColor(.brown)
                        .multilineTextAlignment(.center)
                        .offset(x: smallBirdXOffset + 20)
                    if (smallBirdHungry) {
                        Image("hungryBird")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: babyBirdSize, height: babyBirdSize)
                            .rotationEffect(.degrees(30))
                            .offset(x: smallBirdXOffset)
                    } else {
                        Image(systemName: "bird.fill")
                            .resizable()
                            .frame(width: babyBirdSize, height: babyBirdSize)
                            .foregroundColor(.brown)
                            .scaleEffect(x: -1, y: 1)
                            .offset(x: smallBirdXOffset)

                    }
                }
            }
            Rectangle()
                  .frame(width: 50, height: 50) // Set width, height can be 0
                  .foregroundColor(.clear)
            Button("Get a worm!") {
                goFindWorm()
            }
            .disabled(hasWorm)
            Button("Feed the baby bird!") {
                feedBaby()
            }
            .disabled(!hasWorm)
            Button(getButtonText()) { // Button text
                isDancing.toggle()
            }
            .disabled(hasWorm || fedCount < 5)
        }
        .onAppear {
            startHungryTimer()
        }
    }
}
#Preview {
    ContentView()
}


