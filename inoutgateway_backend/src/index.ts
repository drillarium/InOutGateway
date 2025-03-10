import express, { Request, Response } from 'express';
import { getCurrentVersion, Version } from './version';
import { initLogger, logger } from './logger';
import { AppConfig, readConfig } from './config';
import { AddressInfo } from 'net';
import cors from 'cors';
import { router as appRouter } from './app/app.router';
import path from 'path';
import * as fs from 'fs';

// config
const config: AppConfig = readConfig();

// current version
const version: Version = getCurrentVersion();

// logger
initLogger();

// App started
logger.info(`App started version: ${version.version} config: ${JSON.stringify(config)}`);

const app = express();

// vars
const PORT = config.port;
const INTERFACE = config.interface;
const PUBLIC_FOLDER = config.publicFolder;

// Ensure log directory exists
try {
  if(!fs.existsSync(PUBLIC_FOLDER)) {    
    fs.mkdirSync(PUBLIC_FOLDER);
  }
}
catch(error: any) {

}

// Middleware to parse JSON request body
app.use(express.json());

// enable all CORS requests
app.use(cors());

// router
app.use('/api/v1/backend', appRouter);

// Serve static files from the public folder
app.use(express.static(PUBLIC_FOLDER));

// Route for serving the Flutter app
app.get('/', (_req, res) => {
  res.sendFile(path.join(PUBLIC_FOLDER, 'index.html'));
});

// Start server
const server = app.listen(PORT, INTERFACE, () => {
  const { address, port } = server.address() as AddressInfo;
  logger.info(`Server is running on ${address}:${port}`);
});

// Function to handle clean exit
const handleExit = (signal: string) => {
    logger.info(`Received ${signal}. Shutting down gracefully...`);
    
    // Here you can also perform other cleanup tasks like closing DB connections, etc.
    
    // Exit the process after logging
    process.exit();
};

// Listen for SIGINT (Ctrl+C) and SIGTERM (for other termination signals)
process.on('SIGINT', handleExit);  // Ctrl+C
process.on('SIGTERM', handleExit);  // Termination signal (used by Docker, Kubernetes, etc.)
