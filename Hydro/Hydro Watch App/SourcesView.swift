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
            // MARK: - Hydration Guidelines
            Section(header: Text("Hydration Guidelines")) {

                NavigationLink("Mayo Clinic – Water: How much should you drink?") {
                    WalkingGuidanceView()
                }

                NavigationLink("NHS – Water, drinks and hydration") {
                    NHSGuidanceView()
                }
            }

            // MARK: - Disclaimer (button)
            Section(header: Text("Legal")) {
                NavigationLink("Disclaimer") {
                    DisclaimerView()   // 👈 Opens your full disclaimer screen
                }
            }
        }
        .navigationTitle("Sources")
    }
}

// MARK: - Detail views used above

struct WalkingGuidanceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("How much should you drink every day??")
                    .font(.headline)

                Text("""

Water is essential to good health. Are you getting enough? These guidelines can help you find out.

The U.S. National Academies of Sciences, Engineering, and Medicine determined that an adequate daily fluid intake is:

About 3.7 liters of fluids a day for men
About 2.7 liters of fluids a day for women

These recommendations cover fluids from water, other beverages and food. About 20% of daily fluid intake usually comes from food and the rest from drinks.

What about the advice to drink 8 glasses a day?

You've probably heard the advice to drink eight glasses of water a day. That's easy to remember, and it's a reasonable goal.

Most healthy people can stay hydrated by drinking water and other fluids whenever they feel thirsty. For some people, fewer than eight glasses a day might be allright. But other people might need more.

You might need to modify your total fluid intake based on several factors:

Exercise. If you do any activity that makes you sweat, you need to drink extra water to cover the fluid loss. It's important to drink water before, during and after a workout.
Environment. Hot or humid weather can make you sweat and requires additional fluid. Dehydration also can occur at high altitudes.
Overall health. Your body loses fluids when you have a fever, vomiting or diarrhea. Drink more water or follow a doctor's recommendation to drink oral rehydration solutions. Other conditions that might require increased fluid intake include bladder infections and urinary tract stones.
Pregnancy and breast-feeding. If you are pregnant or breast-feeding, you may need additional fluids to stay hydrated.
Is water the only option for staying hydrated?

No. You don't need to rely only on water to meet your fluid needs. What you eat also provides a significant portion. For example, many fruits and vegetables, such as watermelon and spinach, are almost 100% water by weight.

In addition, beverages such as milk, juice and herbal teas are composed mostly of water. Even caffeinated drinks — such as coffee and soda — can contribute to your daily water intake. But go easy on sugar-sweetened drinks. Regular soda, energy or sports drinks, and other sweet drinks usually contain a lot of added sugar, which may provide more calories than needed.

How do I know if I'm drinking enough?

Your fluid intake is probably adequate if:

You rarely feel thirsty
Your urine is colorless or light yellow
Your doctor or dietitian can help you determine the amount of water that's right for you every day.

To prevent dehydration and make sure your body has the fluids it needs, make water your beverage of choice. It's a good idea to drink a glass of water:

With each meal and between meals
Before, during and after exercise
If you feel thirsty
""")
                .font(.footnote)
                .multilineTextAlignment(.leading)

                Group {
                    Text("Source:")
                        .font(.subheadline)
                        .bold()

                    Text("Mayo Clinic — full article:\nhttps://www.mayoclinic.org/healthy-lifestyle/nutrition-and-healthy-eating/in-depth/water/art-20044256")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle("Walking & Weight")
    }
}

struct NHSGuidanceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("NHS – Water, drinks and hydration")
                    .font(.headline)

                Text("""
Adults are generally advised to drink 6–8 cups of fluid a day \
(around 1.5–2 litres). Your needs increase in hot weather or \
during physical activity. Water, lower-fat milk and sugar-free \
drinks are healthier choices.

For full details, please refer to the NHS guidance on your paired iPhone.
""")
                .font(.footnote)
                .multilineTextAlignment(.leading)

                Group {
                    Text("Source:")
                        .font(.subheadline)
                        .bold()

                    Text("NHS – Water, drinks and hydration:\nhttps://www.nhs.uk/live-well/eat-well/food-guidelines-and-food-labels/water-drinks-nutrition/")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle("NHS Guidance")
    }
}
