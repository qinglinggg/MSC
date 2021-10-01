FROM node:16
WORKDIR /app
COPY ./src/main/frontend .
RUN curl -v https://registry.npmjs.com/
RUN npm install
EXPOSE 8080
CMD ["node", "index.js"]

FROM openjdk:11
WORKDIR /app
COPY ./target/aws-image-upload.jar ./artifacts
CMD ["java","-jar","./artifacts/aws-image-upload.jar"]
