import { Device } from "./device.model";

export class Board {
  id!: number;              // identifier
  name!: string;            // name
  type!: string;            // type   BlackMagic, Network Adapter
  devices!: Device[];       // list of devices
}