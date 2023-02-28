import SwiftUI

struct 🧍HeightMenuLink: View {
    @EnvironmentObject var 📱: 📱AppModel
    var body: some View {
        NavigationLink {
            Self.🧍HeightEditView()
        } label: {
            Label("Height", systemImage: "figure.stand")
        }
        .disabled(📱.🚩ableBMI == false)
        .font(.subheadline)
    }
    private struct 🧍HeightEditView: View {
        @EnvironmentObject var 📱: 📱AppModel
        @State private var 📝value: Int = 170
        var body: some View {
            VStack {
                Stepper {
                    Text(self.📝value.description + " cm")
                        .font(.system(size: 54).monospacedDigit())
                        .lineLimit(1)
                        .minimumScaleFactor(0.3)
                } onIncrement: {
                    UISelectionFeedbackGenerator().selectionChanged()
                    self.📝value += 1
                } onDecrement: {
                    UISelectionFeedbackGenerator().selectionChanged()
                    self.📝value -= 1
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
        }
    }
}
