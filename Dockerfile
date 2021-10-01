FROM node:16-alpine3.11
FROM openjdk:11

WORKDIR /app
ADD ./src/main/frontend/package.json .
ADD ./src/main/frontend
ADD ./target/aws-image-upload.jar ./artifacts
RUN npm install .
CMD npm start .
ENTRYPOINT ["java","-jar","./artifacts/aws-image-upload.jar"]
