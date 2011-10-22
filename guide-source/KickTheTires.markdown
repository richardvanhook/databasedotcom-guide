Kick the tires
==============

Install Ruby
------------
See [http://www.ruby-lang.org/en/downloads/](http://www.ruby-lang.org/en/downloads/) 

Helpful Tip:  Install RVM while you're at it.

Install databasedotcom gem
--------------------------
<pre class="brush: shell">
$ gem install databasedotcom
</pre>

Create a database.com account
-----------------------------
1. Go to <a href="http://www.database.com" target="_blank">database.com</a>
1. Click Signup
1. Fill in required fields (make note of the username you enter; will be referred to in subsequent steps as **USERNAME**)
1. Click on link in the confirmation email you receive
1. Set a new password and submit (will be referred to as **PASSWORD**)
1. Go to Personal Setup | My Personal Information | Reset My Security Token
1. Click button "Reset Security Token"
1. Note the Security Token you receive via email (**TOKEN**)
1. Go to App Setup | Develop | Remote Access | New
1. Fill in the following required fields with dummy values (later we'll update with real values):

    **Application**: Test Local
    
    **Callback**: https://localhost:5000
    
    **Contact Email**: your email
    
1. Note Consumer Secret and Key in the Authentication section.  (**CONSUMERSECRET** and **CONSUMERKEY**)

Connect via the gem
-------------------
Start an interactive Ruby shell:
<pre class="brush: shell">
$ irb
</pre>

Copy the following code to a local text editor and replace each {VARIABLE} with value from above.  When finished replacing the values, copy and paste to your open irb session.
<pre class="brush: ruby">
require 'sinatra'
require 'databasedotcom'
client = Databasedotcom::Client.new :client_id => "{CONSUMERKEY}", :client_secret => "{CONSUMERSECRET}"
client.authenticate :username => "{USERNAME}", :password => "{PASSWORD}{TOKEN}"
</pre>

If you see something like the following, then something was incorrectly replaced above.
<pre class="brush: plain">
Databasedotcom::SalesForceError: authentication failure - Invalid Password
	from /Users/rvanhook/.rvm/gems/ruby-1.9.2-p290/gems/databasedotcom-1.0.8/lib/databasedotcom/client.rb:95:in 'authenticate'
	from (irb):9
	from /Users/rvanhook/.rvm/rubies/ruby-1.9.2-p290/bin/irb:16:in '&lt;main&gt;'
</pre>

Hopefully you see something like the following.  If so, **congrats, you've connected**!  
<pre class="brush: plain">
=> "00DU0000000IKsX!AQQAQGHnlMeFKn_xAI3uhKEIvG9PKamngI.iokfwPQr6ugEXrxDzT_epMdhcSiF7M2eVWd3GiMfEHG0GIsZgNxLXZZoAZ9el" 
</pre>

Now let's do some fun stuff.

Kick the Tires
--------------
Below are some code quick code snippets you can copy and paste into your irb session.  This section is not intended to be an exhaustive guide of what the databasedotcom gem can do, rather its intention is to give you a feel for the databasedotcom gem.

<pre class="brush: ruby">
# list all objects
puts client.list_sobjects.sort.join "\n"
</pre>

<pre class="brush: ruby">
# load User object metadata
# this will create a Class called User
client.materialize('User')
</pre>

<pre class="brush: ruby">
# list methods now available for User
puts User.methods.sort.join "\n"
</pre>

<pre class="brush: ruby">
# list attributes on User object
puts User.attributes.sort.join "\n"
</pre>

<pre class="brush: ruby">
# load your user record via find
# client.user_id returns the User record ID of the user credentials you supplied above
me = User.find_by_id(client.user_id)
puts "My name is #{me.FirstName} #{me.LastName}"
</pre>

<pre class="brush: ruby">
# reload via different find method
me = User.find_by_Username(me.Username)
puts "My name is still #{me.FirstName} #{me.LastName}"
</pre>

<pre class="brush: ruby">
# or load via old-school soql where clause
# query returns an array
me = User.query("id = '#{client.user_id}'")[0]
puts "My name is still #{me.FirstName} #{me.LastName}"
</pre>
