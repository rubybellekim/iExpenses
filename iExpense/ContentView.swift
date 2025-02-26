//
//  ContentView.swift
//  iExpense
//
//  Created by Ruby Kim on 2024-07-18.
//

import SwiftUI

//struct for id & items
struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Double
    let currency: String
    let range: String
}

struct Settings {
    var selectedCurrencies: [String] = ["USD", "CAD", "EUR", "JPY", "GBP"]
    
    let allCurrencies = ["CAD", "USD", "EUR", "GBP", "JPY", "KRW", "AUD", "CHF", "CNY", "HKD", "SGD", "MXN", "INR", "BRL"]

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

struct ItemList: View {
    let item: ExpenseItem

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
            }
            
            Spacer()
            
            Text(item.amount, format: .currency(code: item.currency))
                .fontWeight(.semibold)
                .foregroundColor(getColor(for: item.range))
        }
    }
    
    private func getColor(for range: String) -> Color {
        if range == "Low 🔵" {
            return .blue
        } else if range == "Medium 🟢" {
            return .green
        } else {
            return .orange
        }
    }
}
    
struct ExpenseRange: View {
    var body: some View {
        HStack {
            Text("🔵 low")
            
            Spacer()
            
            Text("🟢 medium")
            
            Spacer()
            
            Text("🟠 high")
        }
    }
}

struct ContentView: View {
    //state variables
    @State private var expenses = Expenses()
    @State private var settings = Settings()
    
    @State private var showingAddExpense = false
    @State private var showingSettingSheet = false

    @State private var selectedType = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            //displaying all the saved expense datas
            List {
                Section(header: Text("Personal")) {
                    //filtering only 'personal' type expenses
                    ForEach(expenses.items.filter { $0.type == "Personal"} ) { item in
                        ItemList(item: item)
                    }
                    .onDelete(perform: removeItems)
                }
                Section(header: Text("Business")) {
                    //filtering only 'business' type expenses
                    ForEach(expenses.items.filter { $0.type == "Business"} ) { item in
                        ItemList(item: item)
                    }
                    .onDelete(perform: removeItems)
                }
                
                Section {
                    //footer section to inform coloured category by amount of budget
                } footer: {
                    ExpenseRange()
                }
            }
            
            .navigationTitle("iExpense")
            .toolbar {
                //add new item button
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showingAddExpense = true
                    }) {
                        Label("Add", systemImage: "plus")
                    }
                }
                
                //setting button
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingSettingSheet.toggle() }) {
                        Label("Custom Setting", systemImage: "gearshape")
                    }
                }
                
                //delete button
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }

            }
            
            //** using .navigationLink instead of .sheet **
            
            .navigationDestination(isPresented: $showingAddExpense) {
                AddView(selectedCurrencies: $settings.selectedCurrencies, expenses: expenses)
            }
            
            .sheet(isPresented: $showingSettingSheet) {
                SettingView(settings: $settings)
            }
        }
    }
        
        func removeItems(at offsets: IndexSet) {
            expenses.items.remove(atOffsets: offsets)
        }

}

#Preview {
    ContentView()
}
