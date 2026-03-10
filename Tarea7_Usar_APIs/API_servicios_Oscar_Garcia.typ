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
  #text(font: title-font, size: 18pt, weight: "bold")[_Tarea 6: Crear sistemas de administración de Base de Datos en la nube_]
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

  #text(size: 11pt)[8 de marzo de 2026]
]

#pagebreak()

// ---------- After cover: restart numbering at 1 ----------

#outline(title: [Índice],depth: 3)
#pagebreak()

#let running_title = "Computación en la nube: Crear sistemas de administración de Base de de Datos en la nube"
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

= Prerrequisitos

Como paso inicial para la práctica, se descargó el cliente de
MySQL Workbench, de la página oficial. MySQL Workbench nos servirá
para conectarnos a nuestras bases de datos, así como para crear
nuestras estructuras y crear nuestros registros dentro de las
tablas creadas.

#link("https://www.mysql.com/products/workbench/")[*URL de la página oficial de MySQL Workbench*]

#pagebreak()

= Introducción

En el panorama tecnológico actual, los Sistemas de Administración de Bases de Datos (DBMS)
actúan como la columna vertebral de cualquier aplicación informática. Un manejador de base de
datos es un software diseñado para definir, crear, mantener y controlar el acceso a los datos,
permitiendo a los usuarios y aplicaciones interactuar con la información de manera estructurada y segura.
Su propósito principal es garantizar la integridad, consistencia y disponibilidad de los
datos.

A diferencia del almacenamiento tradicional en archivos locales, un DBMS moderno ofrece
mecanismos avanzados de consulta y gestión de transacciones. No obstante, la implementación
de estos sistemas ha evolucionado drásticamente con el cómputo en la nube. Mientras que los modelos
on-premises (en sitio) otorgan un control total, también conllevan una carga operativa
significativa en mantenimiento de hardware y escalabilidad.

Esta práctica se centra en la implementación de soluciones de bases de datos
bajo el modelo de Plataforma como Servicio (PaaS) en dos de los proveedores de nube más importantes:
Microsoft Azure y Google Cloud Platform (GCP). En esta práctica exploraremos
cómo configurar servidores flexibles, bases de datos y gestionar estructuras de datos de forma remota
utilizando clientes estándar como MySQL Workbench.

#pagebreak()

= Creación del manejador de base de datos en Azure

A continuación se mostrarán imágenes de la creación del manejador de base
de datos en Azure, así como la conexión a nuestra base de datos, la
creación de una tabla y la inserción de registros en nuestra tabla.

== Creación del manejador

El primer paso para crear el manejador es ingresar al portal de Azure,
dar clic en "Crear un recurso", "Bases de datos" y finalmente dar clic
en "Crear", debajo de Azure Database for MySQL Flexible Server

#figure(
    image("images/portal_azure_home.png", width: 100%),
    caption: [Azure Portal, creación de recurso Azure Database for MySQL Flexible Server.]
  )

Después daremos clic en "Creación Avanzada", para definir manualmente
una serie de configuración de nuestra base de datos.

#figure(
    image("images/creacion_avanzada.png", width: 100%),
    caption: [Pantalla de creación de base de datos.]
  )

A continuación se muestra la pantalla de configuración de nuestro
servidor flexible, donde aplicaremos lo siguiente:

#figure(
    image("images/servidor_flex_conf.png", width: 100%),
    caption: [Configuración inicial del servidor flexible.]
  )

- *Suscripción:* Seleccionaremos nuestra suscripción (Azure for Students).
- *Grupo de recursos:* Daremos clic en crear nuevo y definiremos uno nuevo con el nombre grupo-db.
- *Nombre del servidor:* Definiremos un nombre único para nuestro servidor (oeggtestdb).
- *Región:* Definiremos una región, de acuerdo a nuestras regiones disponibles.
- *Versión de MySQL:* Seleccionaremos la versión 8.0.
- *Tipo de carga de trabajo:* Seleccionaremos Desarrollo/pruebas.
- *Método de autenticación:* Seleccionaremos "Autenticación de MySQL" y definiremos uu usuario y contraseña.

