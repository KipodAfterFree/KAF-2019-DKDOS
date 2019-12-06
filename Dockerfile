FROM python:2.7

WORKDIR /home
COPY server /home

CMD ["python", "server.py"]