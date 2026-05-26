#!/bin/bash
i=0
until mysqladmin ping -h $DB_HOST -u app -p"$DB_PASSWORD" --skip-ssl
    do
        echo "MySQL not ready yet..."
        sleep 5
        i=$((i+1))
        if [ "$i" -ge 15 ]; then
        echo "MySQL failed to start"
        exit 1
        fi
    done
    
    echo "MySQL is ready"
    echo "Start app and uvicorn"

    exec uvicorn main:app --host 0.0.0.0 --port 5000