Una vez configurado nuestro servidor flexible, daremos clic en
"Siguiente: Redes" o en la pestaña superior "Redes". En esta pantalla,
debemos verificar que el Método de conectividad tenga seleccionada la
opción "Acceso público (direcciones IP permitidas)".

Después, en el siguiente paso, en la sección Reglas de firewall, presionaremos
el enlace +Agregar 0.0.0.0 - 255.255.255.255. Esto permitirá que cualquier
usuario pueda acceder desde cualquier conexión a internet.

#figure(
    image("images/conn_conf.png", width: 100%),
    caption: [Configuración de Redes del servidor flexible.]
  )

Finalmente, podemos dar clic en el botón Revisar y crear. Ahí podemos verificar
el resumen de nuestra configuración y posteriormente dar clic en "Crear".

Después de que se haya creado el recurso, podemos dar clic en el botón
"Ir al recurso", donde podremos ver la información general de nuestro
servidor flexible. De esta pantalla, debemos guardar el dato que
se llama "Punto de conexión", ya que nos servirá más adelante para conectarnos.

#figure(
    image("images/serv_flexible_props.png", width: 100%),
    caption: [Información general de nuestro servidor flexible de Azure Database.]
  )

Posteriormente, nos dirigiremos a la sección Configuración -> Bases de datos. Se nos
abrirá una pantalla de "Bases de Datos". Ahí, daremos clic en "+ Agregar" y
definiremos un nombre para nuestra base de datos (E.g. compradores) y daremos clic
en "Guardar".

Una vez realizado esto, podremos ver que nuestra base de datos en el listado de
bases de datos. Este solo es el "esqueleto" de nuestra base de datos; la estructura
y los datos deben ingresarse desde otro entorno o aplicación como
MySQL Workbench.

#figure(
    image("images/bd_creada_azure.png", width: 100%),
    caption: [Base de datos compradores creada.]
  )

== Conexión desde MySQL Workbench

Ya que tenemos nuestra base de datos creada, iremos a nuestra aplicación
MySQL Workbench y daremos clic en el botón "+", que se encuentra
después del texto MySQL Connections.

En la creaeción de la conexión hacia el manejador de BD que tenemos
en azure, estableceremos los siguientes valores:

- *Connection name:* Colocar un nombre distintivo de la conexión. Es algo local, para identificar a dónde deseamos conectarnos (e.g. azure_compradores).
- *Hostname:* Es el nombre o IP del servidor donde está nuestro DBMS. Es el valor que copiamos en
  la sección anterior. En nuestro caso: oeggtestdb.mysql.database.azure.com
- *Username:* El usuario que creamos en la configuración del manejador (e.g. oeggadmin).

Después, presionaremos en el botón "Store in Keychain..." (o Store in Vault..) e
ingresaremos la contraseña del usuario administrador que definimos.

Finalmente, en *Default Schema* debemos indicar el nombre de la base
de datos a la que deseamos conectarnos, en este caso *compradores*. Daremos
clic en el botón "Test Connection", para verificar que la conexión puede
establecerse con éxito.

#figure(
    image("images/conn_azure.png", width: 100%),
    caption: [Conexión exitosa hacia nuestra base de datos en Azure.]
  )

Posteriormente, daremos clic en "Ok" y nos regresará a la pantalla
principal de la aplicación. Ahí, podremos ver listada nuestra nueva
conexión. Daremos clic en ella, para acceder a nuestra base de datos.

#figure(
    image("images/conn_azure_home.png", width: 100%),
    caption: [Conexión listada en la página principal de MySQL Workbench.]
  )

== Creación de nuestra estructura en base de datos

Una vez dentro de nuestra conexión, iremos a la pestaña "Schemas"
y daremos clic en el botón de "Creación de tabla" (5to botón
de izquierda a derecha que es una tabla con un signo +).

En la siguiente pantalla, definiremos nuestra tabla *clientes*, de la
siguiente forma y daremos clic en el botón *Apply*:

#figure(
    image("images/tabla_clientes.png", width: 100%),
    caption: [Tabla de clientes.]
  )

Aparecerá después un cuadro de diálogo indicando las sentencias SQL
que se enviarán al DBMS en la nube. Verificaremos y presionaremos
nuevamente *Apply*. Esto nos regresará nuevamente a nuestra página
principal, donde podremos ver en el árbol que se creó nuestra
nueva tabla.

