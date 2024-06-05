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
    @State private var birdOffset = CGSize.zero
    @State private var birdAngle = Angle.degrees(0)
    @State private var isRotated = false

    @State var hungryTimer: Timer?
    @State var findingWormTimer: Timer?

    func goFindWorm() {
        findingWorm = true

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
                birdOffset = CGSize(width: 0, height: 0) // Move bird offscreen
            }
        })
    }

    func feedBaby() {
        smallBirdHungry = false
//
        startHungryTimer()
        withAnimation {
            isRotated = true
        } completion: {
            hasWorm = false
            isRotated = false
        }


    }

    func startHungryTimer() {
        hungryTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
            smallBirdHungry = true
            hungryTimer = nil
        })
    }

    var body: some View {
        VStack {

            HStack(alignment: .bottom) {
                if hasWorm {
                    Image("birdAndWorm")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .offset(birdOffset)
                        .rotationEffect(.degrees(isRotated ? 30 : 0))
                } else {
                    Image(systemName: "bird.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.orange)
                        .offset(birdOffset)
                        .scaleEffect(x: (findingWorm ? -1 : 1), y: 1)
                }
                VStack {

                    Text(smallBirdHungry ? "I'm\nhungry!" : "           \n        ")
                        .font(.system(size: 14))
                    Image(systemName: "bird.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.brown)
                        .scaleEffect(x: -1, y: 1)
                }
            }
            Button("Get a worm!") {
                goFindWorm()
            }
            .disabled(hasWorm)
            Button("Feed the baby bird!") {
                feedBaby()
            }
            .disabled(!hasWorm)
        }
        .onAppear {
            startHungryTimer()
        }
    }

}
#Preview {
    ContentView()
}
