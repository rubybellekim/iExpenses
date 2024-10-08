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
                .foregroundColor(item.currency == "JPY" ? itemStyle2(item.amount) : itemStyle1(item.amount))
        }
    }
    
    //function: change the text colour by budget
    func itemStyle1(_ amount: Double) -> Color {
        switch amount {
        case ..<30:
            return Color.blue
        case 30..<99:
            return Color.green
        default:
            return Color.orange
        }
    }
    
    func itemStyle2(_ amount: Double) -> Color {
        switch amount {
        case ..<3000:
            return Color.blue
        case 3000..<10000:
            return Color.green
        default:
            return Color.orange
        }
    }
}


struct ExpenseRange: View {
    var body: some View {
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddView(expenses: expenses)) {
                        Label("Add", systemImage: "plus")
                    }
                }
                //delete button
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
                                
            //** using .navigationLink instead of .sheet **
            
//            .sheet(isPresented: $showingAddExpense) {
//                AddView(expenses: expenses)
//            }
            

        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    


}

#Preview {
    ContentView()
}
