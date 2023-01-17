//
//  MainView.swift
//  ExCoreMotion
//
//  Created by sonjuhyeong on 2023/01/17.
//

import UIKit

class MainView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "CoreMotion"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    let todayStepsLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .red
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    let weekStepsLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .blue
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    let startDateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    let endDateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setAddSubviews() {
        self.addSubview(titleLabel)
        self.addSubview(todayStepsLabel)
        self.addSubview(weekStepsLabel)
        self.addSubview(startDateLabel)
        self.addSubview(endDateLabel)
    }
    
    private func configureConstraints() {
        setAddSubviews()
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(100)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        todayStepsLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        weekStepsLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(todayStepsLabel.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        startDateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(weekStepsLabel.snp.bottom).offset(100)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        endDateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(startDateLabel.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
    }

    
}
