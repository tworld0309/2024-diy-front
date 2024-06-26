# Stage 1: 빌드 환경 설정
FROM node:14-alpine as build

WORKDIR /app

# package.json과 package-lock.json을 복사하여 먼저 종속성을 설치합니다.
COPY package*.json ./
RUN npm install

# 소스 코드를 복사하고 빌드합니다.
COPY . .
RUN npm run build

# Stage 2: 배포용 nginx 이미지 설정
FROM nginx:1.21-alpine

# Nginx에서 React 애플리케이션을 호스팅할 디렉토리를 설정합니다.
COPY --from=build /app/build /usr/share/nginx/html

# 기본 Nginx 설정을 제거하고 애플리케이션을 제공하기 위한 사용자 정의 설정을 복사합니다.
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

# Nginx 서버 시작
CMD ["nginx", "-g", "daemon off;"]
