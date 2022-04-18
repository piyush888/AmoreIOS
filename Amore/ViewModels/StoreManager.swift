//
//  StoreManager.swift
//  Amore
//
//  Created by Kshitiz Sharma on 2/28/22.
//  Refer tutorial https://blckbirds.com/post/how-to-use-in-app-purchases-in-swiftui-apps/ if you want to learn

import Foundation
import StoreKit
import Firebase

// To fetch the products, we adapt the NSObject and SKProductsRequestDelegate protocols.
class StoreManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var productIDs = [
        //Use your product IDs instead
        "Amore.ProductId.5.SuperLikes.v1",
        "Amore.ProductId.15.SuperLikes.v1",
        "Amore.ProductId.30.SuperLikes.v1",
        "Amore.ProductId.2.Boosts.v1",
        "Amore.ProductId.5.Boosts.v1",
        "Amore.ProductId.10.Boosts.v1",
        "Amore.ProductId.5.Messages.v1",
        "Amore.ProductId.10.Messages.v1",
        "Amore.ProductId.15.Messages.v1",
        "Amore.ProductId.1M.Gold.v2",
        "Amore.ProductId.3M.Gold.v2",
        "Amore.ProductId.6M.Gold.v2",
        "Amore.ProductId.1M.Platinum.v2",
        "Amore.ProductId.3M.Platinum.v2",
        "Amore.ProductId.6M.Platinum.v2"]
    
    @Published var superLikesPricing: [String: SKProduct] = [:]
    @Published var boostsPricing: [String: SKProduct] = [:]
    @Published var messagesPricing: [String: SKProduct] = [:]
    @Published var amoreGoldPricing: [String: SKProduct] = [:]
    @Published var amorePlatinumPricing: [String: SKProduct] = [:]
    
    // SKProductsRequest property in our StoreManager, which we will use to start the fetching process
    var request: SKProductsRequest!
    
    // Sends a request to the Apple servers based on given product IDs. At the same time we use the StoreManager class itself as the delegate of the request  so that the request knows that the didReceive response method should be called as soon as the Apple servers send a response.
    // Get Products from IAP
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
                print("Product List " + fetchedProduct.localizedTitle)
                DispatchQueue.main.async {
                    // Localized Titles Are Stored in Apple InApp Purchase Developer account
                    // Please make sure Localized Titles are always same even when you create new products
                    // other wise the application will break
                    if fetchedProduct.localizedTitle.contains("Super Likes") {
                        self.superLikesPricing[fetchedProduct.localizedTitle] = fetchedProduct
                    } else if fetchedProduct.localizedTitle.contains("Boosts") {
                        self.boostsPricing[fetchedProduct.localizedTitle] = fetchedProduct
                    } else if fetchedProduct.localizedTitle.contains("Messages") {
                        self.messagesPricing[fetchedProduct.localizedTitle] = fetchedProduct
                    } else if fetchedProduct.localizedTitle.contains("Amore Gold") {
                        self.amoreGoldPricing[fetchedProduct.localizedTitle] = fetchedProduct
                    } else if fetchedProduct.localizedTitle.contains("Amore Platinum") {
                        self.amorePlatinumPricing[fetchedProduct.localizedTitle] = fetchedProduct
                    }
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
                // UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
                queue.finishTransaction(transaction)
                transactionState = .purchased
                // Only store data in firebase when payment is successfull
                // If Purchase is Successfull, update the new purchase data
                // Check if the object is not nil & the call is being actually done by the user
                if self.purchaseDataDetails.subscriptionTypeId != nil && self.purchaseDataDetails != self.oldpurchaseDataDetails {
                    self.purchaseDataDetails = self.oldpurchaseDataDetails
                    // Store the details of consumables and subscription to firebase
                    _ = self.storePurchaseNoParams()
                    // Store the transaction in payment activity
                    _ = self.storePurchaseActivityDetails(transaction:transaction)
                }
            case .restored:
                // UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
                self.getPurchase()
                queue.finishTransaction(transaction)
                transactionState = .restored
            case .failed, .deferred:
                print("Store Manager: Payment Queue Error: \(String(describing: transaction.error))")
                self.oldpurchaseDataDetails = self.purchaseDataDetails
                queue.finishTransaction(transaction)
                transactionState = .failed
            default:
                queue.finishTransaction(transaction)
            }
        }
    }
    
    // Restore the purchase
    func restoreProducts() {
        print("Store Manager: Restoring products ...")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // ******************************************** //
    // ******************************************** //
    // ******************************************** //
    // ************ Purchase to Firebase ********** //
    // ******************************************** //
    // ******************************************** //
    // ******************************************** //
    
    let db = Firestore.firestore()
    @Published var purchaseDataDetails = ConsumableCountAndSubscriptionModel()
    @Published var oldpurchaseDataDetails = ConsumableCountAndSubscriptionModel()
    @Published var paymentCompleteDisplayMyAmore : Bool = false
    var purchaseDataFetched = false
    
    // Call this function to store the user purchase data into firebase
    func storePurchase(product: ConsumableCountAndSubscriptionModel) -> Bool {
        
        if let userId = Auth.auth().currentUser?.uid {
            do {
                _ = try db.collection("InAppPurchase").document(userId).setData(from: product)
                return true
            }
            catch let error {
                print("storePurchase: Can't store the purchase data in firestore: \(error)")
            }
            
        } else {
            print("No User Id")
        }
        return false
    }
    
    // Call this function to store the details of the payment which was just made
    func storePurchaseActivityDetails(transaction:SKPaymentTransaction) -> Bool  {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss 'UTC'"
        if let userId = Auth.auth().currentUser?.uid {
            do {
                _ = try db.collection("InAppPurchase").document(userId).collection("PurchaseActivity")
                    .addDocument(data: ["timeOfPurchase": Date(),
                                        "productRefernceId": transaction.payment.productIdentifier])
                self.paymentCompleteDisplayMyAmore = true
                return true
            }
            catch let error {
                print("storePurchase: Can't store the purchase activity in firestore: \(error)")
            }
        } else {
            print("No User Id")
        }
        return false
    }
    
    
    // Call this function when you want to store firestore object without an object
    func storePurchaseNoParams() -> Bool {
        return self.storePurchase(product:self.purchaseDataDetails)
    }
    
    // Call this function when you don't want to pass an object to be stored
    func storePurchaseWithParams(product:ConsumableCountAndSubscriptionModel) -> Bool {
        return self.storePurchase(product:product)
    }
    
    // Save the purchase data to firebase
    func getPurchase() {
        
        self.purchaseDataFetched = false
        let collectionRef = db.collection("InAppPurchase")
        if let documentId = Auth.auth().currentUser?.uid {
            let docRef = collectionRef.document(documentId)
            // Get Data from Firestore. Network Action -- Async Behaviour at this point
             .getDocument { [self] document, error in
                if let error = error as NSError? {
                    print("Error getting document: \(error.localizedDescription)")
                }
                else {
                    if let document = document {
                        do {
                            // Get User Purchase Data from firestore
                            self.oldpurchaseDataDetails = try document.data(as: ConsumableCountAndSubscriptionModel.self) ?? ConsumableCountAndSubscriptionModel()
                            self.purchaseDataDetails = self.oldpurchaseDataDetails
                            self.purchaseDataFetched = true
                        }
                        catch {
                            print(error)
                            self.purchaseDataFetched = true
                        }
                    } // if document
                } // else
            } // docref
        } // documentID
    } // getPurchase
    
    
    func writeReview() {
      let productURL = URL(string: "https://itunes.apple.com/app/id958625272")!
      var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
      components?.queryItems = [
        URLQueryItem(name: "action", value: "write-review")
      ]
     guard let writeReviewURL = components?.url else {
        return
      }
     UIApplication.shared.open(writeReviewURL)
    }
    
}


extension SKProduct {

    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    var isFree: Bool {
        price == 0.00
    }

    var localizedPrice: String? {
        guard !isFree else {
            return nil
        }
        
        let formatter = SKProduct.formatter
        formatter.locale = priceLocale

        return formatter.string(from: price)
    }

}
