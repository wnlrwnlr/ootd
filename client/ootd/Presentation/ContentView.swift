//
//  ContentView.swift
//  ootd
//
//  Created by Gyuni on 11/6/24.
//

import SwiftUI
import Service

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    @ViewBuilder
    private var imageView: some View {
        if let imageURL = viewModel.imageURL {
            AsyncImage(url: imageURL) { result in
                result.image?
                    .resizable()
            }
        } else {
            Image("sample-clothes-image")
                .resizable()
        }
    }

    var body: some View {
        VStack {
            imageView
                .scaledToFit()
                .cornerRadius(20)
                .frame(maxHeight: 250)

            List {
                weatherSection
                personalSettingsSection
            }
            .overlay(alignment: .bottom) {
                fetchRecommendationButton
            }
            .disabled(viewModel.isLoading)
            .navigationTitle("OOTD")
        }
        .overlay(alignment: .center) {
            if viewModel.isLoading {
                loadingOverlay
            }
        }
    }

    // MARK: - Subviews

    private var weatherSection: some View {
        Section(
            header: Text("날씨"),
            footer: Text("사용자의 위치 정보 기반으로 자동으로 받아옵니다")
        ) {
            HStack(spacing: 20) {
                Image(systemName: "thermometer")
                VStack(alignment: .leading) {
                    Text("기온")
                        .font(.subheadline)
                    Text(viewModel.temperature)
                        .font(.title3)
                        .bold()
                }
                VStack(alignment: .leading) {
                    Text("습도")
                        .font(.subheadline)
                    Text(viewModel.humidity)
                        .font(.title3)
                        .bold()
                }
                Spacer()
                Button(action: {
                    viewModel.refreshWeather()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var personalSettingsSection: some View {
        Section(
            header: Text("개인 설정"),
            footer: Text("사용자의 성별, 상황, 선호 스타일에 따라 추천을 받습니다")
        ) {
            Picker("성별", selection: $viewModel.sex) {
                ForEach(Sex.allCases) { sex in
                    Text(sex.rawValue).tag(sex)
                }
            }

            Picker("상황", selection: $viewModel.situation) {
                ForEach(Situation.allCases) { situation in
                    Text(situation.rawValue).tag(situation)
                }
            }

            Picker("선호 스타일", selection: $viewModel.stylePreference) {
                ForEach(StylePreference.allCases) { preference in
                    Text(preference.rawValue).tag(preference)
                }
            }
        }
    }

    private var fetchRecommendationButton: some View {
        Button(action: {
            Task {
                await viewModel.fetchRecommendation()
            }
        }) {
            Text("OOTD 추천받기")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .frame(height: 30)
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }

    private var loadingOverlay: some View {
        ZStack {
            Color.primary.opacity(0.4)
                .ignoresSafeArea()
            ProgressView("추천을 불러오는 중...")
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(10)
        }
    }
}

#Preview {
    ContentView()
}
