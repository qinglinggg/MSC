WORKDIR /app
ADD ./src/main/frontend/package.json .
ADD ./src/main/frontend .
ADD ./target/aws-image-upload.jar ./artifacts

FROM node:16-alpine3.11
RUN npm install
CMD npm start

FROM openjdk:11
ENTRYPOINT ["java","-jar","./artifacts/aws-image-upload.jar"]
