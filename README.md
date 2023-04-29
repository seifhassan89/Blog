# Blog Management Web API
This is a simple Blog WebApi that allows users to view posts and comments and interacte with each other, while Admin can manage all posts and comments
and view them. The project is built using Ruby On Rails, ActiveRecord and mysql2 and jwt and bcrypt gems.

## Features
- CRUD operations for Posts.
- CRUD operations for Comments.
- CRUD operations for Users.
- CRUD operations for Roles.
- Authentication and Authorization operations for all Users.

## Technologies Used
- Ruby
- Ruby on rails
- mysql2 database
- jwt
- bcrypt

## Getting Started
To get started with this project, follow these steps:

## Installing
1. Clone the repository to your local machine.
```
git clone https://github.com/seifhassan89/Blog
```
2. Install Ruby and Ruby on Rails if you haven't already
```
gem install rails -v 5.0.1
```
3. Run bundle install to install all required gems.
```
bundle install
```


## Database Connection
1.to create the database run:
```
db:create
```
2.to run the database migrations run:
```
db:migrate
```


## Run the application
1. Here is command to run your application:
```
rails s
```
You should now be able to access the application at http://localhost:3000.

## Usage
The API endpoints can be tested using a tool such as Postman. The following endpoints are available:

![image](https://user-images.githubusercontent.com/64795421/235300304-4bd225be-fabe-496c-a04a-9991dfcf51b2.png)
![image](https://user-images.githubusercontent.com/64795421/235300325-cc3ff1d9-6f7b-4c2a-a039-23d581b5bf19.png)
![image](https://user-images.githubusercontent.com/64795421/235300335-f4907287-919e-4a1c-a0c3-8d5cf30d42ef.png)


## Contributing
Contributions are welcome! If you'd like to contribute to this project, please follow these steps:

1. Fork the repository.
2. Create a new feature branch.
3. Make your changes.
4. Create a pull request.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
