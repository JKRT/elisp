;;; omjl-rag-mode.el --- Emacs interface for omjl-rag codebase search -*- lexical-binding: t; -*-
;;; @Author John Tinnerholm with the help of Claude.

(defgroup omjl-rag nil
  "Interface to the omjl-rag Julia codebase search tool."
  :group 'tools
  :prefix "omjl-rag-")

(defcustom omjl-rag-program "omjl"
  "Path to the omjl CLI wrapper."
  :type 'string
  :group 'omjl-rag)

(defcustom omjl-rag-default-top-k 5
  "Default number of results to return."
  :type 'integer
  :group 'omjl-rag)

(defcustom omjl-rag-global-keymap-prefix "C-c j"
  "Prefix key for global omjl-rag keybindings."
  :type 'string
  :group 'omjl-rag)

(defvar omjl-rag-buffer-name "*omjl-rag*"
  "Name of the results buffer.")

;;; Faces

(defgroup omjl-rag-faces nil
  "Faces for omjl-rag results."
  :group 'omjl-rag
  :group 'faces)

(defface omjl-rag-header
  '((t :foreground "#0031a9" :weight bold))
  "Face for result headers."
  :group 'omjl-rag-faces)

(defface omjl-rag-similarity
  '((t :foreground "#006800"))
  "Face for similarity scores."
  :group 'omjl-rag-faces)

(defface omjl-rag-symbol
  '((t :foreground "#721045" :weight bold))
  "Face for symbol names."
  :group 'omjl-rag-faces)

(defface omjl-rag-type
  '((t :foreground "#6f5500"))
  "Face for symbol types (function, struct, etc.)."
  :group 'omjl-rag-faces)

(defface omjl-rag-file-link
  '((t :foreground "#0031a9" :underline t))
  "Face for clickable file paths."
  :group 'omjl-rag-faces)

;;; Results major mode

(defvar omjl-rag-results-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "n")   #'omjl-rag-next-result)
    (define-key map (kbd "p")   #'omjl-rag-prev-result)
    (define-key map (kbd "RET") #'omjl-rag-open-file-at-point)
    (define-key map (kbd "o")   #'omjl-rag-open-file-at-point)
    (define-key map (kbd "q")   #'bury-buffer)
    (define-key map (kbd "g")   #'omjl-rag-rerun-last)
    map)
  "Keymap for omjl-rag results buffer.

  n / p   - Next / previous result
  RET / o - Open file at point
  g       - Re-run last query
  q       - Bury buffer")

(defvar-local omjl-rag--last-command nil
  "The last command run in this results buffer, for re-running with g.")

(define-derived-mode omjl-rag-results-mode special-mode "OmjlRAG"
  "Major mode for omjl-rag search results.

\\{omjl-rag-results-mode-map}"
  (setq buffer-read-only t)
  (setq-local truncate-lines nil)
  (font-lock-add-keywords nil
    '(("^## Result [0-9]+ +(similarity [0-9.]+)" 0 'omjl-rag-header)
      ("similarity \\([0-9.]+\\)" 1 'omjl-rag-similarity)
      ("\\*\\*`\\([^`]+\\)`\\*\\* +. +\\([a-z_]+\\)" (1 'omjl-rag-symbol) (2 'omjl-rag-type))
      ("^[0-9]+ +\\(/[^ \t\n]+\\)" 1 'omjl-rag-symbol)  ; fuzzy/lookup lines
      ("── [0-9]+ +(similarity \\([0-9.]+\\))" 1 'omjl-rag-similarity)))
  (font-lock-mode 1))

;;; Navigation within results buffer

(defun omjl-rag-next-result ()
  "Move point to the next result header."
  (interactive)
  (let ((found (re-search-forward "^\\(## Result\\|──\\)" nil t)))
    (unless found (message "No more results."))))

(defun omjl-rag-prev-result ()
  "Move point to the previous result header."
  (interactive)
  (let ((found (re-search-backward "^\\(## Result\\|──\\)" nil t)))
    (unless found (message "No previous result."))))

(defun omjl-rag-open-file-at-point ()
  "Open the file:line reference on the current line."
  (interactive)
  (let* ((line (thing-at-point 'line t))
         (match (and line
                     (string-match
                      "`\\(/[^`]+\\):\\([0-9]+\\)-?[0-9]*`"
                      line))))
    (if match
        (let* ((path (match-string 1 line))
               (lineno (string-to-number (match-string 2 line))))
          (if (file-exists-p path)
              (progn
                (find-file-other-window path)
                (goto-char (point-min))
                (forward-line (1- lineno)))
            (message "File not found: %s" path)))
      (message "No file reference on this line."))))

(defun omjl-rag-rerun-last ()
  "Re-run the last search command."
  (interactive)
  (if omjl-rag--last-command
      (apply #'omjl-rag--run-display omjl-rag--last-command)
    (message "No previous omjl-rag command to re-run.")))

;;; Async runner

(defun omjl-rag--run-display (header args)
  "Run omjl with ARGS, display results under HEADER in the results buffer."
  (let ((result-buf (get-buffer-create omjl-rag-buffer-name))
        (proc-buf   (generate-new-buffer " *omjl-rag-proc*")))
    (with-current-buffer result-buf
      (let ((inhibit-read-only t))
        (erase-buffer)
        (omjl-rag-results-mode)
        (setq omjl-rag--last-command (list header args))
        (insert (propertize (concat header "\n") 'face 'omjl-rag-header))
        (insert (make-string (length header) ?-) "\n\n")
        (insert "Running…\n")))
    (display-buffer result-buf)
    (let ((proc (apply #'start-process "omjl-rag" proc-buf omjl-rag-program args)))
      (set-process-sentinel
       proc
       (lambda (p _)
         (when (memq (process-status p) '(exit signal))
           (let ((output (with-current-buffer (process-buffer p)
                           (buffer-string))))
             (with-current-buffer result-buf
               (let ((inhibit-read-only t))
                 (goto-char (point-min))
                 (re-search-forward "^Running…\n" nil t)
                 (delete-region (match-beginning 0) (match-end 0))
                 (insert output)
                 (omjl-rag--buttonize-file-paths)))
             (kill-buffer (process-buffer p)))))))))

(defun omjl-rag--buttonize-file-paths ()
  "Make `file:line' references in the results buffer clickable."
  (save-excursion
    (goto-char (point-min))
    (let ((inhibit-read-only t))
      (while (re-search-forward "`\\(/[^`]+\\):\\([0-9]+\\)-?[0-9]*`" nil t)
        (let* ((path (match-string 1))
               (line (match-string 2))
               (beg  (match-beginning 0))
               (end  (match-end 0)))
          (when (file-exists-p path)
            (make-text-button beg end
                              'face 'omjl-rag-file-link
                              'omjl-path path
                              'omjl-line (string-to-number line)
                              'action (lambda (b)
                                        (find-file-other-window
                                         (button-get b 'omjl-path))
                                        (goto-char (point-min))
                                        (forward-line
                                         (1- (button-get b 'omjl-line))))
                              'follow-link t
                              'help-echo (format "Open %s:%s" path line))))))))

;;; Interactive commands

(defun omjl-rag-search (query &optional top-k)
  "Semantic search for QUERY in the indexed codebase.
With prefix argument, prompt for number of results."
  (interactive
   (list (read-string "Search query: ")
         (when current-prefix-arg
           (read-number "Results (top-k): " omjl-rag-default-top-k))))
  (let ((k (or top-k omjl-rag-default-top-k)))
    (omjl-rag--run-display
     (format "Search: %s  (top %d)" query k)
     (list "search" query "--top-k" (number-to-string k)))))

(defun omjl-rag-lookup (name)
  "Exact symbol lookup for NAME. Defaults to symbol at point."
  (interactive
   (list (read-string "Symbol name: "
                      (thing-at-point 'symbol t))))
  (omjl-rag--run-display
   (format "Lookup: %s" name)
   (list "lookup" name)))

(defun omjl-rag-fuzzy (pattern &optional top-k)
  "Partial symbol name search for PATTERN.
With prefix argument, prompt for number of results."
  (interactive
   (list (read-string "Fuzzy pattern: "
                      (thing-at-point 'symbol t))
         (when current-prefix-arg
           (read-number "Results (top-k): " 10))))
  (let ((k (or top-k 10)))
    (omjl-rag--run-display
     (format "Fuzzy: %s  (top %d)" pattern k)
     (list "fuzzy" pattern "--top-k" (number-to-string k)))))

(defun omjl-rag-stats ()
  "Show index statistics."
  (interactive)
  (omjl-rag--run-display "Index statistics" (list "stats")))

(defun omjl-rag-files ()
  "List all indexed files."
  (interactive)
  (omjl-rag--run-display "Indexed files" (list "files")))

(defun omjl-rag-rebuild (&optional force)
  "Incrementally update the index. With prefix argument, force full rebuild."
  (interactive "P")
  (let ((args (if force '("index" "--force") '("index"))))
    (message "Rebuilding index%s…" (if force " (force)" ""))
    (omjl-rag--run-display
     (if force "Rebuild index (force)" "Rebuild index (incremental)")
     args)))

;;; Global minor mode

(defvar omjl-rag-global-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "s") #'omjl-rag-search)
    (define-key map (kbd "l") #'omjl-rag-lookup)
    (define-key map (kbd "f") #'omjl-rag-fuzzy)
    (define-key map (kbd "i") #'omjl-rag-stats)
    (define-key map (kbd "F") #'omjl-rag-files)
    (define-key map (kbd "r") #'omjl-rag-rebuild)
    map)
  "Keymap for omjl-rag global commands (under prefix).

Default bindings (under `omjl-rag-global-keymap-prefix', default C-c j):
  s - Semantic search
  l - Exact symbol lookup
  f - Fuzzy symbol search
  i - Index statistics
  F - List indexed files
  r - Rebuild index (C-u r for full rebuild)")

(define-minor-mode omjl-rag-global-mode
  "Global minor mode for omjl-rag keybindings.

Provides codebase search commands under a prefix key.
Default prefix is `C-c j', customizable via `omjl-rag-global-keymap-prefix'.

With this mode enabled:
  C-c j s - Semantic search
  C-c j l - Exact symbol lookup
  C-c j f - Fuzzy symbol search
  C-c j i - Index statistics
  C-c j F - List indexed files
  C-c j r - Rebuild index"
  :global t
  :lighter " OmjlRAG"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd omjl-rag-global-keymap-prefix) omjl-rag-global-map)
            map))

(omjl-rag-global-mode 1)

(provide 'omjl-rag-mode)

;;; omjl-rag-mode.el ends here
