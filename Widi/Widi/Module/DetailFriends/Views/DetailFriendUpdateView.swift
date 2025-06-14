//
//  DetailFriendUpdatedView.swift
//  Widi
//
//  Created by Miru on 2025/6/5.
//

import SwiftUI

/// 친구 수정 뷰
struct DetailFriendUpdateView: View {

    @Binding var showFriendEdit: Bool
    @Bindable var viewModel: DetailFriendUpdateViewModel
    
    init(
        container: DIContainer,
        showFriendEdit: Binding<Bool>,
        friendResponse: FriendResponse
    ) {
        self._viewModel = Bindable(wrappedValue: DetailFriendUpdateViewModel(container: container, friendResponse: friendResponse))
        self._showFriendEdit = showFriendEdit
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            modalBar
            
            friendDetailArea
            
            Spacer()
        }
        .safeAreaPadding(.horizontal, 16)
        .safeAreaPadding(.top, 16)
        .task {
            UIApplication.shared.hideKeyboard()
        }
        .background(Color.whiteBlack)
    }
    
    /// 상단 옵션 컨트롤러
    private var modalBar: some View {
        HStack {
            Button {
                showFriendEdit = false
            } label: {
                NavigationIcon.closeX.image
                    .padding(8)
            }
            
            Spacer()
            
            Button {
                Task {
                    await viewModel.updateFriend()
                    showFriendEdit = false
                }
            } label: {
                let icon = NavigationIcon.complete(type: .complete, isEmphasized: !viewModel.nameText.isEmpty)
                
                if let title = icon.title {
                    Text(title)
                        .foregroundStyle(icon.foregroundColor)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .disabled(!viewModel.nameText.isEmpty)
                }
            }
        }
    }
    
    private var friendDetailArea: some View {
        VStack(alignment: .leading, spacing: 40) {
            Text(friendDetailDescription)
                .font(.h2)
                .foregroundStyle(.gray80)
            
            textFieldGroup
            }
        }
    
    private var textFieldGroup: some View {
        VStack(spacing: 20, content: {
            
            makeInfoArea(infoAreaType: .name, text: $viewModel.nameText)
            makeInfoArea(infoAreaType: .birthday, text: $viewModel.birthdayText)
        })
    }
    
    
    @ViewBuilder
    private func makeInfoArea(infoAreaType: InfoAreaType, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 10, content: {
            
            HStack(content: {
                Text(infoAreaType.title)
                    .foregroundStyle(.gray60)
                
                Spacer()
                
                Text(infoAreaType.guideText(text: text.wrappedValue))
                    .foregroundStyle(.gray40)
                
            })
                .font(.cap2)
            
            
            TextField(infoAreaType.title, text: text, prompt: makePrompt(text: infoAreaType.placeholder))
                .padding(16)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.5)
                        .fill(Color.background)
                        .stroke(.gray10, style: .init(lineWidth: 1))
                }
                .keyboardType(infoAreaType.keyboardType)
                .onChange(of: viewModel.nameText) { oldValue, newValue in
                
                    if viewModel.nameText.count > 10 {
                        viewModel.nameText = oldValue
                    }
                }
                .onChange(of: viewModel.birthdayText, { oldValue, newValue in
                    viewModel.birthdayText = ConvertDataFormat.shared.formatBirthdayInput(newValue)
                })
                   
        })
    }
    
    @ViewBuilder
    private func makePrompt(text: String) -> Text {
        Text(text)
            .font(.etc)
            .foregroundStyle(Color.gray40)
    }
}

extension DetailFriendUpdateView {
    private var friendDetailDescription: String { "위디 속 친구 정보를 다듬어보세요" }
    private var nameTitleText: String { "이름" }
    private var namePlaceHolderText: String { "이름" }
    private var birthdayTitleText: String { "생일" }
    private var birthdayPlaceHolderText: String { "mm / dd" }
}
