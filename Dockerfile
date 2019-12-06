FROM python:2.7

WORKDIR /home
COPY server /home
EXPOSE 8000

CMD ["python", "server.py"]