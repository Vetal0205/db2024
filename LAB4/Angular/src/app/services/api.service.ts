import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { ICustomer } from '../interfaces/icustomer';

const httpOptions = {
  headers: new HttpHeaders({
    'Content-Type': 'application/json',
  }),
};


@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private apiurl:string = "http://localhost:5000/api";

  constructor(private http:HttpClient) { }

  getCustomers():Observable<ICustomer[]>{
    const url = `${this.apiurl}/customers`
    return this.http.get<ICustomer[]>(url);
  }
  getCustomerById(id:number):Observable<ICustomer>{
    const url = `${this.apiurl}/customers/${id}`;
    return this.http.get<ICustomer>(url);
  }
  addCustomer(Customer: ICustomer): Observable<ICustomer> {
    const url = `${this.apiurl}/customers`;
    return this.http.post<ICustomer>(url, Customer, httpOptions);
  }
  deleteCustomer(Customer: ICustomer): Observable<ICustomer> {
    const url = `${this.apiurl}/customers/${Customer._id}`
    return this.http.delete<ICustomer>(url);
  }
  updateCustomer(Customer: ICustomer): Observable<ICustomer> {
    const url = `${this.apiurl}/customers/${Customer._id}`;
    return this.http.put<ICustomer>(this.apiurl, Customer, httpOptions);
  }
}
