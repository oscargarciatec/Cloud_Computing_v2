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
  #text(font: title-font, size: 18pt, weight: "bold")[_Tarea 8: Usando funciones de Machine Learning en la nube_]
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

  #text(size: 11pt)[22 de marzo de 2026]
]

#pagebreak()

// ---------- After cover: restart numbering at 1 ----------

#outline(title: [Índice],depth: 3)
#pagebreak()

#let running_title = "Computación en la nube: Usando funciones de ML en la nube"
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

El Machine Learning (ML) o aprendizaje automático es una rama de
la inteligencia artificial que permite a los sistemas aprender de
los datos para realizar tareas sin ser programados explícitamente para cada
una de ellas.

En la actualidad, el uso de funciones de ML en la nube, particularmente
a través de plataformas como Azure Machine Learning, ha democratizado
el acceso a herramientas avanzadas para científicos de datos y empresas.

*Ventajas y Desventajas del Machine Learning Tradicional*

-*Ventajas:* Permite automatizar procesos complejos, realizar predicciones
precisas y manejar grandes volúmenes de datos que serían inmanejables
para un humano.

-*Desventajas:* El ciclo de vida tradicional de ML es costoso en tiempo
y requiere que expertos prueben manualmente algoritmos,
ajusten hiperparámetros y realicen ingeniería de características
repetitiva.

Plataformas como Azure ofrecen entornos robustos que facilitan
desde la creación de libretas de trabajo (notebooks .ipynb)
hasta la implementación con herramientas como Auto ML, que facilitan
todas las tareas repetitivas y tediosas que tienen que hacer los
científicos de datos, previo a un análisis y optimización.

Esta práctica pretende demostrar cómo implementar scripts de python
dentro de Azure, así como demostrar las ventajas y facilidad
con la que se pueden automatizar todas estas tareas repetitivas
dentro de un entorno de nube.

#pagebreak()

= Sección de Azure ML para trabajar con libretas

A continuación se mostrarán los pasos que se siguieron para crear un
notebook (.ipynb) dentro de la nube de Azure, con el servicio
de Azure ML.

== Creación del servicio

El primer paso para crear nuestro servicio de Azure ML, es entrar
al portal de Azure

#figure(
    image("images/portal_home.png", width: 100%),
    caption: [Azure Portal, pantalla principal.]
  )

Una vez dentro del portal, podemos dar clic en "Crear un recurso" y, en la barra de búsqueda,
buscaremos "machine learning".

#figure(
    image("images/machine_learning_busqueda.png", width: 100%),
    caption: [Servicios de Machine Learning en Azure.]
  )

Una vez desplegados los servicios, ubicaremos el servicio de
"Azure Marchine Learning" y daremos clic en el botón "Crear" que se
encuentra debajo y después en "Azure Machine Learning".

#figure(
    image("images/azure_ml.png", width: 100%),
    caption: [Azure Machine Learning.]
  )

Posteriormente se abrirá una pantalla de configuración del servicio
donde configuraremos lo siguiente:

#figure(
    image("images/azure_ml_conf.png", width: 100%),
    caption: [Configuración inicial del servicio de Azure ML.]
  )

- *Suscripción:* Seleccionaremos nuestra suscripción (Azure for Students).
- *Grupo de recursos:* Daremos clic en crear nuevo y definiremos uno nuevo con el nombre gr-machinelearning.
- *Nombre:* Definiremos un nombre que identifique a nuestro servicio. En nuestro caso, Azure ML-mna.
- *Región:* Definiremos una región, de acuerdo a nuestras regiones disponibles.

Una vez seleccionado el nombre, veremos que también se llenan de forma
automática los campos de cuenta de almacenamiento, almacén de claves y
application insights. Estos valores los dejaremos tal cual se crearon.

Para el menú de registro de contenedor, seleccionaremos el valor de
"Ninguno".

