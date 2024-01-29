//
//  ConnectionManager.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 26/01/24.
//

import Network
import UIKit

enum ConnectionStatus {
    case connected
    case disconnected
}

protocol ConnectionDelegate: AnyObject {
    func startMonitoring(completion: @escaping () -> Void)
    func stopMonitoring()
    func onConnectionStatusChanged(completion: @escaping (_ status: ConnectionStatus) -> Void)
    
    var isReachable: Bool { get }
    var coverAction: (() -> Void)? { set get }
}

final class ConnectionManager {
    static let shared: ConnectionDelegate = ConnectionManager()
    
    private var didChangePathStatus: ((ConnectionStatus) -> Void)?
    
    private let pathMonitor: NWPathMonitor
    
    private(set) var pathStatus: NWPath.Status {
        didSet {
            updateStatus()
        }
    }
    
    var coverAction: (() -> Void)?
    
    private var startCompletion: (() -> Void)?
    
    /// Block class initialization
    private init() {
        pathMonitor = NWPathMonitor()
        pathStatus = .requiresConnection
        pathMonitor.pathUpdateHandler = didChangeConnectionStatus
    }
    
    private func updateStatus() {
        logConnection(isReachable)
        didChangePathStatus?( isReachable ? .connected : .disconnected)
    }
    
    private func didChangeConnectionStatus(_ sender: NWPath) {
        defer { startCompletion = nil }
        pathStatus = sender.status
        startCompletion?()
    }
    
    private func logConnection(_ isReachable: Bool) {
        if !isReachable { coverAction?() }
        print("Network status: \(isReachable ? "Connected" : "Not Connected")")
    }
}


extension ConnectionManager: ConnectionDelegate {
    var isReachable: Bool {
        pathStatus == .satisfied || pathStatus == .requiresConnection
    }
    
    func startMonitoring(completion: @escaping () -> Void) {
        startCompletion = completion
        pathMonitor.start(queue: .main)
    }
    
    func stopMonitoring() {
        pathMonitor.cancel()
    }
    
    func onConnectionStatusChanged(completion: @escaping (_ status: ConnectionStatus) -> Void) {
        didChangePathStatus = completion
    }
}
