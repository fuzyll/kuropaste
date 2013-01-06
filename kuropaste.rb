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

    class Paste < Sequel::Model; end

    Syntax = {
        "Plain Text" => "text.plain",
        "Markdown" => "text.blog.markdown",
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
        "Makefile" => "source.makefile",
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
    }

    class Application < Sinatra::Base
        enable :sessions
        set :public_folder, File.dirname(__FILE__) + "/content"
        set :haml, {:format => :html5}

        not_found do
            status 404
            haml :missing
        end

        get "/?" do
            redirect to "/new"
        end

        get "/list/?" do
            @list = Paste.all
            haml :list
        end

        get "/search/?" do
            @list = []
            haml :list
        end

        post "/search/?" do
            matches = []
            Paste.all.each do |paste|
                if paste.summary.include? params[:search] or paste.contents.include? params[:search]
                    matches << paste.id
                end
            end
            @list = Paste.filter([[:id, matches]])
            haml :list
        end

        get "/new/?" do
            haml :new
        end

        post "/new/?" do
            @paste = Paste.create(:summary => params[:summary],
                                  :language => params[:language],
                                  :contents => params[:contents])
            redirect to "/#{@paste[:id]}"
        end

        get "/line/?" do
            # toggle line numbers on/off and refresh page
            if session["line"] == false
                session["line"] = true
            else
                session["line"] = false
            end
            redirect to request.referer
        end

        get %r{^/(\d+)/?$} do
            session["line"] ||= false  # default to no line numbers
            @paste = Paste[params[:captures]]
            @line = session["line"]
            haml :show
        end
    end
end

