FROM node:16-alpine3.11
FROM openjdk:11

WORKDIR /app
ENTRYPOINT ["java","-jar","./artifacts/aws-image-upload.jar"]

COPY ./src/main/frontend .
COPY ./target/aws-image-upload.jar ./artifacts
RUN npm install
EXPOSE 8080
CMD ["node", "index.js"]
