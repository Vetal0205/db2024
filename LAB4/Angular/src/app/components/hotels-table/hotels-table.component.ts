import { Component, OnInit, AfterViewInit, ViewChild } from '@angular/core';
import { ApiService } from '../../services/api.service';
import { MatTableDataSource } from '@angular/material/table';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { ICustomer } from '../../interfaces/icustomer';
import { CustomerService } from '../../services/customer.service';
import { IBooking } from '../../interfaces/ibooking';
@Component({
  selector: 'app-hotels-table',
  templateUrl: './hotels-table.component.html',
  styleUrl: './hotels-table.component.css'
})
export class HotelsTableComponent implements OnInit, AfterViewInit {
  constructor(private apiService: ApiService, private deserializeCustomerService: CustomerService) { }

  @ViewChild(MatPaginator, { static: true }) paginator: MatPaginator = null!;
  @ViewChild(MatSort, { static: true }) sort: MatSort = null!;

  columnsToDisplay: string[] = ['id', 'name', 'email', 'phone'];
  columnsToDisplayWithExpand = [...this.columnsToDisplay, 'expand'];
  displayedInnerColumns: string[] = ['check_in_date', 'check_out_date', 'total_price'];

  dataSource: MatTableDataSource<ICustomer> = new MatTableDataSource();
  customers_list: ICustomer[] = []
  expandedElement: ICustomer | null = null;

  ngAfterViewInit() {
    if (this.dataSource) {
      this.dataSource.sort = this.sort;
      this.dataSource.paginator = this.paginator;
    }
  }
  ngOnInit(): void {
    this.apiService.getCustomers().subscribe((res) => {
      this.dataSource.data = res;
      console.log(this.dataSource.data.length)
    });

  }
  toggleExpand(element: ICustomer) {
    this.expandedElement = this.expandedElement === element ? null : element;
  }
  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }
}