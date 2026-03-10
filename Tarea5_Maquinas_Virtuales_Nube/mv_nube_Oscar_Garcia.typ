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
  #text(font: title-font, size: 18pt, weight: "bold")[_Tarea 5: Crear Máquinas virtuales en la nube_]
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

  #text(size: 11pt)[1 de marzo de 2026]
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

La computación en la nube ha transformado la manera en que desplegamos
infraestructura tecnológica, permitiendo la transición de entornos locales
a soluciones escalables y globales.

En este contexto, una máquina virtual (MV) se define como un entorno de
computación basado en software que emula un ordenador físico, permitiendo
ejecutar sistemas operativos (como Ubuntu o Debian) y aplicaciones de forma
aislada sobre el hardware del proveedor de la nube.

*Beneficios de las MV en la nube:*

- *Escalabilidad y Flexibilidad:* Capacidad de elegir tamaños específicos
  de recursos (vCPU y memoria), como las series Standard_D2s_v3 en Azure
  o e2-micro en GCP, adaptándose a las necesidades del proyecto.

- *Accesibilidad Global:* Uso de direcciones IP públicas que permiten
  el acceso a servicios web desde cualquier parte del mundo.

- *Gestión de Costos:* Modelos de pago por uso y la facilidad de
  detener o eliminar recursos para evitar consumos innecesarios de créditos.

- *Seguridad y Aislamiento:* Implementación de reglas de firewall y
  puertos específicos (HTTP 80, SSH 22) para controlar el tráfico entrante.

*Desventajas y Consideraciones:*

- *Latencia:* Dependiendo la región seleccionada, el tiempo de respuesta
  puede variar según la ubicación del usuario final.

- *Riesgos de Costos Inadvertidos:* Si no se realiza una configuración, estrategia de uso, consumo,
  monitoreo, alertas, etc., se pueden generar cargos continuos que no se tienen presupuestados.

Dicho lo anterior, esta práctica pretende realizar una guía de cómo crear
máquinas virtuales dentro de 2 de los servicios de nube más populares: Azure y GCP.

Con esta guía, se demostrarán las ventajas que nos dan los servicios de nube,
la facilidad con la que se pueden crear máquinas virtuales, sin preocuparnos
por creación y configuración de infraestructura física, así como la facilidad
de desplegar un sitio web, dentro de ellas.

#pagebreak()

= Creación de una máquina virtual en Microsoft Azure

En esta sección se irá demostrando paso a paso el proceso para crear una máquina virtual
dentro de Microsoft Azure así como la carga de archivos para la creación
de nuestro sitio web, a través de una IP pública.

== Creación de la máquina virtual

Primero se accede al portal de Azure. Una vez dentro del portal, se da clic en el botón
"Crear un recurso".

#figure(
    image("images/Crear_recurso.png", width: 100%),
    caption: [Página de inicio de Azure Portal. Creando un recurso.]
  )

Posteriormente, se busca la opción de Máquinas virtuales
y se da clic en el link "Crear".

#figure(
    image("images/crear_mv.png", width: 100%),
    caption: [Menú de creación de recursos/Máquinas virtuales.]
  )

Después de haber dado clic en "_crear_" se desplegará la
página de creación de la máquina virtual,
donde se deberá configurar de la siguiente manera:



- *Suscripción:* Seleccionar la suscripción que se tiene ligada a la cuenta _Azure for Students_.
- *Grupo de recursos:* Dar clic en crear uno nuevo y ponerle el nombre "grupo-mv" (este nombre es opcional; se puede usar otro que sea crea más conveniente).
- *Nombre de la cuenta:* Definir un nombre para la máquina virtual: *personalazurewebserver*
- *Región:* Utilizar la guía para identificar las regiones disponibles para Azure for Students. En nuestro caso, fue Canada Central.
- *Zona:* Al momento de seleccionar el tamaño de la máquina virtual (más adelante), puede marcar un error. En ese caso, seleccionar una zona válida.
- *Imagen:* Asegurarse de enter una imagen Ubuntu, de preferencia *Ubuntu Server 24.04 LTS - x64 Gen2*

