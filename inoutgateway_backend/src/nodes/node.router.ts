import express, { Router, Request, Response } from 'express';
import { logger } from '../logger';
import { NodeController } from './node.controller';

// router definition
export const router: Router = express.Router();

// GET nodes
router.get("/", async(req: Request, res: Response) => {
  try {
    const nc: NodeController = NodeController.getInstance();    
    res.json(nc.inodes);
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