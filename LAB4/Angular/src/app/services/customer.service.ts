import { Injectable } from '@angular/core';
import { ICustomer } from '../interfaces/icustomer';
import { IBooking } from '../interfaces/ibooking';

@Injectable({
  providedIn: 'root'
})
export class CustomerService {

  constructor() { }

  deserializeCustomerData(data: any): ICustomer {
    return {
      _id: data?._id?.$oid,
      name: data?.name,
      email: data?.email,
      phone: data?.phone,
      bookings: data?.bookings?.map((booking: any) => this._deserializeBooking(booking))
    };
  }

  private _deserializeBooking(data: any): IBooking {
    return {
      room_id: data?.room_id,
      check_in_date: new Date(data?.check_in_date),
      check_out_date: new Date(data?.check_out_date),
      total_price: data?.total_price
    };
  }
}
