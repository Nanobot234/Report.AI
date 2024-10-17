import SwiftUI


#warning("What is this for")
struct ContentView: View {
    @Binding var hasCompletedOnboarding: Bool

    var body: some View {
        if hasCompletedOnboarding {
            Text("Onboarding Completed")
                .onAppear {
                    // Notify UIKit to present InitialProblemDescriptionViewController
                    NotificationCenter.default.post(name: .onboardingCompleted, object: nil)
                }
        } else {
            OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
        }
    }
}

extension Notification.Name {
    static let onboardingCompleted = Notification.Name("onboardingCompleted")
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(hasCompletedOnboarding: .constant(false))
    }
}
