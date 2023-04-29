                                        ;Configurations for melpa

(when (>= emacs-major-version 24)
  (require 'package)
  (if package--initialized
      nil
    package-initialize)
  (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                     ("marmalade" . "http://marmalade-repo.org/packages/")
                     ("melpa" . "http://melpa.org/packages/"))))
