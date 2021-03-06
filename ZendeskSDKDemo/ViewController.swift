//
//  ViewController.swift
//  ZendeskSDKDemo
//
//  Created by éĺŠć on 2021/4/22.
//

import UIKit
import ZendeskSDKMessaging

class ViewController: UIViewController {
    private enum InitStatus {
        case notReady
        case initialzing
        case ready
        case failed
    }
    
    private var status: InitStatus = .notReady
    private let channelKey = "eyJzZXR0aW5nc191cmwiOiJodHRwczovL2NvcnA5ODY2LnplbmRlc2suY29tL21vYmlsZV9zZGtfYXBpL3NldHRpbmdzLzAxRjMyQjRKNTBRN1lTUDBCQ1FKS1FNWFRTLmpzb24ifQ=="
    
    private var messaging: ZendeskSDKMessaging.Messaging?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        _initMessagingIfNeeded()
    }

    @IBAction func showConversation(_ sender: Any) {
        _initMessagingIfNeeded { (status) in
            guard status == .ready, let vc = self.messaging?.messagingViewController() else {
                return
            }
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    private func _initMessagingIfNeeded(_ completion: ((_ status: InitStatus) -> Void)? = nil) {
        if status == .ready || status == .initialzing {
            if let completion = completion {
                completion(status)
            }
        } else {
            status = .initialzing
            ZendeskSDKMessaging.Messaging.initialize(channelKey: channelKey) { (result) in
                do {
                    self.messaging = try result.get()
                    self.status = .ready
                    if let completion = completion {
                        completion(.ready)
                    }
                } catch {
                    self.status = .failed
                    if let completion = completion {
                        completion(.failed)
                    }
                }
            }
        }
    }
}

