# Use Node.js as base image
FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Create package.json
COPY package*.json ./

# Initialize package.json if it doesn't exist
RUN if [ ! -f package.json ]; then \
    npm init -y && \
    npm install express cors; \
    fi

# Copy application files
COPY . .

# Create server.js file for the backend API
RUN echo 'const express = require("express");  \n\
const cors = require("cors"); \n\
const app = express(); \n\
const PORT = process.env.PORT || 3000; \n\
\n\
app.use(cors()); \n\
app.use(express.json()); \n\
app.use(express.static(".")); \n\
\n\
// In-memory storage for tasks \n\
const tasks = []; \n\
\n\
// GET endpoint to fetch all tasks \n\
app.get("/tasks", (req, res) => { \n\
    res.json(tasks); \n\
}); \n\
\n\
// POST endpoint to add a new task \n\
app.post("/tasks", (req, res) => { \n\
    const task = { \n\
        id: tasks.length + 1, \n\
        taskName: req.body.taskName \n\
    }; \n\
    tasks.push(task); \n\
    res.status(201).json(task); \n\
}); \n\
\n\
app.listen(PORT, "0.0.0.0", () => { \n\
    console.log(`Server is running on port ${PORT}`); \n\
});' > server.js

# Expose port 3000
EXPOSE 3000

# Start the server
CMD ["node", "server.js"]