== Inserción de registros en nuestra tabla clientes

Posteriormente daremos clic en el último botón, delante del nombre de nuestra tabla. Esto
nos abrirá una página donde se hará un *SELECT* de nuestra tabla
y nos permitirá manipular los datos.

#figure(
    image("images/select_clientes.png", width: 100%),
    caption: [Select a Tabla de clientes.]
  )

En el grid de resultados (parte inferior de la pantalla), podremos
ingresar los datos de nuestra tabla de "clientes". Como podemos
ver, no se define el idcliente, ya que está definido como un
auto-incremental.

#figure(
    image("images/insert_sql_clientes.png", width: 100%),
    caption: [Inserción de registros a Tabla de clientes.]
  )

Después de ingresar los datos, daremos clic en el botón *Apply*, para
mandar los datos a la nube. Aparecerá un cuadro de diálogo mostrando
nuevamente la sentencia SQL que se utilizará en el manejador. Daremos
clic nuevamente en *Apply* para ejecutarla.

Al tener éxito la transferencia de la información, aparecerá un mensaje
de confirmación. Presionaremos *Finish* para salir nuevamente a nuestra
página principal.

#figure(
    image("images/execute_sql_confirm.png", width: 100%),
    caption: [Confirmación de ejecución de sentencias SQL.]
  )

Al regresar a nuestra pantalla de trabajo, observaremos que nuestros
registros siguen ahí, pero ahora ya tienen un id asignado
por el manejador. Esto quiere decir que los datos ya se encuentran
en la nube.

#figure(
    image("images/datos_azure_nube.png", width: 100%),
    caption: [Datos insertados en nuestra base de datos.]
  )

== Anexo: URL del servidor flexible en Azure

A continuación se muestra la URL (punto de conexión) de nuestro servidor flexible. Sin embargo, es
posible que al momento de la revisión de esta guía, el servidor se
encuentre apagado o se haya borrado.

#link("oeggtestdb.mysql.database.azure.com")

= Creación del manejador de base de datos en Google Cloud Platform

A continuación se mostrarán imágenes de la creación del manejador de base
de datos en Google Cloud Platform, así como la conexión a nuestra base de datos, la
creación de una tabla y la inserción de registros en nuestra tabla.

== Creación del manejador

Entraremos a nuestra consola de Google Cloud y, en el menú de hamburguesa,
daremos clic en "Cloud SQL".

#figure(
    image("images/cloud_sql_menu.png", width: 100%),
    caption: [Menú de Google Cloud - Cloud SQL.]
  )

Una vez dentro de Cloud SQL, daremos clic en el botón "+ CREATE INSTANCE",
que se encuentra en la parte superior o en el botón que se
encuentra en la parte inferior de la página.

Después de dar clic, se nos mostrarán tres opciones con diferentes
tecnologías que pueden manejar SQL. Para nuestra práctica, elegiremos
MySQL, presionando el botón "Choose MySQL".

#figure(
    image("images/choose_mysql.png", width: 100%),
    caption: [Pantalla para seleccionar tecnología de nuestra BD.]
  )

Después, se nos mostrará la pantalla de configuración de nuestra instancia,
donde configuraremos lo siguiente:

#figure(
    image("images/conf_mysql_gcp.png", width: 100%),
    caption: [Configuración de instancia MySQL - GCP]
  )

- *Cloud SQL Edition:* Enterprise
- *Edition preset:* Sandbox
- *Database version:* Elegiremos la que sea igual a la que instalamos en MySQL Workbench (en mi caso, 8.0).
- *Instance ID:* Definiremos un identificador de la instancia. Podemos nombrarla como queramos (e.g. mysqldatabasetest)
- *Password:* Definiremos la clave principal de nuestro manejador. Esta clave se asignará como la clave del usuario root de MySQL.
- *Choose region and zone availability:* Dejarmeos la opción "Single Zone", que aparece por default.

Nos aseguraremos que, dentro de la sección "Instance IP assignment" esté
marcada la opción "Public IP", para que nuestro servidor de base de datos esté
disponible a través de internet.

Posteriormente daremos clic en el botón "Show configuration options", para ver y
configurar más parámetros. Expandiremos el menú "Connections", buscaremos
el campo "Authorized networks" y daremos clic en *Add a network*.

