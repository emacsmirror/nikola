;;; nikola.el --- Simple wrapper for nikola
;; Author:: drymer <drymer [ EN ] autistici.org>
;; Copyright:: Copyright (c) 2016, drymer
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 2 of the License, or (at
;; your option) any later version.
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; ◊ Main commands:
;;   • `nikola-build': Builds the site.
;;   • `nikola-start-webserver': Starts nikola's webserver.
;;   • `nikola-stop-webserver': Stops nikola's webserver.
;;   • `nikola-deploy': Deploys the site.
;; ◊ Variables:
;;   • `nikola-output-root-directory': Nikola's site directory.
;;   • `nikola-verbose': If set to *t*, it will create a buffer called
;;     **Nikola** with the output of all commands. Set to *nil* by default.
;;   • `nikola-webserver-auto': If set to *t*, it will use `nikola auto' to
;;     launch the webserver. If set to *nil*, it will use `nikola
;;     serve'. Set to *nil* by default.
;;   • `nikola-webserver-host': Set it to *0.0.0.0* if you want to make the
;;     webserver accesible from outside the machine. Set to *127.0.0.1* by
;;     default.
;;   • `nikola-webserver-port': Nikola's webserver port. Set to *8000* by
;;     default.
;;   • `nikola-deploy-input': If *nil*, just execute plain deploy, if *t*,
;;     asks for user input, *any string* is passed to the deploy string.
;;     This variable is intended to use with a deploy script or command
;;     that uses git, thus needs a commit message. It could be used for
;;     whatever other reason, also. To use the message writed on emacs on
;;     the deploy order, you have to use the variable *$COMMIT*. For
;;     example:
;;   ┌────
;;   │ DEPLOY_COMMANDS = {
;;   │      'default': [
;;   │          "git add .", "git commit -m \"$COMMIT\"", "git push"
;;   │      ]
;;   │  }
;;   └────
;;   • `nikola-deploy-input-default': If `nikola-deploy-input' is *t*, this
;;     variable changes the default value so you can just press RET.
;; Hooks:
;;   Use them as you would usually do.
;;   • `nikola-build-before-hook'
;;   • `nikola-build-after-hook'
;;   • `nikola-deploy-before-hook'
;;   • `nikola-deploy-after-hook'
;;   If you only want to execute a simple script before or after building
;;   or deploying, you can set the next variables to that script's path:
;;   • `nikola-build-before-hook-script'
;;   • `nikola-build-after-hook-script'
;;   • `nikola-deploy-before-hook-script'
;;   • `nikola-deploy-after-hook-script'

