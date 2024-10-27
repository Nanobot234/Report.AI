//
//  MainTabView.swift
//  Report.AI
//
//  Created by Yashraj Jadhav on 16/10/24.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = WelcomeViewModel()
    @State private var selectedTab = 0
    @StateObject private var reports = Reports()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                NavigationView {
                    InitialProblemDescriptionViewControllerRepresentable()
                        .navigationBarTitle("Report a Problem", displayMode: .inline)
                }
                .environmentObject(reports)
                .tag(0)
                NavigationView {
                    ProfileView()
                }
                .environmentObject(reports)
                .tag(1)
                
                NavigationView {
                    ReportListView()
                }
                .environmentObject(reports)
               
                .tag(2)
            }
            .accentColor(.teal)
            
            CustomTabBar(selectedTab: $selectedTab)
                .frame(height: 25)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct HomeView: View {
    var body: some View {
        Text("Home View")
            .font(.largeTitle)
            .fontWeight(.bold)
            .navigationTitle("Home")
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Namespace private var namespace
    
    var body: some View {
        HStack {
            tabBarItem(imageName: "exclamationmark.bubble", title: "Report", tag: 0)
            tabBarItem(imageName: "person.fill", title: "Profile", tag: 1)
            tabBarItem(imageName: "clock.arrow.circlepath", title: "Reports", tag: 2)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.07), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
    
    private func tabBarItem(imageName: String, title: String, tag: Int) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                selectedTab = tag
            }
        }) {
            VStack(spacing: 6) {
                Image(systemName: imageName)
                    .font(.system(size: 20))
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(selectedTab == tag ? .teal : .gray)
            .padding(.vertical, 2)
            .padding(.horizontal, 20)
            .background(
                ZStack {
                    if selectedTab == tag {
                        Capsule()
                            .fill(Color.teal.opacity(0.1))
                            .matchedGeometryEffect(id: "tab_background", in: namespace)
                    }
                }
            )
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
