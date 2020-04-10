# Samba Testbed

This is a basic Alpine Linux based container running Samba, with a number of pre-populated users & passwords. Various settings can be changed at run time.


## Overview

* Alpine Linux 3.10
* Samba 4.10
* Local users & passwords configured via plain text input file
* Setup, user list, server config, and server logs directed to stdout
* Ability to specify content of `~/flag.txt` for a given user


## Usage

```
docker-compose up
```

## Configuration

Environment variables:

* `SAMBA_USERS_FILE`
	* CSV of users & passwords for local samba accounts
	* Default: `/samba-users.csv`


## `SAMBA_USERS_FILE`

Syntax:
```
username1,password1
username2,password2,optional_flag_contents
```

## Sample output

```

```


# Testing

* Browse as guest

```
smbutil view -g //localhost
```

* View available shares as user **alice**
```
smbutil view //alice@localhost
```