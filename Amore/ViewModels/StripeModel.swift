//
//  StripeModel.swift
//  Amore
//
//  Created by Kshitiz Sharma on 2/19/22.
//

import Stripe
import SwiftUI

class StripeModel: ObservableObject {
    
  let backendCheckoutUrl = URL(string: "http://127.0.0.1:5000/paymentsheet")!
  var apiURL = "http://127.0.0.1:5000"
  @Published var paymentSheet: PaymentSheet?
  @Published var paymentResult: PaymentSheetResult?
  @Published var pricingData : StripePricings?

  func preparePaymentSheet() {
        // MARK: Fetch the PaymentIntent and Customer information from the backend
        var request = URLRequest(url: backendCheckoutUrl)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
          guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let customerId = json["customer"] as? String,
                let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
                let paymentIntentClientSecret = json["paymentIntent"] as? String,
                let publishableKey = json["publishableKey"] as? String,
                let self = self else {
            // Handle error
            return
          }

          STPAPIClient.shared.publishableKey = publishableKey
          // MARK: Create a PaymentSheet instance
          var configuration = PaymentSheet.Configuration()
          configuration.merchantDisplayName = "Amore"
          configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
          // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
          // methods that complete payment after a delay, like SEPA Debit and Sofort.
          configuration.allowsDelayedPaymentMethods = true

          DispatchQueue.main.async {
            self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
          }
        })
        task.resume()
    }
    
    func onPaymentCompletion(result: PaymentSheetResult) {
       self.paymentResult = result
     }
    
    
    
    func getPricingData() {
        guard let url = URL(string: self.apiURL + "/fetchpricing") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error in API: \(error)")
                return
            }
            
            if let data = data {
                // Check if you receive a valid httpresponse
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            do {
                                self.pricingData =  try JSONDecoder().decode(StripePricings.self, from: data)
                            }
                            catch let jsonError as NSError {
                                print("Stripe Model loading prices")
                                print("JSON decode failed: \(jsonError.localizedDescription)")
                            }
                            return
                        }
                    }
                    else if [400, 401, 403, 404, 500].contains(httpResponse.statusCode) {
                        print("Stripe Model loading price api gave some error")
                    }
                }
            }
            return
        }.resume()
        
    }
    
}

