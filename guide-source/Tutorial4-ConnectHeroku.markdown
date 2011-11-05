Tutorial 4: Step by Step: Example Heroku Sinatra App
----------------------------------------------------

TO-DO: show the steps required to create an integrated Salesforce/Heroku app which leverages OAuth web server flow and utilizes databasedotcom gem and Sinatra.

This section outlines the steps necessary to build a Hello World app that connects 
to database.com using the databasedotcom gem.  We'll use Sinatra as our web 
framework (because it's lightweight) and Heroku as our deployment environment 
(because it rocks).

Heroku setup
------------
Complete the __**Prerequisites**__ section of <a href="http://devcenter.heroku.com/articles/quickstart" target="_blank">Getting Started with Heroku</a> if you haven't already.  

Stub out the Hello World app
-----------------------------
<pre class="terminal">
$ mkdir helloworld
$ cd helloworld
</pre>
    
Create file **config.ru** with following contents:

<pre class="terminal">
require './hello_world'
run Sinatra::Application
</pre>
    
Create file **Gemfile** with following contents:

<pre class="terminal">
source 'http://rubygems.org'
gem 'sinatra'
gem 'databasedotcom'
</pre>

Deploy it
---------
<pre class="terminal">
$ git init
Initialized empty Git repository in /databasedotcom-guide/helloworld/.git/
$ git add .
$ git commit -m "Hello World!"
git commit -m "Hello World"
[master (root-commit) 3b745fb] Hello World
 2 files changed, 5 insertions(+), 0 deletions(-)
 create mode 100644 Gemfile
 create mode 100644 config.ru
$ heroku create
Creating simple-robot-846... done, stack is bamboo-mri-1.9.2
http://simple-robot-846.heroku.com/ | git@heroku.com:simple-robot-846.git
Git remote heroku added
$ heroku addons:add ssl:piggyback
</pre>

IMPORTANT:  Note the name of your app; it will be referred to as **HEROKUAPP**
 in subsequent steps.  In example above, the name of the app simple-robot-846.

Create a database.com account
-----------------------------
1. Go to <a href="http://www.database.com" target="_blank">database.com</a>
1. Click Signup
1. Fill in required fields (make note of username; will be referred to in subsequent steps as **USERNAME**)
1. Click on link in the confirmation email you receive
1. Set a new password and submit (make note of password; will be referred to in subsequent steps as **PASSWORD**)
1. Go to Personal Setup | My Personal Information | Reset My Security Token
1. Click button "Reset Security Token"
1. Note the Security Token you receive via email; will be referred to in subsequent steps as **TOKEN**
1. Go to App Setup | Develop | Remote Access | New
1. Fill in the following:
    **Application**: Hello World
    **Callback**: https://**{HEROKUAPP}**.heroku.com/auth/salesforce/callback
    **Contact Email**: your email
1. Note Consumer Secret and Key in the Authentication section.



Install databasedotcom and Sinatra gems
-----------------------------
<pre class="terminal">
$ bundle install
</pre>

    
1. 
    $ git init
    Initialized empty Git repository in .git/
    $ git add .
    $ git commit -m "Hello world"
    Created initial commit 5df2d09: new app
    44 files changed, 8393 insertions(+), 0 deletions(-)

"HelloWorld" Improved version
-----------------------------
<pre class="terminal">
require 'sinatra'
require ‘databasedotcom’

# Still the old helloworld method
get ‘/’ do
    ‘hello world’
end
<b>
# Initialization method
def init
    $client = Databasedotcom::Client.new(:client_id => "#{consumer_key}", :client_secret => “#{consumer_secret}”)
    $client.authenticate(:username => “#{username}”, :password => “password + security_token”)

    # Dynamic loading of the User object metadata
    # this will create a Class called User in the current NameSpace / Module
    $client.materialize("User")
end

# Say hello to you.
get ‘/helloyou’ do
 	init()
   me = User.find($client.user_id)
   puts "My name is #{me.FirstName} #{me.LastName}. My Id is #{me.Id}."
   "Hello #{me.FirstName} #{me.LastName}. My Id is #{me.Id}."
end
</b>
</pre>

You should see the following in your browser.<br/><br/>
<b>Hello database master. My Id is #{some number}.</b>