#figure(
    image("images/config_mv.png", width: 100%),
    caption: [Configuración de la máquina virtual.]
  )

- *Arquitectura de VM:* Seleccionar x64
- *Tamaño*: selecciona Standard_D2s_v3
- *Tipo de autenticación:* Seleccionar "contraseña" para poder acceder por medio de una clave y no sea necesario crear llaves SSH.
- *Nombre de usuario:* Ingresar el nombre webmasterazure (este usuario se utilizará para realizar las conexiones a la máquina).
- *Contraseña:* Ingresar una contraseña y confirmarla. No olvidarla, ya que será necesario en pasos posterirores, al querer hacer una conexión a la máquina.

Más abajo, dentro de la misma pantalla de configuración, nos encontraremos
con una sección "Reglas de puerto de entrada". En esta sección se debe
dar clic en el combo "Seleccionar puertos de entrada" y habilitar
las 3 opciones que aparecen: HTTP (80), HTTPS (443) y SSH(22). Estas
opciones nos permitirán abrir algunos puertos o canales de comunicación con
nuestra máquina virtual.

#figure(
    image("images/config_mv2.png", width: 100%),
    caption: [Configuración de la máquina virtual (cont.).]
  )

Una vez configurada nuestra máquina virtual, podemos dar clic en el botón
"Revisar y crear". Esto nos llevará a una pantalla de resumen, donde
podremos hacer una validación de la configuración que realizamos.

Una vez que aparezca el mensaje "Validación superada" y hayamos confirmado
nuestra configuración, podemos presionar el botón "Crear", para iniciar el proceso
de creación de la nueva máquina virtual.

#figure(
    image("images/resumen_mv_crear.png", width: 100%),
    caption: [Revisión y creación de máquina virtual.]
  )

Al finalizar el proceso de creación, aparecerá el mensaje "Se completó la implementación".
En este punto podmos presionar el botón "Ir al recurso" para ver la pantalla
de control de nuestra máquina virtual.

#figure(
    image("images/creacion_completa.png", width: 100%),
    caption: [Creación de la máquina virtual completa.]
  )

Al dar clic en el botón "Ir al recurso", podremos ver una pantalla como la que
se muestra a continuación. En esta pantalla, podemos ver diferentes datos de
nuestra máquina virtual; en esta ocasión, deberemos poner atención en la
dirección IP pública, ya que lo necesitaremos más adelante en el proceso.

#figure(
    image("images/info_general_vm.png", width: 100%),
    caption: [Pantalla de control de nuestra máquina virtual.]
  )

== Conexión a nuestra máquina virtual y configuración de servidor web

Una vez que está en funcionamiento nuestra máquina virtual, necesitamos un cliente
SSH para conectarnos a ella. En nuestro caso, como se cuenta con un equipo Mac,
procederemos a conectarnos via Terminal con el siguiente comando:

#raw(lang: "bash","ssh webmasterazure@[IP_de_nuestra_MV]")

Nos pedirá ingresar la contraseña que definimos en pasos anteriores y, una vez
ingresada, estaremos conectados a nuestra máquina virtual

#figure(
    image("images/ssh_mv_terminal.png", width: 100%),
    caption: [Conexión a nuestra máquina virtual, mediante Terminal (Mac).]
  )

Una vez conectados, procederemos a cambiarnos al entorno de super usuario y
a actualizar los paquetes de instalación, para poder acceder a las últimas
versiones de las aplicaciones. Para ello, ingresaremos los siguientes comandos:

#raw(lang: "bash","sudo su -root")

#raw(lang: "bash","apt_update")

