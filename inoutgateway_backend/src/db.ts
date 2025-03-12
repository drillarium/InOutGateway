import * as sqlite3 from 'sqlite3';
import { logger } from './logger';
import { INode } from './nodes/node.model';
import * as os from 'os';

export class AppDataBase {
  private static instance: AppDataBase;
  private db!: sqlite3.Database;
 
  private constructor() {}

  // singleton  
  public static getInstance(): AppDataBase {
    if (!AppDataBase.instance) {
        AppDataBase.instance = new AppDataBase();
    }
    return AppDataBase.instance;
  }

  public async init(db: string) : Promise<void> {
    return new Promise(async (resolve, reject) => {
      try {
        // Open a SQLite database connection
        this.db = new sqlite3.Database(db);

        await this.createNodesTable();
        await this.createBoardTable();
        await this.createDeviceTable();
        await this.createSourcesTable();
        await this.createRoutesTable();
        await this.createTransformersTable();

        // create a default localhost configuration if not created
        const nodeId = await this.addLocalHostNode();
        if(nodeId > 0) {
          const networkInterfaces = os.networkInterfaces();
          for (const interfaceName in networkInterfaces) {
            const boardId = await this.addLocalHostAdapter(nodeId, interfaceName);

            const interfaces = networkInterfaces[interfaceName];
            if (interfaces) {
              for(var i = 0; i < interfaces.length; i++) {
                await this.addLocalHostInterface(boardId, interfaces[i].address);
              }
            }
          }
        }

        resolve();
      }
      catch(error) {
        reject(error);
      }
    });
  }

  protected async createNodesTable() : Promise<void> {
    return new Promise((resolve, reject) => {
      this.db.serialize(() => {
        // routes
        this.db.run(`CREATE TABLE IF NOT EXISTS nodes (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT NOT NULL,
                    address TEXT NOT NULL UNIQUE,
                    type TEXT NOT NULL
        )`);
        resolve();
      });
    });
  }

  protected async createBoardTable() : Promise<void> {
    return new Promise((resolve, reject) => {
      this.db.serialize(() => {
        // boards
        this.db.run(`CREATE TABLE IF NOT EXISTS boards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            node_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            type TEXT NOT NULL,
            FOREIGN KEY (node_id) REFERENCES nodes(id) ON DELETE CASCADE
        )`);
        resolve();
      });
    });
  }  

  protected async createDeviceTable() : Promise<void> {
    return new Promise((resolve, reject) => {
      this.db.serialize(() => {
        // devices
        this.db.run(`CREATE TABLE IF NOT EXISTS devices (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            board_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            type TEXT NOT NULL,
            address TEXT NOT NULL,
            FOREIGN KEY (board_id) REFERENCES boards(id) ON DELETE CASCADE
        )`);
        resolve();
      });
    });
  }

  protected async createSourcesTable() : Promise<void> {
    return new Promise((resolve, reject) => {
      this.db.serialize(() => {
        // sources
        this.db.run(`CREATE TABLE IF NOT EXISTS sources (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,  
                    name TEXT NOT NULL,
                    type TEXT NOT NULL,
                    address TEXT NOT NULL
        )`);
        resolve();
      });      
    });
  }  

  protected async createRoutesTable() : Promise<void> {
    return new Promise((resolve, reject) => {
      this.db.serialize(() => {
        // routes
        this.db.run(`CREATE TABLE IF NOT EXISTS routes (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,  
                    name TEXT NOT NULL,
                    type TEXT NOT NULL,
                    address TEXT NOT NULL
        )`);
        resolve();
      });
    });
  }

  protected async createTransformersTable() : Promise<void> {
    return new Promise((resolve, reject) => {
      this.db.serialize(() => {
        // routes
        this.db.run(`CREATE TABLE IF NOT EXISTS transformers (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,  
                    name TEXT NOT NULL,
                    type TEXT NOT NULL,
                    address TEXT NOT NULL
        )`);
        resolve();
      });
    });
  }  

  protected async addLocalHostNode() : Promise<number> {
    return new Promise((resolve, reject) => {
      // Nodes with local host if does not exists
      this.db.get('SELECT * FROM nodes WHERE address = ?', ["127.0.0.1"], async (err, row) => {    
        if (err) {
          logger.error(err.message || "An unexpected error occurred.");               
          reject(err); 
          return;
        }
        if (!row) {
          this.db.run('INSERT INTO nodes (name, address, type) VALUES (?, ?, ?)', ["localhost", "127.0.0.1", "host"], function (err) {
            if (err) {
              logger.error(err.message || "An unexpected error occurred.");
              reject(err); 
            }
            else {
              resolve(this.lastID);
            }
          });
        }
        else {
          resolve(-1);
        }
      });
    });
  }

  protected async addLocalHostAdapter(nodeId : number, adapter: string) : Promise<number> {
    return new Promise((resolve, reject) => {
      this.db.serialize(() => {    
        // Adapter for localhost
        this.db.get('SELECT * FROM boards WHERE node_id = ? AND name = ?', [nodeId, adapter], async (err, row) => {
            if (err) {
              logger.error(err.message || "An unexpected error occurred.");     
              reject(err); 
              return;
            }
            if (!row) {
              this.db.run('INSERT INTO boards (node_id, name, type) VALUES (?, ?, ?)', [nodeId, adapter, "network_adapter"], function (err) {
                  if (err) {
                    logger.error(err.message || "An unexpected error occurred.");
                    reject(err); 
                  }
                  else
                  {
                    logger.info(`Network Adapter ${adapter} for localhost node created successfully`);                    
                    resolve(this.lastID);
                  }
                });
            }            
            else {
              logger.info(`Network Adapter ${adapter} for localhost node already exists`);              
              resolve(-1);
            }
          });        
        });
    });
  }

  protected async addLocalHostInterface(adapterId: number, address: string) : Promise<void> {
    return new Promise((resolve, reject) => {
      this.db.serialize(() => {
        // Adapter for localhost
        this.db.get('SELECT * FROM devices WHERE board_id = ? AND address = ? ', [adapterId, address], (err, row) => {
            if (err) {
              logger.error(err.message || "An unexpected error occurred.");     
              reject(err); 
              return;
            }
            if (!row) {
              this.db.run('INSERT INTO devices (board_id, name, type, address) VALUES (?, ?, ?, ?)', [adapterId, address, "reversible", address], (err) => {
                if (err) {
                  logger.error(err.message || "An unexpected error occurred.");
                  reject(err); 
                }
                else
                {
                  logger.info(`Interface ${address} for Network Adapter ${adapterId} created successfully`);
                  resolve();
                }
              });
            } 
            else {        
              logger.info(`Interface ${address} for Network Adapter ${adapterId} already exists`);              
              resolve();
            }
          });        
        });
    });
  }  

  public close(): void {
    if(this.db) {
        this.db.close();
    }
  }

  public async loadNodes(): Promise<INode[]> {
    return new Promise((resolve, reject) => {
        this.db.all('SELECT * FROM nodes', (err, rows: any[]) => {
            if (err) {
                reject(err);
            } else {        
                const nodes: INode[] = rows.map(row => ({id: row.id,
                                                         name: row.name,
                                                         address: row.address,
                                                         type: row.type,
                                                         boards: [] }) );
                resolve(nodes);
            }
        });
    });
  }
}