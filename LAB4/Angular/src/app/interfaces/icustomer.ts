import { IBooking } from './ibooking';

export interface ICustomer {
  _id: string;
  name: string;
  email: string;
  phone: string;
  bookings: IBooking[];
}