;;; Code:
(defgroup nikola nil
  "Wrappers around nikola command."
  :group 'tools)

(defcustom nikola-command "nikola"
  "Nikola's program path.  By default, it uses the one on the $PATH."
  :group 'nikola)

(defcustom nikola-output-root-directory nil
  "Site's default directory."
  :group 'nikola)

(defcustom nikola-verbose nil
  "Create a buffer with nikola commands output."
  :group 'nikola)

(defcustom nikola-webserver-auto nil
  "When nil, the function nikola-start-webserver uses `server` parameter, but w\
hen set to t, uses the `auto` parameter."
  :group 'nikola)

(defcustom nikola-webserver-host "127.0.0.1"
  "Default host to serve nikola's webpage."
  :group 'nikola)

(defcustom nikola-webserver-port "8000"
  "Default host to serve nikola's webpage."
  :group 'nikola)

(defcustom nikola-deploy-input nil
  "If nil, just execute plain deploy, if t, asks for user input, any string i\
s passed to the deploy string."
  :group 'nikola)

(defcustom nikola-deploy-input-default "New post"
  "Default commit message."
  :group 'nikola)

(defcustom nikola-build-before-hook-script nil
  "Path of a script to execute before building the site."
  :type 'hook
  :group 'nikola)

(defcustom nikola-build-after-hook-script nil
  "Path of the script to execute after building the site."
  :type 'hook
  :group 'nikola)

(defcustom nikola-deploy-before-hook-script nil
  "Path of the script to execute before deploying the site."
  :type 'hook
  :group 'nikola)

(defcustom nikola-deploy-after-hook-script nil
  "Path of the script to execute after deploying the site."
  :type 'hook
  :group 'nikola)

(defcustom nikola-build-before-hook nil
  "Hook for before executing nikola-build."
  :type 'hook
  :group 'nikola)

(defcustom nikola-build-after-hook nil
  "Hook for after executing nikola-build."
  :type 'hook
  :group 'nikola)

(defcustom nikola-deploy-before-hook nil
  "Hook for before executing nikola-deploy."
  :type 'hook
  :group 'nikola)

(defcustom nikola-deploy-after-hook nil
  "Hook for after executing nikola-deploy."
  :type 'hook
  :group 'nikola)

(defun nikola-sentinel (process event)
  "React to nikola's PROCESS and EVENTs."
  (cond
   ;; It enters when nikola-build returns an error
   ((string-match-p "This command needs to run inside an existing Nikola site"
		    event)
    (message "The directory nikola-output-root-directory doesn't exist or d\
oesn't contain a Nikola site. Please, create it first.."))
   ;; It enters when nikola-stop-webserver
   ((and
     (string-match-p "(hangup)" event)
     (string-match-p "nikola-webserver" (format "%s" process)))
    (message "Webserver stopped."))
   ;; It enters when restart nikola-build
   ((and
     (string-match-p "(hangup)" event)
     (string-match-p "nikola-build" (format "%s" process)))
    (message "Rebuilding the site..."))
   ;; It enters when nikola-build stops correctly
   ((and
     (string-match-p "finished" event)
     (string-match-p "nikola-build" (format "%s" process)))
    (if (eq nikola-build-after-hook-script nil)
	(run-hook-with-args 'nikola-build-after-hook ""))
    (message "Site built correctly."))
   ;; It enters when nikola-start-webserver's directory is not correct
   ((and
     (string-match-p "finished" event)
     (string-match-p "nikola-webserver" (format "%s" process)))
    (if (eq nikola-verbose nil)
	(message "Something went wrong. You may want to set nikola-verbose to t\
 and retry.")
      (message "Something went wrong. You may want to check the *Nikola* buffer\
.")))
   ;; It enteres when nikola-deploy finishes correctly
   ((and
     (string-match-p "finished" event)
     (string-match-p "nikola-deploy" (format "%s" process)))
    (if (eq nikola-deploy-after-hook-script nil)
	(run-hook-with-args 'nikola-deploy-after-hook ""))
    (message "Deploy done."))
   ;; Generic error control
   ((string-match-p "exited abnormally" event)
    (if (eq nikola-verbose nil)
	(message "Something went wrong. You may want to set nikola-verbose to t\
 and retry.")
      (message "Something went wrong. You may want to check the *Nikola* buffer\
.")))))

(defun nikola-build ()
  "Build the site with nikola build."
  (interactive)
  (set 'default-directory nikola-output-root-directory)
  (if (get-process "nikola-build")
      (if (y-or-n-p "There's a nikola-build process active. Do you want to rest\
art it? ")
	  (progn (signal-process "nikola-build" 1) (sleep-for 1))
	(user-error "Exit")))
  ;; Execute before hook
  (if (eq nikola-build-before-hook-script nil)
      (run-hook-with-args 'nikola-build-before-hook "")
    (set 'nikola-build-before-hook-script (concat nikola-build-before-hook-script " && ")))
  (if (eq nikola-build-after-hook-script t)
      (set 'nikola-build-after-hook-script (concat " && " nikola-build-after-hook-script)))
  (message "Building the site...")
  (if (eq nikola-verbose t)
      (set-process-sentinel
       (start-process-shell-command
	"nikola-build" "*Nikola*" (concat nikola-build-before-hook-script
					  nikola-command " build "
					  nikola-build-after-hook-script))
       'nikola-sentinel)
    (set-process-sentinel
     (start-process-shell-command
      "nikola-build" nil (concat nikola-build-before-hook-script
				 nikola-command
				 " build " nikola-build-after-hook-script))
     'nikola-sentinel)))

(defun nikola-webserver-start ()
  "Start nikola's webserver with the auto-building option."
  (interactive)
  (set 'default-directory nikola-output-root-directory)
  (if (eq nikola-webserver-auto t)
      (set 'webserver "auto")
    (set 'webserver "serve"))
  (if (get-process "nikola-webserver")
      (if (y-or-n-p "There's a nikola-start-webserver process active. Do you wa\
nt to restart it?")
	  (progn (nikola-stop-webserver)(sleep-for 1))
	(user-error "Exit")))
  (message (concat "Serving Webserver on " nikola-webserver-host ":"
		   nikola-webserver-port "..."))
  (if (eq nikola-verbose t)
      (set-process-sentinel
       (start-process-shell-command
	"nikola-webserver" "*Nikola*" (concat nikola-command " " webserver
					      " -a " nikola-webserver-host
					      " -p " nikola-webserver-port))
       'nikola-sentinel)
    (set-process-sentinel
     (start-process-shell-command
      "nikola-webserver" nil (concat nikola-command " " webserver " -a "
				     nikola-webserver-host " -p "
				     nikola-webserver-port))
     'nikola-sentinel)))

(defun nikola-webserver-stop ()
  "Stops the webserver."
  (interactive)
  (if (get-process "nikola-webserver")
      (signal-process "nikola-webserver" 1)
    (message "There's no Webserver running.")))

(defun nikola-deploy ()
  "Deploys the site using the default script."
  (interactive)
  (set 'default-directory nikola-output-root-directory)
  (if (get-process "nikola-deploy")
      (if (y-or-n-p "There's a nikola-deploy process active. Do you want to res\
tart it? ")
	  (progn (signal-process "nikola-deploy" 1) (sleep-for 1))
	(user-error "Exit")))
  (if (eq nikola-deploy-before-hook-script nil)
      (run-hook-with-args 'nikola-deploy-before-hook "")
    (set 'nikola-deploy-before-hook-script (concat nikola-deploy-before-hook-script " && ")))
  (if (eq nikola-deploy-after-hook-script t)
      (set 'nikola-deploy-after-hook-script (concat " && " nikola-deploy-after-hook-script)))
  (if (eq nikola-deploy-input t)
      (progn
	(set 'commit
	     (read-string
	      (concat "Enter the commit message (Default: "
		      nikola-deploy-input-default "): ")))
	(if (string="" commit)
	    (set 'commit nikola-deploy-input-default)))
    (if (eq nikola-deploy-input nil)
	(set 'commit nil)
      (set 'commit nikola-deploy-input)))
  (message "Deploying the site...")
  (if (eq nikola-verbose t)
      (set-process-sentinel
       (start-process-shell-command "nikola-deploy" "*Nikola*"
				    (concat nikola-deploy-before-hook-script " "
					    "COMMIT=\"" commit "\" "
					    nikola-command " deploy " nikola-deploy-after-hook-script))
       'nikola-sentinel)
    (set-process-sentinel
     (start-process-shell-command "nikola-deploy" nil
				  (concat nikola-deploy-before-hook-script " && "
					  "COMMIT=\"" commit "\" "
					  nikola-command " deploy && " nikola-build-after-hook-script))
     'nikola-sentinel)))

(provide 'nikola)

;;; nikola.el ends here
