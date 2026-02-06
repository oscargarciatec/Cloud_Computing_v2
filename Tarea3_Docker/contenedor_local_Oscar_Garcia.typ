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
  #text(font: title-font, size: 18pt, weight: "bold")[_Tarea 3: Crear un contenedor Docker_]
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

  #text(size: 11pt)[8 de febrero de 2026]
]

#pagebreak()

// ---------- After cover: restart numbering at 1 ----------

#outline(title: [Índice],depth: 3)
#pagebreak()

#let running_title = "Computación en la nube: Crear una máquina virtual de manera local"
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

En el ámbito del desarrollo de software moderno y la computación en la nube, la eficiencia y la portabilidad son pilares fundamentales.
Este reporte detalla el proceso técnico para el despliegue de una aplicación web utilizando la contenerización,
una tecnología que permite empaquetar una aplicación junto con todas sus dependencias, librerías y archivos de configuración en una unidad aislada.

El objetivo de esta práctica es demostrar el uso de Docker, la plataforma líder en el mercado para la creación y gestión de contenedores.
A diferencia de la virtualización tradicional, la contenerización ofrece un entorno ligero que garantiza
que el software se ejecute de la misma manera en cualquier infraestructura.

A lo largo del documento, se describe la instalación de Docker Desktop, la personalización de un sitio web,
la construcción de una imagen personalizada basada en el servidor Apache y la puesta en marcha de un contenedor funcional que albegará
nuestro sitio web.


#pagebreak()

= Capturas de pantalla de los ejercicios realizados

En esta sección se irá demostrando paso a paso el proceso para descargar e instalar Docker en nuestras computadoras personales, crear una imagen para nuestro
contenedor, crear nuestro contenedor y desplegar una página web dentro del mismo.

== Descarga e instalación de Docker

A continuación, se muestran los pasos que se siguieron para descargar e instalar el programa Docker, que nos permitirá
crear nuestro contenedor de una manera fácil e intuitiva.

Primero, se tiene que acceder a la página oficial de Docker y descargar el archivo correspondiente al sistema operativo donde se instalará. En mi caso,
se trata de un sistema operativo MacOs (Apple Sillicon), por lo que corresponde el link seleccionado en la imagen.

#figure(
    image("images/Docker_download.png", width: 100%),
    caption: [Página de descarga de Docker.]
  )

Una vez descargado el archivo .dmg, se procede a moverlo a nuestra carpeta de Aplicaciones, para terminar la instalación.

#figure(
    image("images/Docker_app.png", width: 100%),
    caption: [Completar instalación de Docker.]
  )

Después de completar la instalación, procedemos a abrir la aplicación, desde nuestra carpeta de Aplicaciones.

#figure(
    image("images/Docker_app_folder.png", width: 100%),
    caption: [Docker dentro de la carpeta de aplicaciones.]
  )

En mi caso, ya contaba con una instalación previa de docker y algunas imágenes creadas, por lo que mi página principal se ve de la siguiente forma:

#figure(
    image("images/Home_docker.png", width: 100%),
    caption: [Página inicial de Docker.]
  )

Como podemos observar, Docker cuenta con diferentes secciones dentro de su menú; una dedicada a imágenes base, otra dedicada a contenedores y otra
dedicada a los volúmenes de datos que utilizaremos dentro de nuestros contenedores.

== Personalización del sitio web

Ya que tenemos instalado Docker, podemos centrarnos en nuestra página web. El primer paso es descargar nuestro _template_
a utilizar para nuestra página web.

#figure(
    image("images/web_template_download.png", width: 100%),
    caption: [Template de página web, recuperado desde: https://htmltemplates.co/free-website-templates/minimal-personal-portfolio-free-portfolio-html-template.]
  )

Después de descargar el archivo ZIP y guardarlo en nuestra computadora, podemos descomprimirlo. Ahí, podemos notar un archivo llamado "index.html"
que es el archivo que contiene toda la estructura de nuestra página. Podemos abrir este archivo en nuestro navegador preferido para ver el estado actual; sin embargo,
después es necesario abrirlo en un editor de texto (en nuestro caso fue en Antigravity) y una vez identificados los bloques de nuestra página,
podemos hacer las modificaciones pertinentes sobre nombres, descripciones, imágenes, etc.

#figure(
    image("images/web_template_start.png", width: 100%),
    caption: [Estado inicial de nuestra página web.]
  )

#figure(
    image("images/web_template_first_change.png", width: 100%),
    caption: [Archivo HTML modificado en nuestro editor de texto.]
  )

#figure(
    image("images/web_template_local_changes.png", width: 100%),
    caption: [Cambios en el nombre, descripción e imagen inicial.]
  )