Una vez configurado lo anterior, daremos clic en "Siguiente: Inbound
Access", que nos llevará nuevamente a otra pantalla de configuración. En
esta pantalla únicamente veriicaremos que esté seleccionado "All networks"
en la sección de "Public network access".

#figure(
    image("images/inbound_access.png", width: 100%),
    caption: [Configuración de inbound access para Azure ML.]
  )

Finalmente, podemos dar clic en el botón "Revisión y creación", que
nos llevará a una pantalla de resumen de nuestra configuración y,
después de haber sido validado, nos dejará dar clic en el botón
"Crear" para iniciar el proceso de creación de nuestro servicio.

#figure(
    image("images/create_azureml.png", width: 100%),
    caption: [Creación del servicio Azure ML]
  )

== Creación y configuración del notebook

Una vez que se completó la creación de nuestro servicio, nos aparecerá
un botón de "Ir al recurso", al cual daremos clic para entrar
a la configuración general del servicio.

#figure(
    image("images/creation_completed.png", width: 100%),
    caption: [Servicio creado exitosamente.]
  )

Una vez que estemos en la pantalla de "Información general"
de nuestro servicio recién creado, daremos clic en el botón "Launch
Studio".

#figure(
    image("images/launch_studio.png", width: 100%),
    caption: [Información general del servicio - Launch Studio.]
  )

Al dar clic en el botón, se nos mostrará una nueva pantalla de inicio
de Azure ML. Aquí, se muestran las diferentes opciones para
trabajar con proyectos de Data Science. En esta ocasión, mostraremos
cómo crear y configurar un _notebook_ de Python desde este entorno
de trabajo.

Para ello, buscaremos la opción de "Crear cuaderno" dentro de la sección
"Accesos directos" y daremos clic en el botón "Crear nuevo bloc de notas"
que se encuentra debajo y procederemos a darle un nombre a nuestro cuaderno.

#figure(
    image("images/create_notebook.png", width: 100%),
    caption: [Creando un nuevo cuaderno de trabajo en Azure ML.]
  )

#figure(
    image("images/name_notebook.png", width: 100%),
    caption: [Nombrando nuestro cuaderno de trabajo en Azure ML.]
  )

Ya que hemos nombrado nuestro cuaderno de trabajo, se abrirá nuestro
cuaderno de trabajo donde podremos ingresar nuestro código Python
dentro de las celdas, pero antes de poder ejecutar cualquier código, debemos
configurar un nuevo "entorno de procesamiento de Azure ML".

Para ello, buscaremos y daremos clic en el botón "+"
que se encuentra en la sección "Proceso" que se sitúa en la parte superior
de la pantalla.

#figure(
    image("images/crear_proceso.png", width: 100%),
    caption: [Crear nuevo proceso de Azure ML.]
  )

Este botón nos llevará a diferentes pantallas de configuración
donde definiremos lo siguiente:

#figure(
    image("images/compute_conf.png", width: 100%),
    caption: [Pantalla de configuración de entorno de procesamiento.]
  )

- *Nombre del proceso:* Elegiremos un nombre único para nuestro entorno.
- *Tipo de máquina virtual:* Seleccionaremos "CPU".
- *Tamaño de la máquina virtual:* En este caso, seleccionaremos la más pequeña,
  dado que se trata de una simple demostración: Standard_DS11_v2.

Una vez configurado esto, podemos dar clic en "Revisar y crear" y finalmente
en "Crear".

#figure(
    image("images/create_compute.png", width: 100%),
    caption: [Pantalla de creación de entorno de procesamiento.]
  )

Una vez que se haya terminado de crear nuestro "entorno", podremos
seleccionarlo en la sección "proceso" de nuestro cuaderno de
trabajo y una vez que se muestre que está en ejecución, podremos
probarlo ejecutando algún código simple de Python.

#figure(
    image("images/select_compute.png", width: 100%),
    caption: [Cuaderno de trabajo con entorno seleccionado y activo.]
  )

