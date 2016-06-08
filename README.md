

Build:

    docker build -t openbill_webhooks:0.1 .


Start:

    docker run --name 'openbill_webhooks' -e 'PGDATABASE=dbname' -e 'PGUSER=username' -e 'PGPASSWORD=superpass' -e 'PGHOST=postgres addr' -e 'PGPORT=5432' -itd openbill_webhooks:0.1 

Logs: 

    docker logs -f openbill_webhooks
