
;; ロードパス
(setq load-path (append
                 '("~/.emacs.d"
                   "~/.emacs.d/elpa"
                   "~/.emacs.d/elisp")
                 load-path))
(require 'install-elisp)
(setq install-elisp-repository-directory "~/.emacs.d/elisp/")

;; (auto-install-update-emacswiki-package-name t)
;;(auto-install-compatibility-setup)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(tool-bar-mode -1) ; ツールバーの非表示
;; (menu-bar-mode -1) ; メニューバーの非表示
(display-time-mode 1) ; 時間の表示
(line-number-mode 1) ; 行番号の表示
(column-number-mode 1) ; 列番号の表示
(display-battery-mode 1) ; バッテリー残量の表示
(setq ring-bell-function (lambda ())) ; ビープを無効化し、画面のちらつきも防ぐ
(setq-default indent-tabs-mode nil) ; tabキーを押したときにspaceを入力する
(setq transient-mark-mode t)
;; tab
(setq-default tab-width 2)
(setq tab-width 2)
;; window
(windmove-default-keybindings)

;; yes-no
(fset 'yes-or-no-p 'y-or-n-p)
;; color-theme
(require 'color-theme)
(color-theme-initialize)
(color-theme-clarity)

;; auto-install.el
(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/elisp/")
;; (auto-install-update-emacswiki-package-name t)
;; (auto-install-compatibility-setup)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;;howm
(setq howm-menu-lang 'ja)
(global-set-key "\C-c,," 'howm-menu)
(mapc
 (lambda (f)
   (autoload f
     "howm" "Hitori Otegaru Wiki Modoki" t))
 '(howm-menu howm-list-all howm-list-recent
             howm-list-grep howm-create
             howm-keyword-to-kill-ring))
;; frame size
(if window-system
    (progn
      (setq initial-frame-alist '((width . 170)(height . 50)(top . 25)(left . 10)))
      (set-frame-parameter nil 'alpha 70)
      ))

;; GroovyMode
(global-font-lock-mode 1)
(autoload 'groovy-mode "groovy-mode" "Groovy editing mode." t)
(add-to-list 'auto-mode-alist '("\.groovy$" . groovy-mode))
(add-to-list 'auto-mode-alist '("\.grails$" . groovy-mode))
(add-to-list 'auto-mode-alist '("\.gradle$" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))

;; rst mode
(require 'rst)
(setq auto-mode-alist
      (append '(("\\.rst$" . rst-mode)
      ("\\.rest$" . rst-mode)) auto-mode-alist))
(setq frame-background-mode 'dark)
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(rst-level-1-face ((t (:foreground "LightSkyBlue"))) t)
 '(rst-level-2-face ((t (:foreground "LightGoldenrod"))) t)
 '(rst-level-3-face ((t (:foreground "Cyan1"))) t)
 '(rst-level-4-face ((t (:foreground "chocolate1"))) t)
 '(rst-level-5-face ((t (:foreground "PaleGreen"))) t)
 '(rst-level-6-face ((t (:foreground "Aquamarine"))) t))
 ;; (rst-level-7-face ((t (:foreground "LightSteelBlue"))) t)  ;; メモ
 ;; (rst-level-8-face ((t (:foreground "LightSalmon"))) t)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(rst-level-face-base-light 50))


(cua-mode t)
(setq cua-enable-cua-keys nil) ; そのままだと C-x が切り取りになってしまったりするので無効化

;; windowサイズの保存
(defun my-window-size-save ()
  (let* ((rlist (frame-parameters (selected-frame)))
         (ilist initial-frame-alist)
         (nCHeight (frame-height))
         (nCWidth (frame-width))
         (tMargin (if (integerp (cdr (assoc 'top rlist)))
                      (cdr (assoc 'top rlist)) 0))
         (lMargin (if (integerp (cdr (assoc 'left rlist)))
                      (cdr (assoc 'left rlist)) 0))
         buf
         (file "~/.framesize.el"))
    (if (get-file-buffer (expand-file-name file))
        (setq buf (get-file-buffer (expand-file-name file)))
      (setq buf (find-file-noselect file)))
    (set-buffer buf)
    (erase-buffer)
    (insert (concat
             ;; 初期値をいじるよりも modify-frame-parameters
             ;; で変えるだけの方がいい?
             "(delete 'width initial-frame-alist)\n"
             "(delete 'height initial-frame-alist)\n"
             "(delete 'top initial-frame-alist)\n"
             "(delete 'left initial-frame-alist)\n"
             "(setq initial-frame-alist (append (list\n"
             "'(width . " (int-to-string nCWidth) ")\n"
             "'(height . " (int-to-string nCHeight) ")\n"
             "'(top . " (int-to-string tMargin) ")\n"
             "'(left . " (int-to-string lMargin) "))\n"
             "initial-frame-alist))\n"
             ;;"(setq default-frame-alist initial-frame-alist)"
             ))
    (save-buffer)
    ))

;;
(defun my-window-size-load ()
  (let* ((file "~/.emacs.d/.framesize.el"))
    (if (file-exists-p file)
        (load file))))
(my-window-size-load)


;; Call the function above at C-x C-c.
(defadvice save-buffers-kill-emacs
  (before save-frame-size activate)
  (my-window-size-save))

;; anything
(require 'anything)
(require 'anything-config) 
(require 'anything-match-plugin) 
(global-set-key (kbd "C-x b") 'anything) 

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/")) 
(package-initialize)
; melpa.el
;;(require 'melpa)

;;elscreen
(elscreen-start)
(global-set-key [(C-tab)] 'elscreen-next)
(global-set-key [(C-S-tab)] 'elscreen-previous)

;; recentf-ext
(require 'recentf-ext)

(require 'igrep)

;;session
(require 'session)
(add-hook 'after-init-hook 'session-initialize)

;; minibuf-isearch
(require 'minibuf-isearch)

;; history から重複を消す
(require 'cl)
(defun minibuffer-delete-duplicate ()
  (let (list)
    (dolist (elt (symbol-value minibuffer-history-variable))
      (unless (member elt list)
        (push elt list)))
    (set minibuffer-history-variable (nreverse list))))
(add-hook 'minibuffer-setup-hook 'minibuffer-delete-duplicate)

(require 'auto-complete)
(global-auto-complete-mode t)
(setq ac-modes
      (append ac-modes
              (list 'org-mode)
              (list 'web-mode)
              )
      )

;; gtags
(require 'gtags) 
(add-hook 'java-mode-hook (lambda () (gtags-mode 1))) 
(add-hook 'groovy-mode-hook (lambda () (gtags-mode 1))) 

;; start server
(if window-system (server-start))

(global-set-key "\C-h" 'delete-backward-char)

  
;; web-mode
(require 'web-mode)
;;; emacs 23以下の互換
(when (< emacs-major-version 24)
  (defalias 'prog-mode 'fundamental-mode))

;;; 適用する拡張子
(add-to-list 'auto-mode-alist '("\\.phtml$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x$"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))

;;; インデント数

(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-html-offset   2)
  (setq web-mode-css-offset    2)
  (setq web-mode-script-offset 2)
  (setq web-mode-php-offset    2)
  (setq web-mode-java-offset   2)
  (setq web-mode-asp-offset    2))
(add-hook 'web-mode-hook 'web-mode-hook)

;; moccur.el
(require 'color-moccur)

