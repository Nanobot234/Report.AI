import SwiftUI


struct OnboardingFlow: View {
    
    @StateObject var reportList = Reports()
    @StateObject var navRouter = Router() //the router
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @AppStorage("hasCompletedWelcome") private var hasCompletedWelcome: Bool = false
    @State  var fullyCompleted: Bool = false
    
    var body: some View {
        
        NavigationStack(path: $navRouter.loginNavPath) {
            VStack {
                if !hasCompletedOnboarding {
                    OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                } else if hasCompletedOnboarding && !hasCompletedWelcome {
                    //show the view controller here, will need to make it conform to the swiftUiProtocol, i belive, etcc!
                    WelcomeViewAddDetails(hasCompletedWelcome: $hasCompletedWelcome)
                        .environmentObject(reportList)
                    
                }
            }
            .navigationDestination(isPresented: $fullyCompleted) {
                InitialProblemDescriptionViewControllerRepresentable()
                    .navigationBarBackButtonHidden()
            }
            
            
            //else if hasCompletedWelcome && hasCompletedOnboarding {
               //something else here future!
           // }
                
        }
        
        .onAppear {
            if hasCompletedWelcome && hasCompletedOnboarding {
                fullyCompleted = true
            }
        }
    }
}

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    
    let onboardingData: [OnboardingPage] = [
        OnboardingPage(title: "Welcome to Report.AI", description: "Easily report and track community issues.", imageName: "onboarding1"),
        OnboardingPage(title: "Capture the Problem", description: "Take photos or choose from your gallery to document issues.", imageName: "onboarding2"),
        OnboardingPage(title: "Report, Track and Submit", description: "Locate, describe, submit your report, and track its progress.", imageName: "onboarding3")
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<onboardingData.count, id: \.self) { index in
                    OnboardingPageView(page: onboardingData[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            
            Button(action: {
                if currentPage < onboardingData.count - 1 {
                    currentPage += 1
                } else {
                    hasCompletedOnboarding = true //finished onboarding
                    
                }
            }) {
                Text(currentPage < onboardingData.count - 1 ? "Next" : "Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.teal)
                    .cornerRadius(15)
            }
            .padding()
        }
    }
}

struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 20) {
            Image(page.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
            
            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(hasCompletedOnboarding: .constant(false))
    }
}

    
