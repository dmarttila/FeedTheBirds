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
    @State private var birdOffset = CGSize.zero // Track bird's offset

    @State var hungryTimer: Timer?
    @State var findingWormTimer: Timer?

    func goFindWorm() {
        findingWorm = true
        
        withAnimation(.linear(duration: 0.5)) { // Animate offset change
            birdOffset = CGSize(width: -400, height: 0) // Move bird offscreen
        }
        if let existingTimer = findingWormTimer {
            existingTimer.invalidate() // Invalidate existing timer
        }

        findingWormTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            findingWorm = false
            hasWorm = true
            withAnimation(.linear(duration: 0.5)) { // Animate offset change
                birdOffset = CGSize(width: 0, height: 0) // Move bird offscreen
            }
        })
    }

    func feedBaby() {
        smallBirdHungry = false
        hasWorm = false
        startHungryTimer()
    }

    func startHungryTimer() {
        hungryTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
            smallBirdHungry = true
            hungryTimer = nil // Release timer reference after firing
        })
    }

    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                if hasWorm {
                    Text("I have a worm!")
                }
                Image(systemName: "bird.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(hasWorm ? .green : .orange)
                    .offset(birdOffset) // Apply offset for animation
                Image(systemName: smallBirdHungry ? "bird" : "bird.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.green)
                    .scaleEffect(x: -1, y: 1)
                if smallBirdHungry {
                    Text("I'm hungry!")
                        .font(.system(size: 16)) // Adjust font size as needed
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
