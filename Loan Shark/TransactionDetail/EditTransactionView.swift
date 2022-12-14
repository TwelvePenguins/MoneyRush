//
//  EditTransactionView.swift
//  Loan Shark
//
//  Created by Yuhan Du on 21/11/22.
// ...

import SwiftUI

struct EditTransactionView: View {
    
    @Binding var transaction: Transaction
    @FocusState var isTextFieldFocused: Bool
    @Environment(\.dismiss) var dismiss
    
    var transactionTypes = ["Select", "Loan", "Bill Split"]
    
    var body: some View {
        NavigationView{
                VStack {
                    Form {
                        Section(header: Text("Transaction details")) {
                            HStack {
                                Text("Title")
                                    .foregroundColor(Color("PrimaryTextColor"))
                                TextField("Title", text: $transaction.name)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.trailing)
                                    .focused($isTextFieldFocused)
                                    .submitLabel(.done)
                                    .onSubmit {
                                        isTextFieldFocused = false
                                    }
                            }
                        }
                        Section {
                            Toggle(isOn: $transaction.isNotificationEnabled ) {
                                Text("Enable notifications")
                            }
                        } footer: {
                            Text("Enable this to allow Money Rush to automatically send you notifications to remind youcollect your money back.")
                        }
                        if transaction.transactionType == .loan {
                            Section {
                                HStack {
                                    Text("Who")
                                        .foregroundColor(Color("PrimaryTextColor"))
                                    Spacer()
                                    Text(transaction.people[0].name!)
                                        .foregroundColor(Color("SecondaryTextColor"))
                                }
                                HStack {
                                    Text("Amount")
                                        .foregroundColor(Color("PrimaryTextColor"))
                                    
                                    let moneyBinding = Binding {
                                        transaction.people[0].money ?? 0
                                    } set: { money in
                                        transaction.people[0].money = money
                                    }
                                    
                                    DecimalTextField(amount: moneyBinding, hint: "Amount")
                                        .foregroundColor(Color("SecondaryTextColor"))
                                        .multilineTextAlignment(.trailing)
                                }
                                
                                let bindingDate = Binding {
                                    transaction.people[0].dueDate ?? .now
                                } set: { newValue in
                                    transaction.people[0].dueDate = newValue
                                }
                                
                                DatePicker("Due by", selection: bindingDate, displayedComponents: .date)
                                    .foregroundColor(Color("PrimaryTextColor"))
                            }
                        } else if transaction.transactionType == .billSplitNoSync {
                            ForEach($transaction.people, id: \.name) { $person in
                                Section(header: Text(person.name ?? "No Contact Selected")) {
                                    HStack {
                                        Text("Who")
                                            .foregroundColor(Color("PrimaryTextColor"))
                                        Spacer()
                                        Text(person.name ?? "No Contact Selected")
                                            .foregroundColor(Color("SecondaryTextColor"))
                                    }
                                    HStack {
                                        Text("Amount")
                                            .foregroundColor(Color("PrimaryTextColor"))
                                        
                                        let bindingMoney = Binding {
                                            return person.money ?? 0
                                        } set: { money in
                                            person.money = money
                                        }
                                        
                                        
                                        DecimalTextField(amount: bindingMoney, hint: "Amount")
                                            .foregroundColor(Color("SecondaryTextColor"))
                                            .multilineTextAlignment(.trailing)
                                    }
                                    
                                    let dueDateBinding = Binding {
                                        person.dueDate!
                                    } set: { newValue in
                                        person.dueDate = newValue
                                    }
                                    
                                    DatePicker("Due by", selection: dueDateBinding, in: Date.now..., displayedComponents: .date)
                                        .foregroundColor(Color("PrimaryTextColor"))
                                }
                            }
                        } else if transaction.transactionType == . billSplitSync {
                            HStack {
                                Text("Who")
                                    .foregroundColor(Color("PrimaryTextColor"))
                                Spacer()
                                Text(transaction.people.map { $0.name! }.joined(separator: ", "))
                                    .foregroundColor(Color("SecondaryTextColor"))
                            }
                            
                            HStack {
                                Text("Amount each")
                                    .foregroundColor(Color("PrimaryTextColor"))
                                
                                let moneyBinding = Binding {
                                    transaction.people[0].money ?? 0
                                } set: { money in
                                    transaction.people[0].money = money
                                }
                                
                                DecimalTextField(amount: moneyBinding, hint: "Amount")
                                    .foregroundColor(Color("SecondaryTextColor"))
                                    .multilineTextAlignment(.trailing)
                            }
                            
                            let bindingDate = Binding {
                                transaction.people[0].dueDate ?? .now
                            } set: { newValue in
                                transaction.people[0].dueDate = newValue
                            }
                            
                            DatePicker("Due by", selection: bindingDate, in: Date.now..., displayedComponents: .date)
                                .foregroundColor(Color("PrimaryTextColor"))
                        }
                    }
                    Button {
                        dismiss()
                    }  label: {
                        Text("Save")
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color("AccentColor"))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                
                .navigationTitle("Edit Transaction")
            }
            .scrollDismissesKeyboard(.interactively)
        }
    }


