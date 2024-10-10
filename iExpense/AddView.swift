//
//  AddView.swift
//  iExpense
//
//  Created by Ruby Kim on 2024-07-30.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    //State variables
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var isEditing = false
    @State private var currency = "USD"
            
    //variables
    var expenses: Expenses
        
    let types = ["Business", "Personal"]
    
    let currencies = ["USD", "GBP", "JPY"]
    
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
                        ForEach(currencies, id: \.self) { currency in
                            Text(currency)
                        }
                    }
                    
                    // Edited part
//                    TextField("Amount", value: $amount, format: .currency(code: "USD"))
//                        .keyboardType(.decimalPad)
//                }
                    
                    
                    
                }
            }
                
                .navigationTitle("Add new expenses")
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItemGroup(placement: .confirmationAction) {
                        //button sends the data inputted into the main view
                        Button("Save") {
                            let item = ExpenseItem(name: name, type: type, amount: amount, currency: currency)
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
    AddView(expenses: Expenses())
}
