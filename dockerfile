FROM max26292/backend_crm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
    supervisor \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

CMD apachectl -D FOREGROUND