#figure(
    image("images/root_apt_update.png", width: 100%),
    caption: [Pantalla después de cambiarnos al entorno de super usuario y actulizar los paquetes.]
  )

Al finalizar la actualización, es necesario instalar el servidor web
apache2, que nos permitirá desplegar nuestro sitio web, con la siguiente
instrucción:

#raw(lang: "bash","apt -y install apache2")

#figure(
    image("images/apache2_install.png", width: 100%),
    caption: [Instalación del servidor web apache2.]
  )

Una vez instalado el servidor web, podemos verificar su funcionamiento mediante
el comando:

#raw(lang: "bash","service apache2 status")

Si la instalación fue correcta, podremos ver un mensaje que dice "active(running)"

#figure(
    image("images/active_apache2.png", width: 100%),
    caption: [Verificación de estatus del servidor web apache2.]
  )

Una vez verificado el funcionamiento de nuestro servidor web, estableceremos
los permisos necesarios en el directorio de publicación del servidor web. Para esto,
ejecutaremos el siguiente comando:

#raw(lang: "bash","chmod 777 /var/www/html")

#figure(
    image("images/chmod_777.png", width: 100%),
    caption: [Aplicación de permisos sobre directorio.]
  )

== Carga de sitio web

Una vez completado lo anterior, podemos verificar que si utilizamos la IP pública
de nuestra máquina virtual en nuestro navegador web, ahora podemos ver que
es un servidor web y que despliega la página por defecto de apache.

#figure(
    image("images/apache_mv.png", width: 100%),
    caption: [Página por defecto de apache en IP pública.]
  )

Una vez comprobado lo anterior, abriremos nuestro cliente SFTP (En nuestro caso,
utilizamos Filezilla) y nos conectaremos a nuestra máquina virtual,
para poder realizar fácilmente la transferencia de archivos hacia ella.

#figure(
    image("images/Filezilla_conn.png", width: 100%),
    caption: [Conexión desde Filezilla hacia nuestra máquina virtual.]
  )

Una vez conectados, nos trasladaremos al directorio /var/www/html
y borraremos el archivo index.html que se encuentra dentro de ella. Una vez que
tengamos abierto el directorio, procederemos a arrastrar nuestros archivos desde
la ventana izquierda (nuestra máquina local), hacia la ventana derecha (el directorio
remoto de nuestra máquina virtual).

Si la transferencia es correcta, podremos ver
listados nuestros archivos en el directorio remoto.

#figure(
    image("images/copia_archivos_filezilla.png", width: 100%),
    caption: [Copia de archivos hacia nuestra máquina virtual.]
  )

== Visualización de sitio web

Finalmente, al haber transferido nuestro archivos satisfactoriamente, podemos
volver a nuestro navegador e introducir la dirección IP pública de nuestra máquina
virtual. Al hacer esto, podemos ver que nuestro sitio web se despliega correctamente.

#figure(
    image("images/sitio_web_azure.png", width: 100%),
    caption: [Sitio web, desplegado en nuestra máquina virtual, accedido via IP pública.]
  )

== Limpieza de recursos

Si queremos apagar nuestra máquina virtual para que no gaste créditos, debemos
ir al portal de Azure, usar el menú de "hamburguesa" y seleccionar
"Máquinas Virtuales".

Una vez dentro de "Máquinas virtuales", podemos seleccionar nuestra máquina virtual
y dar clic en el botón "Detener".

#figure(
    image("images/detener_mv.png", width: 100%),
    caption: [Pantalla de máquinas virtuales.]
  )

Después de unos segundos, podremos ver que el estatus de la máquina virtual
cambia a "Detenido (desasignado)"

Asimismo, podemos eliminar todos los recursos de Azure que está utilizando
la máquina virtual. Para ello, debemos ir nuevamente al menú de "hamburguesa"
y seleccionar "Grupos de recursos".

Una vez dentro de la pantalla de "Grupos de recursos", seleccionaremos
el grupo asociado a la máquina virtual (grupo-mv) y daremos clic en
"Eliminar grupo de recursos".

