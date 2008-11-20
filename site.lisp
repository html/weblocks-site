(push "/home/sky/weblocks/" asdf:*central-registry*)

(asdf:oos 'asdf:load-op 'weblocks)

(defpackage #:weblocks-site (:use :cl :weblocks :cl-who :f-underscore))

(in-package :weblocks-site)

(defparameter *doc-uri* "http://viridian-project.de/~sky/weblocks-stable/docs/gen/weblocks-package/")

(defwebapp weblocks-site
           :description "Weblocks web application framework"
           :prefix "/"
           :public-files-path "./pub")

(defmacro make-page (title &body body)
  `(lambda ()
     (with-html
       (:h2 (esc ,title))
       ,@body)))

(defun make-welcome-page ()
  (make-page "Welcome to Weblocks"
    (:p "Weblocks is an advanced web framework written in Common Lisp.")
    (:p "It is designed to make Agile web application development as
        effective and simple as possible.")
    (:h3 "Why yet another web framework?")
    (:p "This is not your ordinary run-of-the-mill web framework in PHP, Python or Ruby.")
    (:p "Weblocks uses powerful Lisp features like multiple dispatch, the metaobject protocol,
        lexical closures, keyword arguments, and macros to build abstractions that make web
        development easy, intuitive, and free of boilerplate. In addition, control flow is easily
        expressed using continuations.")
    (:p "Things that are hard or mundane in other frameworks become easy and fun in
        Weblocks.")
    (:h3 "In Common Lisp?")
    (:p "Common Lisp is a powerful standardized language with high-performance implementations.")
    (:p "Weblocks makes use of several advanced features that cannot be found
        in most other programming languages.")
    (:p "Moreover, Common Lisp itself is ideally suited to modern pragmatic and
        Agile programming.")))

(defun make-features-page ()
  (let (features titles)
    (macrolet ((add-feature (title &body body)
                   `(progn
                      (push (with-html-to-string
                               (:a :name ,(attributize-name title) (:h3 ,title))
                              ,@body)
                            features)
                      (push ,title titles))))
      (flet ((render-anchor-table ()
               (with-html
                 (:ul :class "anchors"
                   (mapcar (lambda (title)
                             (htm
                               (:li
                                 (:a :href (format nil "#~A" (attributize-name title))
                                     (esc title)))))
                           (nreverse titles)))))
             (render-content ()
               (mapcar (f_ (with-html (str _))) (nreverse features))))

        (make-page "Features"

          (add-feature "Think and code in high-level abstractions"
            (:p "A web page in Weblocks consists of building blocks called "
                (:em "widgets") ". Every widgets knows how to render itself
                and keeps it state between requests")
            (:p "This simplifies information book-keeping and code re-use."))

          (add-feature "Create multiple views of an object"
            (:p "Weblocks view language lets you specify a view of an object
                in a declarative manner. You can build customized forms and tables
                with only a few lines of code."))

          (add-feature "Fully extensible"
            (:p "Web applications are customized pieces of software.
                Weblocks helps you adapting it by offering an object-oriented
                multiple dispatch interface:")
            (:ul
              (:li "Every generic function is a hook which you can customize
                  using " (:code ":BEFORE") ", " (:code ":AFTER") " and " (:code ":AROUND")
                  " methods.")
              (:li "Every widget written by others may be specialized for your needs
              as well.")))

          (add-feature "Powerful modular dispatcher"
            (:p "User-defined Dispatchers based on string and regex matchers are present
                in every major web framework.")
            (:p "The usual way to go about it is having a centralized dispatcher definition
                (usually declarative or functional). Weblocks takes it one step further
                and offers completely modular and customizable dispatchers that can consume
                any amount of URI parts and invoke other dispatchers.")
            (:p "Additionally the host name and the URI prefix can dispatch
                to different applications."))

          (add-feature "Macros: complete realization of DRY"
            (:p (:em "Don’t Repeat Yourself") " is one of the core principles of
                Agile Development.")
            (:p "Languages without macros of with insufficiently advanced
                macros cannot avoid large parts of code redundancy. By relying
                on Common Lisp Weblocks offers the user the full power
                of code transformation."))

          (add-feature "Harness the power of continuations"
            (:p "Widget continuations let your users use your site in
                a highly flexible manner.")
            (:p "You can have multiple parts of a page going into
                different directions simultaneously. Weblocks does
                all the book-keeping for you.")
            (:p "The best thing is: you don’t even need to know
                anything about continuations. Just use the high-level
                API provided by Weblocks to direct your control flow."))

          (add-feature "Thin JavaScript layer"
            (:p "Thanks to Weblocks' thin JavaScript layer your content degrades gracefully
                on clients that don't have JavaScript enabled.")
            (:p "Features like fully sortable tables use AJAX when available but
                also offer the same user experience without AJAX by making a normal
                request.")
            (:p "All this happens automatically so you don't have to worry
                about it."))
    
          (render-anchor-table)
          (render-content))))))

(defun make-installation-page ()
  (make-page "Getting started"
    (:p "There are several ways to install Common Lisp and Weblocks.")
    (:h3 "Using clbuild")
    (:p (:a :href "http://common-lisp.net/project/clbuild/" "clbuild")
        " is the easiest way to get started with Weblocks.")
    (:p "Perform the following steps:")
    (:ol
      (:li (:strong "Prepare your clbuild installation")
           " as described on the clbuild homepage.")
      (:li
        (:p :style "font-size:inherit" (:strong "Get SBCL."))
        (:ul
          (:li "Darwin users: build " (:a :href "http://www.sbcl.org/" "SBCL")
               " from source with thread support.")
          (:li "GNU/Linux users: install your distribution's SBCL or let clbuild"
               " build the latest version from CVS:"
               (:pre "./clbuild compile-implementation sbcl"))))
      (:li "Use clbuild to " (:strong "install Weblocks and cl-prevalence") ": "
           (:pre "./clbuild install weblocks cl-prevalence")
           " (note: cl-prevalence is required by the demo)")
      (:li (:strong "Run SBCL") " with clbuild: " (:pre "./clbuild lisp"))
      (:li (:strong "Load the demo") ": " (:pre "CL-USER> (asdf:oos 'asdf:load-op 'weblocks-demo)"))
      (:li (:strong "Start the demo") ": " (:pre "CL-USER> (weblocks-demo:start-weblocks-demo "
                                                 (str (format nil "~%"))
                                                 "                                 :port 3455)")
           " (replace 3455 with some port that is currently not in use on your system)")
      (:li (:strong "Check out the demo") " by pointing your browser at "
           (:pre "http://localhost:3455/weblocks-demo"))
      (:li "Use the demo as a starting point for " (:strong "your own application")
           " or generate a new base application named NAME in an existing directory DIR"
           " by issuing"
           (:pre "CL-USER> (wop:make-app 'NAME \"DIR\")")))
    (:h3 "Manual setup")
      (:p "We have several Mercurial repositories at Bitbucket.")
      (:p "The two official ones are")
      (:dl
        (:dt (:a :href "http://www.bitbucket.org/skypher/weblocks-stable/" "weblocks-stable"))
        (:dd "weblocks-stable, a tree that is synced at stable release points and receives
             only important bug fixes in between.")
        (:dt (:a :href "http://www.bitbucket.org/S11001001/weblocks-dev/" "weblocks-dev"))
        (:dd "weblocks-dev, the tree where all the latest action is."))
      (:p "Saikat Chakrabarti has written a "
        (:a :href "http://slg.posterous.com/installing-weblocks" "step-by-step tutorial on
            setting up SBCL and Weblocks from scratch on Darwin."))))

(defun make-faq-page ()
  (make-page "FAQ"))

(defun make-documentation-page ()
  (make-page "Documentation"
    (:h3 "Tutorials and blog posts")
    (:p "Some introductory material can be found on the old "
        (:a :href "http://trac.common-lisp.net/cl-weblocks/wiki/Tutorials" "Weblocks Trac wiki")
        ". Some of these are slightly outdated and need some bits changed to make them
        work with the latest Weblocks code, though.")

    (:h3 "User guide")
    (:p "A real manual will be available in December 2008 or January 2009.
        Until then please use the "
        (:a :href "http://trac.common-lisp.net/cl-weblocks/wiki/UserManual" "quick guide")
        " in conjunction with community support and the source code documentation.")
    (:p "The " (:a :href "http://www.bitbucket.org/skypher/weblocks-stable/src/tip/test/" "tests")
        " and the "
        (:a :href "http://www.bitbucket.org/skypher/weblocks-stable/src/tip/examples/" "examples")
        " are also helpful.")

    (:h3 "API documentation")
    (:p "The latest auto-generated API documentation for the stable branch
        can be found at " (:a :href *doc-uri*
                                    (esc *doc-uri*)))
             
    (:h3 "Development process")
    (:dl
      (:dt "Submitting patches, working with the repositories")
      (:dd (:a :href "http://trac.common-lisp.net/cl-weblocks/wiki/WeblocksDevelopment"
               "http://trac.common-lisp.net/cl-weblocks/wiki/WeblocksDevelopment"))
      (:dt "Working with the test framework")
      (:dd (:a :href "http://groups.google.com/group/weblocks/msg/b25cbcd1398a91cc"
               "http://groups.google.com/group/weblocks/msg/b25cbcd1398a91cc")))))

(defun make-community-page ()
  (make-page "Community"
    (:h3 "Discussion")
    (:p "The " (:a :href "http://groups.google.com/group/weblocks/" "Weblocks Group")
        " is the central place to get help and discuss development of Weblocks.")
    (:p "You can get free support and talk about bugs and features there.")))

(defmethod render-widget-body ((obj navigation) &rest args)
  ;; we just cheat a bit until the new dispatching/rendering separation
  ;; is ready for production
  (let ((body-html (with-html-output-to-string (*weblocks-output-stream*)
                     (:div :class "navigation-body"
                           (call-next-method)))))
  (apply #'render-navigation-menu obj args)
  (write body-html :stream *weblocks-output-stream* :escape nil)))

(defmethod page-title ((app weblocks-site))
  (declare (special *current-page-description*))
  (format nil "Weblocks: ~A" (or *current-page-description* "")))

(defun init-user-session (comp)
  (setf (composite-widgets comp)
        (list (make-navigation "Main"
                               "Welcome" (make-welcome-page)
                               "Features" (make-features-page)
                               "Getting started" (make-installation-page)
                               ;"FAQ" (make-faq-page)
                               "Documentation" (make-documentation-page)
                               "Community" (make-community-page)))))

