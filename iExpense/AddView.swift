//
//  AddView.swift
//  iExpense
//
//  Created by Ruby Kim on 2024-07-30.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCurrencies: [String]
    
    //State variables
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var isEditing = false
    @State private var currency = "CAD"
    @State private var range = "Low 🔵"
                
    //variables
    var expenses: Expenses
//    var selectedCurrencies: [String]
            
    let types = ["Personal", "Business"]
    let ranges = ["Low 🔵", "Medium 🟢", "High 🟠"]
    
    var body: some View {
        NavigationStack {
            //Input forms(expense name, type and currency/amount)
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                HStack {
                    TextField("Amount", value: $amount, format: .number .precision(.fractionLength(2)))
                        .keyboardType(.decimalPad)
                    
                    Picker("", selection: $currency) {
                        ForEach(selectedCurrencies, id: \.self) { currency in
                            Text(currency)
                        }
                    }
                }
                    // Edited part
//                    TextField("Amount", value: $amount, format: .currency(code: "USD"))
//                        .keyboardType(.decimalPad)
//                }
                    
                Section {
                    Picker("Gravity", selection: $range) {
                                            ForEach(ranges, id: \.self) { range in
                                                Text(range)
                                            }
                                        }
                    
                }
            }
                
                .navigationTitle("Add new expenses")
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItemGroup(placement: .confirmationAction) {
                        //button sends the data inputted into the main view
                        Button("Save") {
                            let item = ExpenseItem(name: name, type: type, amount: amount, currency: currency, range: range)
                            expenses.items.append(item)
                            dismiss()
                        }
                    }

                    ToolbarItemGroup(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(.red)
                    }
                    
                }
            }
        }
}

#Preview {
    AddView(selectedCurrencies: .constant(["CAD", "USD", "EUR"]), expenses: Expenses())
}
