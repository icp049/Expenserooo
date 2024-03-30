import SwiftUI

struct SmallAddButton: View {
    
    let title: String
    let background: Color
    let action: () -> Void
    
    
    
    var body: some View {
        
        
        Button{
            action()
            
        } label: {
            Text(title)
                .foregroundColor(.white)
                .bold()
                .frame(width: 80, height: 40) // Adjust the width and height as needed
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(background))        }
    }
    
}


struct SmallAddButton_Previews: PreviewProvider {
    static var previews: some View {
        SmallAddButton(title: "Login", background:.black){
        }
    }
}