Se desplegará un apartado para editar la red, que permitiremos conectar
a nuestro manejador. Para aceptar cualquier conexión, debemos
colocar los valores siguientes:

- *Name:* Todas (es solo un identificador).
- *Network:* 0.0.0.0/0

Seleccionar la caja "I acknowledge the risks" y dar clic en el botón *DONE*.

#figure(
    image("images/network_gcp.png", width: 100%),
    caption: [Configuración de instancia MySQL - GCP]
  )

Con la configuración lista, podemos presionar el botón "CREATE INSTANCE"
para comenzar con el proceso de creación de nuestro manejador
de base de datos.

Una vez que finalice la creación, se mostrará un mensaje, indicando que
ha sido creada la instancia y que se encuentra lista para utilizar.

De igual forma, se mostrará la página del manejo de la instancia del manejador. Aquí,
podemos gestionar usuarios, conexiones, réplicas, etc. Por ahora, guardaremos
el dato que se muestra en *Public IP Address*, que nos servirá posteriormente
para conectarnos. En nuestro caso es: 35.233.135.214

#figure(
    image("images/public_ip_add.png", width: 100%),
    caption: [Datos de conexión de nuestra instancia - GCP]
  )

Después de haber revisado nuestros datos, nos moveremos al apartado "Users". En
esta página, podemos administrar los usuarios de nuestro manejador de base de datos. Siempre
es reocmendable que cada base de datos al menos tenga un usuario para su
manipulación. Presionaremos el botón *+ ADD USER ACCOUNT* para crearlo.

Crearemos un nuevo usuario (e.g. dbuser) y definiremos un password para él. Finalmente,
daremo s clic en *ADD* para finalizar la creación del usuario. Al finalizar el proceso,
podremos ver al usuario en la lista de usuarios.

#figure(
    image("images/user_created.png", width: 100%),
    caption: [Usuario creado en nuestra instancia - GCP]
  )


Ahora iremos al apartado "Databases", donde crearemos una base datos, preisonando
el botón *+ CREATE DATABASE*. En la sección de creación, solamente ingresaremos el nombre
de la base de datos (e.g. clientes) y daremos clic en *CREATE*.

Una vez finalizado el proceso de creación, podremos visualizar el nombre de
nuestra base de datos en el listado de bases de datos del manejador.

#figure(
    image("images/db_created.png", width: 100%),
    caption: [Base de datos creada en nuestra instancia - GCP]
  )

== Conexión desde MySQL Workbench

Después de esto, podemos ir a nuestra aplicación MySQL Workbench para
conectarnos a nuestra base de datos para crear nuestra estructura y poder
guardar nuestros datos.

Para ello, repetiremos los pasos que seguimos para conectarnos a nuestra
instancia de Azure, dando clic en el botón *+*, delante
de "MySQL Connections", donde definiremos nuestros datos de conexión:

- *Connection name:* Definiremos el nombre de nuestra conexión.
- *Hostname:* La IP que guardamos en la sección anterior, que corresponde a la IP pública de nuestro manejador.
  En nuestro caso, 35.233.135.214.
- *Username:* El usuario con el que deseamos conectarnos. Utilizaremos el super usuario del manejador (root).
- *Default schema:* La base de datos a la que nos queremos conectar; en nuestro caso, *clientes*.

Presionaremos el botón Store in Keychain...(o Store in Vault), para asignar una clave a utilizar con el usuario deifnido. Al
regresar al cuadro de diálogo, presionaremos el botón *Test Connection* para probar
que se puede establecer una conexión correcta. Si todo funciona correctamente, aparecerá
un mensaje indicando la conexión exitosa.

#figure(
    image("images/conn_gcp.png", width: 100%),
    caption: [Conexión exitosa a nuestra instancia de GCP.]
  )

Nuevamente al dar clic en "OK", se mostrará nuestra conexión en la página
principal de MySQL Workbench, donde daremos clic sobre esta, para conectarnos.

== Creación de nuestra estructura en base de datos

Una vez dentro, procederemos a repetir los pasos que seguimos para nuestra
base de datos en Azure.

