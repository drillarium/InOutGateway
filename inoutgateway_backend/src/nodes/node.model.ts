import { Board } from "./board.model";

export interface INode {
  id: number;          // identifier
  name: string;        // name
  address: string;     // address
  type: string;        // type        Host, AWS, ...
  boards: Board[];     // array of boards
};