# jakeson_server

## Ideas

Create an issue and we do this!

## Create Client

`aqueduct auth add-client --id app_dev -s secret`

## Objects

- User
- Group
- Event
- Location
- Comment

## Permission System (Server)

### Owner

- Add User
- Edit User
- Delete(every) User

### Admin

- Add Group
- Delete(every) Group
- Delete(every) Group

### Moderator

- Edit Group [Add members to group]
- Delete(every) Event
- Edit(every) Event
- Delete(every) Comment

### Member

- Add Event
- Edit Event
- Delete(own) Event

### Guest

- Add Comment
- Edit(own) Comment
- Delete(own) Comment

## Running the Application Locally

- Install aqueduct
- Install postgressql and add it in the `database.yaml`
- Setup the database with `aqueduct db generate`
- Activate the ci with `pub global activate aqueduct`

Run `aqueduct serve` from this directory to run the application. For running within an IDE, run `bin/main.dart`. By default, a configuration file named `config.yaml` will be used.

To generate a SwaggerUI client, run `aqueduct document client`.

## Running Application Tests

To run all tests for this application, run the following in this directory:

```
pub run test
```

The default configuration file used when testing is `config.src.yaml`. This file should be checked into version control. It also the template for configuration files used in deployment.

## Deploying an Application

See the documentation for [Deployment](https://aqueduct.io/docs/deploy/).