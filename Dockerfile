FROM python:3.12-alpine

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

ARG VERSION=dev
RUN echo "$VERSION" > /app/VERSION

# порт приложения внутри, из вашего варианта; то же число в EXPOSE
ENV APP_PORT=5009
ENV PYTHONDONTWRITEBYTECODE=1
EXPOSE 5009

ENV MARKER=applab
CMD ["python", "app.py"]

