//
//  WorkHeader.swift
//  Concertmaster
//
//  Created by Adriano Brandao on 14/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct WorkHeader: View {
    var work: Work
    var composer: Composer
    @State private var showSheet = false
    @EnvironmentObject var settingStore: SettingStore
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Select an action"), message: nil, buttons: [
            .default(Text(self.settingStore.favoriteWorks.contains(work.id) ? "Remove work from favorites" : "Add work to favorites"), action: {
                
                APIpost("\(AppConstants.concBackend)/dyn/user/work/\(self.settingStore.favoriteWorks.contains(self.work.id) ? "unfavorite" : "favorite")/", parameters: ["id": self.settingStore.userId, "auth": authGen(userId: self.settingStore.userId, userAuth: self.settingStore.userAuth) ?? "", "wid": self.work.id, "cid": self.composer.id]) { results in
                    
                    print(String(decoding: results, as: UTF8.self))
                    
                    DispatchQueue.main.async {
                        if let addWork: AddWork = safeJSON(results) {
                            self.settingStore.favoriteWorks = addWork.list
                            self.settingStore.composersFavoriteWorks = addWork.composerworks
                            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.showToast(message: "\(self.settingStore.favoriteWorks.contains(self.work.id) ? "Added!" : "Removed!")", image: "checked", text: nil)
                        }
                    }
                }
            }),
            .cancel()
        ])
    }
    
    var body: some View {
        HStack {
            BackButton()
            VStack {
                VStack(alignment: .leading) {
                    
                    Text(composer.name.uppercased())
                        .foregroundColor(Color(hex: 0xfce546))
                        .font(.custom("ZillaSlab-SemiBold", size: 18))
                    
                    Group{
                        Text(work.title)
                        .font(.custom("PetitaBold", size: 17))
                        if work.subtitle != "" {
                            Text(work.subtitle!)
                            .font(.custom("PetitaMedium", size: 15))
                        }
                    }
                    .foregroundColor(.white)
                    .lineLimit(20)
                    
                }
                .padding(8)
            }
            
            Spacer()
            
            if self.settingStore.userId != "" {
                Button(action: {
                    self.showSheet = true
                })
                {
                    EllipsisButton()
                        .actionSheet(isPresented: $showSheet, content: { self.actionSheet })
                }
            }
        }
        .onAppear(perform: { self.endEditing(true) })
    }
}

struct WorkHeader_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
