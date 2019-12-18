//
//  HomeViewController.swift
//  PushyApp
//
//  Created by Sebastian Gonzalez on 12/17/19.
//  Copyright © 2019 Sebastian Gonzalez. All rights reserved.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    @IBOutlet weak var lblNotificationAction: UILabel!
    
    private lazy var notificationManager = resolve(type: RemoteNotificationManagerProtocol.self)!
    private var subscribers = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationManager.methodPublisher
            .eraseToAnyPublisher()
            .delay(for: 2.0, scheduler: RunLoop.main)
            .receive(on: RunLoop.main).sink {[unowned self] val in
            self.lblNotificationAction.text = val
        }.store(in: &subscribers)
    }
}