#figure(
    image("images/python_example.png", width: 100%),
    caption: [Código Python de ejemplo, ejecutado en nuestro cuaderno de trabajo.]
  )

== Carga de datos

Una vez que hayamos comprobado que nuestro entorno funciona correctamente,
procederemos a realizar una carga de datos, a partir de un archivo previamente
descargado (weatherAUS.csv), correspondiente a los registros de clima en Australia.
Para ello, nos dirigiremos a la sección de "Datos", que se encuentra debajo de
"Recursos", en la barra lateral izquierda.

#figure(
    image("images/barra_datos.png", width: 100%),
    caption: [Menú de Datos, dentro de la barra lateral de nuestro cuaderno de trabajo.]
  )

Una vez que demos clic, entraremos a una nueva pantalla de recursos
de datos. Una vez ahí, daremos clic en "+ Crear" para iniciar con la
definición de nuestro origen de datos.

#figure(
    image("images/create_dataset.png", width: 100%),
    caption: [Creación de recurso de datos.]
  )

Al dar clic, se nos abrirá una nueva pantalla de configuración, donde
definiremos lo siguiente:

#figure(
    image("images/conf_dataset.png", width: 100%),
    caption: [Pantalla de configuración de recurso de datos.]
  )

- *Nombre:* Definiremos un nuevo nombre para nuestro recurso de datos.
- *Descripción:* Definiremos una descripción para nuestro recurso de datos.
- *Tipo:* Seleccionaremos "Archivo (uri_file)" para nuestro caso de uso.

Después, en la siguiente sección: Origen de datos, seleccionaremos
la opción "De archivos locales" y daremos clic en "Siguiente".

#figure(
    image("images/local_files.png", width: 100%),
    caption: [Elegir el origen para el recurso de datos.]
  )

En la siguiente pantalla, seleccionaremos el almacén de datos
"workspaceblobstore", que fue el almacén que se creó al inicializar
nuestro espacio de trabajo en Azure ML.

#figure(
    image("images/almacen_datos.png", width: 100%),
    caption: [Seleccionar nuestro almacen de datos.]
  )

Posteriormente, en la sección "Selección de archivo", podremos
cargar nuestro archivo previamente descargado con el botón
"Crear archivo" y seleccionando el archivo desde nuestra computadora.
Una vez que se haya completado la carga, podemos dar clic en "Siguiente".

#figure(
    image("images/upload_file.png", width: 100%),
    caption: [Carga de nuestro archivo de datos.]
  )

Finalmente podemos revisar el resumen de la configuración de nuestro
recurso de datos y dar clic en "Crear".

#figure(
    image("images/create_resource.png", width: 100%),
    caption: [Creación de nuestro recurso de datos.]
  )

Una vez creado nuestro recurso de datos, se nos mostrará la pantalla
de información, donde podremos realizar varias acciones.

#figure(
    image("images/info_resource.png", width: 100%),
    caption: [Pantalla de información de nuestro recurso de datos.]
  )

1. En la pestaña "Explorar" podremos tener una previsualización
  de nuestros datos cargados.

#figure(
    image("images/explore_data.png", width: 100%),
    caption: [Pantalla de previsualización de datos.]
  )

2. En la pestaña "Consumir", podremos ver un ejemplo de código
  en Python, que nos permitirá consultar nuestros datos cargados.
  Por ahora, copiaremos este código, ya que lo utilizaremos posteriormente
  para consumir nuestros datos.

#figure(
  image("images/consume_data.png", width: 100%),
  caption: [Pantalla de consumo de datos.]
)

== Ejecución de código en cuaderno de trabajo y análisis de datos

Una vez que copiamos el código Python de la pestaña "Consumir",
regresaremos a nuestra cuaderno de trabajo dando clic en "Notebooks",
en la barra lateral izquierda y, una vez en nuestro cuaderno de trabajo,
pegaremos nuestro código y lo ejecutaremos.

#figure(
  image("images/run_code.png", width: 100%),
  caption: [Ejecución de código en nuestro cuaderno de trabajo]
)

