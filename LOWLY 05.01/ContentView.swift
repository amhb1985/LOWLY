//
//  ContentView.swift
//  LOWLY 05.01
//
//  Created by Amir Habibi on 04.04.23.
//


import SwiftUI

struct ContentView: View {
    @State private var weight = ""
    @State private var height = ""
    @State private var age = ""
    @State private var gender = 0
    @State private var activityLevel = 0
    @State private var showingBMR = false
    
    let genders = ["Male", "Female"]
    let activityLevels = ["Sedentary", "Lightly Active", "Moderately Active", "Very Active", "Extra Active"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.numberPad)
                    TextField("Height (cm)", text: $height)
                        .keyboardType(.numberPad)
                    TextField("Age (years)", text: $age)
                        .keyboardType(.numberPad)
                    Picker(selection: $gender, label: Text("Gender")) {
                        ForEach(0 ..< genders.count) {
                            Text(self.genders[$0])
                        }
                    }
                    Picker(selection: $activityLevel, label: Text("Activity Level")) {
                        ForEach(0 ..< activityLevels.count) {
                            Text(self.activityLevels[$0])
                        }
                    }
                }
                
                Button(action: {
                    self.showingBMR = true
                }) {
                    Text("Calculate Basal Metabolic Rate")
                }
                
                NavigationLink(destination: NutrientInfo()) {
                    Text("Enter Nutrient Info Manually")
                }
                
            }
            .navigationBarTitle("LOWLY")
        }
        .sheet(isPresented: $showingBMR) {
            BMRResultView(weight: Double(self.weight) ?? 0, height: Double(self.height) ?? 0, age: Double(self.age) ?? 0, gender: self.gender)
        }
    }
}

struct BMRResultView: View {
    var weight: Double
    var height: Double
    var age: Double
    var gender: Int
    
    var body: some View {
        let bmr: Double
        
        if gender == 0 {
            bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age)
        } else {
            bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age)
        }
        
        return Text("Your Basal Metabolic Rate is \(bmr, specifier: "%.2f") calories/day")
    }
}




struct NutrientInfo: View {
    @State private var nutrientName = ""
    @State private var calorieCount = ""
    @State private var carbCount = ""
    @State private var proteinCount = ""
    @State private var fatCount = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter Nutrient Information")) {
                    TextField("Nutrient Name", text: $nutrientName)
                    TextField("Calorie Count", text: $calorieCount)
                        .keyboardType(.numberPad)
                    TextField("Carbohydrate Count (g)", text: $carbCount)
                        .keyboardType(.numberPad)
                    TextField("Protein Count (g)", text: $proteinCount)
                        .keyboardType(.numberPad)
                    TextField("Fat Count (g)", text: $fatCount)
                        .keyboardType(.numberPad)
                }
            }
            .navigationBarTitle("Enter Nutrient Info")
        }
    }
}


struct EnterNutrientInfo: View {
    @State private var nutrientData: [[String]] = [["Food Name", "Calories", "Protein (g)", "Carbs (g)", "Fat (g)"], ["", "", "", "", ""]]
    
    var body: some View {
        VStack {
            HStack {
                Text("Enter Nutrient Information")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            Divider()
            ScrollView(.horizontal) {
                HStack {
                    ForEach(nutrientData[0], id: \.self) { header in
                        Text(header)
                            .frame(width: 120, height: 60, alignment: .center)
                            .background(Color.gray.opacity(0.3))
                    }
                }
                ForEach(1..<nutrientData.count) { index in
                    HStack {
                        ForEach(nutrientData[index], id: \.self) { data in
                            TextField("", text: Binding(
                                get: { self.nutrientData[index][self.nutrientData[0].firstIndex(of: data)!] },
                                set: { self.nutrientData[index][self.nutrientData[0].firstIndex(of: data)!] = $0 }
                            ))
                            .frame(width: 120, height: 50, alignment: .center)
                            .border(Color.gray, width: 1)
                        }
                    }
                }
                Button(action: {
                    nutrientData.append(["", "", "", "", ""])
                }, label: {
                    Text("Add Row")
                })
                .padding(.bottom, 50)
            }
            Spacer()
            Button(action: {
                // Save the nutrient data
            }, label: {
                Text("Save Nutrient Data")
            })
            .padding(.bottom, 50)
        }
    }
}

struct EnterNutrientInfo_Previews: PreviewProvider {
    static var previews: some View {
        EnterNutrientInfo()
    }
}



//struct EnterNutrientInfoB_Previews: PreviewProvider {
    //static var previews: some View {
        //EnterNutrientInfoB()
   //}
//}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
