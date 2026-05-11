;; -*- lexical-binding: t; -*-
(setq EMACS_HOME "~/.emacs.d/elisp/")

(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/eat/"))

;Recompile all files that where recently changed for fast loading
(byte-recompile-directory (expand-file-name "~/.emacs.d/elisp/Linux/.") 0)
(byte-recompile-directory (expand-file-name "~/.emacs.d/elisp/General/.") 0)
(native-compile-async (expand-file-name "~/.emacs.d/elisp/Linux/.") 'recursively)
;; (while (or comp-files-queue
;;                (> (comp-async-runnings) 0))
;;       (sleep-for 1))
;Load settings for other modes Linux specific
(load-file "~/.emacs.d/elisp/Linux/settings.elc")
(load-file "~/.emacs.d/elisp/Linux/brackets.elc")
(load-file "~/.emacs.d/elisp/Linux/c++.elc")
(load-file "~/.emacs.d/elisp/Linux/keybindings.elc")
(load-file "~/.emacs.d/elisp/Linux/melpa.elc")
(load-file "~/.emacs.d/elisp/Linux/tags.elc")
(load-file "~/.emacs.d/elisp/Linux/tablegenmode.elc")
(load-file "~/.emacs.d/elisp/Linux/susan-mode/susanMode.elc")
;(load-file "~/.emacs.d/elisp/Linux/modelica-mode/modelica-mode.elc")
                                        ;(load-file "~/.emacs.d/elisp/Linux/gptel.elc")
(load-file "~/.emacs.d/elisp/Linux/qwen.elc")
(load-file "~/.emacs.d/elisp/Linux/xwidget.el")
(load-file "~/.emacs.d/elisp/Linux/omjledit.el")

;; Eat terminal emulator - compile if needed and load
(let* ((eat-dir (expand-file-name "~/.emacs.d/elisp/eat/"))
       (eat-el (concat eat-dir "eat.el"))
       (eat-elc (concat eat-dir "eat.elc")))
  (when (and (file-exists-p eat-el)
             (or (not (file-exists-p eat-elc))
                 (file-newer-than-file-p eat-el eat-elc)))
    (message "Compiling eat...")
    (let ((default-directory eat-dir))
      (shell-command "make")))
  (when (file-exists-p eat-elc)
    (load-file eat-elc)))

;; Klaude - Claude Code interface (use M-x klaude to start, M-x klaude-global-mode to enable keybindings)
(load-file "~/.emacs.d/elisp/Linux/KlaudeMode/klaude.elc")

;; omjl-rag - Julia codebase search (C-c j s = search, C-c j l = lookup, C-c j f = fuzzy, etc.)
(load-file "~/.emacs.d/elisp/Linux/omjl-rag-mode/omjl-rag-mode.elc")

;Load things from General
(load-file "~/.emacs.d/elisp/General/loadGeneral.elc")
;;Setting up Modelica mode
(autoload 'modelica-mode "modelica-mode" "Modelica Editing Mode" t)
(setq auto-mode-alist (cons '("\.mo$" . modelica-mode) auto-mode-alist))
;Modelica Mode for .mos files.
(setq auto-mode-alist (cons '("\.mos$" . modelica-mode) auto-mode-alist))
;;Loading doremi
(load-file "~/.emacs.d/elisp/Linux/doremi.el/doremi.elc")
;;Turn of tabs
(setq-default indent-tabs-mode nil)
;Please be quiet emacs :)
(setq visible-bell t)
(setq auto-save-default nil)
;; Backup and Autosave Directories
(setq temporary-file-directory "~/.tmp/")
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))


(defun my-eat-apply-blue-theme ()
  "Apply a blue-background theme to eat terminals."
  (let ((background "#0000AA")
        (foreground "#ffffff")
        (colors '("#ffffff" "#ff5555" "#55ff55" "#ffff55"
                  "#55ffff" "#ff55ff" "#55ffff" "#ffffff"
                  "#aaaaaa" "#ff5555" "#55ff55" "#ffff55"
                  "#8888ff" "#ff55ff" "#55ffff" "#ffffff")))
    (face-remap-add-relative 'default
                             :background background
                             :foreground foreground)
    (face-remap-add-relative 'eat-term-font-0
                             :background background
                             :foreground foreground)
    (dotimes (i 16)
      (face-remap-add-relative (intern (format "eat-term-color-%i" i))
                               :background background
                               :foreground (nth i colors)))
    (dotimes (i 240)
      (face-remap-add-relative (intern (format "eat-term-color-%i" (+ i 16)))
                               :background background))))
(add-hook 'eat-mode-hook #'my-eat-apply-blue-theme)



(defun my/goto-file-at-click (event)
  "Open file:line reference at mouse click position.
  Recognizes absolute paths like /path/to/file.jl:42 in any buffer."
  (interactive "e")
  (let* ((pos (posn-point (event-start event)))
         (line-text (save-excursion
                      (goto-char pos)
                      (buffer-substring-no-properties
                       (line-beginning-position)
                       (line-end-position))))
         (col (- pos (save-excursion
                       (goto-char pos)
                       (line-beginning-position)))))
    (let ((best-file nil)
          (best-line nil)
          (best-dist most-positive-fixnum)
          (start 0))
      ;; Find all /path(:line) matches on the line, pick closest to click
      (while (string-match
              "\\(/[^ \t\n\"'`,;):]+\\(?:\\.[a-zA-Z0-9]+\\)\\)\\(?::\\([0-9]+\\)\\)?"
              line-text start)
        (let* ((mb (match-beginning 0))
               (me (match-end 0))
               (file (match-string 1 line-text))
               (lineno (when (match-string 2 line-text)
                         (string-to-number (match-string 2 line-text))))
               (dist (min (abs (- col mb)) (abs (- col me)))))
          (when (and (file-exists-p file) (< dist best-dist))
            (setq best-file file
                  best-line lineno
                  best-dist dist)))
        (setq start (match-end 0)))
      (if best-file
          (progn
            (find-file best-file)
            (when best-line
              (goto-char (point-min))
              (forward-line (1- best-line))))
        (message "No file reference found at click position")))))

;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)


(global-set-key (kbd "<C-mouse-1>") #'my/goto-file-at-click)
(global-set-key (kbd "<C-down-mouse-1>") #'ignore)  ;; prevent selection on ctrl-click


(setq make-pointer-invisible nil)

;; Auto-start server in terminal mode so emacsclient can connect (e.g. from Claude Code hooks)
(require 'server)
(unless (or (display-graphic-p) (server-running-p))
  (server-start))

;; emacs-webkit dynamic module
(let ((webkit-so (expand-file-name "~/Projects/emacs-webkit/webkit-module.so"))
      (webkit-dir (expand-file-name "~/Projects/emacs-webkit")))
  (if (file-exists-p webkit-so)
      (progn
        (add-to-list 'load-path webkit-dir)
        (require 'ol)
        (require 'webkit))
    (message "WARNING: emacs-webkit not found. Build it with: cd ~/Projects/emacs-webkit && make")))
