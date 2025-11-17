//
//  SourcesView.swift
//  Hydration
//
//  Created by Mina Memisevic on 17. 11. 2025..
//

import SwiftUI

struct SourcesView: View {
    var body: some View {
        List {
            Section(header: Text("Hydration Guidelines")) {
                Link("Mayo Clinic – Water: How much should you drink?",
                     destination: URL(string: "https://www.mayoclinic.org/healthy-lifestyle/nutrition-and-healthy-eating/expert-answers/water/faq-20058345")!)

                Link("NHS – Water, drinks and hydration",
                     destination: URL(string: "https://www.nhs.uk/live-well/eat-well/water-drinks-and-your-health/")!)
            }

            Section(header: Text("Disclaimer")) {
                Text("Hydration suggestions in this app are for general wellness only and do not constitute medical advice. Consult your healthcare provider for personalized guidance.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Sources")
    }
}
