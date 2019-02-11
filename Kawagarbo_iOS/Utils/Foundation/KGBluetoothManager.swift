//
//  KGBluetoothManager.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/1/30.
//

import UIKit
import CoreBluetooth

private var BluetoothManager: KGBluetoothManager = KGBluetoothManager()

public class KGBluetoothManager: NSObject, CBCentralManagerDelegate {
    
    static let bluetoothQueue = DispatchQueue(label: "com.kawagarbo.BluetoothManager")

    var central: CBCentralManager?
    var bluetoothEnabledCallback: ((Bool) -> Void)?
    
    public static var bluetoothEnabled: Bool {
        var bluetoothEnabled: Bool = false
        let semaphore = DispatchSemaphore(value: 0)
        
        KGBluetoothManager.bluetoothEnabled(callback: { (enable) in
            bluetoothEnabled = enable
            semaphore.signal()
        })
        let _ = semaphore.wait(timeout: .distantFuture)

        return bluetoothEnabled
    }
    
    public static func bluetoothEnabled(callback: @escaping (Bool) -> Void) {
        guard let _ = BluetoothManager.bluetoothEnabledCallback else {
            BluetoothManager.bluetoothEnabledCallback = callback
            return
        }
        
        guard let central = BluetoothManager.central else {
            return
        }
        callback(central.state == .poweredOn)
    }
    
    public override init() {
        super.init()
        self.central = CBCentralManager(delegate: self, queue: KGBluetoothManager.bluetoothQueue)
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard let callback = bluetoothEnabledCallback else { return }
        callback(central.state == .poweredOn)
    }
    
}