#figure(
    image("images/web_template_local_changes_2.png", width: 100%),
    caption: [Cambios en la descipción e imagen en sección About.]
  )

#figure(
    image("images/web_template_local_changes_3.png", width: 100%),
    caption: [Cambios en textos de sección My Services.]
  )

#figure(
    image("images/web_template_local_changes_4.png", width: 100%),
    caption: [Cambios en Testimonials y Blog.]
  )

#figure(
    image("images/web_template_local_changes_5.png", width: 100%),
    caption: [Cambios en Contact.]
  )

Una vez que hicimos todos los cambios al template de nuestra página web y estamos satisfechos con los resultados, debemos pasar todo el contenido
a una carpeta public-html, que servirá posteriormente para desplegar nuestra página web dentro de nuestro contenedor.

#figure(
    image("images/public_html_web.png", width: 100%),
    caption: [Copia de los archivos de nuestra página web a directorio public-html.]
  )

Adicionalmente, podemos mover esta nueva carpeta al directorio de nuestra conveniencia y, finalmente, procedemos a crear un archivo Dockerfile. Un archivo
Dockerfile es un archivo de "configuración" que contiene una serie de instrucciones que Docker ejecuta automáticamente en orden para configurar un contenedor.
En este archivo se puede definir la imagen a utilizar, la copia de archivos, ejecución de comandos en terminal, etc. que sirvan para replicar el entorno
en cualquier otra computadora.

Dicho esto, el contenido de nuestro Dockerfile es simple y se muestra a continuación:

#figure(
    image("images/dockerfile_create.png", width: 100%),
    caption: [Creación de nuestro archivo Dockerfile en el mismo directorio que nuestra carpeta public-html.]
  )

Como podemos ver, nuestro Dockerfile tiene dos líneas:

1) La línea FROM, que nos indica cuál imagen se utilizará al momento de crear nuestro contenedor: httpd:2.4

2) La línea COPY, que indica que debe copiar todos los archivos dentro de la carpeta public-html (local) al directorio /usr/local/apache2/htdocs
  en nuestro contenedor.

== Crear una imagen con el sitio personalizado

Como ya tenemos nuestra página web personalizada, podemos proceder a crear nuestra imagen que se utilizará dentro de nuestro contenedor,
que contenga nuestro sitio personalizado.

El primer paso es abrir una terminal en nuestra computadora.

#figure(
    image("images/terminal.png", width: 100%),
    caption: [Terminal en MacOS.]
  )

Una vez abierta la terminal, podemos navegar a la carpeta donde se encuentra nuestro directorio public-html y el archivo Dockerfile,
utilizando el comando cd \<ruta_de_nuestro_directorio\>

#figure(
    image("images/cd_ruta.png", width: 100%),
    caption: [Cambiar de ruta, usando el comando cd.]
  )

Una vez que nos encontramos en el directorio, utilizamos el comando _docker build_ para crear nuestra imagen, como se muestra a continuación:

#figure(
    image("images/docker_build.png", width: 100%),
    caption: [Ejecución de comando docker_build para crear nuestra imagen.]
  )

Adicionalmente, como se puede observar, se utilza una parámetro -t, que nos permite indicar un nombre y etiqueta (tag) de la imagen, que en nuestro caso
nombramos apache-portafolio-web, con el tag 1.0. El . del final se escribe con el fin de utilizar todos los archivos que se encuentran en la ruta
en la que nos encontramos, incluyendo el Dockerfile, que contiene las instrucciones específicas de la versión del servidor, así como de los
archivos que tiene que copiar a la imagen.

Una vez que se haya ejecutado correctamente el comando anterior, podemos verificar que aparezca nuestra imagen en nuestro
dashboard de Docker. Asimismo podemos verificar que, hasta este punto, solamente se creó la imagen y no el contenedor, que se
creará en la siguiente sección.

#figure(
    image("images/docker_image_created.png", width: 100%),
    caption: [Imagen apache-portafolio-web creada.]
  )

  #figure(
      image("images/container_not_created.png", width: 100%),
      caption: [Sección de contenedores en Docker.]
    )

#pagebreak()

== Crear el contenedor

Ya que tenemos nuestra imagen creada, como se mostró en la sección anterior, podemos proceder con la creación de nuestro contenedor. Para esto,
también utilizaremos nuestra terminal y ejecutaremos el comando (*Nota*: se cambió al puerto 8081, ya que ya existe otro contenedor corriendo en este puerto):

#raw(lang: "bash", "docker run -dit --name portafolio-web-container -p 8081:80 apache-portafolio-web:1.0")

Este comando se puede desglosar en los siguientes pasos:

