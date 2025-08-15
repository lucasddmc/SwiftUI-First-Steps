import SwiftUI

struct ContentView: View {
    @StateObject private var analiseDeSom = DetectorDeSom()
    
    var body: some View {
        VStack(spacing: 20) {
            
            //Título
            Text("Detector de Sons")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
                .frame(height: 40)
            
            //Área do som detectado
            ZStack {
                Rectangle()
                    .foregroundStyle(.indigo)
                    .cornerRadius(8)
                
                HStack {
                    Image("icone")
                        .resizable()
                        .frame(width: 40, height: 40)
                    
                    Text(analiseDeSom.somIdentificado.isEmpty ? "Nenhum som detectado" : analiseDeSom.somIdentificado)
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            .frame(width: 300, height: 80)
            
            // Botão de ouvir e parar
            Button(action: {
                if analiseDeSom.ouvindo {
                    analiseDeSom.pararDeOuvir()
                } else {
                    analiseDeSom.ouvir()
                }
            }) {
                ZStack {
                    Rectangle()
                        .fill(analiseDeSom.ouvindo ? Color.red : Color.green)
                        .cornerRadius(8)
                    
                    Text(analiseDeSom.ouvindo ? "Parar" : "Começar")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(width: 300, height: 60)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
