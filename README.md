<div id="table-of-contents">
<h2>&Iacute;ndice</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#org985245d">1. nikola.el</a>
<ul>
<li><a href="#orgd67492b">1.1. English</a>
<ul>
<li><a href="#orga913e39">1.1.1. About</a></li>
<li><a href="#org4fc18e1">1.1.2. Requirements</a></li>
<li><a href="#org3a0f96b">1.1.3. Install</a></li>
<li><a href="#org509866b">1.1.4. Configuration</a></li>
<li><a href="#orga8bc031">1.1.5. Usage</a></li>
<li><a href="#org8206764">1.1.6. License</a></li>
</ul>
</li>
<li><a href="#org4e995b7">1.2. Castellano</a></li>
</ul>
</li>
</ul>
</div>
</div>


<a id="org985245d"></a>

# nikola.el


<a id="orgd67492b"></a>

## English


<a id="orga913e39"></a>

### About

This is a simple wrapper around [nikola](http://getnikola.com). Right now, it allows you to build, deploy, start/stop the webserver and execute hooks.


<a id="org4fc18e1"></a>

### Requirements

The extras package is recommended but not necessary.

    sudo pip3 install Nikola Nikola[extras]

Also, emacs-async is necessary. you can install it from elpa with `M-x package-install RET async RET`.


<a id="org3a0f96b"></a>

### Install

    git clone https://daemons.cf/cgit/nikola.el ~/.emacs.d/lisp/nikola.el


<a id="org509866b"></a>

### Configuration

The relevant variables are on the `:config` section.

    (use-package nikola
      :load-path "~/.emacs.d/lisp/nikola.el/"
      :config
      (setq nikola-output-root-directory "~/Documents/blog/")
      (setq nikola-verbose t)
      (setq nikola-webserver-auto t)
      (setq nikola-webserver-host "127.0.0.1")
      (setq nikola-webserver-port "8000")
      (setq nikola-deploy-input t)
      (setq nikola-deploy-input-default "New post")
      (setq nikola-build-before-hook-script (concat nikola-output-root-directory "scripts/pre-build.sh"))
      (setq nikola-build-after-hook-script nil)
      (setq nikola-deploy-before-hook-script nil)
      (setq nikola-deploy-after-hook-script "rsync -avzP " nikola-output-directory "/var/backups/nikola/"))


<a id="orga8bc031"></a>

### Usage

1.  Main commands:

    -   `nikola-build`: Builds the site.

    -   `nikola-start-webserver`: Starts nikola's webserver.

    -   `nikola-stop-webserver`: Stops nikola's webserver.

    -   `nikola-deploy`: Deploys the site.

2.  Variables:

    -   `nikola-output-root-directory`: Nikola's site directory.

    -   `nikola-verbose`: If set to **t**, it will create a buffer called **&lowast;Nikola&lowast;** with the output of all commands. Set to **nil** by default.

    -   `nikola-webserver-auto`: If set to **t**, it will use `nikola auto` to launch the webserver. If set to **nil**, it will use `nikola serve`. Set to **nil** by default.

    -   `nikola-webserver-host`: Set it to **0.0.0.0** if you want to make the webserver accesible from outside the machine. Set to **127.0.0.1** by default.

    -   `nikola-webserver-port`: Nikola's webserver port. Set to **8000** by default.

    -   `nikola-deploy-input`: If **nil**, just execute plain deploy, if **t**, asks for user input, **any string** is passed to the deploy string automatically.

        This variable is intended to use with a deploy script or command that uses git, thus needs a commit message. It could be used for whatever other reason, also. To use the message writed on emacs on the deploy order, you have to use the variable **$COMMIT**. For example, your deploy command could be:

        DEPLOY_COMMANDS = {
             'default': [
                 "git add .", "git commit -m \"$COMMIT\"", "git push"
             ]
         }

    Set to **nil** by default.

    -   `nikola-deploy-input-default`: If `nikola-deploy-input` is **t**, this variable changes the default value so you can just press RET. Set to **New post** by default.

3.  Hooks:

    Use them as you would usually do.

    -   `nikola-build-before-hook`

    -   `nikola-build-after-hook`

    -   `nikola-deploy-before-hook`

    -   `nikola-deploy-after-hook`

    If you only want to execute a simple script or command before or after building or deploying, you can set the next variables to that script's path or command:

    -   `nikola-build-before-hook-script`

    -   `nikola-build-after-hook-script`

    -   `nikola-deploy-before-hook-script`

    -   `nikola-deploy-after-hook-script`

    For example, to execute a script before deploying:

        (setq nikola-deploy-before-hook-script "~/scripts/pre-deploy.sh")

    For more complicated functions, you should use a hook.


<a id="org8206764"></a>

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


<a id="org4e995b7"></a>

## Castellano

TODO
