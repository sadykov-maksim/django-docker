# Этап, на котором выполняются подготовительные действия
FROM python:3.11.2-alpine3.17 as builder
LABEL authors="Builder"

WORKDIR /installer

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apk update --no-cache && \
    apt-get install -y --no-install-recommends gcc \

RUN pip install --upgrade pip

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Финальный этап
FROM python:3.11.2-alpine3.17
LABEL authors="Developer"

WORKDIR /app

COPY --from=builder /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

RUN adduser --disabled-password app && chmod 755 /opt
USER app

COPY . /app

EXPOSE 8000

ENTRYPOINT ["sh", "-c", "/app/entrypoint.sh"]