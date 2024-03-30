import SwiftUI

struct MainAddButton: View {
    
    let title: String
    let background: Color
    let action: () -> Void
    
    
    
    var body: some View {
        
        
        
        
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.system(.largeTitle))
                .frame(width: 77, height: 70)
                .foregroundColor(Color.white)
                .padding(.bottom, 7)
        }
        .background(background)
        .cornerRadius(38.5)
        .padding()
        .shadow(color: Color.black.opacity(0.3),
                radius: 3,
                x: 3,
                y: 3)
        
    }
    
}


struct MainAddButton_Previews: PreviewProvider {
    static var previews: some View {
        MainAddButton(title: "+", background: .blue){
        }
    }
}