#figure(
    image("images/eliminar_grupo.png", width: 100%),
    caption: [Pantalla para eliminar grupo de recursos.]
  )

Se nos solicitará confirmar el nombre del grupo, para proceder con la eliminación
del mismo.

#figure(
    image("images/confirmar_eliminacion.png", width: 100%),
    caption: [Confirmación de eliminación de grupo de recursos.]
  )

Y, finalmente, después de confirmar y dar clic en el botón "Eliminar",
se nos regresará a la pantalla de "Grupo de recursos", donde, después de unos
segundos, se mostrará el mensaje de confirmación de la eliminación.

De esta forma, nuestra máquina virtual no generará ningún costo ni uso de
créditos.

#figure(
    image("images/mensaje_eliminacion.png", width: 100%),
    caption: [Mensaje de confirmación de eliminación de grupo de recursos.]
  )

#pagebreak()

== Anexo: Liga de sitio web público, en máquina virtual

A continuación se muestra la liga del sitio web público, dentro de la máquina virtual.

*Nota:* Se tuvo que repetir la práctica para crear nuevamente la máquina virtual, ya que
inicialmente se habían borrado los recursos, de acuerdo a la guía, pero después se
notó que se tenía que compartir la URL, por lo que es probable que no coincida la liga
del documento, con la mostrada en los screenshots.

#link("http://4.172.250.201/")[*URL pública del sitio web en Azure*]


= Creación de una máquina virtual en Google Cloud Platform

En esta sección se irá demostrando paso a paso el proceso para crear una
máquina virtual dentro de Google Cloud Platform (por medio de Google Skills)
así como la carga de archivos y la configuración para habilitar
nuestro sitio web, a través de una IP pública.

Como paso inicial, procederemos a comprimir los arhcivos de nuestro sitio web
en un único archivo .zip.

#figure(
    image("images/zip_archivos.png", width: 100%),
    caption: [Comprimir archivos de nuestro sitio web.]
  )

== Creación de la máquina virtual

Para iniciar con esto, ingresaremos a la plataforma de GCP, a través de
Google Skills, con el fin de tener un ambiente controlado que no afecte a
nada más dentro de nuestros proyectos y no se genere algún costo extra;
sin embargo, en un ambiente "real", el procedimiento será muy similar
al descrito en esta práctica.

#figure(
    image("images/pantalla_google_skills.png", width: 100%),
    caption: [Pantalla principal de Google Skills.]
  )

Una vez dentro de Google Skills, buscaremos el laboratorio "_Getting Started with Cloud Shell and gcloud_"
y dar clic en este; este laboratorio servirá como punto de entrada para poder tener un
ambiente controlado de Google Cloud Platorm.

#figure(
    image("images/laboratorio.png", width: 100%),
    caption: [Pantalla de búsqueda de laboratorio Google.]
  )

Al iniciar el laboratorio, ingresaremos las credenciales brindadas por Google y entraremos
a la consola directamente.

#figure(
    image("images/home_console.png", width: 100%),
    caption: [Pantalla inicial de la consola de Google.]
  )


En el menú del lado izquierdo, buscaremos "Compute Engine" y después
"VM Instances" y daremos clic.

#figure(
    image("images/vm_instances.png", width: 100%),
    caption: [Menú de Compute Engine - VM Instances.]
  )

Una vez dentro de la página "VM instances", procederemos a dar clic
en el botón "Create instance".

#figure(
    image("images/create_instance.png", width: 100%),
    caption: [Pantalla VM instances. Creación de una máquina virtual.]
  )

A continuación, configuraremos nuestra máquina virtual la siguiente forma:

#figure(
    image("images/machine_config.png", width: 100%),
    caption: [Pantalla de configuración de la máquina virtual.]
  )