Una vez terminada la ejecución, podremos ver nuestro dataframe
con nuestros datos cargados, desde el archivo que subimos
anteriormente. De esta forma, podemos comprobar que nuestro archivo
se cargó correctamente y podemos empezar con la manipulación y/o
análisis de los datos.

#figure(
  image("images/dataframe_weather.png", width: 100%),
  caption: [Dataframe resultante con datos del clima en Australia]
)

A continuación se muestran algunas cosas y conclusiones a las que se
llegó, basado en este análisis de datos.


1. Se importaron las librerías

#figure(
  image("images/import_libraries.png", width: 100%),
  caption: [Importación de librerías para EDA]
)

2. Se hizo una impresión de estadísticas descriptivas iniciales y de
  la estructura del dataset

  #figure(
    image("images/estadisticas.png", width: 100%),
    caption: [Impresión de estadísticas descriptivas y estructura del dataset.]
  )

3. Se hicieron conversiones iniciales de datos, así como conteo
  de nulos por campo.

#figure(
  image("images/clean_and_nulls.png", width: 100%),
  caption: [Conteo de nulos en el dataset.]
)

4. Se hizo una preparación de datos, que incluye una conversión de variables
  categóricas a "numéricas", así como una imputación sobre los valores
  faltantes.

  #figure(
    image("images/prepare_data.png", width: 100%),
    caption: [Preparación de datos.]
  )

5. Se implementó código para gráficar algunas variables en boxplots, tener una
  matriz de correlación, gráficos de estacionalidad, etc.

  #figure(
    image("images/visualize_data_code.png", width: 100%),
    caption: [Código para visualización de datos.]
  )

=== Hallazgos del análisis de los datos

1. Existen 4 variables con un alto número de nulos: Sunshine, Evaporation,
  Cloud3pm y Cloud9am.

2. Existe un desbalanceo de clases, para nuestra variable objetivo, en nuestros datos.
  Esto puede ocasionar que nuestro modelo sea muy bueno "prediciendo" que no va a llover;
  para ello, tenemos que elegir correctamente nuestras métricas de desempeño.

3. Existen algunas variables (e.g. Rainfall) con un claro sesgo que debería ser
  corregido con alguna transformación (e.g. logarítmica).

4. Hay algunas variables con alto índice de correlación. Esto implicará que el DS quizás decida
  eliminar algunas variables para el modelo final (e.g. Elegir entre MaxTemp/Min Temp y Temp9am/Temp3pm)

5. La humedad de las 3pm tiene una alta correlación con la probabilidad de lluvia de "mañana", lo que
  también nos podría dar grandes inicios al momento de seleccionar nuestras variables predictoras.

6. Hay unos meses donde los casos de lluvia son claramente mayores; esto nos podría
  mostrar casos de estacionalidad.

  #figure(
    image("images/countplot_classes.png", width: 100%),
    caption: [Desbalanceo de clases en los datos.]
  )

  #figure(
    image("images/histograms.png", width: 100%),
    caption: [Histogramas para variables.]
  )

  #figure(
    image("images/correlation.png", width: 100%),
    caption: [Matriz de correlación.]
  )

  #figure(
    image("images/humidity.png", width: 100%),
    caption: [Humedad 3pm vs Predicción de lluvia.]
  )

  #figure(
    image("images/seasonality.png", width: 100%),
    caption: [Estacionalidad.]
  )

#pagebreak()

= Investigación de proceso de Azure AutoML

A continuación se describirá de manera general qué es "AutoML", cuáles
son sus beneficios y cómo configurarlo dentro de Azure ML.

== ¿Qué es AutoML?

Azure AutoML (Machine Learning Automatizado) es una funcionalidad
dentro de Azure Machine Learning diseñada para agilizar
el proceso de creación de modelos de aprendizaje automático.

