FROM python:3.8

RUN apt-get update
RUN pip install Flask==1.1.2

EXPOSE 5000

WORKDIR /work

COPY main.py main.py

CMD ["python", "main.py"]
