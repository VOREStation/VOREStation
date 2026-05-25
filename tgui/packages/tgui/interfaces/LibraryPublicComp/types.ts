export type Data = {
  is_public: boolean;
  screenstate: string;
  emagged: boolean;
  // database
  admin_mode: boolean;
  inventory: Book[];
  inv_left: boolean;
  inv_right: boolean;
  // scanner
  scanned: Book | null;
  scanner_error: string;
  // checkout
  checkoutperiod: number;
  world_time: number;
  checks: CheckedOut[];
  buffer_book: string;
  buffer_mob: string;
};

type Book = {
  id: string;
  title: string;
  author: string;
  category: string;
  deleted: boolean;
  protected: boolean;
  ref: string;
  type: string;
  unique: boolean;
};

type CheckedOut = {
  bookname: string;
  mobname: string;
  timetaken: number;
  timedue: number;
  overdue: boolean;
  ref: string;
};
