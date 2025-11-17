//
//  DisclaimerView.swift
//  Hydration
//
//  Created by Mina Memisevic on 17. 11. 2025..
//
import SwiftUI

struct DisclaimerView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {

                Text("Disclaimer")
                    .font(.headline)

                Text("""
The hydration suggestions in this app are for general wellness only and are not medical advice. 
For any health concerns or personalized recommendations, please consult a healthcare professional.
""")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)

                Text("This app uses publicly available sources like Mayo Clinic and NHS for educational purposes only.")
                    .font(.caption2)
                    .foregroundColor(.secondary)

            }
            .padding()
        }
        .navigationTitle("Disclaimer")
    }
}
