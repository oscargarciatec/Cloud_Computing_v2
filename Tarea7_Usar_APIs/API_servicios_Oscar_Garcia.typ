// ---------- Page + language ----------
#set page(paper: "us-letter", margin: 1in)
#set text(lang: "es")
#show link: it => underline(text(fill: blue)[#it])
#set figure(numbering: "1")
#set figure(gap: 1em)
#show figure: set block(below: 1cm)

// ---------- Global typography ----------
#let body-font  = ("Publico Text","Charter", "Georgia", "Times New Roman")
#let title-font = ("Didot","Baskerville", "Times New Roman")
#let sc-font    = ("Hoefler Text", "Libertinus Serif", "Times New Roman")

#set text(font: body-font, size: 12pt)
#set par(justify: true, leading: 1.2em, spacing: 1.7em, first-line-indent: 0pt)

// Heading fonts (pick from your list)
#let h1-font = ("Didot","Baskerville", "Times New Roman")
#let h2-font = h1-font
#let h3-font = h1-font

// Global heading tweaks (spacing)
#show heading: it => {
  set block(above: 1.5em, below: 1.5em)
  it
}

// Level-specific typography
#show heading.where(level: 1): it => {
  set block(above: 1.5em, below: 1.2em)
  set text(font: h1-font, size: 22pt, weight: "bold")
  it
}
#show heading.where(level: 2): it => {
  set block(above: 1.3em, below: 0.9em)
  set text(font: h2-font, size: 18pt, weight: "bold")
  it
}
#show heading.where(level: 3): it => {
  set block(above: 0.8em, below: 0.5em)
  set text(font: h3-font, size: 14pt, weight: "semibold")
  it
}

// ---------- Cover page (no page number) ----------
#set page(numbering: none)

#align(center)[
  #v(0.5cm)
  #image("images/logo.jpg", width: 70%)
  #v(1.2cm)

  // Institute line with small caps
  #text(font: sc-font, size: 14pt, tracking: 0.03em)[
    #smallcaps[Instituto Tecnológico y de Estudios Superiores de Monterrey]
  ]
  #v(0.5cm)

  // Title + subtitle
  #text(font: title-font, size: 26pt, weight: "bold")[Maestría en Inteligencia Artificial:]
  #v(0.2cm)
  #text(font: title-font, size: 18pt, weight: "bold")[_Tarea 7: Usar APIs en la nube_]
  #v(2.5cm)

]

#align(left)[
  // Name + ID
  #text(font: body-font, size: 13pt, weight: "bold")[Alumno: Oscar Enrique García García - A01016093]
  #v(0.2cm)
]

// Professors (labels aligned to names)
#table(
  columns: (auto, 1fr),
  column-gutter: 0.8em,
  inset: 0pt,
  stroke: none,
  align: (left, left),
)[
  #text(weight: "bold")[Profesor Titular:] Gilberto Echeverría Furió

  #text(weight: "bold")[Profesor asistente:] Yetnalezi Quintas Ruiz
]

#v(1fr)

// Bottom-right: course + date
#align(right)[
  #text(size: 12pt)[Cómputo en la nube]

  #text(size: 11pt)[15 de marzo de 2026]
]

#pagebreak()

// ---------- After cover: restart numbering at 1 ----------

#outline(title: [Índice],depth: 3)
#pagebreak()

#let running_title = "Computación en la nube: Usar APIs en la nube"
#counter(page).update(1)
#set page(
  header: context [
    #block(width: 100%)[
      #text(size: 10pt)[#running_title]
      #h(1fr)
      #text(size: 10pt)[#counter(page).display()]
    ]
    #line(length: 100%, stroke: 0.5pt)
    #v(6pt)
  ],
)

#set heading(numbering: "1.")
#set figure(numbering: "1")

= Introducción

#pagebreak()

= Reconocimiento de caras: MS Azure Cognitive Services

A continuación se mostrarán los pasos que se siguieron para implementar
un script que utiliza la API de Cognitive Services de Microsoft Azure para la detección
de rostros y rasgos faciales, dentro de una imagen.

== Creación del servicio <sec-configuracion>

El primer paso para crear nuestro servicio para la API de Cognitive Services es
entrar al portal de Azure

#figure(
    image("images/portal_home.png", width: 100%),
    caption: [Azure Portal, pantalla principal.]
  )

