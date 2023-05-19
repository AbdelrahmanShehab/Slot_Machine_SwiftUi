//
//  RealView.swift
//  Slot-Machine
//
//  Created by Abdelrahman Shehab on 16/04/2023.
//

import SwiftUI

struct RealView: View {
    var body: some View {
        Image("gfx-reel")
            .resizable()
            .modifier(ImageModifier())
    }
}

struct RealView_Previews: PreviewProvider {
    static var previews: some View {
        RealView()
            .previewLayout(.fixed(width: 220, height: 220))
    }
}
