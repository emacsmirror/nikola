<div id="table-of-contents">
<h2>&Iacute;ndice</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#org268f7bd">1. nikola-mode</a>
<ul>
<li><a href="#org13cc436">1.1. English</a>
<ul>
<li><a href="#org784717b">1.1.1. About</a></li>
<li><a href="#orgc754e0e">1.1.2. Features</a></li>
<li><a href="#org17a34d4">1.1.3. Requirements</a></li>
<li><a href="#org52a1429">1.1.4. Install</a></li>
<li><a href="#orgaf41243">1.1.5. Configuration</a></li>
<li><a href="#orgcff7234">1.1.6. License</a></li>
</ul>
</li>
</ul>
</li>
</ul>
</div>
</div>


<a id="org268f7bd"></a>

# nikola-mode


<a id="org13cc436"></a>

## English


<a id="org784717b"></a>

### About

This is a simple wrapper around nikola. It permits to build, deploy and start the webserver.


<a id="orgc754e0e"></a>

### Features

Hooks before and after building and deploying.


<a id="org17a34d4"></a>

### Requirements

    sudo pip3 install Nikola Nikola[extras]


<a id="org52a1429"></a>

### Install

    git clone https://daemons.cf/cgit/nikola-mode ~/.emacs.d/lisp/


<a id="orgaf41243"></a>

### Configuration

The relevant variables are on the `:config` section.

    (use-package nikola
      :load-path "~/.emacs.d/lisp/"
      :config
      (setq org2nikola-output-root-directory "~/Documents/blog/")
      (setq nikola-verbose t)
      (setq nikola-webserver-auto t)
      (setq nikola-webserver-host "127.0.0.1")
      (setq nikola-webserver-port "8000")
      (setq nikola-deploy-input t)
      (setq nikola-deploy-input-default "New article")
      (setq nikola-build-before-hook-script nil)
      (setq nikola-build-after-hook-script nil)
      (setq nikola-deploy-before-hook-script nil)
      (setq nikola-deploy-after-hook-script nil)
      )


<a id="orgcff7234"></a>

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
