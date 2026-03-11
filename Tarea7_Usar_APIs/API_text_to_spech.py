#Se importan librerías a utilizar en el código para utilizar el API y cargar nuestras variables de ambiente

import os
import azure.cognitiveservices.speech as speechsdk
from dotenv import load_dotenv

#Se carga nuestro archivo .env para el uso del API Key.

load_dotenv()

# Configuración inicial de nuestro API Key y endpoint
subscription_key = os.getenv("SUBSCRIPTION_KEY_TEXT2SPEECH")
ENDPOINT = 'https://textspeechmnaog.cognitiveservices.azure.com/'

speech_config = speechsdk.SpeechConfig(subscription=subscription_key, endpoint=ENDPOINT)
audio_config = speechsdk.audio.AudioOutputConfig(use_default_speaker=True)
speech_synthesizer = speechsdk.SpeechSynthesizer(speech_config=speech_config, audio_config=audio_config)

# --- DICCIONARIO DE PERFILES ---
# Aquí definimos los efectos para la voz que utilizaremos
voice_profiles = {
    "1": {"name": "Normal", "pitch": "0%", "rate": "1.0"},
    "2": {"name": "Ardilla (Helio)", "pitch": "+80%", "rate": "1.2"},
    "3": {"name": "Gigante", "pitch": "-40%", "rate": "0.8"},
    "4": {"name": "Noticiero (Rápido)", "pitch": "+5%", "rate": "1.3"},
    "5": {"name": "Suspenso (Lento)", "pitch": "-10%", "rate": "0.7"}
}

#Función que recibe el texto a convertir, así como el perfil seleccionado por el usuario para la generación de la voz.

def generar_ssml(texto, perfil_id):
    # Obtener el perfil seleccionado por el usuario
    perfil = voice_profiles.get(perfil_id, voice_profiles["1"])
    
    # Construcción del SSML dinámico. Se define el pitch y el rate para lograr los "efectos" deseados, a partir del perfil seleccionado.
    return f"""
    <speak version='1.0' xmlns='http://www.w3.org/2001/10/synthesis' xml:lang='es-MX'>
        <voice name='es-MX-DaliaNeural'>
            <prosody pitch='{perfil['pitch']}' rate='{perfil['rate']}'>
                {texto}
            </prosody>
        </voice>
    </speak>
    """ 

# --- INTERFAZ DE LA DEMO ---
#Se imprime el título de la demo y el diccionario de perfiles.
print("--- DEMO DE TEXT-TO-SPEECH ---")
print("Elige un estilo de voz:")
for key, value in voice_profiles.items():
    print(f"{key}: {value['name']}")

#Se pide un perfil al usuario, así como el texto a convertir.
opcion = input("\nSelecciona un número (1-5): ")
texto_a_decir = input("¿Qué quieres que diga la voz? > ")

# Se manda a llamar la función para generar el SSML con el perfil elegido
ssml_final = generar_ssml(texto_a_decir, opcion)

# Se ejecuta la síntesis final para obtener el audio, a partir del texto.
result = speech_synthesizer.speak_ssml_async(ssml_final).get()

#Se imprime el resultado final
if result.reason == speechsdk.ResultReason.SynthesizingAudioCompleted:
    print("\n¡Voz generada con éxito!")
elif result.reason == speechsdk.ResultReason.Canceled:
    print(f"Error: {result.cancellation_details.error_details}")