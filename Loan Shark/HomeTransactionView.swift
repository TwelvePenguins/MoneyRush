//
//  HomeTransactionView.swift
//  Loan Shark
//
//  Created by Yuhan Du on 1/11/22.
//

import SwiftUI

struct HomeTransactionView: View {
    
    @Binding var transaction: Transaction
    @State var showTransactionDetailsSheet = false
    
    var body: some View {
        Button {
            showTransactionDetailsSheet = true
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(transaction.name)
                        .foregroundColor(.black)
                    Text(transaction.people.joined(separator: ", "))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("$" + String(format: "%.2f", transaction.money))
                    .foregroundColor(transaction.isOverdue ? Color(red: 0.8, green: 0, blue: 0) : Color(.black))
                    .font(.title2)
            }
        }
        .sheet(isPresented: $showTransactionDetailsSheet) {
            TransactionDetailView(transaction: $transaction)
        }
    }
}

struct HomeTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTransactionView(transaction: .constant(Transaction(name: "", people: [], money: 0, dueDate: .now)))
    }
}
