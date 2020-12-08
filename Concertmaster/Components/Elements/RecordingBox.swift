//
//  RecordingBox.swift
//  Concertmaster
//
//  Created by Adriano Brandao on 29/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import URLImage

struct RecordingBox: View {
    var recording: Recording
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                URLImage(recording.cover ?? URL(fileURLWithPath: AppConstants.concNoCoverImg), placeholder: { _ in
                    Rectangle()
                        .fill(Color(hex: 0x2B2B2F))
                        .frame(width: 125, height: 125)
                        //.cornerRadius(20)
                }) { img in
                    img.image
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        //.cornerRadius(20)
                }
                .frame(width: 125, height: 125)
                .padding(.bottom, 10)
                 
                if recording.work != nil {
                    if recording.work!.composer!.id != "0" {
                        Text(recording.work!.composer!.name.uppercased().trimmingCharacters(in: .whitespacesAndNewlines))
                            .font(.custom("ZillaSlab-SemiBold", size: 12))
                            .foregroundColor(Color(hex: 0xfce546))
                            .lineLimit(20)
                    } else if recording.work!.composer!.name != "None" {
                        ForEach(recording.work!.composer!.name.components(separatedBy: CharacterSet(charactersIn: "&,")), id: \.self) { composer in
                            Text(composer.uppercased().trimmingCharacters(in: .whitespacesAndNewlines))
                            .font(.custom("ZillaSlab-SemiBold", size: 12))
                            .foregroundColor(Color(hex: 0xfce546))
                            .lineLimit(20)
                        }
                    }
                    
                    Text(recording.work!.title)
                        .font(.custom("PetitaMedium", size: 11))
                        .foregroundColor(.white)
                        .padding(.bottom, 6)
                        .lineLimit(20)
                        //.fixedSize(horizontal: false, vertical: true)
                }
                
                if recording.observation != "" && recording.observation != nil {
                    Text(recording.observation ?? "")
                    .font(.custom("PetitaMedium", size: 8))
                    .padding(.bottom, 6)
                }
                
                ForEach(recording.performers, id: \.name) { performer in
                    Group {
                        if (self.recording.performers.count <= AppConstants.maxPerformers || AppConstants.mainPerformersList.contains(performer.role ?? "")) {
                                Text(performer.name)
                                    .font(.custom("PetitaBold", size: (self.recording.work != nil ? 9 : 9)))
                                +
                                Text(performer.readableRole)
                                    .font(.custom("PetitaMedium", size: (self.recording.work != nil ? 9 : 9)))
                        }
                    }
                }
                .foregroundColor(.white)
                .lineLimit(20)
            }
            .frame(maxWidth: 125)
            
            //Spacer()
        }
        .padding(20)
        .frame(minWidth: 165, maxWidth: 165, minHeight: 300,  maxHeight: 300, alignment: .top)
        .background(Color(hex: 0x202023))
        //.cornerRadius(20)
    }
}

struct RecordingBox_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