En lugar de que un científico de datos pruebe manualmente
cada algoritmo y ajuste cada hiperparámetro, AutoML lo hace de
forma automática. Es como tener un "asistente experto" que "entrena"
cientos de combinaciones para encontrar la mejor para tus datos.

Tradicionalmente, el ciclo de vida de ML requiere mucho tiempo en
tareas repetitivas. AutoML se encarga de:

- *Selección del Algoritmo:* Prueba desde modelos lineales simples
  hasta redes neuronales o algoritmos de boosting (como XGBoost o LightGBM).

- *Ingeniería de Características (Featurization):* Maneja automáticamente
  los valores nulos, realiza codificación de variables categóricas y
  escala los datos numéricos.

- *Ajuste de Hiperparámetros:* Encuentra la configuración óptima
  para maximizar la precisión.

- *Validación:* Aplica técnicas como validación cruzada para asegurar
  que el modelo sea robusto y no solo memorice los datos.

Actualmente, Azure AutoML está optimizado para tres tareas principales:

- *Clasificación:* Como nuestro caso de "lluvia" (¿Sí o No?),
  detección de fraude o diagnóstico médico.

- *Regresión:* Predecir valores numéricos, como el precio de una casa
  o la demanda de energía.

- *Pronóstico de Series de Tiempo (Forecasting):* Predecir valores futuros
  basados en datos históricos, considerando tendencias y estacionalidad
  (ej. ventas del próximo mes).

== Configuración del servicio y carga de datos

Para crear un nuevo trabajo de AutoML, es necsario entrar al mismo servicio
de la sección anterior: Azure ML. Dentro de Azure ML, procederemos a ir a la sección
"ML automatizado".

#figure(
  image("images/automl.png", width: 100%),
  caption: [Pantalla de ML automatizado.]
)

Al entrar a la sección de "ML automatizado", procederemos dar clic al botón
"+ Nuevo trabajo de ML automatizado".

#figure(
  image("images/automl_new_job.png", width: 100%),
  caption: [Nuevo trabajo de ML automatizado.]
)

Al dar clic en el botón, se nos abrirá una nueva pantalla de configuración,
donde podremos definir el nombre del trabajo, el nombre del experimento, la
descripción y las etiquetas.

#figure(
  image("images/automl_general.png", width: 100%),
  caption: [Configuración general de trabajo de AutoML.]
)

En secciones siguientes, dentro de la misma pantalla, también podremos
seleccionar nuestro almacén de datos, así como cargar, configurar y revisar
nuestro origen de datos (e.g. nuestro archivo de clima
de Australia), de forma muy similar a como lo hicimos en la libreta
de la sección anterior.

#figure(
  image("images/almacen_automl.png", width: 100%),
  caption: [Selección de almacén de datos.]
)

#figure(
  image("images/upload_data.png", width: 100%),
  caption: [Carga de datos nuevos. Botón "+ Crear".]
)

#figure(
  image("images/carga_datos.png", width: 100%),
  caption: [Configuración de origen de datos. En este caso, seleccionamos tipo Tabular, debido a la naturaleza del archivo.]
)

#figure(
  image("images/origen_datos_automl.png", width: 100%),
  caption: [Selección de origen de datos.]
)

#figure(
  image("images/archivo_cargado_automl.png", width: 100%),
  caption: [Carga de nuestro archivo.]
)

También se muestra una sección donde podemos configurar nuestro origen de datos,
en cuanto a delimitadores, codificación, encabezados, etc.

#figure(
  image("images/prev_datos.png", width: 100%),
  caption: [Previsualización de datos cargados.]
)

Asimismo, se muestra una pantalla donde podemos seleccionar nuestras
columnas a utilizar (quizás resultado de un EDA anterior, como lo hicimos nosotros)
así como el tipo de dato de cada columna.

#figure(
  image("images/esquema.png", width: 100%),
  caption: [Selección de columnas y tipos de datos.]
)

#figure(
  image("images/validate_data.png", width: 100%),
  caption: [Validación y revisión de origen de datos.]
)

