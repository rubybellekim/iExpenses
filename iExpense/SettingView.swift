//
//  SettingView.swift
//  iExpense
//
//  Created by Ruby Kim on 2025-02-25.
//

import SwiftUI



struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var settings: Settings
        
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Select Currencies")) {
                    ForEach(settings.allCurrencies, id: \.self) { currency in
                        Toggle(currency, isOn: Binding(
                            get: { settings.selectedCurrencies.contains(currency) },
                            set: { isSelected in
                                if isSelected {
                                    settings.selectedCurrencies.append(currency)
                                } else {
                                    settings.selectedCurrencies.removeAll { $0 == currency }
                                }
                            }
                        ))
                    }
                }
                
            }
            .navigationTitle("Settings")
            .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    dismiss()
                                }
                            }
                        }
        }
    }
}

//#Preview {
//    SettingView(settings: .constant(Settings()))
//}