1) _docker run_ es el comando de creación y ejecución del contenedor

2) -dit son las "banderas" utilizadas para el comando.
  - d: Detached, que ejecuta el contenedor en segundo plano; es decir, una vez ejecutado el comando, podemos seguir utilizando nuestra terminal y no seguimos viendo los logs del contenedor, sin poder utilizarla.
  - i: Interactive, que mantiene abierto el canal de entrada estándar del contenedor. Esto permite que el contenedor pueda recibir comandos.
  - t: TTY, que asigna una terminal virtual al contenedor. Esto simula una pantalla de terminal real, lo que permite que programas como bash o sh funcione correctamente.

Gracias a estas banderas, una vez que el contenedor arranca, no se apaga al instante, al simular que tiene una terminal abierta. De esta forma,
nuestro sitio web permancerá activo, mientras el contenedor esté encendido.

#figure(
    image("images/docker_run.png", width: 100%),
    caption: [Comando docker run ejecutado en terminal.]
  )

Una vez que ejecutamos este comando, podemos verificar en Docker que, efectivamente, se creó nuestro contenedor y que está corriendo:

#figure(
  image("images/container_created.png", width: 100%),
    caption: [Contenedor creado dentro de Docker.]
  )

= Resultados obtenidos

Finalmente, podemos ir a la dirección localhost:8081 (recordemos que se cambió, referente al manual proporcionado) y podremos
ver nuestro sitio web en acción.

#figure(
    image("images/website_docker.png", width: 65%),
    caption: [Sitio web ejecutándose desde localhost, en el puerto 8081.]
  )

Como un comentario final, me gustaría mencionar que se tuvo que hacer un ajuste al archivo Dockerfile, ya que el copiado de archivos no
sobreescribía los archivos por default que se creaban al instalar el server (carpeta assets y archivo index.html), por lo que no se
mostraba el sitio web creado por nostros, sino uno default que simplemente mostraba la leyenda "It works!".

#figure(
    image("images/updated_dockerfile.png", width: 100%),
    caption: [Archivo Dockerfile actualizado.]
  )

Al finalizar este proceso, podemos concluir que se lograron los siguientes resultados de forma satisfactoria:
  1. Se descargó e instaló la aplicación Docker en nuestra computadora personal.
  2. Se personalizó la plantilla de nuestro sitio web, por medio de un editor de texto.
  3. Se creó una imagen personalizada de un servidor web Apache, en su versión 2.4, y se copiaron
  los archivos correspondientes a nuestro sitio web, a partir de un archivo Dockerfile.
  4. Se creó un contenedor, a partir de la imagen creada en el punto anterior y se expuso el puerto 8081, para
  poder visualizar nuestro sitio web, a través de cualquier navegador web.
  5. Se comprobó que el contenedor opera de forma independiente al sistema operativo base, consumiendo una fracción mínima de recursos
  , comparado con la máquina virtual creada en la práctica anterior, manteniendo así, una respuesta ágil del servidor web.

#pagebreak()

= Reflexión

La realización de esta práctica permite contrastar las ventajas de la contenerización frente a otros modelos de despliegue.
Docker se presenta como una herramienta indispensable en el flujo de trabajo de un ingeniero de IA o software, ya que resuelve el problema
clásico de "en mi máquina sí funciona" al estandarizar el entorno de ejecución (versiones, librerías, paquetes, rutas, etc.).

Al igual que se mencionó en la práctica anterior, la creación de contenedores también tiene sus ventajas y desventajas, que se listarán a continuación:

*Ventajas*:

1. Destaca su ligereza, ya que los contenedores comparten el núcleo del sistema operativo anfitrión, permitiendo encender servicios en segundos.
2. Escalabilidad superior, facilitando el despliegue de microservicios.
3. Estandarización del entorno de ejecución y, por lo tanto, minimización de falles entre ambientes.

*Desventajas*
1. La principal limitación reside en que todos los contenedores deben compartir el mismo sistema operativo base (kernel)
  , lo que puede representar un reto de seguridad si no se gestionan correctamente los permisos de aislamiento.

*Próximos Pasos*

Como evolución natural de este ejercicio, los siguientes pasos consistirían en la orquestación de contenedores.
Mientras que Docker gestiona contenedores individuales, herramientas como Kubernetes o Docker Swarm permiten administrar clústeres
enteros de contenedores, gestionando automáticamente su disponibilidad, balanceo de carga y actualizaciones en entornos de producción a gran escala.
Esta práctica sienta las bases necesarias para comprender arquitecturas nativas de la nube más complejas.

#pagebreak()

= Referencias
#set text(lang: "es")
#bibliography("refs.bib", style: "ieee", full: true, title: none)