Una vez dentro del portal, podemos dar clic en "Crear un recurso" y, en la barra de búsqueda,
buscaremos "Servicios de Azure AI".

#figure(
    image("images/azure_ai.png", width: 100%),
    caption: [Servicios de Azure AI.]
  )

Al dar clic sobre el servicio, se abrirá una pantalla de configuración para nuestro nuevo
servicio. En esta pantalla, configuraremos nuestro servicio de la siguiente forma:

#figure(
    image("images/azure_ai_conf.png", width: 100%),
    caption: [Configuración inicial del servicio de Azure AI.]
  )


- *Suscripción:* Seleccionaremos nuestra suscripción (Azure for Students).
- *Grupo de recursos:* Daremos clic en crear nuevo y definiremos uno nuevo con el nombre GR-FaceRecog-API-Python.
- *Región:* Definiremos una región, de acuerdo a nuestras regiones disponibles.
- *Nombre:* Definiremos un nombre que identifique a nuestro servicio. El nombre debe ser único. En nuestro caso, definimos el nombre "FaceRecognitionMNAOG"
- *Plan de tarifa:* Seleccionar Standard S0.

Una vez configurado nuestro servicio de Azure AI, podemos dar clic en el botón
"Revisar y Crear" y, una vez validado, nos saldrá el botón "Crear" para empezar a crear
el recurso.

#figure(
    image("images/revisar_y_crear.png", width: 100%),
    caption: [Revisar y crear: Página de validación.]
  )

Una vez que se haya creado nuestro servicio, podremos dar clic en el botón "Ir al recurso". Esto nos
llevará a la página de información general del servicio.

#figure(
    image("images/creation_completed.png", width: 100%),
    caption: [Creación del servicio completada.]
  )

== Obtención de la llave

Dentro de la página de información general del servicio, podremos ver en el menú lateral la sección
"Administración de recursos -> Claves y puntos de conexión" a la cual le daremos clic y nos abrirá
una nueva pantalla.

#figure(
    image("images/general_info.png", width: 100%),
    caption: [Información general de nuestro servicio de Azure AI.]
  )

Una vez en la pantalla nueva, tenemos que poner atención en dos cosas principales:

1. La Clave 1. Esta clave nos servirá como API Key para poder utilizar la API de detección
  de rostros. Para ello, es necesario dar clic en "Mostrar claves" y después dar clic en el botón de copiar,
  si así lo deseamos.

2. El endpoint que se muestra hasta abajo. Este endpoint también es importante para que nuestro código
  sepa a dónde conectarse para la utilización del servicio.

#figure(
    image("images/key_endpoint.png", width: 100%),
    caption: [Información general de nuestro servicio de Azure AI.]
  )

== Uso de la API CS dentro de un notebook/script

Ya que hemos creado nuestro servicio de Azure AI, podemos utilizar el endpoint y el API Key que obtuvimos
en el paso anterior, para realizar acciones de detección de rostros en una serie de imágenes.

Al final de esta sección se incluye la liga hacia el notebook que se utilizó para estas pruebas, donde
se encuentra todo el detalle y comentarios sobre cada sección del código, pero se puede resumir en
los siguientes pasos:

1. Importación de librerías globales y carga de variables: en esta sección se hace un _import_ de las
  librerías globales que se utilizarán dentro de nuestro código y se cargan nuestras variables locales,
  a partir de un archivo .env, con la función load_dotenv().

#figure(
    image("images/librerias.png", width: 100%),
    caption: [Librerías importadas en el código.]
  )

2. Configuración del API Key y el Endpoint: en esta sección se definen nuestras variables que servirán para
  realizar la conexión hacia nuestro servicio de Azure AI, previamente creado.

#figure(
    image("images/api_conf_end.png", width: 100%),
    caption: [Configuración del API Key y el Endpoint.]
  )

3. Configuración y creación de la petición (request) ejemplo: en esta
  sección se define la URL del endpoint, los headers (donde aparece la autenticación), los parámetros y,
  finalmente, se arma la petición a través de la librería _requests_, para una imagen de ejemplo.

#figure(
    image("images/request.png", width: 100%),
    caption: [Configuración y creación de la petición.]
  )

