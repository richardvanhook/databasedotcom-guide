Tutorial 1: Setup Your Environment
----------------------------------

### Create a database.com account
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

###Install Ruby
See [http://www.ruby-lang.org/en/downloads/](http://www.ruby-lang.org/en/downloads/) 

###Install databasedotcom gem
<pre class="brush: shell">
$ gem install databasedotcom
</pre>
