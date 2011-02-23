## How lolwut is different

lolwut is just like the default Monk skeleton, except for these differences:

### Testing with RSpec

Testing is done with RSpec and Webrat instead of Webrat and Contest/Stories.

### Session security

The default Monk skeleton doesn't use a secret key for ensuring session data
integrity.  I think a lot of people don't realize how much of a security threat
this is, so my skeleton creates a random key in `config/secret.txt` the first
time the app is run.

## Using lolwut

Add this line to ~/.monk:

    lolwut: git://github.com/cvonkleist/lolwut.git

Then, use this command to create a new Sinatra app:

    monk init -s lolwut my_app_name
