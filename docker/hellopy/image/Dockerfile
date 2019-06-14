FROM python:3.6-slim

WORKDIR /hello
COPY . /hello

RUN pip install -i https://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com -r requirements.txt

EXPOSE 80

ENV WHO World
ENV REDIS_HOST redis

CMD ["python", "hello.py"]
