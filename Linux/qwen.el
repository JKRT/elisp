;;; qwen-gptel.el --- gptel config for local Qwen via llama-server -*- lexical-binding: t; -*-

;; Add to your init.el or load this file.
;; Requires: gptel (M-x package-install RET gptel RET)
;;
;; Usage:
;;   M-x gptel        — open chat buffer
;;   M-x gptel-send   — send region/buffer (C-c RET by default)
;;   M-x gptel-menu   — transient menu for settings
;;   M-x qwen-code    — quick code question in minibuffer

(require 'gptel)
(require 'json)
(require 'url)

;; ============================================================
;; Backend: local llama-server
;; ============================================================

(defvar qwen--local-host "localhost:8080"
  "Host for the local llama-server.")

(defun qwen--fetch-model-name ()
  "Query the local llama-server for its model name.
Returns the model id string, or nil if the server is unreachable."
  (condition-case nil
      (let* ((url (format "http://%s/v1/models" qwen--local-host))
             (buf (url-retrieve-synchronously url t nil 3)))
        (when buf
          (unwind-protect
              (with-current-buffer buf
                (goto-char (point-min))
                (when (re-search-forward "\n\n" nil t)
                  (let* ((json-object-type 'alist)
                         (json-array-type 'list)
                         (resp (json-read))
                         (data (alist-get 'data resp)))
                    (when data
                      (alist-get 'id (car data))))))
            (kill-buffer buf))))
    (error nil)))

(defvar qwen--model-name
  (or (qwen--fetch-model-name) "qwen-local")
  "Model name reported by the local llama-server.")

(defvar qwen-backend
  (gptel-make-openai "Qwen-local"
    :host qwen--local-host
    :protocol "http"
    :stream t
    :models (list qwen--model-name))
  "gptel backend for local Qwen via llama-server.")

;; Set as default backend
(setq gptel-backend qwen-backend
      gptel-model qwen--model-name)

;; ============================================================
;; Default parameters — matchar din Modelfile
;; ============================================================

(setq gptel-temperature 0.3
      gptel-max-tokens 4096)

;; System prompt — kodassistent
(setq gptel-default-mode 'org-mode)

(defvar qwen-system-prompt
  "You are an expert coding assistant specializing in Julia, C++, C, and Emacs Lisp, \
with broad experience across most programming languages.
Write concise, idiomatic, correct code. Explain only when asked.
Prefer clarity over cleverness."
  "System prompt for local Qwen coding assistant.")

(setq gptel-directives
      `((default . ,qwen-system-prompt)
        (code . "You are a coding assistant. Respond only with code, no explanations unless asked.")
        (julia . "You are a Julia expert. Use idiomatic Julia: snake_case for functions, \
PascalCase for types, multiple dispatch, broadcasting. Prefer clarity.")
        (elisp . "You are an Emacs Lisp expert. Write clean, idiomatic elisp. \
Use lexical-binding. Prefer cl-lib over cl. Document with docstrings.")
        (cpp . "You are a modern C++17/20 expert. Use RAII, const-correctness, \
smart pointers, std::optional, structured bindings. Avoid raw new/delete.")
        (explain . "Explain clearly and concisely. Use examples. \
Assume the reader is an experienced programmer.")
        (review . "Review the following code. Point out bugs, performance issues, \
and style problems. Be direct and specific.")))

;; ============================================================
;; Keybindings
;; ============================================================

;; Global: C-c g prefix
(global-set-key (kbd "C-c g g") #'gptel)
(global-set-key (kbd "C-c g s") #'gptel-send)
(global-set-key (kbd "C-c g m") #'gptel-menu)
(global-set-key (kbd "C-c g a") #'gptel-abort)

;; In prog-mode: ask about code
(with-eval-after-load 'gptel
  (define-key gptel-mode-map (kbd "C-c RET") #'gptel-send))

;; ============================================================
;; Convenience commands
;; ============================================================

(defun qwen-code (prompt)
  "Quick code question to Qwen in minibuffer."
  (interactive "sQwen: ")
  (let ((buf (generate-new-buffer "*qwen-answer*")))
    (with-current-buffer buf
      (funcall gptel-default-mode)
      (gptel-mode 1)
      (insert "* " prompt "\n\n"))
    (display-buffer buf)
    (gptel-request prompt
      :buffer buf
      :system qwen-system-prompt
      :callback
      (lambda (response info)
        (when response
          (with-current-buffer (plist-get info :buffer)
            (goto-char (point-max))
            (insert response)))))))

(defun qwen-explain-region (beg end)
  "Ask Qwen to explain the selected code."
  (interactive "r")
  (let ((code (buffer-substring-no-properties beg end)))
    (qwen-code (format "Explain this code concisely:\n\n```\n%s\n```" code))))

(defun qwen-refactor-region (beg end)
  "Ask Qwen to refactor the selected code."
  (interactive "r")
  (let ((code (buffer-substring-no-properties beg end))
        (lang (or (and (derived-mode-p 'julia-mode) "julia")
                  (and (derived-mode-p 'c++-mode) "c++")
                  (and (derived-mode-p 'emacs-lisp-mode) "elisp")
                  (symbol-name major-mode))))
    (qwen-code (format "Refactor this %s code. Show only the improved version:\n\n```%s\n%s\n```"
                       lang lang code))))

(defun qwen-inline-complete ()
  "Replace region with Qwen's completion/fix."
  (interactive)
  (unless (use-region-p)
    (user-error "Select code first"))
  (let* ((beg (region-beginning))
         (end (region-end))
         (code (buffer-substring-no-properties beg end))
         (lang (or (and (derived-mode-p 'julia-mode) "julia")
                   (and (derived-mode-p 'c++-mode) "c++")
                   (and (derived-mode-p 'emacs-lisp-mode) "elisp")
                   ""))
         (prompt (format "Fix/complete this %s code. Return ONLY the corrected code, \
no explanations, no markdown fences:\n\n%s" lang code)))
    (gptel-request prompt
      :system "You are a code completion engine. Return only code, nothing else."
      :callback
      (lambda (response info)
        (when response
          (let ((clean (string-trim response)))
            ;; Strip markdown fences if model adds them anyway
            (when (string-match "\\````[a-z]*\n\\(\\(?:.\\|\n\\)*\\)\n```\\'" clean)
              (setq clean (match-string 1 clean)))
            (save-excursion
              (delete-region beg end)
              (goto-char beg)
              (insert clean))))))))

;; Code-specific bindings
(global-set-key (kbd "C-c g e") #'qwen-explain-region)
(global-set-key (kbd "C-c g r") #'qwen-refactor-region)
(global-set-key (kbd "C-c g c") #'qwen-inline-complete)
(global-set-key (kbd "C-c g q") #'qwen-code)

;; ============================================================
;; Optional: multiple backends (switch with gptel-menu)
;; ============================================================

;; Uncomment if you also use Anthropic/OpenAI:
;;
;; (gptel-make-anthropic "Claude"
;;   :stream t
;;   :key 'gptel-api-key-from-auth-source)
;;
;; Then switch in gptel-menu or:
;;   (setq gptel-backend qwen-backend)   ; local
;;   (setq gptel-backend (alist-get "Claude" gptel--known-backends)) ; remote

(provide 'qwen-gptel)
;;; qwen-gptel.el ends here
