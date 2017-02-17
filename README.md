<div id="table-of-contents">
<h2>&Iacute;ndice</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#org0bc224d">1. nikola.el</a>
<ul>
<li><a href="#org5b8e4d3">1.1. English</a>
<ul>
<li><a href="#org0add57e">1.1.1. About</a></li>
<li><a href="#org9b457be">1.1.2. Requirements</a></li>
<li><a href="#org8035653">1.1.3. Install</a></li>
<li><a href="#org1ed05ff">1.1.4. Configuration</a></li>
<li><a href="#org26efe12">1.1.5. Advanced usage</a></li>
<li><a href="#org2f63655">1.1.6. License</a></li>
<li><a href="#orgc572119">1.1.7. Bugs, patches and feature requests</a></li>
</ul>
</li>
<li><a href="#orgac6bdf9">1.2. Castellano</a></li>
</ul>
</li>
</ul>
</div>
</div>


<a id="org0bc224d"></a>

# nikola.el


<a id="org5b8e4d3"></a>

## English


<a id="org0add57e"></a>

### About

This is a simple wrapper around [nikola](http://getnikola.com). Right now, it allows you to create a site, build, deploy, start/stop the webserver and execute hooks.


<a id="org9b457be"></a>

### Requirements

The extras package is recommended but not necessary.

    sudo pip3 install Nikola Nikola[extras]

Also, emacs-async is necessary. you can install it from elpa with `M-x package-install RET async RET`.


<a id="org8035653"></a>

### Install

    git clone https://daemons.cf/cgit/nikola.el ~/.emacs.d/lisp/nikola.el


<a id="org1ed05ff"></a>

### Configuration

A minimal configuration would be this.

    (add-to-list 'load-path "~/.emacs.d/lisp/nikola.el/")
    (require 'nikola)
    (setq nikola-output-root-directory "~/Documents/blog/")

For a more advanced configuration check the next chapter.


<a id="org26efe12"></a>

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
          :load-path "~/Proyectos/nikola.el/"
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
          (setq nikola-deploy-after-hook-script (concat nikola-output-root-directory "nikola iarchiver")))


<a id="org2f63655"></a>

### License

    Author:: drymer <drymer [ EN ] autistici.org>
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


<a id="orgc572119"></a>

### Bugs, patches and feature requests

If you find a bug, have a patch or have a feature request, you may send an e-mail to the address in the previous section or go to [<https://git.daemons.cfr/drymer/nikola.el/>](https://git.daemons.cfr/drymer/nikola.el/)


<a id="orgac6bdf9"></a>

## Castellano

TODO