#figure(
    image("images/machine_config2.png", width: 100%),
    caption: [Pantalla de configuración de la máquina virtual (cont.).]
  )

- *Name:* Elegir un nombre para nuestra máquina virtual. Se recomienda *vmpersonalwebserver*.
- *Region*: Aparecerá una región en este campo ya por defecto.
- *Zone*: Elegir una zona de las que están disponibles.
- *Serie:* Seleccionar la serie E2.
- *Machine type:* e2-micro (2 vCPU, 1GB memory), que es una máquina muy pequeña, pero
  cubre los requisitos mínimos para nuestro servidor web personal.

En la pestaña _OS and storage_, verificar que el size sea 10Gb y en image esté
"Debian GNU/Linuz 12 (bookworm)"; en caso de que no estén estos valores definidos,
presionar "Change" y actualizarlos.

#figure(
    image("images/os_storage.png", width: 100%),
    caption: [Configuración de sistema operativo y almacenamiento.]
  )

En la pestaña _Networking_, activar la opción para tráfico por HTTP (Allow HTTP
traffic).

#figure(
    image("images/http_traffic.png", width: 100%),
    caption: [Configuración de red.]
  )

En la pestaña _Security_, seleccionar "Allow default access", en caso de que no
esté seleccionado por defecto.

#figure(
    image("images/security.png", width: 100%),
    caption: [Configuración de seguridad.]
  )

Ahora podemos dar clic en el botón "Create". Nos llevará a la página de las instancias
y aparecerá el nombre de nuestra máquina virtual creada, donde también se podrá
observar que el proceso de creación se está ejecutando y podrá tomar unos
momentos para completarse.

== Conexión a nuestra máquina virtual y configuración del servidor web

Una vez que termine de crearse, aparecerá una palomita verde en la columna
_Status_. Una vez que se encuentre en este estado, es importante identificar los
siguientes valores:

- *El enlace con el nombre de la MV:* Este enlace sirve para ir a la página
  de configuración de la MV y poder ajustar algunos parámetros
  (en nuestro ejemplo vmpersonalwebserver)
- *Internal IP:* Es la IP que se maneja en la red interna de Google
  (en nuestro ejemplo 10.132.0.2)
- *External IP:* Es la IP pública por la cuál a través de internet se
  puede llegar a la MV (en nuestro ejemplo 34.53.234.195) aunque por el
  momento si das clic o la usas en un navegador todavía no tiene un servicio
  que pueda responder.
- *El botón SSH:* Permite abrir una página web con un entorno de terminal
  a través de SSH conectado a la MV para poder interactuar con el sistema operativo

#figure(
    image("images/vm_creada_gcp.png", width: 100%),
    caption: [Máquina virtual creada, con IPs y botón SSH.]
  )

A continuación, subiremos los archivos de nuestro sitio web, a la máquina virtual
recién creada. Procederemos a dar clic en el botón "SSH". Cuando se pregunte,
autorizar la conexión por SSH.

#figure(
    image("images/SSH_auth.png", width: 100%),
    caption: [Ventana de SSH. Autorización de SSH.]
  )

Una vez dentro de la ventana de SSH, procederemos a dar clic en el botón
"UPLOAD FILE" y seleccionaremos nuestro archivo ZIP, que creamos al inicio de
la sección.

#figure(
    image("images/upload_file.png", width: 100%),
    caption: [Ventana de SSH. Carga de archivo.]
  )

#figure(
    image("images/select_file.png", width: 100%),
    caption: [Seleccionar archivo a cargar.]
  )

Una vez hecho lo anterior, estableceremos nuestro usuario, como super usuario. Para
ello, es necesario ingresar la siguiente instrucción:

#raw(lang: "bash", "sudo su - root")

Y actualizaremos el gestor de paquetes:

#raw(lang: "bash", "apt update")

#figure(
    image("images/sudo_su_upd.png", width: 100%),
    caption: [Establecer nuestro usuario como super usuario y actualizar gestos de paquetes.]
  )

