import * as fs from 'fs';

export interface AppConfig {
  interface: string;
  port: number;
  logsFolder: string;
  publicFolder: string;
  db: string;
}

const defaultConfig: AppConfig = {
  interface: "0.0.0.0",
  port: 5555,
  logsFolder: "./logs",
  publicFolder: "./www",
  db: "backend.fb"
};

var config: AppConfig = defaultConfig;

export function readConfig(): AppConfig {
  if(!fs.existsSync('config.json')) {
    fs.writeFileSync('config.json', JSON.stringify(defaultConfig, null, 2));
  }
 
  const configData = fs.readFileSync('config.json', 'utf8');
  config = JSON.parse(configData);
  return config;
}

export function getCurrentConfig(): AppConfig {
    return config;
}
