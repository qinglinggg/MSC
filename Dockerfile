FROM node:16
WORKDIR /core
ENV PATH='./node_modules/.bin:$PATH'
COPY ./src/main/frontend .
RUN npm run build
CMD ["npm","start"]

FROM adoptopenjdk:11-jre-openj9
WORKDIR /app
COPY ./target/aws-image-upload.jar ./artifacts/
CMD ["java","-jar","./artifacts/aws-image-upload.jar"]
