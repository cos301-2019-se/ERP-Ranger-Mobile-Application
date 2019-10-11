export interface Park {
  id: string;
  created: number;
  updated: number;
  name: string;
  fence: {
    geoJson: {
      type: string;
      coordinates: [number[][]];
    };
  };
}