1. Movernos a la pestaña de schemas para ver el listado de elementos asociados
  a nuestra base de datos: tables, views, stored procedures, etc.
2. Presionar el botón para *crear una nueva tabla* (el 5to de izquierda a derecha, en la barra de herramientas).

Al realizar estos pasos, aparecerá un apartado donde realizaremos el diseño
de la nueva tabla *empresas* en la base de datos, definiéndola de la siguiente manera:

#figure(
    image("images/table_empresas.png", width: 100%),
    caption: [Creación de nuestra tabla empresas.]
  )

== Inserción de registros en nuestra tabla empresas

Una vez finalizada la definición de nuestra tabla, podemos dar clic en *Apply*. Regresaremos a nuestro
espacio de trabajo, iremos a la pestaña "Schemas", donde veremos nuestra nueva
tabla dentro de la sección "Tables". Ahí, daremos clic en el tercer botoón que aparece frente al nombre de nuestra tabla empresas.

Se mostrará una ventana con un *SELECT* hacia nuestra tabla y, debajo de ella, se mostrará una
ventana para ingresar los datos. Definiremos nuestros datos de la siguiente forma:

#figure(
    image("images/insert_empresas.png", width: 100%),
    caption: [Inserción de registros en nuestra tabla empresas.]
  )

Después de ingresar los datos, presionaremos el botón *Apply* para guardar
los datos en la nube. Aparecerá una ventana con la sentencia SQL que se ejecutará
en el manejador de base de datos en la nube y daremos nuevamente clic
en *Apply*.

#figure(
    image("images/sql_insert_empresas.png", width: 100%),
    caption: [Inserción de registros en nuestra tabla empresas.]
  )

Si todo está correcto, aparecerá el mensaje de éxito en la ejecución de la
sentencia. Al regresar a la pantalla, podemos observar nuestros registros, que
ahora ya cuentan con un id asignado automáticamente por el manejador.

#figure(
    image("images/id_auto_empresas.png", width: 100%),
    caption: [Registros en tabla empresas con ID asignado.]
  )

Con esto, podemos dar por concluida la práctica de creación de manejadores
de base de datos en Azure y GCP.

#pagebreak()

= Reflexión

La realización de esta práctica permite concluir que la transición hacia sistemas
de administración de bases de datos en la nube representa una ventaja competitiva fundamental
para el desarrollo de software moderno. Al comparar la creación de recursos
en Azure Database for MySQL y Cloud SQL de GCP, se hace evidente que la nube simplifica tareas
que antes requerían días de configuración manual en infraestructura física.

== Ventajas y desventajas de los DBMS en la Nube

- *Ventajas*
  - *Escalabilidad Inmediata:* Capacidad de ajustar recursos de cómputo y almacenamiento según la demanda.
  - *Alta Disponibilidad:* Configuración de redundancia en diferentes zonas para evitar
    pérdidas de servicio.
  - *Reducción de Gastos Operativos:* Se elimina la necesidad de gestionar hardware físico,
    permitiendo enfocarse en la estructura de los datos.
  - *Seguridad y Respaldos:* Integración nativa de copias de seguridad automáticas y conexiones
    cifradas (TLS/SSL).

- *Desventajas:*
  - *Dependencia de Conectividad:* La gestión y el acceso dependen totalmente de una conexión a
    internet estable.
  - *Costos Variables:* Si no se monitorean adecuadamente, los costos por uso de recursos pueden
    incrementarse rápidamente.
  - *Latencia:* Dependiendo de la región elegida, puede existir un retardo mayor en comparación
    con una base de datos local.

En conclusión, la flexibilidad y facilidad que ofrecen herramientas como el "Flexible Server" de Azure o
las instancias administradas de GCP permite que proyectos de cualquier escala,
desde pruebas de desarrollo hasta aplicaciones empresariales de alto rendimiento,
cuenten con un respaldo robusto y seguro. La habilidad para conectar entornos locales
(como MySQL Workbench) con la infraestructura global de la nube es, sin duda, una competencia
esencial para cualquier especialista en manejo de datos (e.g. ingeniero de datos, científico
de datos, MLOps Engineer, etc.).

#pagebreak()

= Referencias
#set text(lang: "es")
#bibliography("refs.bib", style: "ieee", full: true, title: none)