4. Definición de función reutilizable: en esta sección se crea la función _print_landmarks_ que nos permitirá
  imprimir nuestras imágenes, además de los objetos de detección que devuelve la API: detección de posición de
  rostros (con su índice asociado), ojos, labios, cejas, nariz, etc., además de imprimir cada uno de los datos en un formato de
  dataframe de _Pandas_.

```python
  import pandas as pd
  import matplotlib.pyplot as plt
  import requests
  from PIL import Image, ImageDraw, ImageFont
  from io import BytesIO
  from IPython.display import display

  def print_landmarks(image_url, data):
      # --- CONFIGURACIÓN DE PANDAS ---
      pd.set_option('display.max_columns', None)
      pd.set_option('display.max_rows', None)

      # 1. DESCARGA Y APERTURA DE IMAGEN
      try:
          response_img = requests.get(image_url)
          img = Image.open(BytesIO(response_img.content)).convert("RGB")
      except Exception as e:
          print(f"Error al cargar la imagen: {e}")
          return

      draw = ImageDraw.Draw(img)

      # 2. PROCESAMIENTO DE CADA ROSTRO
      for i, row in enumerate(data):
          rect = row['faceRectangle']
          left, top = rect['left'], rect['top']
          width, height = rect['width'], rect['height']
          right, bottom = left + width, top + height

          # --- LÓGICA DE TEXTO GRANDE Y ESCALABLE ---
          font_size = int(width * 0.3)

          try:
              font = ImageFont.truetype("/System/Library/Fonts/Supplemental/Arial Bold.ttf", font_size)
          except:
              try:
                  font = ImageFont.truetype("Arial.ttf", font_size)
              except:
                  font = ImageFont.load_default()

          # A. Dibujar el Rectángulo del rostro
          draw.rectangle([left, top, right, bottom], outline='red', width=6)

          # B. Dibujar el fondo del número
          bbox = draw.textbbox((left, top), str(i), font=font)
          draw.rectangle([bbox[0]-5, bbox[1]-font_size, bbox[2]+5, bbox[1]], fill='black')

          # C. Escribir el número de índice
          draw.text((left, top - font_size), str(i), fill='white', font=font)

          # D. Dibujar los Landmarks
          landmarks = row['faceLandmarks']
          r = max(3, int(width * 0.015))

          for feature_name, coords in landmarks.items():
              x, y = coords['x'], coords['y']
              draw.ellipse([x - r, y - r, x + r, y + r], fill='blue', outline='white', width=1)

      # 3. VISUALIZACIÓN DE LA IMAGEN
      plt.figure(figsize=(15, 12))
      plt.imshow(img)
      plt.axis('off')
      plt.title(f"Análisis Exhaustivo: {len(data)} rostros detectados", fontsize=16)
      plt.show()

      # 4. CREACIÓN Y MUESTRA DEL DATAFRAME
      df = pd.json_normalize(data)

      # 5. Imprimir resultados
      print("\n  DETALLES TÉCNICOS POR ROSTRO ")
      display(df)```

== Obtención de Resultados

Como pudimos ver en la sección anterior, la API devuelve un JSON que contiene dos cosas principales:

1. La posición y tamaño de las áreas donde fue detectado un rostro.

2. La posición (coordenadas _x_ y _y_) de los bordes de cada rasgo caracterísitico de los rostros, como
lo son boca, nariz, pupilas, cejas, labio superior, labio inferior, etc.

