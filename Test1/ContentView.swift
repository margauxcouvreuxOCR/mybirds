import SwiftUI

struct ContentView: View {
    // Couleurs personnalisées
    let primary_brown = Color(red: 0.56, green: 0.30, blue: 0.11)
    let secondary_darkbeige = Color(red: 0.87, green: 0.67, blue: 0.50)
    let secondary_lightbeige = Color(red: 0.96, green: 0.86, blue: 0.72)
    let tertiary_green = Color(red: 0.70, green: 0.75, blue: 0.55)
    
    @State private var firstname: String = ""
    @State private var surname: String = ""
    @State private var showAlert = false
    @State private var selectedOption: String = "" // Variable pour l'option sélectionnée
    
    let options = ["Baltimore Oriole", "Barred Owl", "Eastern Bluebird", "Northern Cardinal"] // Liste des options

    @ObservedObject var birdAPI = BirdAPI() // Instance pour gérer l'API

    var body: some View {
        NavigationStack {
            ZStack {
                secondary_darkbeige
                    .edgesIgnoringSafeArea(.all) // Couvre tout l'écran
                
                VStack(spacing: 20) {
                    // Section des infos personnelles
                    Section(header: Text("Bird enthusiast info").foregroundColor(primary_brown).font(.headline)) {
                        VStack {
                            TextField("", text: $firstname)
                                .placeholder(when: firstname.isEmpty) {
                                    Text("First name")
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(.horizontal, 10)
                            
                            TextField("", text: $surname)
                                .placeholder(when: surname.isEmpty) {
                                    Text("Last name")
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(.horizontal, 10)
                        }
                        .padding()
                    }
                    
                    // Affichage de l'option sélectionnée
                    Text("Selection : \(selectedOption)")
                        .foregroundColor(primary_brown)
                        .padding()
                    
                    // Bouton pour charger les oiseaux
                    Button("Load Birds") {
                        selectedOption = "" // Réinitialiser la sélection à chaque fois qu'on charge la liste
                        birdAPI.fetchBirds(regionCode: "US-NY") // Exemple pour la région New York
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(tertiary_green)
                    .cornerRadius(10)
                    
                    // Liste des oiseaux
                    VStack(spacing: 20) {
                        // Liste des oiseaux, chaque élément est cliquable
                        List(birdAPI.birds, id: \.comName) { bird in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(bird.comName)
                                    .font(.headline)
                                    .foregroundColor(primary_brown)
                                    .onTapGesture {
                                        // Mise à jour de la sélection lorsque l'oiseau est cliqué
                                        selectedOption = bird.comName
                                    }
                                Text("Scientific Name: \(bird.sciName)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Number observed: \(bird.howMany ?? 0)") // Utilise 0 comme valeur par défaut si `howMany` est nil
                                Text("Location: \(bird.locName)")
                                    .font(.caption)
                                Text("Observed on: \(bird.obsDt)")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                            .padding()
                        }
                    }

                    // Affichage de l'image de l'oiseau sélectionné
                    if !selectedOption.isEmpty {
                        Image(selectedOption) // Affiche l'image de l'oiseau sélectionné
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .padding()
                    }
                    
                    // Bouton avec alerte
                    Button("Let's bird") {
                        showAlert = true
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(firstname.isEmpty || surname.isEmpty || selectedOption.isEmpty ? Color.gray.opacity(0.5) : tertiary_green)
                    .cornerRadius(10)
                    .disabled(firstname.isEmpty || surname.isEmpty || selectedOption.isEmpty)
                    .alert("\(firstname) \(surname)", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("Your favorite bird is: \(selectedOption)")
                    }
                }
                .padding()
                .background(secondary_lightbeige)
                .cornerRadius(15)
                .padding()
                .navigationTitle("My Birds")
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(Color(tertiary_green), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        // ShareLink pour partager l'image sélectionnée
                        ShareLink(item: Image(selectedOption), preview: SharePreview("Your bird", image: Image(selectedOption))) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
            }
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
            }
            self
        }
    }
}

#Preview {
    ContentView()
}
