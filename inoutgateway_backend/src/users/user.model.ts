export class UserPreferences {
  darkMode!: boolean;
}

export class User {
  id!: number;
  username!: string;
  password!: string;
  role!: string;
  email!: string;
  preferences!: UserPreferences;
}