A continuación se muestra un framgento del JSON que resulta como respuesta de la API, donde podemos
ver lo que se describe en los puntos anteriores; "faceRectangle" corresponde a cada uno de los
rostros detectados y el arreglo "faceLandmarks" contiene cada una de las posiciones para los
diferentes rasgos.

  ```json
  [{"faceRectangle": {
    "top": 352, "left": 467, "width": 50, "height": 50},
  "faceLandmarks": {
    "pupilLeft": {"x": 479.8, "y": 366.1},
    "pupilRight": {"x": 503.6, "y": 367.2},
    "noseTip": {"x": 493.8, "y": 377.7},
    "mouthLeft": {"x": 479.6, "y": 388.1},
    "mouthRight": {"x": 500.7, "y": 389.4},
    "eyebrowLeftOuter": {"x": 470.8, "y": 361.6},
    "eyebrowLeftInner": {"x": 489.6, "y": 361.4},
    "eyeLeftOuter": {"x": 477.3, "y": 366.6},
    "eyeLeftTop": {"x": 480.2, "y": 365.6},
    "eyeLeftBottom": {"x": 480.2, "y": 367.2},
    "eyeLeftInner": {"x": 483.0, "y": 366.6},
    "eyebrowRightInner": {"x": 497.2, "y": 361.6},
    "eyebrowRightOuter": {"x": 513.3, "y": 363.2},
    "eyeRightInner": {"x": 500.1, "y": 367.2},
    "eyeRightTop": {"x": 503.6, "y": 366.3},
    "eyeRightBottom": {"x": 503.7, "y": 367.7},
    "eyeRightOuter": {"x": 506.6, "y": 367.4},
    "noseRootLeft": {"x": 488.6, "y": 367.0},
    "noseRootRight": {"x": 496.0, "y": 367.1},
    "noseLeftAlarTop": {"x": 487.1, "y": 374.2},
    "noseRightAlarTop": {"x": 497.6, "y": 374.6},
    "noseLeftAlarOutTip": {"x": 483.8, "y": 377.9},
    "noseRightAlarOutTip": {"x": 500.6, "y": 378.6},
    "upperLipTop": {"x": 491.3, "y": 387.0},
    "upperLipBottom": {"x": 491.3, "y": 389.2},
    "underLipTop": {"x": 491.1, "y": 391.8},
    "underLipBottom": {"x": 491.0, "y": 395.3}}},
  {"faceRectangle": {"top": 312, "left": 736, "width": 49, "height": 49},
    "faceLandmarks": {
      "pupilLeft": {"x": 749.2, "y": 326.6},
      "pupilRight": {"x": 771.3, "y": 326.0},
      "noseTip": {"x": 759.4, "y": 337.7},
      "mouthLeft": {"x": 749.7, "y": 347.8},
      "mouthRight": {"x": 773.5, "y": 346.8},
      "eyebrowLeftOuter": {"x": 740.6, "y": 325.1},
      "eyebrowLeftInner": {"x": 754.6, "y": 323.0},
      "eyeLeftOuter": {"x": 745.8, "y": 327.7},
      "eyeLeftTop": {"x": 749.0, "y": 325.6},
      "eyeLeftBottom": {"x": 749.3, "y": 328.5},
      "eyeLeftInner": {"x": 752.5, "y": 327.2},
      "eyebrowRightInner": {"x": 764.8, "y": 322.3},
      "eyebrowRightOuter": {"x": 779.7, "y": 322.9},
      "eyeRightInner": {"x": 767.5, "y": 326.6},
      "eyeRightTop": {"x": 771.2, "y": 324.6},
      "eyeRightBottom": {"x": 770.9, "y": 327.7},
      "eyeRightOuter": {"x": 774.6, "y": 326.6},
      "noseRootLeft": {"x": 756.5, "y": 327.2},
      "noseRootRight": {"x": 763.2, "y": 327.0},
      "noseLeftAlarTop": {"x": 754.9, "y": 333.5},
      "noseRightAlarTop": {"x": 765.3, "y": 333.4},
      "noseLeftAlarOutTip": {"x": 751.6, "y": 337.5},
      "noseRightAlarOutTip": {"x": 769.1, "y": 336.6},
      "upperLipTop": {"x": 760.2, "y": 345.2},
      "upperLipBottom": {"x": 760.5, "y": 347.3},
      "underLipTop": {"x": 760.8, "y": 351.6},
      "underLipBottom": {"x": 761.1, "y": 354.9}}}']```

Como ya tenemos definida nuestra función, podemos aplicarla para el procesamiento y análisis de diferentes
imágenes, que se muestran a continuación.

=== Aplicación de código a imagen muestra

A continuación se muestra la imagen resultante de aplicar nuestra función personalizada
a la imagen muestra de la guía, con la detección de los rostros y rasgos correspondientes.

#figure(
    image("images/muestra_img.png", width: 100%),
    caption: [Imagen muestra: detección de rostros y rasgos.]
  )

#figure(
    image("images/muestra_datos.png", width: 100%),
    caption: [Fragmento de datos recuperados por API de detección de rostros.]
  )

#text(font: sc-font, size: 14pt, tracking: 0.03em)[
  #underline(
    stroke: 0.5pt + black,
    offset: 2pt,
    evade: true
  )[Hallazgos e interpretación de resultados para imagen muestra]
]

