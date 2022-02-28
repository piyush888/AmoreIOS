//
//  StoreManager.swift
//  Amore
//
//  Created by Kshitiz Sharma on 2/28/22.
//  Refer tutorial https://blckbirds.com/post/how-to-use-in-app-purchases-in-swiftui-apps/ if you want to learn

import Foundation
import StoreKit

// To fetch the products, we adapt the NSObject and SKProductsRequestDelegate protocols.
class StoreManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var productIDs = [
        //Use your product IDs instead
        "Amore.ProductId.5.SuperLikes.v1",
        "Amore.ProductId.15.SuperLikes.v1",
        "Amore.ProductId.30.SuperLikes.v1"
    ]
    
    // SKProductsRequest property in our StoreManager, which we will use to start the fetching process
    var request: SKProductsRequest!
    
    // Array that will contain the IAP products as SKProduct instances. Since we want to update the observing ContentView every time a new SKProduct is added, we use the @Published property wrapper.
    @Published var myProducts = [SKProduct]()
    
    // Sends a request to the Apple servers based on given product IDs. At the same time we use the StoreManager class itself as the delegate of the request, so that the request knows that the didReceive response method should be called as soon as the Apple servers send a response.
    func getProducts() {
        print("Store Manager: Start requesting products ...")
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }
    
    
    // didReceive response method
    // To conform to the SKProducutsRequestDelegate, we add the following function to our class
    // As soon as we receive a response from App Store Connect, this function is called.
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Store Manager: Did receive response")
        // we check if the response also contains produts
        if !response.products.isEmpty {
            // If we are sure that we have received products, we can add any of these products to our myProducts array using a for-in loop.
            for fetchedProduct in response.products {
                DispatchQueue.main.async {
                    self.myProducts.append(fetchedProduct)
                }
            }
        }
        
        // If for some reason our response contains product IDs that are invalid, we want to be notified. We use a corresponding for-in loop for this purpose as well.
        for invalidIdentifier in response.invalidProductIdentifiers {
            print("Store Manager: Invalid identifiers found: \(invalidIdentifier)")
        }
    }
    
    // Notifies that we got no response from Apple servers & the request fails
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Store Manager: Request did fail: \(error)")
    }
    
    
    //HANDLE TRANSACTIONS - state of a transaction
    @Published var transactionState: SKPaymentTransactionState?
    
    
    // Once we have started a transaction(paymentQueue), this function is called every time something changes in the status of the transaction(s) currently processed.
    func purchaseProduct(product: SKProduct) {
        // Make sure a user can start the transaction. Eg. a parent control is setup
        if SKPaymentQueue.canMakePayments() {
            // Start the payment process using SKPayment & add it to the queue
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            print("Store Manager: User can't make payment.")
        }
    }
    
    // start the purchase process as soon as the user taps on the respective “Purchase” Button.
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                transactionState = .purchasing
            case .purchased:
                UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
                queue.finishTransaction(transaction)
                transactionState = .purchased
            case .restored:
                UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
                queue.finishTransaction(transaction)
                transactionState = .restored
            case .failed, .deferred:
                print("Store Manager: Payment Queue Error: \(String(describing: transaction.error))")
                queue.finishTransaction(transaction)
                transactionState = .failed
            default:
                queue.finishTransaction(transaction)
            }
        }
    }
    
    
    func restoreProducts() {
        print("Store Manager: Restoring products ...")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

