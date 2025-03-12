import express, { Request, Response } from 'express';
import { getCurrentVersion, Version } from './version';
import { initLogger, logger } from './logger';
import { AppConfig, readConfig } from './config';
import { AddressInfo } from 'net';
import cors from 'cors';
import { router as appRouter } from './app/app.router';
import path from 'path';
import * as fs from 'fs';
import { AppDataBase } from './db';
import { NodeController } from './nodes/node.controller';
import { router as nodeRouter } from './nodes/node.router';

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
const DB = config.db;

// Ensure log directory exists
try {
  if(!fs.existsSync(PUBLIC_FOLDER)) {
    logger.info(`Creating public folder ${PUBLIC_FOLDER}.`);
    fs.mkdirSync(PUBLIC_FOLDER);
  }
  else {
    logger.info(`Public folder ${PUBLIC_FOLDER} already exists.`);
  }
}
catch(error: unknown) {
  if (error instanceof Error) {
    logger.error(`Error creating public folder ${PUBLIC_FOLDER}. ${error.message || 'An unexpected error occurred.'}`);
  }
  else {
    logger.error(`Error creating public folder ${PUBLIC_FOLDER}. An unexpected error occurred`);
  }
}

// Middleware to parse JSON request body
app.use(express.json());

// enable all CORS requests
app.use(cors());

// router
app.use('/api/v1/backend', appRouter);
app.use('/api/v1/node', nodeRouter);

// Serve static files from the public folder
app.use(express.static(PUBLIC_FOLDER));

// Route for serving the Flutter app
app.get('/', (_req, res) => {
  res.sendFile(path.join(PUBLIC_FOLDER, 'index.html'));
});

// DB
const db : AppDataBase = AppDataBase.getInstance();

// Node controller
const nc : NodeController = NodeController.getInstance();

// Start server
const server = app.listen(PORT, INTERFACE, async () => {
  const { address, port } = server.address() as AddressInfo;
  logger.info(`Server is running on ${address}:${port}`);

  try {
    // load DB config
    logger.info(`Loading configuration`);
    await db.init(DB);
    logger.info(`Configuration loaded`);

    // load nodes
    logger.info(`Loading nodes`);
    await nc.init();
    logger.info(`Nodes loaded`);

    // load orchestrator app
  }
  catch(error: unknown) {
    if (error instanceof Error) {
      logger.error(`Error init app. ${error.message || 'An unexpected error occurred.'}`);
    }
    else {
      logger.error(`Error init app. An unexpected error occurred`);
    }
  }
});

// Function to handle clean exit
const handleExit = (signal: string) => {
    logger.info(`Received ${signal}. Shutting down gracefully...`);
    
    // nodes
    nc.deinit();

    // close DB
    db.close();

    logger.info(`Application ends`);
    
    // Exit the process after logging
    process.exit();
};

// Listen for SIGINT (Ctrl+C) and SIGTERM (for other termination signals)
process.on('SIGINT', handleExit);  // Ctrl+C
process.on('SIGTERM', handleExit);  // Termination signal (used by Docker, Kubernetes, etc.)
