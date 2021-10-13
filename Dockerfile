FROM node:16
WORKDIR /app
COPY ./src/main/frontend .
RUN npm install
ENV REACT_APP_NAME=myName
ENV CHINESE_FOOD=good
EXPOSE 3000
CMD ["npm","start"]