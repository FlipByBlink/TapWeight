
import SwiftUI


struct HeightMenu: View {
    @EnvironmentObject var 📱:📱Model
    
    @State private var 📝Height: Int = 170
    
    var body: some View {
        NavigationLink {
            HeightEditView()
        } label: {
            HStack {
                Label("🌏Height", systemImage: "ruler")
                
                Spacer()
                
                Text(📱.💾Height.description + " cm")
            }
            .padding(.leading)
            .foregroundColor(.primary)
        }
        .listRowSeparator(.hidden)
    }
}


struct HeightEditView: View {
    @EnvironmentObject var 📱:📱Model
    
    @State private var 📝Height: Int = 170
    
    var body: some View {
        VStack {
            Stepper {
                Text(📝Height.description + " cm")
                    .font(.system(size: 54).monospacedDigit())
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
            } onIncrement: {
                📝Height += 1
            } onDecrement: {
                📝Height -= 1
            }
            .padding()
            .padding(.vertical, 32)
            
            HStack {
                Text("BMI = ")
                    .font(.title2)
                
                VStack(spacing: 16) {
                    Text("Weight(kg)")
                    
                    Text("Height(m) × Height(m)")
                }
                .padding()
                .overlay {
                    Rectangle()
                        .frame(height: 2)
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("🌏Height")
        .onAppear {
            📝Height = 📱.💾Height
        }
        .onDisappear {
            📱.💾Height = 📝Height
        }
    }
}




struct HeightMenu_Previews: PreviewProvider {
    static let 📱 = 📱Model()
    
    static var previews: some View {
        HeightEditView()
            .environmentObject(📱)
    }
}
