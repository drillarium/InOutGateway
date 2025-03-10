export interface Version {
    version: string;
    changes: string[];
  }

interface VersionHistory {
  currentVersion: Version;
  previousVersions: Version[];
}
  
var versionHistory: VersionHistory = {
  currentVersion: {
    version: "0.0.1",
    changes: ["Initial beta"]
  },
  previousVersions: []
};

export function getCurrentVersion(): Version {
    return versionHistory.currentVersion;
}
  