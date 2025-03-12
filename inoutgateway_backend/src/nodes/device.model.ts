export class Device {
  id!: number;                  // id
  type!: string;                // type. Input, Output, IO
  name!: string;
  address!: string;             // case BM, the device name, case network adapter the ip
  mixerId!: number;             // case SDI input, possible Mixer Output connected
  mixerOutputId!: number;       // ""
}