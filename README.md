<div id="table-of-contents">
<h2>&Iacute;ndice</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#org6899ef9">1. nikola.el</a>
<ul>
<li><a href="#org5fffca1">1.1. English</a>
<ul>
<li><a href="#orgb44a49b">1.1.1. About</a></li>
<li><a href="#org46a6fa6">1.1.2. Requirements</a></li>
<li><a href="#org3d1d2f5">1.1.3. Install</a></li>
<li><a href="#orgcbae840">1.1.4. Configuration</a></li>
<li><a href="#org4c1017c">1.1.5. Advanced usage</a></li>
<li><a href="#orge56f6e0">1.1.6. License</a></li>
<li><a href="#orgb01d227">1.1.7. Bugs, patches and feature requests</a></li>
</ul>
</li>
<li><a href="#org145399f">1.2. Castellano</a>
<ul>
<li><a href="#org5384662">1.2.1. Acerca de</a></li>
<li><a href="#org3cb3be4">1.2.2. Requisitos</a></li>
<li><a href="#orgdf6cce5">1.2.3. Instalar</a></li>
<li><a href="#org286c2aa">1.2.4. Configuración</a></li>
<li><a href="#orgf51f68d">1.2.5. Uso avanzado</a></li>
<li><a href="#orgd0e956b">1.2.6. Bugs, parches y solicitudes de características</a></li>
</ul>
</li>
</ul>
</li>
</ul>
</div>
</div>


<a id="org6899ef9"></a>

# nikola.el


<a id="org5fffca1"></a>

## English


<a id="orgb44a49b"></a>

### About

Nikola is a static site generator. If you don't know what it is, you should probable learn about it on [their site](https://getnikola.com) and then come back here. Nikola.el is a simple wrapper around nikola. Right now, it allows you to create a site, create posts and pages, build, deploy, start/stop the webserver and execute hooks.

