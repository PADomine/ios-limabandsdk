//
//  LimaBandClient.swift
//  Lima
//
//  Created by Leandro Tami on 4/20/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation

public typealias ScanHandler       = (_ success: Bool, _ devices: [BluetoothDevice]?) -> Void
public typealias ConnectHandler    = (_ success: Bool, _ fitnessDevice: FitnessDevice?) -> Void

public class LimaBandClient: FitnessDeviceManagerDelegate
{

    public static let shared           = LimaBandClient()
    
    private var manager         : FitnessDeviceManager!

    var isBluetoothAvailable : Bool {
        return manager.isBluetoothAvailable
    }

    var currentDevice : FitnessDevice? {
        return manager.fitnessDevice
    }
    
    private var scanHandler     : ScanHandler?
    private var connectHandler  : ConnectHandler?
    
    private init()
    {
    }

    public func start()
    {
        manager = FitnessDeviceManager()
        manager.delegate = self
    }
    
    public func scan(filterBySignalLevel: Bool, handler: @escaping ScanHandler)
    {
        // wait some time until Bluetooth is ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.scanHandler = handler
            self.manager.scan(filterBySignalLevel: filterBySignalLevel)
        }
    }
    
    public func connect(device: BluetoothDevice, handler: @escaping ConnectHandler)
    {
        self.connectHandler = handler
        manager.connect(toDevice: device)
    }
    
    // MARK: - FitnessDeviceManagerDelegate
    
    func didFind(success: Bool, devices: [BluetoothDevice])
    {
        scanHandler?(true, devices)
        scanHandler = nil
    }
    
    func didConnect(success: Bool, fitnessDevice: FitnessDevice?)
    {
        connectHandler?(success, fitnessDevice)
        connectHandler = nil
    }

    func didDisconnect()
    {
        scanHandler?(false, nil)
        scanHandler = nil
    }

}
