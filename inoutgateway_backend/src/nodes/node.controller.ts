import { AppDataBase } from "../db";
import { logger } from "../logger";
import { NodeInstance } from "./node.instance";
import { INode } from "./node.model";

export class NodeController {
  private static instance: NodeController;
  private nodes: Map<number, NodeInstance> = new Map<number, NodeInstance>();
     
  private constructor() {}

  // singleton  
  public static getInstance(): NodeController {
    if (!NodeController.instance) {
        NodeController.instance = new NodeController();
    }
    return NodeController.instance;
  }

  // load nodes from db and start monitoring
  public async init() : Promise<void> {
    return new Promise((resolve, reject) => {
        const db = AppDataBase.getInstance();

        db.loadNodes().then((nodes) => {
          nodes.forEach(node => {
            const ni = new NodeInstance(node);    
            logger.info(`Node ${ni.name} loaded`);
            this.nodes.set(node.id, ni);
            ni.init();
          });            
        })
        .catch(error => { reject(error); })
        .finally(() => { resolve(); });
    });
  }

  // unload nodes
  public deinit() : void {
    this.nodes.forEach(node => {
        logger.info(`Node ${node.name} unloaded`);
        node.deinit();
    });
    this.nodes.clear();
  }

  // get array of nodes
  public get inodes() : INode[] {
    var ret: INode[] = [];
    this.nodes.forEach(node => {
        ret.push(node.inode);
    });
    return ret;
  }
}