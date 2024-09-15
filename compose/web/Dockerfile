FROM python:3.12-slim-bullseye

RUN apt-get update -y && \
  apt-get upgrade -y && \
  # Python dev
  apt-get install -y python3-pip build-essential gcc python3-dev musl-dev libssl-dev cargo \
  # PostgreSQL
  libpq-dev \
  # Misc
  libffi-dev \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

RUN pip install --upgrade pip
COPY ./requirements-dev.txt /requirements.txt
RUN pip install -r /requirements.txt

COPY ./compose/wait_postgres.sh /wait_postgres.sh
COPY ./compose/entrypoint.sh /entrypoint
COPY ./compose/web/web.sh /web

RUN rm -rf /root/.pip

WORKDIR /app

EXPOSE 8000

ENTRYPOINT ["/entrypoint"]
