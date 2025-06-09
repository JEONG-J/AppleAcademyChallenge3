//
//  HomeDragView.swift
//  Widi
//
//  Created by Apple Coding machine on 6/3/25.
//

import SwiftUI

struct HomeDragView: View {
    
    @Bindable var viewModel: HomeViewModel
    @EnvironmentObject var container: DIContainer
    
    init() {
        self.viewModel = .init()
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: 20, content: {
            dragIndicator
            
            VStack(alignment: .center, spacing: 16, content: {
                topController
                
                ScrollView(.vertical, content: {
                    bottomContents
                })
                .padding(.bottom, 48)
            })
            
            Spacer()
        })
        .safeAreaPadding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
        .background {
            UnevenRoundedRectangle(topLeadingRadius: 24, topTrailingRadius: 24)
                .fill(Color.white.opacity(0.7))
                .shadow(color: Color(red: 0.56, green: 0.56, blue: 0.58).opacity(0.05), radius: 4, x: 0, y: -14)
        }
        .ignoresSafeArea()
        .navigationDestination(for: NavigationDestination.self) { destination in
            NavigationRoutingView(destination: destination)
                .environmentObject(container)
        }
    }
    
    /// 드래그 인디케이터
    private var dragIndicator: some View {
        Capsule()
            .fill(Color.gray30)
            .frame(width: 40, height: 4)
    }
    
    /// 드래그뷰 상단 컨트롤러
    private var topController: some View {
        HStack {
            Text(topTitle)
                .font(.h2)
                .foregroundStyle(Color.gray80)
            
            Spacer()
            
            FriendsAddButton(action: {
                container.navigationRouter.push(to: .addFriendView)
            })
        }
        .padding(.bottom, 20)
    }
    
    /// 하단 친구리스트 영역
    @ViewBuilder
    private var bottomContents: some View {
        if let data = viewModel.friendsData {
            LazyVStack(alignment: .center, spacing: 8, content: {
                ForEach(data, id: \.id) { data in
                    FriendsCard(friendsData: data)
                }
            })
        } else {
            notContents
        }
    }
    
    /// 친구 없을 경우 등장
    @ViewBuilder
    private var notContents: some View {
        Spacer().frame(height: 160)
        
        ZStack(alignment: .center, content: {
            Text(notContentsText)
                .font(.b1)
                .foregroundStyle(Color.gray50)
                .lineLimit(2)
                .lineSpacing(1.6)
                .multilineTextAlignment(.center)
        })
        .frame(width: 240, height: 231)
        .background {
            Circle()
                .fill(Color.white.opacity(0.7))
                .blur(radius: 35)
        }
        
        Spacer()
    }
}

extension HomeDragView {
    private var topTitle: String { "나의 친구들" }
    private var notContentsText: String { "기억하고 싶은 사람이 있나요? \n친구와의 추억을 위디로 남겨봐요 💌" }
}


#Preview {
    HomeDragView()
        .environmentObject(DIContainer())
}
