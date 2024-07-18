//
//  ContentView.swift
//  iExpense
//
//  Created by Ruby Kim on 2024-07-18.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Double
    let currency: String
}

@Observable
class Expenses: Codable {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    
    //state variables
    @State private var expenses = Expenses()
    
    @State private var showingAddExpense = false

    @State private var selectedType = ["Business", "Personal"]

    var body: some View {
        NavigationStack {
            //displaying all the saved expense datas
            List {
                Section(header: Text("Personal")) {
                    //filtering only 'personal' type expenses
                    ForEach(expenses.items.filter { $0.type == "Personal"} ) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: item.currency))
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(itemStyle(item.amount))
                    }
                    .onDelete(perform: removeItems)
                    
                }
                Section(header: Text("Business")) {
                    //filtering only 'business' type expenses
                    ForEach(expenses.items.filter { $0.type == "Business"} ) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: item.currency))
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(itemStyle(item.amount))
                    }
                    .onDelete(perform: removeItems)
                }
                
                Section {
                   //footer section to inform coloured category by amount of budget
                } footer: {
                    HStack {
                        Circle()
                            .fill(.blue)
                            .frame(width: 15, height: 15)
                        Text("low")
                        
                        Spacer()
                        
                        Circle()
                            .fill(.green)
                            .frame(width: 15, height: 15)
                        Text("medium")
                        
                        Spacer()
                        
                        Circle()
                            .fill(.orange)
                            .frame(width: 15, height: 15)
                        Text("high")
                    }
                }
            }
            
            .navigationTitle("iExpense")
            .toolbar {
                //add new item button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddExpense = true
                    }) {
                        Label("Add", systemImage: "plus")
                    }
                }
                //delete button
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
                                
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    //function: change the text colour by budget
    func itemStyle(_ amount: Double) -> Color {
        switch amount {
        case ..<10:
            return Color.blue
        case 10..<100:
            return Color.green
        default:
            return Color.orange
        }
    }

}

#Preview {
    ContentView()
}