Para esta imagen, podemos ver que se detectaron 8 rostros (que corresponden a cada registro del dataframe) y que se "pintaron" los puntos clave
dentro de la imagen. Los cuadros rojos representan cada "faceRectangle" que consta de una posición "top",
una posición "left", un ancho y un alto, para poder plasmarlo.

Por otro lado, los círculos azules corresponden a cada uno de los rasgos detectados dentro de
esas áreas de rostros, pertenecientes a ojos, labios, nariz,
cejas, etc. Asimismo, como con los "faceRectangles", podemos pintar sobre nuestra imagen estos
puntos llamados "faceLandmarks" y podemos verificar que la detección de los mismos
haya sido correcta y precisa.

=== Aplicación de código a imagen personal 1.

#figure(
    image("images/img_1_results.png", width: 100%),
    caption: [Imagen personal 1: detección de rostros y rasgos.]
  )

#figure(
    image("images/img_1_data.png", width: 100%),
    caption: [Imagen personal 1: Fragmento de datos recuperados por API de detección de rostros.]
  )

#text(font: sc-font, size: 14pt, tracking: 0.03em)[
  #underline(
    stroke: 0.5pt + black,
    offset: 2pt,
    evade: true
  )[Hallazgos e interpretación de resultados para imagen personal 1]
]

En este caso, podemos ver que únicamente se detectaron 9 rostros (los registros del dataframe) y que otros dos rostros quedaron fuera de
esta detección. Esto podría deberse a que los rostros se encuentran un poco más atrás que "el plano principal" y el algoritmo de detección
podría tener problemas con este tipo de casos, donde se da prioridad al "primer plano".

Cabe mencionar que, al igual que en el caso anterior, los rasgos parecen haberse plasmado de forma correcta para los 9 rostros
detectados.

=== Aplicación de código a imagen personal 1.

#figure(
    image("images/img_2_results.png", width: 100%),
    caption: [Imagen personal 2: detección de rostros y rasgos.]
  )

#figure(
    image("images/img_2_data.png", width: 100%),
    caption: [Imagen personal 2: Fragmento de datos recuperados por API de detección de rostros.]
  )

#text(font: sc-font, size: 14pt, tracking: 0.03em)[
  #underline(
    stroke: 0.5pt + black,
    offset: 2pt,
    evade: true
  )[Hallazgos e interpretación de resultados para imagen personal 2]
]

Finalmente, para esta imagen también podemos notar que una de las personas no fue detectada correctamente. Esto puede deberse a que en
esa parte de la imagen hay mucha luz, lo que pudo haber confundido al algoritmo para la detección.

Otro factor que pudo haber jugado en contra
para la detección de esta persona es la resolución de la imagen (está un tanto pixelada),
ya que estos algoritmos suelen comparar los pixeles
aledaños, luces, cambios de color, etc, para la detección de objetos o personas.

== Conclusiones de la aplicación del algoritmo de detección de rostros

Con los diferentes ejemplos que mostramos, podemos concluir los siguientes puntos:

1. La API de detección de rostros funciona muy bien para detectar rostros en los primeros planos de la imagen.
2. Para rostros que se encuentran muy en el fondo de la foto o que están en un plano diferente a la imagen central, tiene algunos
    problemas de detección (E.g. primer ejemplo con imágenes propias. Dos personas que se encuentran atrás de todos, no fueron detectados).
3. Para rostros que se encuentran muy iluminados (muy blancos) es posible que la API no detecte de buena
    forma el rostro (E.g. segundo ejemplo con imágenes propias. Para una de las personas, sus rasgos no fueron completamente identificados y otra persona
    no fue detectada, ya que en esa zona, la luz era mayor al resto de la imagen).

#pagebreak()

= Conversión de texto a voz: MS Azure Cognitive Services

== Investigación y referencias del servicio

Como servicio adicional seleccionado, se optó aplicar el servicio de conversión de texto
a voz, que también pertenece a la suite de MS Azure Cognitive Services. Este servicio permite que
nuestras aplicaciones, herramientas o dispositivos sean capaces de convertir cualquier texto a una voz
sintenizada similar a la humana.

Este servicio permite usar voces estándar, pero también permite crear voces customizadas que podamos utilizar
dentro de nuestro productos, aplicaciones, sitios, etc.

Algunos de los casos de uso de este servicio podrían ser:

1. Convertir textos, libros, posts, blogs en "audiolibros".

