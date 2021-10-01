FROM node:16
FROM openjdk:11

WORKDIR /app

COPY ./src/main/frontend .
COPY ./target/aws-image-upload.jar ./artifacts

ENTRYPOINT ["java","-jar","./artifacts/aws-image-upload.jar"]

RUN npm install
EXPOSE 8080
CMD ["node", "index.js"]
