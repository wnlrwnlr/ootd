//
//  ContentView.swift
//  ootd
//
//  Created by Gyuni on 11/6/24.
//

import SwiftUI

struct ContentView: View {
    @State private var sex: Sex = .male
    @State private var situation: Situation = .casual
    @State private var stylePreference: StylePreference = .casual

    var body: some View {
        Image("sample-clothes-image")
            .resizable()
            .scaledToFit()
            .cornerRadius(20)
            .frame(maxHeight: 250)
        
        List {
            Section(content: {
                HStack(spacing: 20) {
                    Image(systemName: "thermometer")
                    VStack(alignment: .leading) {
                        Text("기온")
                            .font(.subheadline)
                        Text("11°C")
                            .font(.title3)
                            .bold()
                    }
                    VStack(alignment: .leading) {
                        Text("습도")
                            .font(.subheadline)
                        Text("60%")
                            .font(.title3)
                            .bold()
                    }
                    Spacer()
                    
                    Button(action: {
                        print("refresh")
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }, header: {
                Text("날씨")
            }, footer: {
                Text("사용자의 위치 정보 기반으로 자동으로 받아옵니다")
            })
            
            Section(content: {
                Picker("성별", selection: $sex) {
                    ForEach(Sex.allCases) { sex in
                        Text(sex.rawValue).tag(sex)
                    }
                }
                
                Picker("상황", selection: $situation) {
                    ForEach(Situation.allCases) { situation in
                        Text(situation.rawValue).tag(situation)
                    }
                }
                
                Picker("선호 스타일", selection: $stylePreference) {
                    ForEach(StylePreference.allCases) { preference in
                        Text(preference.rawValue).tag(preference)
                    }
                }
            }, header: {
                Text("개인 설정")
            }, footer: {
                Text("사용자의 성별, 상황, 선호 스타일에 따라 추천을 받습니다")
            })
        }
        .overlay(alignment: .bottom) {
            Button(action: {
                print("OOTD 추천받기")
            }) {
                Text("OOTD 추천받기")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("OOTD")
    }
}

#Preview {
    ContentView()
}