2. Asistentes de voz: Respuestas dinámicas basadas en documentos o bases de datos (saldos, estatus de pedidos, etc.)

3. Personalización por región: Usar un selecto de voces para que, por ejemplo, un cliente en México escuche una
  voz "mexicana" y alguien en España, también pueda escuchar una voz más "española", generando así mayor confianza y satisfacción.

4. Avatares parlantes: Sincronizar la voz con algún contenido para cursos en línea.

5. Efectos de sonido vocales: Si, por ejemplo, se quiere contar un cuento a partir de un texto, se podrían
  usar los ajustes de pitch y rate (que se demostrarán en el código), para crear voces de monstruos, robots,
  _animales_, etc.

Podemos encontrar más sobre las capacidades y customización que se puede realizar dentro del servicio
en la documentación oficial de Azure: https://learn.microsoft.com/en-us/azure/ai-services/speech-service/index-text-to-speech

== Configuración del servicio

Para configurar este servicio, podemos seguir la sección: #link(<sec-configuracion>)[2.1 Creación del Servicio]
dentro de este mismo documento, que básicamente se resumen en 4 pasos principales:

1. Creación del servicio en Azure Portal (Crear un nuevo recurso).
2. Configuración del servicio.
3. Revisión y creación.
4. Obtención de llave y endpoint.

#figure(
    image("images/azure_home_t2s.png", width: 100%),
    caption: [Creación de un nuevo recurso: Azure Portal.]
  )

#figure(
    image("images/servicios_ai_t2s.png", width: 100%),
    caption: [Servicios de Azure AI.]
  )

#figure(
    image("images/conf_azure_ai_t2s.png", width: 100%),
    caption: [Configuración de servicio.]
  )

#figure(
    image("images/claves_y_puntos_t2s.png", width: 100%),
    caption: [Información general de servicio. Ir a Claves y puntos de conexión.]
  )

#figure(
    image("images/clave_endpoint_t2s.png", width: 100%),
    caption: [Clave y endpoint de servicio.]
  )

== Código para implementación y uso de servicio

En esta sección se muestra el código utilizado para hacer uso del servicio anteriormente
creado. El código se divide en los siguientes pasos (flujo desde punto de vista del usuario):

1. Se cargan las librerías y variables de ambiente correspondiente.
2. Se configura el API Key, así como el endpoint del servicio.
3. Se configuran parámetros de conexión y personalización del servicio.
4. Se genera un diccionario con diferentes personalizaciones de las voces.
5. Se solicita al usuario una elección de "estilo de voz": Normal, Ardilla, Gigante, Noticiero, Suspenso.
6. Se solicita al usuario un texto a "convertir".
7. El código recibe ambos parámetros, genera un bloque de código para personalizar la voz y
  envía la petición hacia la API.
8. El código devuelve el audio generado a partir del texto escrito por el usuario.

```python
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
    print(f"Error: {result.cancellation_details.error_details}")```

== Obtención de resultados y explicación

A continuación se realiza una demostración en video del código anteriormente mostrado, donde:

1. Se solicita al usuario que seleccione un perfil de los disponibles: Normal, Ardilla, Gigante, Noticiero, Suspenso.
2. El usuario selecciona uno de los perfiles.
3. Se solicita al usuario que introduzca un texto a convertir.
4. El usuario introduce el texto que quiere convertir.
5. El código devuelve el texto convertido a audio, con el perfil seleccionado.

#link("https://www.loom.com/share/d830e55dd34a4f4aa5a31fbdb5a27d60")[Link hacia Loom para demostración del código]

Con este video demostramos que la API es capaz de convertir cualquier texto hacia un audio, con
algún perfil o modificación definida por el usuario y que el resultado es el esperado: el código recibió
nuestra elección de perfil (Ardilla), recibió nuestro texto a convertir y regresó de forma
correcta el audio correspondiente al texto, con la transformación adecuada de la voz.

De esta forma, también reitreamos el hecho de que esta API tiene muchos casos de uso, como lo son:
conversión de textos, libros o posts a audiolibros, asistencia telefónica personalizada, creación de
contenido (e.g. cuentos con efectos de voz o cursos en línea), etc.

= Reflexión



#pagebreak()

= Referencias
#set text(lang: "es")
#bibliography("refs.bib", style: "ieee", full: true, title: none)