Una vez configurado nuestro origen de datos, se nos dará la opción de elegir
nuestro tipo de tarea (en nuestro caso, Clasificación), los datos a utilizar (
los que creamos en el paso anterior), el tipo de validación (cruzada, en nuestro caso),
el número de validaciones, el porcentaje de datos de prueba, etc.

#figure(
  image("images/tipo_tarea.png", width: 100%),
  caption: [Selección de tipo de tarea y origen de datos.]
)

#figure(
  image("images/config_class.png", width: 100%),
  caption: [Configuración de la clasificación.]
)

Finalmente, podremos configurar nuestra máquina virtual y proceso,
de la siguiente forma:

#figure(
  image("images/vm_automl.png", width: 100%),
  caption: [Configuración del proceso y máquina virtual.]
)

#figure(
  image("images/revision_automl.png", width: 100%),
  caption: [Pantalla de revisión de nuestro trabajo de ML automatizado.]
)

Una vez terminado este proceso, podremos ver nuestro nuevo trabajo de ML listado
en la página inicial. Podremos ver también, que se encuentra en un estado "En
ejecución" (así permanecerá hasta que termine el trabajo completo, que dependerá
de los modelos, los datos, las validaciones configuradas, etc.). Nota: Tener en cuenta
que este proceso puede durar horas, dependiendo nuestra configuración.

#figure(
  image("images/automl_status.png", width: 100%),
  caption: [Nuevo trabajo de ML automatizado - En ejecución.]
)

== Resultados

Una vez completo nuestro proceso, podremos ver que el estatus cambia a
"Completado".

#figure(
  image("images/automl_completed.png", width: 100%),
  caption: [Nuevo trabajo de ML automatizado - Completado.]
)

Y, una vez completado, podremos ver diferentes cosas:

1. Insights interesantes sobre los datos: equilibrio de clases, valores nulos,
  cardinalidades, etc. En nuestro caso, como ya lo habíamos mencionado en la sección
  anterior, tenemos un problema de desbalanceo, así como de valores faltantes.

  #figure(
    image("images/insights.png", width: 100%),
    caption: [Insights mostrados por AutoML.]
  )

2. Modelos evaluados: se muestra un listado de los modelos y parámetros utilizados
  para la comparación, mostrando en el tope, el mejor modelo resultante.

  #figure(
    image("images/models.png", width: 100%),
    caption: [Nuevo trabajo de ML automatizado - Completado.]
  )

3. Código y pipelines generados.

#figure(
  image("images/resultados_registros.png", width: 100%),
  caption: [Código generado para la replicación del modelo.]
)

De igual forma, podemos ver una pantalla de resumen sobre el nombre del algoritmo
resultante, el valor de la métrica de AUC (y otras métricas), así como un link
para ver los detalles del conjunto.

#figure(
  image("images/summary_automl.png", width: 100%),
  caption: [Pantalla de resumen del trabajo de ML automatizado]
)

#figure(
  image("images/details_summary.png", width: 100%),
  caption: [Detalles del conjunto. Transformaciones y modelos utilizados.]
)

Y, al dar clic sobre el link del algoritmo, se nos abrirá una nueva pantalla,
donde podremos ver otra serie de cosas:

1. Resumen del modelo, métricas y modelos registrados.

#figure(
  image("images/summary_model.png", width: 100%),
  caption: [Pantalla de resumen del trabajo de ML automatizado]
)

#figure(
  image("images/list_metrics.png", width: 100%),
  caption: [Listado de métricas resultantes del trabajo de ML automatizado.]
)

2. Métricas: en esta pestaña podremos ver una serie de gráficos y valores que
  fueron evaluados en las diferentes iteraciones del trabajo.

  #figure(
    image("images/metrics_ml.png", width: 100%),
    caption: [Pantalla de gráficas y métricas del trabajo de ML automatizado]
  )

