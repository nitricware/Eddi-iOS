//
//  KarvonenCalculator.swift
//  Eddi
//
//  Created by Kurt Höblinger on 18.01.20.
//  Copyright © 2020 Kurt Höblinger. All rights reserved.
//

import Foundation

class KarvonenCalculator {
    var age: Double = 0
    var hfmin: Double = 0
    var hfmax: Double = 0
    var hfres: Double = 0
    var karvonenResult: KarvonenStruct = KarvonenStruct()
    var edwardsResult: EdwardsZonesStruct = EdwardsZonesStruct()
    
    func calcHFMax() -> Void {
        self.hfmax = 220.0 - self.age
    }
    
    func calcHFRes() -> Void {
        self.hfres = self.hfmax - self.hfmin
    }
    
    func calculateKarvonen() -> Void {
        self.karvonenResult.extensiveTraining = Int(self.hfres * 0.8 + self.hfmin)
        self.karvonenResult.intensiveTraining = Int(self.hfres * 0.6 + self.hfmin)
        self.karvonenResult.untrained = Int(self.hfres * 0.5 + self.hfmin)
    }
    
    func calculateEdwardsZones() -> Void {
        self.edwardsResult.healthZone.bottom = Int(self.hfmin + (self.hfres * 0.5))
        self.edwardsResult.healthZone.top = Int(self.hfmin + (self.hfres * 0.6))
        self.edwardsResult.fatZone.bottom = self.edwardsResult.healthZone.top
        self.edwardsResult.fatZone.top = Int(self.hfmin + (self.hfres * 0.7))
        self.edwardsResult.aerobicZone.bottom = self.edwardsResult.fatZone.top
        self.edwardsResult.aerobicZone.top = Int(self.hfmin + (self.hfres * 0.8))
        self.edwardsResult.anaerobicZone.bottom = self.edwardsResult.aerobicZone.top
        self.edwardsResult.anaerobicZone.top = Int(self.hfmin + (self.hfres * 0.9))
        self.edwardsResult.competitionZone.bottom = self.edwardsResult.anaerobicZone.top
        self.edwardsResult.competitionZone.top = Int(self.hfmax)
    }
}
