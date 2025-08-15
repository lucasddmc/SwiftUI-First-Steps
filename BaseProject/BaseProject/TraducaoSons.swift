import Foundation

struct TraducaoSons {
    
    // Mapeamento de classificações do SoundAnalysis para português
    static let traducoes: [String: String] = [
        // Sons Humanos - Fala e Vocalização
        "speech": "Fala",
        "shout": "Grito",
        "yell": "Berro",
        "battle_cry": "Grito de Guerra",
        "children_shouting": "Crianças Gritando",
        "screaming": "Gritaria",
        "whispering": "Sussurro",
        "conversation": "Conversa",
        "human_voice": "Voz Humana",
        "male_speech": "Voz Masculina",
        "female_speech": "Voz Feminina",
        "child_speech": "Voz de Criança",
        
        // Sons Humanos - Risos
        "laughter": "Risada",
        "baby_laughter": "Risada de Bebê",
        "giggling": "Risinhos",
        "snicker": "Risada Contida",
        "belly_laugh": "Gargalhada",
        "chuckle_chortle": "Risadinha",
        
        // Sons Humanos - Choro e Emoções
        "crying_sobbing": "Choro",
        "baby_crying": "Choro de Bebê",
        "sigh": "Suspiro",
        "gasp": "Suspiro de Susto",
        
        // Sons Humanos - Canto e Música
        "singing": "Cantando",
        "choir_singing": "Coral Cantando",
        "yodeling": "Iodeling",
        "rapping": "Rap",
        "humming": "Cantarolando",
        "whistling": "Assobiando",
        
        // Sons Humanos - Respiração e Corporais
        "breathing": "Respiração",
        "snoring": "Ronco",
        "cough": "Tosse",
        "sneeze": "Espirro",
        "nose_blowing": "Assoar o Nariz",
        "hiccup": "Soluço",
        "burping": "Arroto",
        "yawn": "Bocejo",
        
        // Sons Humanos - Movimento
        "person_running": "Pessoa Correndo",
        "person_shuffling": "Pessoa Arrastando os Pés",
        "person_walking": "Pessoa Caminhando",
        "footsteps": "Passos",
        "walk_footsteps": "Passos Caminhando",
        "run_footsteps": "Passos Correndo",
        
        // Sons Humanos - Atividades
        "applause": "Aplausos",
        "clapping": "Palmas",
        "finger_snapping": "Estalar Dedos",
        "hands_clapping": "Bater Palmas",
        
        // Instrumentos Musicais - Teclado
        "piano": "Piano",
        "electric_piano": "Piano Elétrico",
        "keyboard": "Teclado",
        "organ": "Órgão",
        "harpsichord": "Cravo",
        "synthesizer": "Sintetizador",
        
        // Instrumentos Musicais - Cordas
        "guitar": "Violão",
        "electric_guitar": "Guitarra Elétrica",
        "acoustic_guitar": "Violão Acústico",
        "bass_guitar": "Baixo",
        "violin": "Violino",
        "cello": "Violoncelo",
        "double_bass": "Contrabaixo",
        "harp": "Harpa",
        "banjo": "Banjo",
        "mandolin": "Bandolim",
        "ukulele": "Ukulele",
        
        // Instrumentos Musicais - Percussão
        "drums": "Bateria",
        "drum_kit": "Kit de Bateria",
        "snare_drum": "Caixa",
        "bass_drum": "Bumbo",
        "cymbal": "Prato",
        "hi_hat": "Chimbal",
        "timpani": "Tímpanos",
        "xylophone": "Xilofone",
        "marimba": "Marimba",
        "bells": "Sinos",
        "chime": "Carrilhão",
        "gong": "Gongo",
        "tambourine": "Pandeiro",
        
        // Instrumentos Musicais - Sopro
        "flute": "Flauta",
        "saxophone": "Saxofone",
        "trumpet": "Trompete",
        "clarinet": "Clarinete",
        "oboe": "Oboé",
        "harmonica": "Gaita",
        "accordion": "Acordeão",
        "bagpipes": "Gaita de Foles",
        "trombone": "Trombone",
        "french_horn": "Trompa",
        "tuba": "Tuba",
        
        // Música e Gêneros
        "music": "Música",
        "background_music": "Música de Fundo",
        "classical_music": "Música Clássica",
        "rock_music": "Rock",
        "pop_music": "Pop",
        "jazz": "Jazz",
        "blues": "Blues",
        "country_music": "Música Country",
        "electronic_music": "Música Eletrônica",
        "hip_hop_music": "Hip Hop",
        "reggae": "Reggae",
        "folk_music": "Música Folk",
        
        // Animais Domésticos
        "dog": "Cachorro",
        "dog_barking": "Latido",
        "puppy_barking": "Latido de Filhote",
        "cat": "Gato",
        "cat_meowing": "Miado",
        "purr": "Ronronar",
        "kitten": "Gatinho",
        
        // Animais de Fazenda
        "cow": "Vaca",
        "cow_mooing": "Mugido",
        "pig": "Porco",
        "pig_oinking": "Grunhido de Porco",
        "horse": "Cavalo",
        "horse_neighing": "Relincho",
        "sheep": "Ovelha",
        "sheep_bleating": "Balido",
        "goat": "Cabra",
        "rooster": "Galo",
        "rooster_crowing": "Canto do Galo",
        "chicken": "Galinha",
        "duck": "Pato",
        "duck_quacking": "Grasnido",
        "turkey": "Peru",
        
        // Animais Selvagens
        "bird": "Pássaro",
        "bird_singing": "Canto de Pássaro",
        "chirp": "Chilrear",
        "tweet": "Piar",
        "owl": "Coruja",
        "eagle": "Águia",
        "crow": "Corvo",
        "seagull": "Gaivota",
        "lion": "Leão",
        "lion_roaring": "Rugido de Leão",
        "elephant": "Elefante",
        "elephant_trumpeting": "Barrito",
        "monkey": "Macaco",
        "wolf": "Lobo",
        "wolf_howling": "Uivo de Lobo",
        "frog": "Sapo",
        "frog_croaking": "Coaxar",
        
        // Insetos
        "bee": "Abelha",
        "bee_buzzing": "Zumbido de Abelha",
        "fly": "Mosca",
        "mosquito": "Mosquito",
        "cricket": "Grilo",
        "cricket_chirping": "Grilar",
        "insect": "Inseto",
        
        // Transporte
        "car": "Carro",
        "car_engine": "Motor de Carro",
        "motorcycle": "Motocicleta",
        "truck": "Caminhão",
        "bus": "Ônibus",
        "train": "Trem",
        "airplane": "Avião",
        "helicopter": "Helicóptero",
        "boat": "Barco",
        "ship": "Navio",
        "bicycle": "Bicicleta",
        
        // Sons de Tráfego
        "traffic": "Tráfego",
        "car_horn": "Buzina",
        "siren": "Sirene",
        "ambulance_siren": "Sirene de Ambulância",
        "police_siren": "Sirene de Polícia",
        "fire_truck_siren": "Sirene de Bombeiros",
        
        // Natureza e Clima
        "rain": "Chuva",
        "heavy_rain": "Chuva Forte",
        "light_rain": "Chuva Leve",
        "thunderstorm": "Tempestade",
        "thunder": "Trovão",
        "wind": "Vento",
        "storm": "Tempestade",
        "water": "Água",
        "ocean": "Oceano",
        "waves": "Ondas",
        "stream": "Riacho",
        "waterfall": "Cachoeira",
        "fire": "Fogo",
        "fire_crackling": "Crepitar do Fogo",
        
        // Casa e Eletrodomésticos
        "vacuum_cleaner": "Aspirador de Pó",
        "washing_machine": "Máquina de Lavar",
        "dishwasher": "Lava-louças",
        "microwave": "Micro-ondas",
        "blender": "Liquidificador",
        "coffee_machine": "Cafeteira",
        "air_conditioner": "Ar Condicionado",
        "fan": "Ventilador",
        "hair_dryer": "Secador de Cabelo",
        
        // Tecnologia
        "computer_keyboard": "Teclado de Computador",
        "typing": "Digitação",
        "mouse_click": "Clique do Mouse",
        "phone_ringing": "Telefone Tocando",
        "smartphone": "Smartphone",
        "notification": "Notificação",
        "alarm": "Alarme",
        "alarm_clock": "Despertador",
        "doorbell": "Campainha",
        "printer": "Impressora",
        
        // Sons de Casa
        "door": "Porta",
        "door_opening": "Porta Abrindo",
        "door_closing": "Porta Fechando",
        "door_slam": "Porta Batendo",
        "window": "Janela",
        "glass": "Vidro",
        "glass_breaking": "Vidro Quebrando",
        "toilet_flush": "Descarga",
        "shower": "Chuveiro",
        "faucet": "Torneira",
        "dripping": "Pingando",
        
        // Cozinha
        "cooking": "Cozinhando",
        "frying": "Fritando",
        "sizzling": "Chiado",
        "boiling": "Fervendo",
        "chopping": "Cortando",
        "knife": "Faca",
        "plate": "Prato",
        "cutlery": "Talher",
        "microwave_beep": "Bip do Micro-ondas",
        
        // Ferramentas e Construção
        "hammer": "Martelo",
        "drilling": "Furadeira",
        "saw": "Serra",
        "chainsaw": "Motosserra",
        "jackhammer": "Britadeira",
        "construction": "Construção",
        "power_tool": "Ferramenta Elétrica",
        
        // Sons Diversos
        "silence": "Silêncio",
        "background_noise": "Ruído de Fundo",
        "white_noise": "Ruído Branco",
        "static": "Estática",
        "explosion": "Explosão",
        "gunshot": "Tiro",
        "fireworks": "Fogos de Artifício",
        "pop": "Estalo",
        "bang": "Estrondo",
        "crash": "Estrondo",
        "breaking": "Quebrando",
        "zip": "Zíper",
        "rip": "Rasgar",
        "crumpling": "Amassando",
        "rustling": "Farfalhar",
        
        // Emergência e Segurança
        "smoke_detector": "Detector de Fumaça",
        "fire_alarm": "Alarme de Incêndio",
        "emergency": "Emergência",
        "warning": "Aviso",
        
        // Esportes e Recreação
        "crowd": "Multidão",
        "cheering": "Torcida",
        "stadium": "Estádio",
        "ball": "Bola",
        "whistle": "Apito",
        
        // Sons de Escritório
        "office": "Escritório",
        "paper": "Papel",
        "paper_rustling": "Papel Farfalhando",
        "stapler": "Grampeador",
        "photocopier": "Fotocopiadora",
        
        // Default para sons não mapeados
        "unknown": "Som Desconhecido"
    ]
    
    // Função para traduzir um identificador
    static func traduzir(_ identificador: String) -> String {
        return traducoes[identificador] ?? identificador.capitalized
    }
    
    // Função para obter tradução com porcentagem
    static func traduzirComConfianca(_ identificador: String, confianca: Float) -> String {
        let traducao = traduzir(identificador)
        let porcentagem = Int(confianca * 100)
        return "\(traducao) (\(porcentagem)%)"
    }
}