3. Transformaciones realizadas: en esta pestaña podremos ver
las diferentes transformaciones que se le realizaron a nuestro conjunto de
datos.

#figure(
  image("images/data_transform.png", width: 100%),
  caption: [Pantalla de transformaciones aplicadas a nuestros datos.]
)

De esta forma, podemos ver, AutoML es una herramienta súper potente, que automatiza
muchas de las tareas repetitivas o "tardadas" que deben realizar los
científicos de datos, como lo son: exploración de datos, selección de modelos,
limpieza previa, ajuste de hiperparámetros, validación cruzada, etc. y que, de esta
forma, los científicos pueden eficientar en gran medida su trabajo, al tener
todo concentrado en un solo lugar y de forma automática y concentrarse más en
el análisis de los datos, métricas y resultados.

== Implementación del modelo para predicciones

Adicionalmente, AutoML nos permite implementar nuestro modelo resultante
, por ejemplo, mediante un servicio web. Para ello, debemos regresar a nuestra
pantalla general del modelo y seleccionaremos la opción Implementar -> Servicio Web.

#figure(
  image("images/implement.png", width: 100%),
  caption: [Implementación de nuestro modelo en un servicio web.]
)

Posteriormente, configuraremos nuestra implementación:

#figure(
  image("images/conf_implement.png", width: 100%),
  caption: [Configuración de la implementación de nuestro modelo.]
)

Y, al dar clic en el botón "Implementar", volveremos a nuestra pantalla inicial,
donde se mostrará un aviso en color verde, donde menciona que la implementación
se ha desencadenado correctamente. Después de ello, debemos esperar
a que el estado de la implementación cambié de "En ejecución" a "Completado".

#figure(
  image("images/implement_status.png", width: 100%),
  caption: [Pantalla de estado de la implementación.]
)

Una vez que haya sucedido esto, podremos hacer el consumo de nuestro
modelo, a través del endpoint generado, siguiendo el repositorio:
https://github.com/Azure-Samples/rag-data-openai-python-promptflow/tree/main

#pagebreak()

= Reflexión

El Aprendizaje Automático Automatizado (AutoML) surge como una solución
para agilizar y optimizar el desarrollo de modelos. Actúa como un
"asistente experto" que entrena cientos de combinaciones de algoritmos
y configuraciones para encontrar la mejor opción para un conjunto
de datos específico.

*Ventajas de AutoML:*

- *Eficiencia:* Automatiza tareas tediosas como la selección
  de algoritmos (desde modelos lineales hasta redes neuronales o
  boosting como XGBoost), el ajuste de hiperparámetros y la validación
  cruzada.

- *Ingeniería de Características Automatizada:* Maneja automáticamente
  valores nulos, codificación de variables categóricas y
  escalado de datos numéricos.

- *Insights de los datos:* Genera análisis automáticos sobre los datos,
  como detecciones de desbalanceo de clases y cardinalidades.

- *Optimización del Talento:* Permite que los científicos de datos
  se concentren en el análisis de resultados y métricas estratégicas
  en lugar de en tareas operativas.

*Desventajas y Consideraciones de AutoML:*

- *Consumo de Recursos:* Dependiendo de la configuración y la complejidad
  de los datos, el proceso de entrenamiento automático puede durar horas.

- *Costo:* Al probar múltiples modelos en la nube, es fundamental
  monitorear el uso de máquinas virtuales para evitar costos imprevistos.

- *Necesidad de Supervisión:* Aunque automatiza gran parte del proceso,
  la calidad del modelo final sigue dependiendo de la calidad de los datos
  de entrada y de una correcta selección de métricas de desempeño
  por parte del usuario.

En conclusión, el uso de herramientas de AutoML en la nube representa
un salto significativo en la productividad, permitiendo pasar de
la carga y análisis de datos crudos a modelos implementados en
producción con una intervención manual mínima.

#pagebreak()

= Referencias
#set text(lang: "es")
#bibliography("refs.bib", style: "ieee", full: true, title: none)
