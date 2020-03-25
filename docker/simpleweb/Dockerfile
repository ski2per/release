FROM python:3.7-alpine
RUN sed -i s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g /etc/apk/repositories && \
    apk --no-cache add curl
WORKDIR /app
ENV FLASK_APP app.py
ENV FLASK_RUN_HOST 0.0.0.0
ENV FLASK_RUN_PORT 80
#RUN apk add --no-cache gcc musl-dev linux-headers
EXPOSE 80
COPY . /app
RUN pip install -i https://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com -r requirements.txt
CMD ["flask", "run"]
