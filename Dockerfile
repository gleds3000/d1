
FROM python:2.7-slim

WORKDIR /app

COPY . /app

RUN pip install -r requirements.txt

EXPOSE 5000

ENV NAME desafio

CMD ["python", "main.py"]