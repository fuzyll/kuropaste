##
# KuroPaste | DarkNet Pastebin
#
# Copyright (c) 2012 Alexander Taylor <ajtaylor@fuzyll.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
##

module KuroPaste
    Database = Sequel.sqlite(File.dirname(__FILE__) + "/kuropaste.db")
    unless Database.table_exists?("pastes")
        Database.create_table("pastes") do
            primary_key :id
            timestamp :timestamp,
                :default => Sequel::CURRENT_TIMESTAMP, 
                :null => false
            text :summary
            text :language
            text :contents
        end
    end

    Syntax = {
        "Plain Text" => "text.plain",
        "LaTeX" => "text.tex.latex",
        "HTML" => "text.html.basic",
        "HAML" => "text.haml",
        "YAML" => "source.yaml",
        "XML" => "text.xml",
        "JSON" => "source.json",
        "CSS" => "source.css",
        "JavaScript" => "source.js",
        "SQL" => "source.sql",
        "Shell" => "source.shell",
        "Fortran" => "source.fortran",
        "Pascal" => "source.pascal",
        "C" => "source.c",
        "Objective C" => "source.objc",
        "C++" => "source.c++",
        "Objective C++" => "source.objc++",
        "C#" => "source.c-sharp",
        "D" => "source.d",
        "Java" => "source.java",
        "Perl" => "source.perl",
        "Tcl" => "source.tcl",
        "Lua" => "source.lua",
        "Python" => "source.python",
        "Ruby" => "source.ruby",
        "Erlang" => "source.erlang",
        "Haskell" => "source.haskell"
        # The following are the remaining syntaxes supported by Ultraviolet.
        # I decided to not start with all of them as options, but if you need
        # them, here they are!
        #
        # source.actionscript
        # source.active4d
        # source.active4d.library
        # source.ada
        # source.antlr
        # source.apache-config
        # source.apache-config.mod_perl
        # source.applescript
        # source.asp
        # source.asp.vb.net
        # source.c++.qt
        # source.c.ragel
        # source.camlp4.ocaml
        # source.cm
        # source.coffee
        # source.context-free
        # source.css.beta
        # source.diff
        # source.dot
        # source.dylan
        # source.eiffel
        # source.fscript
        # source.fxscript
        # source.gri
        # source.groovy.groovy
        # source.icalendar
        # source.inform
        # source.ini
        # source.io
        # source.java-props
        # source.js.greasemonkey
        # source.js.jquery
        # source.js.mootools
        # source.js.prototype
        # source.js.prototype.bracketed
        # source.js.yui
        # source.lex
        # source.lighttpd-config
        # source.lilypond
        # source.lisp
        # source.logo
        # source.logtalk
        # source.makefile
        # source.matlab
        # source.mel
        # source.mips
        # source.ml
        # source.modula-3
        # source.nant-build
        # source.ocaml
        # source.ocamllex
        # source.ocamlyacc
        # source.open-gl
        # source.pascal.vectorscript
        # source.php.cake
        # source.plist.tm-grammar
        # source.postscript
        # source.processing
        # source.prolog
        # source.python.django
        # source.qmake
        # source.quake-config
        # source.r
        # source.r-console
        # source.regexp
        # source.regexp.oniguruma
        # source.regexp.python
        # source.remind
        # source.rez
        # source.ruby.experimental
        # source.ruby.rails
        # source.s5
        # source.sass
        # source.scheme
        # source.scilab
        # source.scss
        # source.slate
        # source.smarty
        # source.sql.ruby
        # source.ssh-config
        # source.strings
        # source.swig
        # source.tcl.macports
        # text.active4d-ini
        # text.bbcode
        # text.bibtex
        # text.blog
        # text.blog.html
        # text.blog.markdown
        # text.blog.textile
        # text.gtdalt
        # text.html.asp
        # text.html.asp.net
        # text.html.cfm
        # text.html.django
        # text.html.dokuwiki
        # text.html.doxygen
        # text.html.markdown.multimarkdown
        # text.html.mason
        # text.html.mediawiki
        # text.html.mt
        # text.html.ruby
        # text.html.strict.active4d
        # text.html.tcl
        # text.html.textile
        # text.html.tt
        # text.html.twiki
        # text.html.xhtml.1-strict
        # text.log.latex
        # text.mail.markdown
        # text.man
        # text.moinmoin
        # text.plain.gtd
        # text.plain.release-notes
        # text.plist
        # text.pmwiki
        # text.restructuredtext
        # text.setext
        # text.subversion-commit
        # text.tabular.csv
        # text.tabular.tsv
        # text.tex
        # text.tex.latex.beamer
        # text.tex.latex.haskell
        # text.tex.latex.memoir
        # text.tex.latex.rd
        # text.tex.latex.sweave
        # text.tex.math
        # text.txt2tags
        # text.xml.apple-dist
        # text.xml.strict
        # text.xml.xsl
    }

    class Paste < Sequel::Model; end

    class Application < Sinatra::Base
        enable :sessions
        set :public_folder, File.dirname(__FILE__) + "/content"
        set :haml, {:format => :html5}

        not_found do
            status 404
            haml :missing
        end

        get "/" do
            redirect "/new"
        end

        get "/list" do
            @list = Paste.all
            haml :list
        end

        get "/search" do
            redirect "/new"
        end

        post "/search" do
            matches = []
            Paste.all.each do |paste|
                if paste.summary.include? params[:search] or paste.contents.include? params[:search]
                    tmp << paste.id
                end
            end
            @list = Paste.filter([[:id, matches]])
            haml :list
        end

        get "/new" do
            haml :new
        end

        post "/new" do
            @paste = Paste.create(:summary => params[:summary],
                                  :language => params[:language],
                                  :contents => params[:contents])
            redirect "/#{@paste[:id]}"
        end

        get "/line" do
            # toggle line numbers on/off and refresh page
            if session["line"] == false
                session["line"] = true
            else
                session["line"] = false
            end
            redirect request.referer
        end

        get %r{^/(\d+)$} do
            session["line"] ||= false  # default to no line numbers
            @paste = Paste[params[:captures]]
            @line = session["line"]
            haml :show
        end
    end
end

