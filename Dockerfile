FROM node:carbon

#Create app directory
WORKDIR /usr/src/app

#Install app dependencies
#A wildcard is used to ensure both package.json and package-lock.json are copied
#Where available (npm@5+)
COPY package*.json ./

RUN npm install
#If tou are building your code for production
#RUN npm install --only=production

#Bundle app source
COPY . .

EXPOSE 8080
CMD ["npm", "start"]