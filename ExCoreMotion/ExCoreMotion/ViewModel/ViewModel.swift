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

enum ExCoreError: String, Error {
    case haveNotBeenApproved = "Have not been approved"
    case getTodayStepCount = "Can't Update Today Step Count"
    case weeksStepCount = "Can't Update Weeks Step Count"
    case dateFormattingFailed = "Failing date format"
}

protocol DefaultViewModelProtocol {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
    var disposeBag:DisposeBag { get set }
}

final class ViewModel: DefaultViewModelProtocol {
    
    struct Input {
        let onAppear = PublishSubject<Void>()
    }
    
    struct Output {
        let todayStepCount = PublishRelay<String>()
        let weekStepCount = PublishRelay<String>()
        let errorAlert = PublishSubject<String>()
    }
    
    var input = Input()
    var output = Output()
    
    var disposeBag = DisposeBag()
    
    private let pedometer = CMPedometer()
    
    init() {
        input.onAppear
            .flatMap { _ in self.checkAuthorization() }
            .filter { $0 }
            .flatMap { _ in self.getTodayStepCount() }
            .catch({ error in
                switch error as! ExCoreError {
                case .getTodayStepCount:
                    self.output.errorAlert.onError(ExCoreError.getTodayStepCount)
                case .haveNotBeenApproved:
                    self.output.errorAlert.onError(ExCoreError.haveNotBeenApproved)
                case .weeksStepCount:
                    self.output.errorAlert.onError(ExCoreError.weeksStepCount)
                case .dateFormattingFailed:
                    self.output.errorAlert.onError(ExCoreError.dateFormattingFailed)
                }
                return Observable.just("")
            })
                .bind(to: output.todayStepCount)
                .disposed(by: disposeBag)
    }
    
    func checkAuthorization() -> Observable<Bool> {
        /*
         rawValue == 0 : notDeterminded
         rawValue == 1 : restricted
         rawValue == 2 : denied
         rawValue == 3 : authorized
         */
        return Observable<Bool>.create { observer -> Disposable in
            if !CMPedometer.isStepCountingAvailable() {
                observer.onError(ExCoreError.haveNotBeenApproved)
            }
            
            if CMPedometer.authorizationStatus().rawValue == 1,
               CMPedometer.authorizationStatus().rawValue == 2 {
                observer.onError(ExCoreError.haveNotBeenApproved)
            } else {
                observer.onNext(true)
            }
            
            return Disposables.create()
        }
    }
    
    // 하루 걸음 수 데이터를 가져오는 함수
    private func getTodayStepCount() -> Observable<String> {
        return Observable<String>.create { observer -> Disposable in
            self.pedometer.startUpdates(from: Calendar.current.startOfDay(for: Date()), withHandler: { (data, error) in
                guard error != nil else {
                    observer.onError(ExCoreError.getTodayStepCount)
                    return
                }
                if let steps = data?.numberOfSteps.stringValue {
                    observer.onNext(steps)
                }
            })
            return Disposables.create()
        }
    }
    
    // 한 주 걸음 수 데이터를 가져오는 함수
    private func getWeekStepCount() -> Observable<String> {
        return Observable<String>.create { observer -> Disposable in
            let calendar = Calendar.current
            
            guard let startDay = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: Date()), wrappingComponents: false),
                  let endDay = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: Date()), wrappingComponents: false) else {
                observer.onError(ExCoreError.dateFormattingFailed)
                return
            }
            
            pedometer.queryPedometerData(from: startDay, to: endDay, withHandler: { (data, error) in
                guard error == nil else {
                    self.output.errorAlert.onError(ExCoreError.weeksStepCount)
                    return
                }
                
                if let steps = data.numberOfSteps.stringValue {
                    observer.onNext(steps)
                }
            })
            return Disposables.create()
        }
    }
    
    private func stopStepCountUpdate() {
        pedometer.stopUpdates()
    }
}
