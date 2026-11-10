// console.log("Hello, Node.js!");


import express from 'express';

import { testConnection } from './src/models/db.js';
import { getAllOrganizations } from './src/models/organizations.js';
import { getAllProjects } from './src/models/projects.js';
import { getAllCategories } from './src/models/categories.js';
// Define the application environment
const nodeEnv = process.env.NODE_ENV?.toLowerCase() || 'production';

// Define the port number the server will listen on
const port = process.env.PORT || 3000;

const app = express();

// app.get('/', (req, res) => {
    // res.send('Hello, my name is Samson from Express!');
// });

// app.listen(port, () => {
//   console.log(`Server is running at http://127.0.0.1:${port}`);
//   console.log(`Environment: ${nodeEnv}`);
// });


app.listen(port, async () => {
  try {
    await testConnection();
    const projects = await getAllProjects();
    console.log('Service projects:', projects);
    console.log(`Server is running at http://127.0.0.1:${port}`);
    console.log(`Environment: ${nodeEnv}`);
  } catch (error) {
    console.error('Error initializing the application:', error);
  }
});



// static HTML, paths, middleware, routes


import { fileURLToPath } from 'url';
import path from 'path';

const fileName = fileURLToPath(import.meta.url);
const directoryName = path.dirname(fileName);


// Set EJS as the templating engine
app.set('view engine', 'ejs');

// Tell Express where to find your templates
app.set('views', path.join(directoryName, 'src/views'));


/**
  * Configure Express middleware
  */

// Serve static files from the public directory
app.use(express.static(path.join(directoryName, 'public')));


/**
  * Routes
  */
// app.get('/', (req, res) => {
    // res.sendFile(path.join(directoryName, 'src/views/home.html'));
// });
// 
// app.get('/organizations', (req, res) => {
    // res.sendFile(path.join(directoryName, 'src/views/organizations.html'));
// });
// 
// app.get('/projects', (req, res) => {
    // res.sendFile(path.join(directoryName, 'src/views/projects.html'));
// });
// 

/**
 * updated Routes to render to allow ejs instead of html
 */
app.get('/', async (req, res) => {
    const title = 'Home';
    res.render('home', { title });
});


// app.get('/organizations', async (req, res) => {
    // const title = 'Our Partner Organizations';
    // res.render('organizations', { title });
// });


app.get('/organizations', async (req, res) => {
    const organizations = await getAllOrganizations();
    // console.log(organizations);
      
    const title = 'Our Partner Organizations';
    res.render('organizations', { title, organizations });
});

app.get('/projects', async (req, res) => {
    const projects = await getAllProjects();
    const title = 'Service Projects';
    res.render('projects', { title, projects });
});

app.get('/categories', async (req, res) => {
    const categories = await getAllCategories();
    const title = 'Service Project Categories';
    res.render('categories', { title, categories });
});
