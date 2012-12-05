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
            datetime :timestamp,
                :default => Sequel::CURRENT_TIMESTAMP, 
                :null => false
            text :summary
            text :language
            text :contents
        end
    end

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

        get "/new" do
            haml :new
        end

        post "/new" do
            @paste = Paste.create(:summary => params[:summary],
                                  :language => params[:language],
                                  :contents => params[:contents])
            redirect "/#{@paste[:id]}"
        end

        get "/numbers" do
            if session["numbers"] == false
                session["numbers"] = true
            else
                session["numbers"] = false
            end
            redirect request.referer
        end

        get %r{^/(\d+)$} do
            session["numbers"] ||= false  # default to no line numbers
            @paste = Paste[params[:captures]]
            @numbers = session["numbers"]
            haml :show
        end
    end
end

