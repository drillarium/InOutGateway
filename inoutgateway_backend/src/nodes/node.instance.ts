import { INode } from "./node.model";

export class NodeInstance {
  private node: INode;

  // constructor
  public constructor(node: INode) {
    this.node = node;
  }

  public init() : void {

  }

  public deinit() : void {
    
  }

  public get name() { return this.node.name; }
  public get inode() { return this.node; }
}