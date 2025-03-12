export class Source {
  id!: number;        // id
  name!: string;      // name
  type!: string;      // source type: SDI, 2110, UDP, SRT
  address!: string;   // address
  nodeId!: number;    // node id case associated to a node Input
  boardId!: number;   // "" board identifier
  deviceId!: number;  // "" device identifier
  mixerId!: number;   // mixer id case associated to a mixer (SDI)
  inputId!: number;   // "" input identifier
}