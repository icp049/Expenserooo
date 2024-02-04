import SwiftUI

struct StackedBarChartView: View {
    let data: [(category: String, value: Double)]

    var body: some View {
        VStack {
            ForEach(data, id: \.category) { barData in
                HStack {
                    // Bar for Total Expense
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: CGFloat(barData.value * 10), height: 30) // Adjust the multiplier based on your data scale

                    // Bar for Extra Money
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: CGFloat((100 - barData.value) * 10), height: 30) // Adjust the multiplier based on your data scale
                }
                .padding(.vertical, 4)
                .padding(.leading, 10)
                .background(Text(barData.category).foregroundColor(.primary))
            }
        }
        .padding()
    }
}

struct StackedBarChartView_Previews: PreviewProvider {
    static var previews: some View {
        StackedBarChartView(data: [
            ("Total Expense", 60), // Example: 60% for Total Expense
            ("Extra Money", 40)    // Example: 40% for Extra Money
        ])
    }
}

