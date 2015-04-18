# The application 
A fullstack js app (nodejs, express, mysql, angular, bootstrap)

# Running
0. Environment
  1. install nodejs with npm
  2. `npm install bower gulp -g`
1. Configure
  1. MySQL (find a `schema.sql` and test data in `/sql` folder, find `config.jon` file in the `/backend` folder)
  2. other (find `settings.json` file in the root `/` folder)
2. `npm install`
3. `gulp`
4. `npm start` (you can specify a port, e.g. `npm start 1024`, `3001` - default port)
5. open browser on `http://localhost:3001` (not 127.0.0.1:3001)

# For windows users
There might be some extra unexpected work when install dependencies 
(to run redis correctly please use this https://github.com/rgl/redis/downloads and run it from a command line)
