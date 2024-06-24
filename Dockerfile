# Step 1: Specify the base image. Here, we use the latest Node.js version.
FROM node:latest as build

# Step 2: Set the working directory inside the container.
WORKDIR /

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire application code to the container
COPY . .

# Step 6: Build and run your React app.
RUN npm run build

RUN npm install -g serve

CMD ["serve", "-s", "build"]

# Step 7: Use Nginx to serve the app.
# Specify the base image for the serving stage.
FROM nginx:alpine

# Copy the build output to replace the default nginx contents.
COPY --from=build /build /usr/share/nginx/html

# Expose port 80 to the Docker host, so we can access it 
# from the outside.
EXPOSE 80

# The default command to run when starting the container.
CMD ["nginx", "-g", "daemon off;"]

