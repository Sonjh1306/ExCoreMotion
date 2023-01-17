//
//  ViewModel.swift
//  ExCoreMotion
//
//  Created by sonjuhyeong on 2023/01/17.
//

import Foundation
import CoreMotion
import RxSwift
import RxCocoa

protocol DefaultViewModelProtocol {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
    var disposeBag:DisposeBag { get set }
}

final class ViewModel: DefaultViewModelProtocol {

    struct Input {
        let authorizationState = PublishSubject<Bool>()
    }
    
    struct Output {
        let todayStepCount = PublishRelay<String>()
        let weekStepCount = PublishRelay<String>()
        let errorAlert = PublishRelay<String>()
     }
    
    var input = Input()
    var output = Output()
    
    var disposeBag = DisposeBag()
    
    private let pedometer = CMPedometer()
    
    init() {
 
        input.authorizationState
            .bind { [weak self] _ in
                guard let self = self else { return }
                if self.checkAuthorization() {
                    self.getTodayStepCount()
//                    self.getWeekStepCount()
                } else {
                    self.output.errorAlert.accept("Have not been approved")
                }
            }.disposed(by: disposeBag)
    }
    
    func checkAuthorization() -> Bool {
        if !CMPedometer.isStepCountingAvailable() {
            return false
        }
        
        /*
         rawValue == 0 : notDeterminded
         rawValue == 1 : restricted
         rawValue == 2 : denied
         rawValue == 3 : authorized
         */
        if CMPedometer.authorizationStatus().rawValue == 1,
           CMPedometer.authorizationStatus().rawValue == 2 {
            return false
        } else {
            return true
        }
    }
    
    // 하루 걸음 수 데이터를 가져오는 함수
    private func getTodayStepCount() {
        
        pedometer.startUpdates(from: Calendar.current.startOfDay(for: Date()), withHandler: { (data, error) in
            if error != nil {
                self.output.errorAlert.accept("Can't Update Today Step Count")
            }
            
            if let stepData = data {
                let steps = stepData.numberOfSteps.stringValue
                DispatchQueue.main.async {
                    self.output.todayStepCount.accept(steps)
                }
            }
            
        })
    }
    
    // 한 주 걸음 수 데이터를 가져오는 함수
    private func getWeekStepCount() {
        let calendar = Calendar.current
        
        guard let startDay = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: Date()), wrappingComponents: false),
              let endDay = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: Date()), wrappingComponents: false) else { return }

        pedometer.queryPedometerData(from: startDay, to: endDay, withHandler: { (data, error) in
            if error != nil {
                self.output.errorAlert.accept("Can't Update Weeks Step Count")
            }
            
            if let stepData = data {
                let steps = stepData.numberOfSteps.stringValue
                DispatchQueue.main.async {
                    self.output.weekStepCount.accept(steps)
                }
            }
        })
    }
    
    private func stopStepCountUpdate() {
        pedometer.stopUpdates()
    }
}
