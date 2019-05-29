FROM python:3.6-slim

WORKDIR /app
COPY . /app

RUN pip install -i https://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com -r requirements.txt

EXPOSE 80

ENV NAME World

CMD ["python", "app.py"]