As said, it supports creating posts, but I recommend the awesome package [org2nikola](https://github.com/redguardtoo/org2nikola).

<a id="org46a6fa6"></a>

### Requirements

The extras package is recommended but not necessary.

    sudo pip3 install Nikola Nikola[extras]

Also, emacs-async is necessary. you can install it from elpa with `M-x package-install RET async RET`.


<a id="org3d1d2f5"></a>

### Install

You can installl from Melpa for a stable release or from the git repository, which may be experimental.

    git clone https://git.daemons.it/drymer/nikola.el ~/.emacs.d/lisp/nikola.el

[![img](http://melpa.org/packages/nikola-badge.svg)](http://melpa.org/#/nikola)


<a id="orgcbae840"></a>

### Configuration

A minimal configuration would be this.

    (add-to-list 'load-path "~/.emacs.d/lisp/nikola.el/")
    (require 'nikola)
    (setq nikola-output-root-directory "~/Documents/blog/")

For a more advanced configuration check the next chapter.


<a id="org4c1017c"></a>

### Advanced usage

1.  Main commands:

    -   `nikola-init`: Creates a default site and opens the file **conf.py** to edit it.

    -   `nikola-new-post`: Creates a new post on **nikola-output-root-directory/posts/** and opens it.

    -   `nikola-new-page`: Creates a new page on **nikola-output-root-directory/stories/** and opens it.

    -   `nikola-build`: Builds the site.

    -   `nikola-start-webserver`: Starts webserver.

    -   `nikola-stop-webserver`: Stops webserver.

    -   `nikola-deploy`: Deploys the site.

    -   `nikola-version`: Shows nikola and nikola.el version.

2.  Variables:

    -   `nikola-command`: The nikola command (no shit, Sherlock). It shouldn't be necessary to change it if it's on the PATH.

    -   `nikola-output-root-directory`: Nikola's default directory.

    -   `nikola-verbose`: If set to **t**, it will create a buffer called **&lowast;Nikola&lowast;** with the output of all commands. Set to **nil** by default.

    -   `nikola-webserver-auto`: If set to **t**, it will use `nikola auto` to launch the webserver. If set to **nil**, it will use `nikola serve`. Set to **nil** by default.

    -   `nikola-webserver-host`: Set it to **0.0.0.0** if you want to make the webserver accesible from outside the machine. Set to **127.0.0.1** by default.

    -   `nikola-webserver-port`: Nikola's webserver port. Set to **8000** by default.

    -   `nikola-webserver-open-browser-p`: If set to **t**, opens xdg defined browser.

    -   `nikola-deploy-input`: If **nil**, just execute plain deploy, if **t**, asks for user input, **any string** is passed to the deploy string automatically.

        This variable is intended to use with a deploy script or command that uses git, thus needs a commit message. It could be used for whatever other reason, also. To use the message writed on emacs on the deploy order, you have to use the variable **$COMMIT**. For example, your deploy command could be:

        DEPLOY_COMMANDS = {
             'default': [
                 "git add .", "git commit -m \"$COMMIT\"", "git push"
             ]
         }

    Set to **nil** by default.

    -   `nikola-deploy-input-default`: If `nikola-deploy-input` is **t**, this variable changes the default value so you can just press RET. Set to **New post** by default.

    -   `nikola-new-post-extension`: The extension of new posts. If it's a list, ido completion will be offered. Set to **html** by default.

    -   `nikola-new-page-extension`: The extension of new pages. If it's a list, ido completion will be offered. Set to **html** by default.

3.  Hooks:

    Use them as you would usually do.

    -   `nikola-build-before-hook`: Hook executed before nikola-build.

    -   `nikola-build-after-hook`: Hook executed after nikola-build.

    -   `nikola-deploy-before-hook`: Hook executed before nikola-deploy.

    -   `nikola-deploy-after-hook`: Hook executed after nikola-deploy.

    If you only want to execute a simple script or command before or after building or deploying, you can set the next variables to that script's path or command:

    -   `nikola-build-before-hook-script`: Path of a script to execute before building the site.

    -   `nikola-build-after-hook-script`: Path of the script to execute after building the site.

    -   `nikola-deploy-before-hook-script`: Path of the script to execute before deploying the site.

    -   `nikola-deploy-after-hook-script`:Path of the script to execute after deploying the site.

    For example, to execute a script before deploying:

        (setq nikola-deploy-before-hook-script "~/scripts/pre-deploy.sh")

    For more complicated things, you should use create a function and add id a hook.

4.  Complete example

        (use-package nikola
          :load-path "~/.emacs.d/lisp/nikola.el/"
          :config
          (setq nikola-output-root-directory "~/Documents/blog/")
          (setq nikola-verbose t)
          (setq nikola-webserver-auto nil)
          (setq nikola-webserver-host "0.0.0.0")
          (setq nikola-webserver-port "8080")
          (setq nikola-webserver-open-browser-p t)
          (setq nikola-deploy-input t)
          (setq nikola-deploy-input-default "New article")
          (setq nikola-build-before-hook-script (concat nikola-output-root-directory "scripts/pre-build.sh"))
          (setq nikola-build-after-hook-script (concat nikola-output-root-directory "scripts/post-build.sh"))
          (setq nikola-deploy-after-hook-script "nikola iarchiver"))


<a id="orge56f6e0"></a>

### License

    Author:: drymer <drymer [ AT ] autistici.org>
    Copyright:: Copyright (c) 2016, drymer

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or (at
    your option) any later version.

    This program is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.


<a id="orgb01d227"></a>

### Bugs, patches and feature requests

If you find a bug, have a patch or have a feature request, you may send an e-mail to the address in the previous section or go to [<https://git.daemons.it/drymer/nikola.el/>](https://git.daemons.it/drymer/nikola.el/)


<a id="org145399f"></a>

## Castellano


<a id="org5384662"></a>

### Acerca de

Nikola es un generador de páginas web estáticas. Si no sabes que es, probablemente deberías aprender sobre ello en [su página web](https://getnikola.com) y luego volver aquí. Este paquete es un frontend simple alrededor de nikola. En este momento, permite crear un sitio web, crear articulos y páginas, construirlo, desplegarlo, iniciar/detener el servidor web y ejecutar ganchos (hooks).

Como se ha dicho, soporta la creación de articulos, pero recomiendo el fantástico paquete [org2nikola](https://github.com/redguardtoo/org2nikola).


<a id="org3cb3be4"></a>

### Requisitos

Es recomendable instalar el paquete de extras, pero no es necesario.

    sudo pip install Nikola Nikola[extras]

Además, `emacs-async` es necesario. Puede instalarse desde elpa con `M-x paquete-instalar RET async RET`.


<a id="orgdf6cce5"></a>

### Instalar

Se puede instalar desde Melpa para tener una versión estable o desde el repositorio git, que puede ser inestable.

    git clone https://git.daemons.it/drymer/nikola.el ~/.emacs.d/lisp/nikola.el/

[![img](http://melpa.org/packages/nikola-badge.svg)](http://melpa.org/#/nikola)


<a id="org286c2aa"></a>

### Configuración

Una configuración minimalista sería la siguiente.

    (add-to-list 'load-path "~/.emacs.d/lisp/nikola.el/")
    (require 'nikola)
    (setq nikola-output-directory-root "~/Documents/blog/")

Para una configuración más avanzada hay que consultar la sección siguiente.


<a id="orgf51f68d"></a>

### Uso avanzado

1.  Comandos principales:

    -   `nikola-init`: Crea un sitio predeterminado y abre el archivo **conf.py** para editarlo.

    -   `nikola-new-post`: Crea una nueva entrada en nikola-output-root-directory/posts/ y la abre.

    -   `nikola-new-page`: Crea una nueva página en nikola-output-root-directory/stories/ y la abre.

    -   `nikola-build`: Crea el sitio.

    -   `nikola-start-webserver`: Inicia el servidor web.

    -   `nikola-stop-webserver`: Detiene el servidor web.

    -   `nikola-deploy`: Despliega el sitio.

    -   `nikola-version`: Muestra las versiones nikola y nikola.el.

2.  Variables:

    -   `nikola-command`: La ruta de la orden **nikola**. No debería ser necesario cambiarlo si está en el PATH.

    -   `nikola-output-root-directory`: Directorio predeterminado de Nikola.

    -   `nikola-verbose`: Si se establece en **t**, creará un buffer llamado **&lowast;Nikola&lowast;** con la salida de todas las ordenes. Establecido en **nil** de forma predeterminada.

    -   `nikola-webserver-auto`: Si se establece en **t**, utilizará `nikola auto` para iniciar el servidor web. Si se establece en **nil**, utilizará **nikola server**. Establecido en **nil** de forma predeterminada.

    -   `nikola-deploy-input`: Si es **nil**, solo ejecuta la orden de despliegue, si es **t**, pide que se entre un mensaje, **cualquier mensaje** se pasa como variable **$COMMIT**.

        Esta variable está pensada para ser usada con un script de despliegue o una orden que use git, por lo que necesita un mensaje de commit, aunque podria usarse para cualquier otra cosa. Para usar el mensaje escrito en el minibuffer de emacs en la orden de despliegue, tienes que usar la variable $COMMIT. Por ejemplo, su comando deploy podría ser:

        DEPLOY_COMMANDS = {
            'default': [
                "git add .", "git commit -m \"$COMMIT\"", "git push"
            ]
        }

    Establecido en **nil** de forma predeterminada.

    -   `nikola-deploy-input-default`: Si `nikola-deploy-input` es **t**, esta variable cambia el valor por defecto de modo que sólo hay que pulsar RET. Establecido en **New post** por defecto.

    -   `nikola-new-post-extension`: La extensión de los nuevos articulos. Si es una lista, se ofrecerá autocompletado con ido. Establecido en **html** de forma predeterminada.

    -   `nikola-new-page-extension`: La extensión de las nuevas páginas. Si es una lista, se ofrecerá autocompletado con ido. Establecido en **html** de forma predeterminada.

3.  Ganchos

    Se usan como se haria habitualmente.

    -   `nikola-build-before-hook`: Gancho ejecutado antes de `nikola-build`.

    -   `nikola-build-after-hook`: Gancho ejecutado después de `nikola-build`.

    -   `nikola-deploy-before-hook`: Gancho ejecutado antes de `nikola-deploy`.

    -   `nikola-deploy-after-hook`: Gancho ejecutado después de `nikola-deploy`.

    Si sólo desea ejecutar un script o comando simple antes o después de crear o desplegar, se puede establecer las siguientes variables en la ruta del script o la orden:

    -   `nikola-build-before-hook-script`: Ruta del script u órdenes a ejecutar antes de construir el sitio.

    -   `nikola-build-after-hook-script`: Ruta del script u órdenes a ejecutar después de construir el sitio.

    -   `nikola-deploy-antes-hook-script`: Ruta del script u órdenes a ejecutar antes de desplegar el sitio.

    -   `nikola-deploy-after-hook-script`: Ruta del script u órdenes a ejecutar después de desplegar el sitio.

        Por ejemplo, para ejecutar un script antes del despliegue:

        (setq nikola-deploy-before-hook-script "~/scripts/pre-deploy.sh")

    Para cosas más complejas, deberia usarse una función y agregarlo como un gancho.

4.  Ejemplo completo

        (use-package nikola
          :load-path "~/.emacs.d/lisp/nikola.el/"
          :config
          (setq nikola-output-directory-root "~/Documents/blog/")
          (setq nikola-verbose t)
          (setq nikola-webserver-auto nil)
          (setq nikola-webserver-host "0.0.0.0")
          (setq nikola-webserver-port "8080")
          (setq nikola-webserver-open-browser-p t)
          (setq nikola-deploy-input t)
          (setq nikola-deploy-input-default "New post")
          (setq nikola-build-before-hook-script (concat nikola-output-directory-root "scripts/pre-build.sh"))
          (Setq nikola-build-after-hook-script (concat nikola-output-directory-root "scripts/post-build.sh"))
          (setq nikola-deploy-after-hook-script "nikola iarchiver"))

5.  Licencia

        Autor:: drymer <drymer [EN] autistici.org>
        Derechos de autor:: Copyright (c) 2016, drymer

        Este programa es software libre: puedes redistribuirlo y/o modificarlo
        bajo los términos de la Licencia Pública General GNU publicada por
        la Free Software Foundation, ya sea la versión 2 de la Licencia, o
        su opción) cualquier versión posterior.
        Este programa se distribuye con la esperanza de que sea útil, pero
        SIN NINGUNA GARANTÍA; Sin la garantía implícita de
        COMERCIABILIDAD o APTITUD PARA UN PROPÓSITO PARTICULAR. Vea el GNU
        Licencia Pública General para más detalles.

        Debería haber recibido una copia de la GNU General Public License
        junto con este programa. Si no es así, consulte <http://www.gnu.org/licenses/>.


<a id="orgd0e956b"></a>

### Bugs, parches y solicitudes de características

Si encuentras un error, tienes un parche o tienes la solicitud de una característica, puedes enviar un correo electrónico a la dirección de la sección anterior o ir a [<https://git.daemons.itr/drymer/nikola.el>](https://git.daemons.itr/drymer/nikola.el).
