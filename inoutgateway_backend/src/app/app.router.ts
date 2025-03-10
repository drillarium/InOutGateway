import express, { Router, Request, Response } from 'express';
import { AppConfig, getCurrentConfig } from '../config';
import { logger } from '../logger';

// router definition
export const router: Router = express.Router();

// GET config
router.get("/", async(req: Request, res: Response) => {
  try {
    const config: AppConfig = getCurrentConfig();
    res.json(config);
  }
  catch(error: unknown) {
    logger.error(`GET "/" ${JSON.stringify(error)}`);
    if (error instanceof Error) {
        res.status(400).send(error.message || 'An unexpected error occurred.');
    }
    else {
        res.status(400).send('An unexpected error occurred.');
    }
  }
});