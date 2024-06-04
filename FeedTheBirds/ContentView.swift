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

    @State var hungryTimer: Timer?
    @State  var findingWormTimer: Timer?

    func goFindWorm () {
        findingWorm = true
        if let existingTimer = findingWormTimer {
            existingTimer.invalidate() // Invalidate existing timer
        }
        findingWormTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            findingWorm = false
            hasWorm = true
            findingWormTimer = nil // Release timer reference after firing
        })
    }

    func feedBaby () {
        smallBirdHungry = false
        hasWorm = false
    }

    func startHungryTimer () {
        hungryTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
            smallBirdHungry = true
            hungryTimer = nil // Release timer reference after firing
        })
    }


    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                if (hasWorm) {
                    Text("I have a worm!")
                }
                if !findingWorm {
                    Image(systemName: "bird.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(hasWorm ? .green : .orange)
                }
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
            Button("Feed the baby bird!") {
                feedBaby()
                startHungryTimer()
            }
            .disabled(!hasWorm)
            .onAppear { // Call startHungryTimer on view appearance
                  startHungryTimer()
                }
        }
    }
}
#Preview {
    ContentView()
}
