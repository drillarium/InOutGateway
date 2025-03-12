export class Route {
    id!: number;        // id
    name!: string;      // name
    type!: string;      // source type: SDI, 2110, UDP, SRT
    address!: string;   // address
    nodeId!: number;    // node id case associated to a node Output
    boardId!: number;   // "" board identifier
    deviceId!: number;  // "" device identifier
  }