Después, realizaremos la instalación de nuestro servidor web, por medio de
la instrucción:

#raw(lang: "bash", "apt -y install apache2")

Podemos verificar que nuestro servidor se instaló correctamente y se encuentra
activo, por medio de la instrucción:

#raw(lang: "bash", "service apache2 status")

#figure(
    image("images/apache2_stat.png", width: 100%),
    caption: [Verificación de estatus de nuestro servidor apache2.]
  )

Una vez hecho esto, podemos utilizar nuestra IP pública en nuestro navegador
y veremos la página por defecto del servidor web, funcionando en nuestra
máquina virtual.

#figure(
    image("images/apache_def_mv.png", width: 100%),
    caption: [Página por defecto del servidor web, en nuestra máquina virtual.]
  )

== Carga de sitio web

Ahora podemos proceder a desplegar nuestro sitio web. Para ello, iniciaremos
instalando el programa "unzip", que nos permitirá descomprimir la carpeta
que cargamos a nuestra máquina virtual, usando el comando:

#raw(lang: "bash", "apt install unzip")

#figure(
    image("images/install_unzip.png", width: 100%),
    caption: [Instalación de programa unzip, dentro de nuestra máquina virtual.]
  )

Después, nos moveremos al directorio /var/www/html, con el comando:

#raw(lang: "bash", "cd /var/www/html")

#figure(
    image("images/cd_var.png", width: 100%),
    caption: [Cambio de directorio a /var/www/html.]
  )

Una vez dentro del directorio mencionado, moveremos nuestro archivo ZIP
hacia este mismo directorio, con el comando:

#raw(lang: "bash", "mv [home_path_de_nuestro_user]/[nombre_archivo].zip") .

Después de haber movido nuestro archivo al directorio actual, debemos
descomprimirlo y, cuando nos pregunte si queremos reemplazar el archivo index.html,
responder "y".

#figure(
    image("images/unzip_arch.png", width: 100%),
    caption: [Descomprimir archivo ZIP en nuestro directorio.]
  )

== Visualización de sitio web

Finalmente, podemos verificar nuevamente en nuestro navegador que nuestro sitio
web se despliega de forma correcta y podemos dar por concluida la práctica.

#figure(
    image("images/sitio_mv.png", width: 100%),
    caption: [Sitio web, desplegado en nuestra máquina virtual, accedido via IP pública.]
  )

En esta ocasión, no haremos una limpieza de recursos ya que, como se mencionó
al inicio de la sección, esto se realizó dentro de un laboratorio de Google
Skills, que es un ambiente efímero y se destruye al terminar el tiempo definido
para el mismo.

#pagebreak()

= Reflexión

La creación de máquinas virtuales en plataformas líderes
como Microsoft Azure y Google Cloud Platform (GCP) demuestra la
madurez del cómputo en la nube. A través de este ejercicio práctico,
se observa que, aunque las interfaces varían, los principios fundamentales
son consistentes: aprovisionamiento de recursos, configuración de red
y despliegue de servicios.

El proceso de conectar una máquina local con una remota mediante
protocolos como SSH y SFTP (usando herramientas como Filezilla o la Terminal)
es fundamental para la labor de un ingeniero moderno.

Esta práctica no solo permite desplegar un portafolio personal de manera
profesional , sino que también enseña la responsabilidad operativa
de gestionar el ciclo de vida de la infraestructura, desde la creación
hasta la eliminación total de los recursos para garantizar
la eficiencia financiera.

En conclusión, la nube democratiza el acceso a potencia de cómputo
que antes era exclusiva de grandes centros de datos, permitiendo
a cualquier usuario desplegar aplicaciones robustas en cuestión de minutos.

#pagebreak()

= Referencias
#set text(lang: "es")
#bibliography("refs.bib", style: "ieee", full: true, title: none)
