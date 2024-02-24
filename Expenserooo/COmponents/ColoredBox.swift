import SwiftUI

struct ColoredBox: View {
    var color: Color
    var size: CGSize
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: size.width, height: size.height)
    }
}

