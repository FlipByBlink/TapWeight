
import SwiftUI

struct 🧍HeightMenuLink: View {
    @EnvironmentObject var 📱: 📱AppModel
    
    var body: some View {
        NavigationLink {
            🧍HeightEditView()
        } label: {
            Label("Height", systemImage: "figure.stand")
                .padding(.leading)
                .badge(Text(📱.🧍HeightValue.description + " cm"))
        }
        .disabled(📱.🚩AbleBMI == false)
        .font(.subheadline)
    }
}


struct 🧍HeightEditView: View {
    @EnvironmentObject var 📱: 📱AppModel
    @State private var 📝Height: Int = 170
    
    var body: some View {
        VStack {
            Stepper {
                Text(📝Height.description + " cm")
                    .font(.system(size: 54).monospacedDigit())
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
            } onIncrement: {
                UISelectionFeedbackGenerator().selectionChanged()
                📝Height += 1
            } onDecrement: {
                UISelectionFeedbackGenerator().selectionChanged()
                📝Height -= 1
            }
            .padding()
            .padding(.vertical, 48)
            
            
            Group {
                HStack {
                    Text("BMI = ")
                        .font(.title3)
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 2) {
                            Text("Weight")
                            
                            Text("(kg)")
                                .font(.subheadline)
                        }
                        
                        HStack(spacing: 2) {
                            Text("Height")
                                .layoutPriority(1)
                            
                            Text("(m)")
                                .font(.subheadline)
                                .layoutPriority(1)
                            
                            Text(" × ")
                                .layoutPriority(1)
                            
                            Text("Height")
                                .layoutPriority(1)
                            
                            Text("(m)")
                                .font(.subheadline)
                                .layoutPriority(1)
                        }
                    }
                    .padding()
                    .overlay {
                        Rectangle()
                            .frame(height: 2)
                    }
                }
            }
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Height")
        .onAppear { 📝Height = 📱.🧍HeightValue }
        .onDisappear { 📱.🧍HeightValue = 📝Height }
    }
}
