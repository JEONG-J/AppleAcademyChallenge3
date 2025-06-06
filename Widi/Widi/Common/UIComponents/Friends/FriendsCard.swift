//
//  FriendsCard.swift
//  Widi
//
//  Created by Apple Coding machine on 6/1/25.
//

import SwiftUI
import Kingfisher

struct FriendsCard: View {
    
    // MARK: - Property
    let friendsData: FriendResponse
    
    // MARK: - Init
    
    init(friendsData: FriendResponse) {
        self.friendsData = friendsData
    }
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 12, content: {
            profileImage
            
            Text(friendsData.name)
                .font(.h3)
                .foregroundStyle(Color.gray80)
                .frame(maxWidth: .infinity, alignment: .leading)
        })
        .padding(.vertical, 18)
        .padding(.horizontal, 16)
        .background {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.whiteBlack)
                .shadow1()
                .frame(maxWidth: .infinity, minHeight: 68)
        }
    }
    
    /// 프로필 이미지 캐시 처리
    @ViewBuilder
    private var profileImage: some View {
        if let urlString = friendsData.experienceDTO.characterInfo?.imageURL,
           let url = URL(string: urlString) {
            KFImage(url)
                .downsampling(size: .init(width: 400, height: 400))
                .cacheOriginalImage()
                .placeholder({
                    ProgressView()
                        .controlSize(.small)
                }).retry(maxCount: 2, interval: .seconds(2))
                .resizable()
                .clipShape(Circle())
                .frame(width: 32, height: 32)
        } else {
            Circle()
                .fill(Color.gray10)
                .frame(width: 32, height: 32)
        }
    }
}

#Preview {
    FriendsCard(friendsData: .init(name: "지나", birthDay: "222-22-222", experienceDTO: .init(experiencePoint: 1, characterInfo: .init(imageURL: "https://i.namu.wiki/i/iCHC076zQo7GAZ2-mVkE8pieXrNb3of2rE-0Xq05ZE5kuvyynrU7dq9DIodkrOaoyDRMTRDBty6skiZByeF_pSg-ZykIcgIXnQ5MAr6lzhztv0Wz8nQILcQ8kZMus9XrP_Cist1bxrTgq8Z8EjR3sA.webp"))))
}
