# Needed for 0.1
- Add tests for all the classes in the system.
- Find a way to use it within a Rails project. Don't extract a restspec-rails gem yet, just:
    + Find a way to change between using HTTParty and RackTest to test inside a Rails application without specifying a url.
    + Add a Rails generator.
    + Add a test application made in Rails integrated internally and a test application made in Sinatra with tests outside.
- Find a way to support a way of authentication based on cookies with an initial login.
- Make a complete README.

# For 0.2 (They require more thoughts)
- Research pagination strategies and integrating them with `schema_id`.
- Research some way to generate markdown from a mix of the schemas and endpoints. (Like Apiary and others)
