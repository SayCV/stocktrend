# 使用Alpine Linux Python镜像
FROM python:3-alpine

# 设置作者或维护者信息（可选）
LABEL maintainer="your_email@example.com"

# 设置环境变量来禁止Python写入pyc文件和缓冲stdout和stderr
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# 更新系统，并安装git和编译相关的包
RUN apk update \
    && apk add --no-cache git \
    && apk add --no-cache --virtual .build-deps \
       g++ \
       gcc \
       libxslt-dev \
       libffi-dev \
       openssl-dev \
       musl-dev \
       make

# 克隆项目仓库
RUN mkdir /app
WORKDIR /app
RUN git clone https://github.com/olixu/stocktrend.git .

# 安装Python依赖
# requirements文件应该位于仓库的根目录
RUN pip install --upgrade pip\
    && pip install --no-cache-dir -r requirements.txt

# 清理不需要的包和缓存，减小镜像体积
RUN apk del .build-deps

# 暴露端口（假设你的应用使用的是8080端口）
EXPOSE 8080

# 设置运行时的默认命令
CMD ["python", "main.py"]