# You Are Digital Docker (yadock)
Our own Docker setup.

# Installation guide
1. `$ git clone https://github.com/You-Are-Digital/yadock`
2. Copy env-example to .env
3. Edit .env to fit local environment
4. `$ docker-compose up -d {nginx} {apache2} {mysql}`

# Notes
## docker-compose up
There is no need to up the workspace or the php container because they are linked to the webserver and database containers.