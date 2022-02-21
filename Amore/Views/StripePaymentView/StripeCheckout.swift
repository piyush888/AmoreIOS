//
//  StripeCheckout.swift
//  Amore
//
//  Created by Kshitiz Sharma on 2/20/22.
//

import SwiftUI
import Stripe

struct CheckoutView: View {
  @ObservedObject var model = StripeModel()

  var body: some View {
    
        VStack {
           if let paymentSheet = model.paymentSheet {
             PaymentSheet.PaymentButton(
               paymentSheet: paymentSheet,
               onCompletion: model.onPaymentCompletion
             ) {
               Text("Buy")
             }
           } else {
             Text("Loading…")
           }
           
            if let result = model.paymentResult {
             switch result {
                 case .completed:
                   Text("Payment complete")
                 case .failed(let error):
                   Text("Payment failed: \(error.localizedDescription)")
                 case .canceled:
                   Text("Payment canceled.")
             }
           }
            
         }.onAppear { model.preparePaymentSheet() }
      
  }
}
