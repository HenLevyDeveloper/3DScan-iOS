//
//  AppTitleIcon.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 07/02/2025.
//

import SwiftUI

struct AppTitleIcon: View {
    let iconSystemName: String
    let title: String
    
    var body: some View {
        VStack {
            Image(systemName: iconSystemName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.white)
            
            Text(title)
                .font(.largeTitle.bold())
                .foregroundColor(.white)
        }
    }
}
